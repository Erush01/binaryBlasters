library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE alienMissile IS
PROCEDURE SQ_AlienMissile(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
END alienMissile;

PACKAGE BODY alienMissile IS
PROCEDURE SQ_AlienMissile(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+10) AND Ycur>Ypos AND Ycur<(Ypos+30))THEN
	 RGB<="11111111";
	 DRAW<='1';
	 ELSE
	 DRAW<='0';
 END IF;
 
END SQ_AlienMissile;
END alienMissile;