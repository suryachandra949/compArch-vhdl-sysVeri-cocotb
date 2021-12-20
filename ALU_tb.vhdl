library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DigEng.All;
entity ALU_tb is

end ALU_tb;

architecture arch of ALU_tb is
constant width_size: integer :=16;
signal A: STD_LOGIC_VECTOR (width_size -1 downto 0);
signal B:STD_LOGIC_VECTOR(width_size - 1 downto 0);
signal X:STD_LOGIC_VECTOR(log2(width_size) -1 downto 0);
signal OPCODE: STD_LOGIC_VECTOR(3 downto 0);
signal ALU_OUT: STD_LOGIC_VECTOR(width_size -1 downto 0);
signal FLAGS_OUT: STD_LOGIC_VECTOR(0 to 7);
begin
UUT: entity work.ALU
    generic map(data_width => width_size)
    Port map(A=>A,
            B =>B,
            X=>X,
            OPCODE=>OPCODE,
            ALU_OUT => ALU_OUT,
            FLAGS_OUT=>FLAGS_OUT);

TEST: process
type test_vector is record
    A: STD_LOGIC_VECTOR (width_size -1 downto 0);
    B:STD_LOGIC_VECTOR(width_size - 1 downto 0);
    X:STD_LOGIC_VECTOR(log2(width_size) -1 downto 0);
    OPCODE: STD_LOGIC_VECTOR(3 downto 0);
    ALU_OUT:STD_LOGIC_VECTOR(width_size-1 downto 0);
    FLAGS_OUT: STD_LOGIC_VECTOR(0 to 7);
end record;

type test_vector_array is array
    (natural range <>) of test_vector;
    constant test_vectors: test_vector_array :=
    ((X"0900",  X"0000", "0000", "0000" , X"0900", "01001010"), -- testing for no operation
    (X"4000",  X"7000",  "0000", "0100" , X"4000", "01001010"), -- testing for AND operation
    (X"F003",  X"7230",  "0000", "0101" , X"F233", "01010100"), -- testing for OR operation
    (X"B021",  X"7230",  "0000", "0110" , X"C211", "01010100"), -- testing for XOR operation
    (X"2541",  X"0000",  "0000", "0111" , X"DABE", "01010100"), -- testing for NOT operation
    (X"3122",  X"0000",  "0000", "1000" , X"3123", "01001010"), -- testing for increment by 1 operation
    (X"3122",  X"0000",  "0000", "1001" , X"3121", "01001010"), -- testing for decrement by 1 operation
    (X"3122",  X"8130",  "0000", "1010" , X"B252", "01010100"), -- testing for 2-input addition operation
    (X"FC18",  X"F060",  "0000", "1011" , X"0BB8", "01001010"), -- testing for 2-input subtraction opeartion
    (X"2C28",  X"0000",  "0100", "1100" , X"C280", "01010100"), -- testing for arithmetic shift left
    (X"12A8",  X"0000",  "0110", "1101" , X"004A", "01001010"), -- testing for arithmetic shift right
    (X"3128",  X"0000",  "0100", "1110" , X"1283", "01001010"), -- testing for rotate left
    (X"A221",  X"0000",  "0010", "1111" , X"6888", "01001010")); -- testing for rotate right

begin
    wait for 100 ns;
    for i in test_vectors'range loop
      --set the inputs
      A <= test_vectors(i).A;
      B <= test_vectors(i).B;
      X <=test_vectors(i).X;
      OPCODE <= test_vectors(i).OPCODE;
      -- wait for results
      wait for 10 ns;
      -- check for outputs
      assert ALU_OUT = test_vectors(i).ALU_OUT
      report "ALU_OUT mismatch"
      severity failure;

      assert FLAGS_OUT = test_vectors(i).FLAGS_OUT
      report "FLAGS_OUT mismatch"
      severity failure;

      report "Output is correct"
      severity note;
    end loop;
    report "end of test"
    severity note;
    wait;
end process;

end arch;
