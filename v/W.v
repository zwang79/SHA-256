// To process array [31:0] W [63:0] and output [31:0] W_iteration, takes  clock cycles in total after W_start pulled high
module W (input  wire          clk ,
          input  wire          reset , 
          input  wire  [511:0] M ,
          input  wire          W_start,
          output reg   [31:0]  W_H_data
          );

parameter [1:0] /* FSM states coding */
          S0 = 2'b00, /* Wait */
          S1 = 2'b01, /* process W [0:15] within 1 clock period */
          S2 = 2'b10; /* process W [16:63] within 48 clock periods */ 

reg  [3:0]  counter;
reg  [31:0] W [0:15];
reg  [1:0]  current_state, next_state;
reg  [31:0] sig0;
reg  [31:0] sig1;
wire [3:0]  cnt2,cnt9,cnt15,cnt16;
wire c2,c9,c15,c16;
//wire [31:0] sig0;
//wire [31:0] sig1;
//wire [3:0]  cnt1,cnt9,cnt14,cnt16;
//wire c2,c9,c15,c16;

integer i,j;

always @(posedge clk or posedge reset) begin
  if (reset) current_state <= S0;
  else       current_state <= next_state;
end

always @(*) begin
  case (current_state)

    S0: begin
      case (W_start)
      1'b0: next_state <= S0;
      1'b1: next_state <= S1;
      endcase
    end
    S1: next_state <= S2;
    S2: begin
      case (W_start)
      1'b0: next_state <= S0;
      1'b1: next_state <= S2;
      endcase
    end
    default: next_state <= S0;
  endcase
end

always @(posedge clk) begin
  if (current_state == S2) counter <= counter + 3'b1;
  else counter <= 3'b0;
end 

/*generate
  for (genvar gv = 0; gv<16; gv=gv+1) begin
      always @(posedge clk) begin
           if (current_state == S0) W [gv] <= 32'b0;
           else if (current_state == S1) W[gv] <= M[511-32*gv-:32];
           end
      end
endgenerate */

always @(posedge clk) begin
  case (current_state)

    S0: begin
      for (i=0; i<16; i=i+1) W[i] <= 0;
    end
    S1: begin
      sig0 <= ({M[479:448],M[479:448]}>>7)^({M[479:448],M[479:448]}>>18)^(M[479:448]>>3);
      sig1 <= ({M[63:32],M[63:32]}>>17)^({M[63:32],M[63:32]}>>19)^(M[63:32]>>10);
      for (j=0; j<16; j=j+1) W[j] <= M[511-32*j-:32];
    end
    S2: begin
      sig0 <= ({W[cnt2],W[cnt2]}>>7)^({W[cnt2],W[cnt2]}>>18)^(W[cnt2]>>3); //pipeline i-14 for W[counter + 17]
      sig1 <= ({W[cnt15],W[cnt15]}>>17)^({W[cnt15],W[cnt15]}>>19)^(W[cnt15]>>10); // pipeline i-1 for W[counter + 17]
      W[cnt16] <= W[cnt9]+W[counter]+sig0+sig1;
      //W[counter + 16] <= W[counter + 9]^W[counter]^sig0^sig1; // W[j] <= W[j-7] + W[j-16] + sig0 + sig1;
    end
  endcase
end

always @(posedge clk) begin
	if (current_state == S2) W_H_data <= W[counter]; 
	else W_H_data <= 32'b0;
end

//assign sig0 = ({W[cnt1],W[cnt1]}>>7)^({W[cnt1],W[cnt1]}>>18)^(W[cnt1]>>3); //pipeline i-14 for W[counter + 17]
//assign sig1 = ({W[cnt14],W[cnt14]}>>17)^({W[cnt14],W[cnt14]}>>19)^(W[cnt14]>>10); // pipeline i-1 for W[counter + 17]
assign {c2,cnt2} = counter + 2;
assign {c15,cnt15} = counter + 15;
//assign {c1,cnt1} = counter + 1;
//assign {c14,cnt14} = counter + 14;
assign {c9,cnt9} = counter + 9;
assign {c16,cnt16} = counter + 16;


endmodule

