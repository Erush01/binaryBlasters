library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE missile IS
PROCEDURE SQ_missile(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;signal playerHit:in std_logic);
END missile;

PACKAGE BODY missile IS
PROCEDURE SQ_missile(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal playerHit:in std_logic) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+4) AND Ycur>Ypos AND Ycur<(Ypos+30))THEN
	if (playerHit = '1') then 
		DRAW <= '0';
	else
	 RGB<="11111111";
	 DRAW<='1';
	end if;
	 ELSE
	 DRAW<='0';
 END IF;
 
END SQ_missile;
END missile;