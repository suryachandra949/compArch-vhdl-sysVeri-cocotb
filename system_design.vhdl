library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
entity System_design is
	generic(data_width: integer := 8;
			num_register: integer := 8);

	port(CLK: in STD_LOGIC;
		 RESET: in STD_LOGIC;
		 PB: in STD_LOGIC;
		 LED: out STD_LOGIC_VECTOR( 7 downto 0));
end System_design;


architecture arch of System_design is

signal RA: STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
signal RB: STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
signal Wr_ENABLE: STD_LOGIC;
signal WA: STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);

signal s1: STD_LOGIC;
signal IMM: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal SH: STD_LOGIC_VECTOR(log2(data_width) -1 downto 0);
signal OPCODE: STD_LOGIC_VECTOR(3 downto 0);
signal s4: STD_LOGIC;
signal s3: STD_LOGIC;
signal MA:  STD_LOGIC_VECTOR(data_width -1 downto 0);
signal Mem_load : STD_LOGIC_VECTOR(data_width-1 downto 0);
signal MDA: STD_LOGIC_VECTOR(data_width-1 downto 0);
signal OEN: STD_LOGIC;
signal FLAGS_OUT: STD_LOGIC_VECTOR(0 to 7);
signal MEMDATA_wr: STD_LOGIC_VECTOR(data_width-1 downto 0);
signal MIA: STD_LOGIC_VECTOR(7 downto 0);
signal Instr: STD_LOGIC_VECTOR(31 downto 0);
begin

control: entity work.control_logic
	port map(CLK => CLK,
			 RESET => RESET,
			 Instr => Instr,
			 FLAGS_OUT => FLAGS_OUT,
			 OEN => OEN,
			 WEN => Wr_ENABLE,
			 s1 => s1,
			 s3 => s3,
			 s4 => s4,
			 OPCODE => OPCODE,
			 X => SH,
			 RA => RA,
			 RB => RB,
			 RT => WA,
			 imm => IMM,
			 MA => MA,
			 MIA => MIA);


datapath: entity work.datapath
	generic map(data_width => data_width,
				num_register => num_register)
	port map(CLK => CLK,
			 RST => RESET,
			 RA => RA,
			 RB => RB,
			 Wr_ENABLE => Wr_ENABLE,
			 WA => WA,
			 s1 => s1,
			 IMM => IMM,
			 SH => SH,
			 OPCODE => OPCODE,
			 s4 => s4,
			 s3 => s3,
			 MA => MA,
			 Mem_load => Mem_load,
			 MDA => MDA,
			 OEN => OEN,
			 FLAGS_OUT => FLAGS_OUT,
			 MEMDATA_wr => MEMDATA_wr);

MM_unit: entity work.MM_unit
	port map(CLK => CLK,
			 RESET => RESET,
			 MIA => MIA,
			 OEN => OEN,
			 MDA => MDA,
			 Mem_load => Mem_load,
			 MEMDATA_wr => MEMDATA_wr,
			 LED => LED,
			 PB => PB,
			 Instr => Instr);

end arch;