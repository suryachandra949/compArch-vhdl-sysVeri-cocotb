
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

-- This entity descibes the ALU behaviour
-- The ALU performs certain operations like add, sub, shift etc 
-- on two signed operands of parameterizable width.
-- The ALU also generates flags for interrupt subsystem.
entity ALU is
  generic (data_width : integer := 16);                             --Width of the operands
  port (A: in STD_LOGIC_VECTOR (data_width -1 downto 0);            --Input A operand to the ALU
        B: in STD_LOGIC_VECTOR (data_width -1 downto 0);            --Input B operand to the ALU
        X: in STD_LOGIC_VECTOR(log2(data_width)-1 downto 0);        --Shift bits for shift operation 
        OPCODE: in STD_LOGIC_VECTOR ( 3 downto 0);                  --Opcode (control bits) for ALU operation
        ALU_OUT : out STD_LOGIC_VECTOR (data_width -1 downto 0);    --Output of ALU
        FLAGS_OUT: out STD_LOGIC_VECTOR (0 to 7));                  --Flag bits output
end ALU;

architecture arch of ALU is

signal ALU_OUT_TEMP: signed (data_width-1 downto 0);    
signal A_signed : signed (data_width-1 downto 0);         -- Signed value of input A
signal B_signed : signed (data_width-1 downto 0);         -- Signed value of input B
signal Flags: STD_LOGIC_VECTOR (0 to 7);                  
signal overflow_check_add:STD_LOGIC;
signal overflow_check_sub:STD_LOGIC;

begin
A_signed <= signed(A);
B_signed <= signed(B);

ALU_OUT_TEMP <= A_signed and B_signed when OPCODE = "0100" else
			    A_signed or B_signed when OPCODE = "0101" else
                A_signed xor B_signed when OPCODE = "0110" else
                not A_signed when OPCODE = "0111" else
                A_signed + 1 when OPCODE = "1000" else
                A_signed -1 when OPCODE = "1001" else
                A_signed + B_signed when OPCODE = "1010" else
                A_signed - B_signed when OPCODE = "1011" else
                shift_left(A_signed,(to_integer(unsigned(X)))) when OPCODE = "1100" else
                shift_right(A_signed,(to_integer(unsigned(X)))) when OPCODE = "1101" else
                rotate_left(A_signed,(to_integer(unsigned(X)))) when OPCODE = "1110" else
                rotate_right(A_signed,(to_integer(unsigned(X)))) when OPCODE = "1111" else
		            A_signed;

Flags(0) <= '1' when ALU_OUT_TEMP = 0 else
            '0';
Flags(1) <= '1' when ALU_OUT_TEMP /= 0 else
            '0';
Flags(2) <= '1' when ALU_OUT_TEMP = 1 else
            '0';
Flags(3) <= '1' when ALU_OUT_TEMP < 0 else                         -- 1 1 0  0 0 1. 0 1 0  0 1 1
            '0';
Flags(4) <= '1' when ALU_OUT_TEMP > 0 else
            '0';
Flags(5) <= '1' when ALU_OUT_TEMP <=0 else
            '0';
Flags(6) <= '1' when ALU_OUT_TEMP >= 0 else
            '0';
--Overflow detection logic 
overflow_check_add <= (A(data_width-1) xor ALU_OUT_TEMP(data_width-1)) and  (B(data_width-1) xor ALU_OUT_TEMP(data_width-1));
overflow_check_sub <= (A(data_width-1) xor B(data_width-1)) and (B(data_width-1) and ALU_OUT_TEMP(data_width-1)); 

Flags(7) <= '1' when (overflow_check_add = '1' and (OPCODE="1000" or OPCODE="1010")) or (overflow_check_sub ='1' and (OPCODE="1001" or OPCODE="1011"))   else
            '0';

ALU_OUT <= STD_LOGIC_VECTOR(ALU_OUT_TEMP);
FLAGS_OUT <= STD_LOGIC_VECTOR(Flags);

end arch;
