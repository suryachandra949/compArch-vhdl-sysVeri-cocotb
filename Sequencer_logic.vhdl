library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequencer_logic is
	port(CLK: in STD_LOGIC;
		RESET: in STD_LOGIC;
		Branch_instr: in STD_LOGIC_VECTOR(5 downto 0);
		offset: in STD_LOGIC_VECTOR(8 downto 0);
		FLAGS_OUT: in STD_LOGIC_VECTOR (0 to 7);
		MIA: out STD_LOGIC_VECTOR(7 downto 0));
	
end entity Sequencer_logic;


architecture arch of Sequencer_logic is
signal PC: unsigned (7 downto 0);
signal Sequencer_out: unsigned (7 downto 0);
signal CLB: STD_LOGIC;
begin

process(CLK)
	begin
	if(rising_edge(CLK)) then
		if(RESET = '1') then
			PC <= (others => '0');
		else
			PC <= Sequencer_out;
		end if;
	end if;
end process;

CLB <= '1' when Branch_instr = "110000" and FLAGS_OUT(0) = '1' else
	   '1' when Branch_instr = "110001" and FLAGS_OUT(1) = '1' else
	   '1' when Branch_instr = "110010" and FLAGS_OUT(2) = '1' else
	   '1' when Branch_instr = "110011" and FLAGS_OUT(3) = '1' else
	   '1' when Branch_instr = "110100" and FLAGS_OUT(4) = '1' else
	   '1' when Branch_instr = "110101" and FLAGS_OUT(5) = '1' else
	   '1' when Branch_instr = "110110" and FLAGS_OUT(6) = '1' else
	   '0';

Sequencer_out <= PC + unsigned(offset(7 downto 0)) when CLB ='1' and offset(8) = '0' else
				PC - unsigned(offset(7 downto 0)) when CLB='0' and offset(8) = '1' else
				PC when reset='1' else
				PC + 1;

MIA <= STD_LOGIC_VECTOR(Sequencer_out);
end architecture arch;