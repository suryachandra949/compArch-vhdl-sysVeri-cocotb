library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;

entity System_design_tb is

end System_design_tb;


architecture arch of System_design_tb is

signal CLK: STD_LOGIC;
signal RESET: STD_LOGIC;
signal PB: STD_LOGIC;
signal LED: STD_LOGIC_VECTOR( 7 downto 0);

constant data_width: integer := 16;
constant num_register: integer := 32;

constant clk_period: time := 10 ns;
begin

UUT: entity work.System_design
	generic map(data_width => data_width,
				num_register => num_register)
	port map(CLK => CLK,
			 RESET => RESET,
			 PB => PB,
			 LED => LED);

clk_process: process
			begin
				CLK <= '0';
				wait for clk_period/2;
				CLK <= '1';
				wait for clk_period/2;
			end process;

TEST: process
	begin
	wait for 100 ns;
	wait until falling_edge(CLK);
	RESET <= '0';
	wait for clk_period;
	RESET <= '1';
	wait for clk_period * 7/3;
	RESET <= '0';


	PB <= '1';
	wait for clk_period * 7/3;
	PB <= '0';

	wait;
end process;

end arch;