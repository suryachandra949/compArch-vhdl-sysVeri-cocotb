library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;

entity datapath is
    generic(data_width: integer := 8;
            num_register: integer :=8);
            
    Port(CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        RA : in STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
        RB : in STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
        Wr_ENABLE: in STD_LOGIC; 
        WA: in STD_LOGIC_VECTOR(log2(num_register) -1 downto 0);
 -- COntrol signals
        s1: in STD_LOGIC;
        IMM: in STD_LOGIC_VECTOR(data_width -1 downto 0);
        SH: in STD_LOGIC_VECTOR(log2(data_width) -1 downto 0);
        OPCODE: in STD_LOGIC_VECTOR(3 downto 0);
        s4: in STD_LOGIC;
        s3: in STD_LOGIC;
        MA: in STD_LOGIC_VECTOR(data_width -1 downto 0);
        Mem_load: in STD_LOGIC_VECTOR(data_width -1 downto 0);
        MDA: out STD_LOGIC_VECTOR(data_width -1 downto 0);
		FLAGS_OUT : out STD_LOGIC_VECTOR(0 to 7));
        
end datapath;

architecture Behavioral of datapath is

signal REG_wr_Data: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal REG_READ1: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal REG_READ2: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal ALU_in_mux: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal ALU_OUT: STD_LOGIC_VECTOR(data_width -1 downto 0);
begin

registers_inst: entity work.RegisterBank
	generic map(data_width => data_width,
				num_register => num_register)
	port map(CLK => CLK,
			RST => RST,
			REG_wr_Data => REG_wr_Data,
			REG_ADDR => WA,
			wr_ENABLE => wr_ENABLE,
			REG_READ1_ADDRESS =>  RA,
			REG_READ2_ADDRESS => RB,
			REG_READ1 => REG_READ1,
			REG_READ2 => REG_READ2);
				
ALU_in_mux <= IMM when s1 = '1' else
			  REG_READ2;

ALU: entity work.ALU
	generic map(data_width => data_width)
	port map(A => REG_READ1,
			B => ALU_in_mux,
			X => SH,
			ALU_OUT => ALU_OUT,
			OPCODE => OPCODE,
			FLAGS_OUT => FLAGS_OUT);

MDA <= MA when s3 = '1' else
		ALU_OUT;

REG_wr_Data <= ALU_OUT when s4 = '0' else
			   Mem_load; -- Need to change (place holder for now)

end Behavioral;

