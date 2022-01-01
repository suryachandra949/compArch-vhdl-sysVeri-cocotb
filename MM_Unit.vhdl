library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MM_Unit is
	port(CLK: in STD_LOGIC;
		 RESET: in STD_LOGIC;
		 MIA: in STD_LOGIC_VECTOR( 7 downto 0);
		 OEN: in STD_LOGIC;
		 MDA: in STD_LOGIC_VECTOR(15 downto 0);
		 Mem_load: out STD_LOGIC_VECTOR(15 downto 0);
		 MEMDATA_wr: in STD_LOGIC_VECTOR(15 downto 0);
		 LED: out STD_LOGIC_VECTOR(7 downto 0);
		 PB: in STD_LOGIC;
		 Instr: out STD_LOGIC_VECTOR(31 downto 0));

end MM_Unit;


architecture arch of MM_Unit is

signal DP_Mem_inst_Add: STD_LOGIC_VECTOR(6 downto 0);
signal DP_Mem_data_Add: STD_LOGIC_VECTOR(6 downto 0);
signal WE: STD_LOGIC;
signal DP_MEM_data_read: STD_LOGIC_VECTOR(31 downto 0);
signal DP_MEM_data_write: STD_LOGIC_VECTOR(31 downto 0);
signal LED_output: STD_LOGIC_VECTOR(15 downto 0);
signal Mem_load_data: STD_LOGIC_VECTOR(15 downto 0);

signal MSB_Mem_data_16 : STD_LOGIC_VECTOR(15 downto 0);
signal LSB_Mem_data_16: STD_LOGIC_VECTOR(15 downto 0);
signal PB_resize: STD_LOGIC_VECTOR(15 downto 0);
begin
	DP_Mem_inst_Add <= MIA(6 downto 0);

	DP_Mem_data_Add <= STD_LOGIC_VECTOR(unsigned(MDA(7 downto 1 )) + 64);

	WE <= OEN;

	PB_resize<= X"0001" when PB ='1' else
                   (others=> '0');

    
				    
	Mem_load <= PB_resize when (MDA = X"01F0") else
                  DP_MEM_data_read (15 downto 0) when MDA(0) = '0' else
                  DP_MEM_data_read (31 downto 16);

    MSB_Mem_data_16 <= DP_MEM_data_read(31 downto 16);
    LSB_Mem_data_16 <= DP_MEM_data_read(15 downto 0);

	DP_MEM_data_write <= MSB_Mem_data_16 & MEMDATA_wr when MDA(0) ='0' else
						 MEMDATA_wr & LSB_Mem_data_16;


DualPort_Mem: entity work.DP_Memory
    Port map(CLK => CLK,
    		DP_Mem_inst_Add => DP_Mem_inst_Add,
            DP_Mem_data_Add =>DP_Mem_data_Add,
            WE=>WE,
            DP_MEM_data_read =>DP_MEM_data_read,
            DP_MEM_data_write => DP_MEM_data_write,
            Instr => Instr);


process(CLK)
begin
	
if (rising_edge(CLK)) then
    if (RESET = '1') then
		LED_output <= (others => '0');
	else
		if(WE = '1' and MDA = X"01F8") then
			LED_output <= MEMDATA_wr;
				
		end if;
	end if;
end if;

end process;	

LED <= LED_output(15 downto 8);
	
end arch;