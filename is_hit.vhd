library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;
use work.missile.all;
use work.alien.all;

entity is_hit is
port(
	clk : in std_logic;
	SQ_X1: in INTEGER RANGE 0 TO 1688;
	SQ_Y1: in INTEGER RANGE 0 TO 1688;
	SQ_X2: in INTEGER RANGE 0 TO 1688;
	SQ_Y2: in INTEGER RANGE 0 TO 1688;
	
	hit : out std_logic
);
end entity;

architecture main of is_hit is
begin
	process(clk)
		begin
		if((SQ_X2<SQ_X1 AND SQ_X1<SQ_X2+80) AND (SQ_Y2<SQ_Y1 AND SQ_Y1<SQ_Y2+50)) then
			hit <= '1';
		else
			hit<= '0';
		end if;
	end process;
end main;