
module ALU(A,B,X,OPCODE,ALU_OUT,FLAGS_OUT);
parameter data_width = 16;
input signed [data_width-1:0] A;
input signed [data_width-1:0] B;
input unsigned [3:0] X;
input  [3:0] OPCODE;

output signed reg [data_width-1:0] ALU_OUT;
output [0:7] FLAGS_OUT;

reg ALU_OUT_temp;
wire overflow_check_add;
wire overflow_check_sub;

always @(A,B,X,OPCODE) begin
      case (OPCODE)
         4'b0100 : ALU_OUT_temp = A & B;
         4'b0101 : ALU_OUT_temp = A | B;
         4'b0110 : ALU_OUT_temp = A ^ B;
         4'b0111 : ALU_OUT_temp = ~ A;
         4'b1000 : ALU_OUT_temp = A + 1;
         4'b1001 : ALU_OUT_temp = A - 1;
         4'b1010 : ALU_OUT_temp = A + B;
         4'b1011 : ALU_OUT_temp = A - B;
         4'b1100 : ALU_OUT_temp = A << X;
         4'b1101 : ALU_OUT_temp = A >> X;
         4'b1110 : ALU_OUT_temp = {A[data_width-1-X:0], A[data_width-1:data_width-X]};
         4'b1111 : ALU_OUT_temp = {A[data_width-1:data_width-X],A[data_width-1-X:0]};
         default : ALU_OUT_temp = A;
      endcase
   end


assign FLAGS_OUT[0] = (ALU_OUT_temp) ? 0 : 1;
assign FLAGS_OUT[1] = (ALU_OUT_temp != 0) ? 1:0;
assign FLAGS_OUT[2] = (ALU_OUT_temp) ? 1:0;
assign FLAGS_OUT[3] = (ALU_OUT_temp < 0) ? 1: 0;
assign FLAGS_OUT[4] = (ALU_OUT_temp > 0) ? 1:0;
assign FLAGS_OUT[5] = (ALU_OUT_temp <= 0) ? 1:0;
assign FLAGS_OUT[6] = (ALU_OUT_temp >= 0) ? 1:0;

assign overflow_check_add = (A[data_width-1] ^ ALU_OUT_TEMP[data_width-1]) &  (B[data_width-1] ^ ALU_OUT_TEMP[data_width-1]);
assign overflow_check_sub = (A[data_width-1] ^ B[data_width-1]) & (B[data_width-1] & ALU_OUT_TEMP[data_width-1]); 


assign FLAGS_OUT[7] = ((overflow_check_add = '1' && (OPCODE="1000" || OPCODE="1010")) || (overflow_check_sub ='1' && (OPCODE="1001" || OPCODE="1011"))) ? 1:0;





endmodule

