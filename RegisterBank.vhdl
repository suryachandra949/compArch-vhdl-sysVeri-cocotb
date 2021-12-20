
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity RegisterBank is
    generic (data_width: integer := 8;
             num_register: integer := 8);
    port (CLK: in STD_LOGIC;
          RST: in STD_LOGIC;
          REG_wr_Data : in STD_LOGIC_VECTOR (data_width -1 downto 0);
          REG_ADDR: in STD_LOGIC_VECTOR (log2(num_register) -1 downto 0);
          wr_ENABLE: in STD_LOGIC;
          REG_READ1: out STD_LOGIC_VECTOR(data_width-1 downto 0);
          REG_READ1_ADDRESS: in STD_LOGIC_VECTOR(log2(num_register) -1 downto 0);
          REG_READ2: out STD_LOGIC_VECTOR(data_width-1 downto 0);
          REG_READ2_ADDRESS: in STD_LOGIC_VECTOR(log2(num_register) -1 downto 0));
end RegisterBank;

architecture arch of RegisterBank is
signal REG_wr_ENABLE: STD_LOGIC_VECTOR (num_register -1 downto 0);

type reg_read_bus is array ( 0 to num_register-1) of STD_LOGIC_VECTOR(data_width-1 downto 0);
signal REG_DATA_OUT: reg_read_bus;
type reg_read_registers is array(0 to num_register-1) of STD_LOGIC_VECTOR(data_width-1 downto 0);
signal REG_DATA: reg_read_registers;
begin

REG_READ1 <= (others => '0') when (unsigned(REG_READ1_ADDRESS) = 0) else
            (others => 'Z');
REG_READ2 <= (others => '0') when (unsigned(REG_READ2_ADDRESS) = 0) else
            (others => 'Z');

write_reg: for i in 1 to num_register-1 generate
            REG_wr_ENABLE(i) <= '1' when wr_ENABLE = '1' and unsigned(REG_ADDR) = i else
                                '0';
data_width_register: entity work.D_Register
    generic map(reg_width => data_width)
    port map(CLK => CLK,
             RST => RST,
             EN => REG_wr_ENABLE(i),
             D => REG_wr_Data,
             Q => REG_DATA(i));
            REG_READ1 <= REG_DATA_OUT(i) when (unsigned(REG_READ1_ADDRESS) = i) else
             (others => 'Z');
             REG_READ2 <= REG_DATA_OUT(i) when (unsigned(REG_READ2_ADDRESS) = i) else
             (others => 'Z');
             end generate;
             


bus_inputs: for i in 0 to num_register -1 generate
            REG_DATA_OUT(i) <= REG_DATA(i);
            
            end generate;



end arch;

