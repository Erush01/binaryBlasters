library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE alien IS
PROCEDURE SQ_alien(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal alienshipAddress: out integer range 0 to (2**14)-1;
signal alienshipData : in STD_LOGIC_VECTOR(23 downto 0);
signal alienHit: in std_logic);

END alien;

PACKAGE BODY alien IS
PROCEDURE SQ_alien(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL R: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL G: out STD_LOGIC_VECTOR(7 downto 0);
SIGNAL B: out STD_LOGIC_VECTOR(7 downto 0);SIGNAL RGB:OUT STD_LOGIC_VECTOR(7 downto 0);SIGNAL DRAW: OUT STD_LOGIC;
signal alienshipAddress: out integer range 0 to (2**14)-1;
signal alienshipData : in STD_LOGIC_VECTOR(23 downto 0);
signal alienHit: in std_logic) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+70) AND Ycur>Ypos AND Ycur<(Ypos+70))THEN
	if(alienHit='1')then
		DRAW<='0';
	else
		RGB<="11111111";
	 alienshipAddress<=(Xcur-1)+(Ycur-1)-(Xpos)-Ypos+(69*((Ycur-1)-Ypos));
	 R<=alienshipData(23 downto 16);
	 G<=alienshipData(15 downto 8);
	 B<=alienshipData(7 downto 0);
	 DRAW<='1';
	end if;
	 ELSE
	 DRAW<='0';
	 alienshipAddress<=0;

 END IF;
 
END SQ_alien;
END alien;