library ieee;
use ieee.std_logic_1164.all;
entity full_adder is
  port (A,B,Cin:in std_logic; 
        s,c: out std_logic);
end full_adder;

architecture FA_arc of full_adder is
  begin
    s <= A xor B xor Cin;
    c <= (A and B) or (B and Cin) or (A and Cin);
   end FA_arc;