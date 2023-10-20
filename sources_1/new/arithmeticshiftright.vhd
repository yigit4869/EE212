

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity arithmeticshiftright is
 Port (input: in std_logic_vector(5 downto 0 );
       output: out std_logic_vector(5 downto 0));
end arithmeticshiftright;

architecture Behavioral of arithmeticshiftright is

begin
process(input)
begin
for i in 1 to 5 loop
output(i-1) <= input(i);
output(5) <= input(5);
end loop;
end process;

end Behavioral;
