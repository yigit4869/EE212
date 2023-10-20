
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity logicalshiftleft is
 Port (input: in std_logic_vector(5 downto 0 );
       output: out std_logic_vector(5 downto 0));
end logicalshiftleft;

architecture Behavioral of logicalshiftleft is

begin
process(input)
begin
for i in 0 to 4 loop
output(i+1) <= input(i);
output(0) <= '0';
end loop;
end process;

end Behavioral;
