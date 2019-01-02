module H (input  wire         clk,
	      input  wire         reset,
	      input  wire         H_read, 
	      input  wire         H_iterate,
	      input  wire  [31:0] hmem__dut__data,
	      input  wire  [31:0] W_H_data,
	      input  wire  [31:0] kmem__dut__data,
	      output reg   [31:0] dut__dom__data
	      );

parameter [2:0]
          S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;

reg  [31:0] H [0:7];
reg  [2:0]  counter;
reg  [2:0]  current_state, next_state;

wire [31:0] ch;
wire [31:0] maj;
wire [31:0] sum0;
wire [31:0] sum1;
wire [31:0] a1,e1,T1,T2;

reg  [31:0] kmem__dut__data_r;
reg  [31:0] hmem__dut__data_r;
reg  [31:0] dut__dom__data_r;

always @(posedge clk) begin
    kmem__dut__data_r <= kmem__dut__data;
    hmem__dut__data_r <= hmem__dut__data;
    dut__dom__data <= dut__dom__data_r;
end

always @(posedge clk or posedge reset) begin
  if (reset) current_state <= S0;
  else        current_state <= next_state;
end


always @(*) begin
  case (current_state)

    S0: begin
      case (H_read)
      1'b0: next_state <= S0;
      1'b1: next_state <= S1;
      endcase
    end
    S1: begin
      case (H_read)
      1'b0: next_state <= S2;
      1'b1: next_state <= S1;
      endcase
    end
    S2: begin
      case (H_iterate)
      1'b0: next_state <= S2;
      1'b1: next_state <= S3;
      endcase
    end
    S3: begin
      case (H_iterate)
      1'b0: next_state <= S4;
      1'b1: next_state <= S3;
      endcase
    end
    S4: begin
      case (H_read)
      1'b0: next_state <= S0;
      1'b1: next_state <= S4;
      endcase
    end
  endcase
end

always @(posedge clk) begin /* counter logic */
	if ((current_state == S1) || (current_state == S4)) counter <= counter + 3'b1;
	else counter <= 3'b0;
end

always @(posedge clk) begin /* H logic*/
    case (current_state)

      S0: begin
      	H[0] <= 32'b0;
	H[1] <= 32'b0;
	H[2] <= 32'b0;
	H[3] <= 32'b0;
	H[4] <= 32'b0;
	H[5] <= 32'b0;
	H[6] <= 32'b0;
	H[7] <= 32'b0;
      end
      S1: H[counter] <= hmem__dut__data_r;
      S3: begin
        H[7] <= H[6];
    	H[6] <= H[5];
    	H[5] <= H[4];
    	H[4] <= H[3] + T1;
    	H[3] <= H[2];
    	H[2] <= H[1];
    	H[1] <= H[0];
    	H[0] <= T1 + T2;
      end
      default: begin
        H[0] <= H[0];
	H[1] <= H[1];
	H[2] <= H[2];
	H[3] <= H[3];
	H[4] <= H[4];
	H[5] <= H[5];
	H[6] <= H[6];
	H[7] <= H[7];
      end
    endcase
end



always @(posedge clk) begin /* output logic */
	if (current_state == S4) dut__dom__data_r <= H[counter] + hmem__dut__data_r;
	else dut__dom__data_r <= 32'b0;	
end

assign sum0 = ({H[0],H[0]}>>2)^({H[0],H[0]}>>13)^({H[0],H[0]}>>22);
assign sum1 = ({H[4],H[4]}>>6)^({H[4],H[4]}>>11)^({H[4],H[4]}>>25);
assign ch = (H[4] & H[5])^(~H[4] & H[6]);
assign maj = (H[0] & H[1])^(H[0] & H[2])^(H[1] & H[2]);
assign T1 = sum1 + ch + H[7] + W_H_data + kmem__dut__data_r;
assign T2 = sum0 + maj;
assign a1 = T1 + T2;
assign e1 = H[3] + T1;

/*assign b1 = b;
assign c1 = c;
assign f1 = f;
assign g1 = g;*/

endmodule
	
