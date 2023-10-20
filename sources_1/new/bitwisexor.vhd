


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bitwisexor is
  Port (in1 : in std_logic_vector(5 downto 0);
        in2 : in std_logic_vector(5 downto 0);
        out1 : out std_logic_vector(5 downto 0));
end bitwisexor;

architecture Behavioral of bitwisexor is

begin
process (in1, in2)
begin
for i in 0 to 5 loop
out1(i) <= in1(i) xor in2(i);
end loop;
end process;
end Behavioral;
