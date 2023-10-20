
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity comparator is
 Port (A, B : in std_logic_vector(5 downto 0);
        eq: out std_logic;
        AgtB: out std_logic;
        AltB: out std_logic
        );
end comparator;

architecture Behavioral of comparator is
signal ic: std_logic_vector(5 downto 0);
begin
eq <= ic(5) and ic(4) and ic(3) and ic(2) and ic(1) and ic(0);
AgtB <= (A(3) and not B(3)) or (ic(3) and A(2) and not B(2)) or (ic(3) and ic(2) and A(1) and not B(1)) or (ic(3) and ic(2) and ic(1) and A(0) and not B(0));
AltB <= not ((ic(5) and ic(4) and ic(3) and ic(2) and ic(1) and ic(0)) or  (A(3) and not B(3)) or (ic(3) and A(2) and not B(2)) or (ic(3) and ic(2) and A(1) and not B(1)) or (ic(3) and ic(2) and ic(1) and A(0) and not B(0)));         
process(A,B)
begin
ic(0) <= A(0) xnor B(0);
ic(1) <= A(1) xnor B(1);
ic(2) <= A(2) xnor B(2);
ic(3) <= A(3) xnor B(3);
ic(4) <= A(4) xnor B(4);
ic(5) <= A(5) xnor B(5);



end process;


end Behavioral;
