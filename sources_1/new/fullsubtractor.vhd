

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity full_subtractor is
 Port ( A, B, Bin: in std_logic;
        D, Bout: out std_logic); 
end full_subtractor;

architecture Behavioral of full_subtractor is
begin
D <= (A xor B) xor Bin;
Bout <= ((B xor Bin) and not A) or (B and Bin);


end Behavioral;
