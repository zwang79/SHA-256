// the function of M is to receive msg data and process [511:0] M while M_read is high.
module M #(parameter MAX_MESSAGE_LENGTH  = 55 )
           (input  wire                                  clk,
            input  wire                                  reset, 
            input  wire  [ $clog2(MAX_MESSAGE_LENGTH):0] xxx__dut__msg_length_r,
            input  wire  [7:0]                           msg__dut__data ,
            input  wire                                  dut__msg__enable,
            input  wire                                  dut__xxx__finish,
            output reg   [511:0]                         M
            );

reg [5:0] counter;
reg [7:0] msg__dut__data_r;
reg       dut__msg__enable_r;

always @(posedge clk) begin
  msg__dut__data_r <= msg__dut__data;
  dut__msg__enable_r <= dut__msg__enable;
end

always @(posedge clk or posedge reset) begin
	if (reset) counter <= 6'b000000;
	else if (!dut__msg__enable_r || counter==(xxx__dut__msg_length_r-1)) counter <= 6'b000000;
	else counter <= counter + 6'b000001;
end

always @(posedge clk or posedge reset) begin
    if (reset) M <= 512'b0;
    else if (dut__xxx__finish) M <= 512'b0;
    else if (dut__msg__enable_r) begin
      M [511-8*counter-:8] <= msg__dut__data_r;
      M [511-8*xxx__dut__msg_length_r] <= 1'b1;
      M [$clog2(MAX_MESSAGE_LENGTH)+3:3] <= {xxx__dut__msg_length_r};
    end
end

endmodule
