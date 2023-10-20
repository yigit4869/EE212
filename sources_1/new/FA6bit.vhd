library ieee;
use ieee.std_logic_1164.all;

entity FA_6bit is
port(x,y : in std_logic_vector(5 downto 0);
     Cin : in std_logic;
      sum : out std_logic_vector(5 downto 0);
      co : out std_logic);
end FA_6bit;

architecture FA_arch of FA_6bit is
signal cary : std_logic_vector(4 downto 0);

component full_adder is
  port (A,B,Cin:in std_logic; 
        s,c: out std_logic);
end component;
  begin
     a0:full_adder port map (x(0),y(0),cin,sum(0),cary(0));
     a1:full_adder port map (x(1),y(1),cary(0),sum(1),cary(1));
     a2:full_adder port map (x(2),y(2),cary(1),sum(2),cary(2));
     a3:full_adder port map (x(3),y(3),cary(2),sum(3),cary(3));
     a4:full_adder port map (x(4),y(4),cary(3),sum(4),cary(4));
     a5:full_adder port map (x(5),y(5),cary(4),sum(5),co);
     
end FA_arch;
