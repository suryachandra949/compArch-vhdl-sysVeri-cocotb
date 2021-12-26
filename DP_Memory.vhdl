library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DP_Memory is
	port(CLK: in STD_LOGIC;
		 DP_Mem_inst_Add: in STD_LOGIC_VECTOR(6 downto 0);
		 DP_Mem_data_Add: in STD_LOGIC_VECTOR(6 downto 0);
		 WE: in STD_LOGIC;
		 DP_MEM_data_read: out STD_LOGIC_VECTOR(31 downto 0);
		 DP_MEM_data_write: in STD_LOGIC_VECTOR(31 downto 0);
		 Instr: out STD_LOGIC_VECTOR(31 downto 0));
end DP_Memory;

architecture arch of DP_Memory is
type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
signal my_ram: ram_type := (
0 => X"00000000",
1 => X"8407C00F",
2 => X"C007FC00",
3 => X"18007C1F",
4 => X"10000001",
5 => X"20000021",
6 => X"CC03EFE0",
7 => X"980003E1",
8 => X"20000021",
9 => X"240003FF",
10 => X"DC07F000",
11 => X"84004002",
12 => X"5400101E",
13 => X"880003C3",
14 => X"8C07F7C4",
15 => X"5BFFFC1D",
16 => X"80000007",
17 => X"500043A5",
18 => X"50000486",
19 => X"C003F8A0",
20 => X"10001C67",
21 => X"64000484",
22 => X"60000463",
23 => X"240000A5",
24 => X"C407E8A0",
25 => X"94000007",
26 => X"680024E7",
27 => X"6C000CE7",
28 => X"400000E8",
29 => X"4C0023A8",
30 => X"14001D09",
31 => X"1C00052A",
32 => X"D003DD40",
33 => X"D803E140",
34 => X"1800094B",
35 => X"D403E960",
36 => X"48002CEC",
37 => X"9C07FC0C",
38 => X"44002D8C",
39 => X"C803F580",
40 => X"DC000000",
41 => X"DC000000",
42 => X"9407E007",
43 => X"DC000000",
others => X"00000000");
begin
Instr <= my_ram(to_integer(unsigned(DP_Mem_inst_Add)));
DP_MEM_data_read <= my_ram(to_integer(unsigned(DP_Mem_data_Add)));

process (CLK)
begin
if (rising_edge(CLK)) then
	if (WE='1') then
		my_ram(to_integer(unsigned(DP_Mem_data_Add))) <= DP_MEM_data_write;
	end if;
end if;
end process;


end arch;