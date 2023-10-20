library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU6bit is
    Port(input1: in std_logic_vector(5 downto 0);
        input2: in std_logic_vector(5 downto 0);
        selectF: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(5 downto 0);
        carry: out std_logic;
        equal: out std_logic;
        less_than: out std_logic;
        greater_than: out std_logic);
end ALU6bit;

architecture Behavioral of ALU6bit is

component FA_6bit is
    port(x,y : in std_logic_vector(5 downto 0);
     Cin : in std_logic;
      sum : out std_logic_vector(5 downto 0);
      co : out std_logic);
end component;

component FS_6bit is
    Port (x,y : in std_logic_vector(5 downto 0);
     bin : in std_logic;
      D : out std_logic_vector(5 downto 0);
      bout : out std_logic);
end component;

component logicalshiftleft is
    Port (input: in std_logic_vector(5 downto 0 );
       output: out std_logic_vector(5 downto 0));
end component;

component arithmeticshiftright is
    Port (input: in std_logic_vector(5 downto 0);
    output: out std_logic_vector(5 downto 0));
end component;

component logicalshiftright is
    Port (input: in std_logic_vector(5 downto 0);
    output: out std_logic_vector(5 downto 0));
end component;

component comparator is
 Port (A, B : in std_logic_vector(5 downto 0);
        eq: out std_logic;
        AgtB: out std_logic;
        AltB: out std_logic
        );
end component;

component rotate_right is
    Port (input: in std_logic_vector(5 downto 0);
    output: out std_logic_vector(5 downto 0));
end component;

component bitwisexor
     Port (in1 : in std_logic_vector(5 downto 0);
        in2 : in std_logic_vector(5 downto 0);
        out1 : out std_logic_vector(5 downto 0));
end component;

signal adder_out, subtractor_out, logical_shift_left_out, arithmetic_shift_right_out, logical_shift_right_out, rotate_right_out, bitwise_xor_out: std_logic_vector(5 downto 0);
signal adder_carry, subtractor_carry: std_logic;
signal comp_equal, comp_less_than, comp_greater_than: std_logic;

begin

Adder: FA_6bit port map(x => input1, y => input2, Cin => '0', co => adder_carry, sum => adder_out);
Subtractor: FS_6bit port map(x => input1, y => input2, bout => subtractor_carry, D => subtractor_out, bin => '0');
LogicalShiftLeftt: logicalshiftleft port map(input => input1, output => logical_shift_left_out);
ArithmeticShiftRightt: arithmeticshiftright port map(input => input1, output => arithmetic_shift_right_out);
LogicalShiftRightt: logicalshiftright port map(input => input1, output => logical_shift_right_out);
Comparator1: comparator port map(A => input1, B => input2, eq => comp_equal, AltB => comp_less_than, AgtB => comp_greater_than);
RotateRigh1t: rotate_right port map(input => input1, output => rotate_right_out);
BitwiseXOR1: bitwisexor port map(in1 => input1, in2 => input2, out1 => bitwise_xor_out);

with selectF select result <=
adder_out when                      "000", -- 0
subtractor_out when                 "001", -- 1
logical_shift_left_out when         "010", -- 2
arithmetic_shift_right_out when     "011", -- 3      -- situation numbers
logical_shift_right_out when        "100", -- 4
"000000" when                       "101", -- 5
rotate_right_out when               "110", -- 6
bitwise_xor_out when                "111", -- 7
"000000" when others;

with selectF select carry <=
adder_carry when "000",
subtractor_carry when "001",
'0' when others;

with selectF select equal <=
comp_equal when "101",
'0' when others;

with selectF select less_than <=
comp_less_than when "101",
'0' when others;

with selectF select greater_than <=
comp_greater_than when "101",
'0' when others;

end Behavioral;
