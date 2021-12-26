
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.ALL;
entity datapath_tb is

end datapath_tb;

architecture arch of datapath_tb is
    constant data_width: integer := 16;
    constant num_register: integer := 32;
signal CLK: STD_LOGIC;
signal RST: STD_LOGIC;
signal RA : STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
signal RB :  STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
signal Wr_ENABLE: STD_LOGIC; 
signal WA: STD_LOGIC_VECTOR(log2(num_register) -1 downto 0);
     -- COntrol signals
signal s1: STD_LOGIC;
signal IMM: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal SH: STD_LOGIC_VECTOR(log2(data_width) -1 downto 0);
signal OPCODE: STD_LOGIC_VECTOR(3 downto 0);
signal s4: STD_LOGIC;
signal s3: STD_LOGIC;
signal MA: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal Mem_load: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal MDA: STD_LOGIC_VECTOR(data_width -1 downto 0);
signal OEN: STD_LOGIC;
signal FLAGS_OUT : STD_LOGIC_VECTOR(0 to 7);

constant clk_period : time := 10 ns;  
begin
UUT: entity work.datapath
    generic map(data_width => data_width,
                num_register => num_register)
    Port map(CLK => CLK,
            RST => RST,
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
            FLAGS_OUT => FLAGS_OUT);

clk_process: process
            begin
                CLK <='0';
                wait for clk_period/2;
                CLK<='1';
                wait for clk_period/2;
            end process;

TEST: process
type test_vector is record
     RA : STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
     RB :  STD_LOGIC_VECTOR( log2(num_register) - 1 downto 0);
     Wr_ENABLE: STD_LOGIC; 
     WA: STD_LOGIC_VECTOR(log2(num_register) -1 downto 0);
     -- COntrol signals
     s1: STD_LOGIC;
     IMM: STD_LOGIC_VECTOR(data_width -1 downto 0);
     SH: STD_LOGIC_VECTOR(log2(data_width) -1 downto 0);
     OPCODE: STD_LOGIC_VECTOR(3 downto 0);
     s4: STD_LOGIC;
     s3: STD_LOGIC;
     MA: STD_LOGIC_VECTOR(data_width -1 downto 0);
     Mem_load: STD_LOGIC_VECTOR(data_width -1 downto 0);
     MDA: STD_LOGIC_VECTOR(data_width -1 downto 0);
     FLAGS_OUT : STD_LOGIC_VECTOR(0 to 7);
end record; 

type test_vector_array is array
        (natural range <>) of test_vector;
        -- RA, RB,wr_ENABLE,WA,s1,IMM,SH,OPCODE,s4,s3,MA,MEM_LOAD,MDA,FLAGS_OUT
constant test_vectors: test_vector_array :=
            (("00000", "00000", '1',"00001",'0',X"0000","0000","1000",'0','0',X"0000",X"0000",X"0001","01101010"),
              ("00000", "00000", '1',"00010",'1',X"0005","0000","1010",'0','0',X"0000",X"0000",X"0005","01001010"),
              ("00001", "00000", '1',"00011",'0',X"0000","0011","1100",'0','0',X"0000",X"0000",X"0008","01001010"),
              ("00011", "00010", '0',"00000",'0',X"0000","0000","0000",'0','0',X"0000",X"0000",X"0008","01001010"),
              ("00000", "00000", '1',"00101",'0',X"0000","0000","0000",'1','1',X"1f1f",X"0007",X"1f1f","10000110")
              
              );
            
begin
    wait for 100 ns;
   wait until falling_edge(clk);
   RST <='0';
   wait for clk_period;
   RST <= '1';
   wait for clk_period * 7/2;
   RST <= '0';
   wait for clk_period* 7/2;
   
   for i in test_vectors'range loop
   --set the inputs
        RA <= test_vectors(i).RA;
        RB <= test_vectors(i).RB;
        wr_ENABLE <= test_vectors(i).wr_ENABLE;
        WA <= test_vectors(i).WA;
        s1 <= test_vectors(i).s1;
        IMM <= test_vectors(i).IMM;
        SH <= test_vectors(i).SH;
        OPCODE <= test_vectors(i).OPCODE;
        S4 <= test_vectors(i).S4;
        S3 <= test_vectors(i).S3;
        MA <= test_vectors(i).MA;
        MEM_LOAD <= test_vectors(i).MEM_LOAD;
        
         -- wait for results
         wait for 10 ns;
         -- check for outputs
         assert MDA = test_vectors(i).MDA
         report "MDA mismatch"
         severity error;
       
         assert FLAGS_OUT = test_vectors(i).FLAGS_OUT
         report "FLAGS_OUT mismatch"
         severity error;
      end loop;
      report "end of test"
      severity note;
      wait;
end process;
       
end arch;
