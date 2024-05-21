library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE credits IS
PROCEDURE SQ_credits(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal creditsAddress: out integer range 0 to (2**13)-1;
signal creditsData : in STD_LOGIC_VECTOR(23 downto 0));

END credits;

PACKAGE BODY credits IS
PROCEDURE SQ_credits(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal creditsAddress: out integer range 0 to (2**13)-1;
signal creditsData : in STD_LOGIC_VECTOR(23 downto 0)) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+100) AND Ycur>Ypos AND Ycur<(Ypos+42))THEN

	RGB<="11111111";
	 creditsAddress<=(Xcur-1)+(Ycur-1)-(Xpos)-Ypos+(41*((Ycur-1)-Ypos));
	 R<=creditsData(23 downto 16);
	 G<=creditsData(15 downto 8);
	 B<=creditsData(7 downto 0);
	 DRAW<='1';
	 ELSE
	 DRAW<='0';
	 creditsAddress<=0;

 END IF;
 
END SQ_credits;
END credits;