library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity control_logic is
	--generic(data_width: integer :=16);
	port(CLK: in STD_LOGIC;
		RESET: in STD_LOGIC;
		Instr: in STD_LOGIC_VECTOR(31 downto 0);
		FLAGS_OUT: in STD_LOGIC_VECTOR(0 to 7);
		OEN: out STD_LOGIC;
		WEN: out STD_LOGIC;
		s1: out STD_LOGIC;
		s3: out STD_LOGIC;
		s4: out STD_LOGIC;
		OPCODE: out STD_LOGIC_VECTOR(3 downto 0);
		X: out STD_LOGIC_VECTOR(3 downto 0);
		RA: out STD_LOGIC_VECTOR(4 downto 0);
		RB: out STD_LOGIC_VECTOR(4 downto 0);
		RT: out STD_LOGIC_VECTOR(4 downto 0);
		imm: out STD_LOGIC_VECTOR(15 downto 0);
		MA: out STD_LOGIC_VECTOR(15 downto 0);
		MIA: out STD_LOGIC_VECTOR(7 downto 0));
	end control_logic;



architecture arch of control_logic is
signal offset: STD_LOGIC_VECTOR(8 downto 0);
signal Instr_reg: STD_LOGIC_VECTOR(31 downto 0);
begin

process (clk) begin
if rising_edge(clk) then
	if (RESET = '1') then
		Instr_reg <= (others => '0'); 
	else
		Instr_reg <= Instr;
	end if;
end if;
end process;



s1 <= '0' when Instr_reg(31 downto 26) = "000101" or Instr_reg(31 downto 26) = "000100" or Instr_reg(31 downto 26) = "010001" or Instr_reg(31 downto 26) = "010010" or  Instr_reg(31 downto 26) = "010011" else
		'1';

s3 <= '1' when Instr_reg(31 downto 26) = "100001" or Instr_reg(31 downto 26) = "100101" else
		'0';

s4 <= '1' when Instr_reg(31 downto 26) = "100001" or Instr_reg(31 downto 26) = "100010" or Instr_reg(31 downto 26) = "100011" else
		'0';

OEN <= '1' when Instr_reg(31 downto 26) = "100101" or Instr_reg(31 downto 26) = "100110" or Instr_reg(31 downto 26) = "100111" else
		'0';

WEN <= '0' when Instr_reg(31 downto 26)="000000" or Instr_reg(31 downto 26) = "100101" or Instr_reg(31 downto 26) = "100110" or Instr_reg(31 downto 26) = "100111" or Instr_reg(31 downto 30)="11" else
		'1';

OPCODE <= "1010" when Instr_reg(31 downto 26) ="000100" or Instr_reg(31 downto 26) ="000110" or Instr_reg(31 downto 26)="100011" or Instr_reg(31 downto 26)="100111" else
		  "1011" when Instr_reg(31 downto 26) ="000101" or Instr_reg(31 downto 26) ="000111" else
		  "0111" when Instr_reg(31 downto 26) ="010000" else
		  "0100" when Instr_reg(31 downto 26) ="010001" or Instr_reg(31 downto 26)="010100" else
		  "0101" when Instr_reg(31 downto 26) ="010010" or Instr_reg(31 downto 26)="010101" else
		  "0110" when Instr_reg(31 downto 26) ="010011" or Instr_reg(31 downto 26)="010110" else
		  "1100" when Instr_reg(31 downto 26) ="011000" else
		  "1101" when Instr_reg(31 downto 26) ="011001" else
		  "1110" when Instr_reg(31 downto 26) ="011010" else
		  "1111" when Instr_reg(31 downto 26) ="011011" else
		  "1000" when Instr_reg(31 downto 26) ="001000" else
		  "1001" when Instr_reg(31 downto 26) ="001001" else
		  "0000";


RA <= Instr_reg(9 downto 5);

RB <= Instr_reg(14 downto 10) when Instr_reg(31 downto 26) = "000101" or Instr_reg(31 downto 26) = "000100" or Instr_reg(31 downto 26) = "010001" or Instr_reg(31 downto 26) = "010010" or  Instr_reg(31 downto 26) = "010011" else
	  Instr_reg(4 downto 0);

RT <= Instr_reg(4 downto 0);

X <= Instr_reg(13 downto 10);

imm <= Instr_reg(25 downto 10);

MA <= Instr_reg(25 downto 10);

offset <= Instr_reg(18 downto 10);


Sequencer: entity work.Sequencer_logic
	port map(CLK => CLK,
			RESET=> RESET,
			offset => offset,
			Branch_Instr => Instr_reg(31 downto 26),
			FLAGS_OUT => FLAGS_OUT,
			MIA => MIA);
	
end arch;