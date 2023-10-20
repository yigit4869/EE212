----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2023 20:21:04
-- Design Name: 
-- Module Name: logicalshiftleft - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rotate_right is
 Port (input: in std_logic_vector(5 downto 0 );
       output: out std_logic_vector(5 downto 0));
end rotate_right;

architecture Behavioral of rotate_right is

begin
process(input)
begin
for i in 1 to 5 loop
output(i-1) <= input(i);
output(5) <= input(0);
end loop;
end process;

end Behavioral;
