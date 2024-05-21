library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE MY IS
PROCEDURE SQ(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal spaceshipAddress: out integer range 0 to (2**15)-1;
signal spaceshipData : in STD_LOGIC_VECTOR(23 downto 0);
signal playerHit:in std_logic);

END MY;
PACKAGE BODY MY IS

PROCEDURE SQ(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal spaceshipAddress: out integer range 0 to (2**15)-1;signal spaceshipData : in STD_LOGIC_VECTOR(23 downto 0);
signal playerHit:in std_logic) IS

BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+150) AND Ycur>Ypos AND Ycur<(Ypos+150))THEN
	if(playerHit='1')then
		DRAW<='0';
		
	 else
	 RGB<="11111111";
	 spaceshipAddress<=(Xcur-1)+(Ycur-1)-(Xpos)-Ypos+(149*((Ycur-1)-Ypos));
	 R<=spaceshipData(23 downto 16);
	 G<=spaceshipData(15 downto 8);
	 B<=spaceshipData(7 downto 0);
	 DRAW<='1';
	 end if;
 ELSE
 spaceshipAddress<=0;
 DRAW<='0';
 END IF;
 
END SQ;
END MY;