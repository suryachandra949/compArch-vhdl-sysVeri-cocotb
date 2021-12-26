library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity D_Register is
    generic(reg_width: integer:= 8);
    port(CLK: in STD_LOGIC;
         RST: in STD_LOGIC;
         EN: in STD_LOGIC;
         D: in STD_LOGIC_VECTOR(reg_width-1 downto 0);
         Q: out STD_LOGIC_VECTOR(reg_width-1 downto 0));
end D_Register;

architecture arch of D_Register is

begin
process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(RST = '1') then
                Q <= (others => '0');
            else
                if(EN = '1') then
                Q <= D;
                end if;
            end if;
        end if;
end process;
end arch;
