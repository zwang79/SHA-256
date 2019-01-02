//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// DUT




module MyDesign #(parameter OUTPUT_LENGTH       = 8,
                  parameter MAX_MESSAGE_LENGTH  = 55,
                  parameter NUMBER_OF_Ks        = 64,
                  parameter NUMBER_OF_Hs        = 8 ,
                  parameter SYMBOL_WIDTH        = 8  )
            (

            //---------------------------------------------------------------------------
            // Control
            //
            output reg                                   dut__xxx__finish     ,
            input  wire                                  xxx__dut__go         ,  
            input  wire  [ $clog2(MAX_MESSAGE_LENGTH):0] xxx__dut__msg_length ,

            //---------------------------------------------------------------------------
            // Message memory interface
            //
            output reg  [ $clog2(MAX_MESSAGE_LENGTH)-1:0]   dut__msg__address  ,  // address of letter
            output reg                                      dut__msg__enable   ,
            output reg                                      dut__msg__write    ,
            input  wire [7:0]                               msg__dut__data     ,  // read each letter
            
            //---------------------------------------------------------------------------
            // K memory interface
            //
            output reg  [ $clog2(NUMBER_OF_Ks)-1:0]     dut__kmem__address  ,
            output reg                                  dut__kmem__enable   ,
            output reg                                  dut__kmem__write    ,
            input  wire [31:0]                          kmem__dut__data     ,  // read data

            //---------------------------------------------------------------------------
            // H memory interface
            //
            output reg  [ $clog2(NUMBER_OF_Hs)-1:0]     dut__hmem__address  ,
            output reg                                  dut__hmem__enable   ,
            output reg                                  dut__hmem__write    ,
            input  wire [31:0]                          hmem__dut__data     ,  // read data


            //---------------------------------------------------------------------------
            // Output data memory 
            //
            output reg  [ $clog2(OUTPUT_LENGTH)-1:0]    dut__dom__address  ,
            output reg  [31:0]                          dut__dom__data     ,  // write data
            output reg                                  dut__dom__enable   ,
            output reg                                  dut__dom__write    ,


            //-------------------------------
            // General
            //
            input  wire                 clk             ,
            input  wire                 reset  

            );

  //---------------------------------------------------------------------------
wire W_start;
wire H_read;
wire H_iterate;
wire dut__xxx__finish_1;

wire [ $clog2(MAX_MESSAGE_LENGTH)-1:0] dut__msg__address_1;
wire dut__msg__enable_1;
wire dut__msg__write_1;

wire [ $clog2(NUMBER_OF_Ks)-1:0] dut__kmem__address_1;
wire dut__kmem__enable_1;
wire dut__kmem__write_1;

wire [ $clog2(NUMBER_OF_Hs)-1:0] dut__hmem__address_1;
wire dut__hmem__enable_1;
wire dut__hmem__write_1;

wire [ $clog2(OUTPUT_LENGTH)-1:0] dut__dom__address_1;
wire dut__dom__enable_1;
wire dut__dom__write_1;
wire [31:0] dut__dom__data_1;

wire [511:0] M;
wire [31:0]  W_H_data;
wire [$clog2(MAX_MESSAGE_LENGTH):0]     xxx__dut__msg_length_r;

always @(*) begin
    dut__xxx__finish   <= dut__xxx__finish_1;

    dut__msg__address  <= dut__msg__address_1;
    dut__msg__enable   <= dut__msg__enable_1;
    dut__msg__write    <= dut__msg__write_1;

    dut__kmem__address <= dut__kmem__address_1;
    dut__kmem__enable  <= dut__kmem__enable_1;
    dut__kmem__write   <= dut__kmem__write_1;

    dut__hmem__address <= dut__hmem__address_1;
    dut__hmem__enable  <= dut__hmem__enable_1;
    dut__hmem__write   <= dut__hmem__write_1;
    
    dut__dom__address  <= dut__dom__address_1;
    dut__dom__data     <= dut__dom__data_1;
    dut__dom__enable   <= dut__dom__enable_1;
    dut__dom__write    <= dut__dom__write_1;
end

M #(.MAX_MESSAGE_LENGTH(MAX_MESSAGE_LENGTH)) m(.clk(clk), .reset(reset), .xxx__dut__msg_length_r(xxx__dut__msg_length_r), .msg__dut__data(msg__dut__data), .dut__msg__enable(dut__msg__enable_1), .dut__xxx__finish(dut__xxx__finish_1), .M(M));
W w(.clk(clk), .reset(reset), .M(M), .W_start(W_start), .W_H_data(W_H_data));
H h(.clk(clk), .reset(reset), .H_read(H_read), .H_iterate(H_iterate), .hmem__dut__data(hmem__dut__data), .W_H_data(W_H_data), .kmem__dut__data(kmem__dut__data), .dut__dom__data(dut__dom__data_1));
Control #(.OUTPUT_LENGTH(OUTPUT_LENGTH), .MAX_MESSAGE_LENGTH(MAX_MESSAGE_LENGTH), .NUMBER_OF_Ks(NUMBER_OF_Ks), .NUMBER_OF_Hs(NUMBER_OF_Hs)) control(.clk(clk), .reset(reset), .xxx__dut__go(xxx__dut__go), .xxx__dut__msg_length(xxx__dut__msg_length), .dut__msg__address(dut__msg__address_1), .dut__msg__enable(dut__msg__enable_1), .dut__msg__write(dut__msg__write_1), .xxx__dut__msg_length_r(xxx__dut__msg_length_r), .dut__kmem__address(dut__kmem__address_1), .dut__kmem__enable(dut__kmem__enable_1), .dut__kmem__write(dut__kmem__write_1), .dut__hmem__address(dut__hmem__address_1), .dut__hmem__enable(dut__hmem__enable_1), .dut__hmem__write(dut__hmem__write_1), .dut__dom__address(dut__dom__address_1), .dut__dom__enable(dut__dom__enable_1), .dut__dom__write(dut__dom__write_1), .dut__xxx__finish(dut__xxx__finish_1), .W_start(W_start), .H_read(H_read), .H_iterate(H_iterate));

 // `include "v564.vh"


endmodule

