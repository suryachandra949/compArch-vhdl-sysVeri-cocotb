library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
entity control_tb is

end control_tb;


architecture arch of control_tb is

constant data_width: integer := 16;
constant num_register: integer := 32;

signal CLK: STD_LOGIC;
signal RESET: STD_LOGIC;
signal Instr: STD_LOGIC_VECTOR(31 downto 0);
signal FLAGS_OUT: STD_LOGIC_VECTOR(0 to 7);
signal OEN: STD_LOGIC;
signal WEN: STD_LOGIC;
signal s1: STD_LOGIC;
signal s3: STD_LOGIC;
signal s4: STD_LOGIC;
signal OPCODE: STD_LOGIC_VECTOR(3 downto 0);
signal X: STD_LOGIC_VECTOR(3 downto 0);
signal RA: STD_LOGIC_VECTOR(4 downto 0);
signal RB: STD_LOGIC_VECTOR(4 downto 0);
signal RT: STD_LOGIC_VECTOR(4 downto 0);
signal imm: STD_LOGIC_VECTOR(15 downto 0);
signal MA: STD_LOGIC_VECTOR(9 downto 0);
signal MIA: STD_LOGIC_VECTOR(7 downto 0);
signal Mem_load: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal MDA: STD_LOGIC_VECTOR(data_width -1 downto 0);

begin

control: entity work.control
		 Port map(CLK => CLK,
		 		  RESET => RESET,
		 		  Instr => Instr,
		 		  FLAGS_OUT => FLAGS_OUT,
		 		  OEN => OEN,
		 		  WEN => WEN,
		 		  s1 => s1,
		 		  s3 => s3,
		 		  s4 => s4,
		 		  OPCODE => OPCODE,
		 		  X => X,
		 		  RA => RA,
		 		  RB => RB,
		 		  RT => RT,
		 		  imm => imm,
		 		  MA => MA,
		 		  MIA => MIA);

datapath: entity work.datapath
    generic map(data_width => data_width,
                num_register => num_register)
    Port map(CLK => CLK,
            RST => RST,
            RA => RA,
            RB => RB,
            Wr_ENABLE => WEN,
            WA => RT,
            s1 => s1,
            IMM => IMM,
            SH => X,
            OPCODE => OPCODE,
            s4 => s4,
            s3 => s3,
            MA => MA,
            Mem_load => Mem_load,
            MDA => MDA,
            FLAGS_OUT => FLAGS_OUT);

clk_process: process
            begin
                CLK <='0';
                wait for clk_period/2;
                CLK<='1';
                wait for clk_period/2;
            end process;


end control_tb;