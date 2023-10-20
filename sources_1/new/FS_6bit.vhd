library ieee;
use ieee.std_logic_1164.all;

entity FS_6bit is
port(x,y : in std_logic_vector(5 downto 0);
     bin : in std_logic;
      D : out std_logic_vector(5 downto 0);
      bout : out std_logic);
end FS_6bit;

architecture FS_arch of FS_6bit is
signal carry : std_logic_vector(4 downto 0);

component full_subtractor is
  port (A,B, Bin:in std_logic; 
        D, Bout: out std_logic);
end component;
  begin
     s0:full_subtractor port map (x(0),y(0),bin,D(0),carry(0));
     s1:full_subtractor port map (x(1),y(1),carry(0),D(1),carry(1));
     s2:full_subtractor port map (x(2),y(2),carry(1),D(2),carry(2));
     s3:full_subtractor port map (x(3),y(3),carry(2),D(3),carry(3));
     s4:full_subtractor port map (x(4),y(4),carry(3),D(4),carry(4));
     s5:full_subtractor port map (x(5),y(5),carry(4),D(5),bout);
     
end FS_arch;
