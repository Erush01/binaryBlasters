library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;
use work.missile.all;
use work.alien.all;
use work.alienMissile.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
R: OUT STD_LOGIC_VECTOR(7 downto 0);
G: OUT STD_LOGIC_VECTOR(7 downto 0);
B: OUT STD_LOGIC_VECTOR(7 downto 0);
digit0 : out std_LOGIC_VECTOR(3 downto 0);
digit1 : out std_LOGIC_VECTOR(3 downto 0);
digit2 : out std_LOGIC_VECTOR(3 downto 0);
digit3 : out std_logic_vector(3 downto 0);
KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
S: IN STD_LOGIC_VECTOR(1 downto 0);
ps2_key : in STD_LOGIC_VECTOR(7 DOWNTO 0);
ps2_new  : in STD_LOGIC
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
component spaceship is
    Port (
        address : in STD_LOGIC_VECTOR(14 downto 0);
        data_out : out STD_LOGIC_VECTOR(23 downto 0)
    );
end component;

component alienship is
    Port (
        address : in STD_LOGIC_VECTOR(13 downto 0);
        data_out : out STD_LOGIC_VECTOR(23 downto 0)
    );
end component;

-----1280x1024 @ 60 Hz pixel clock 108 MHz

-----Constant declarations 
constant alienNumber : integer:=4;
constant spaceShipX: integer:=900;
constant spaceShipY: integer:=900;
constant DIV_VALUE : integer := 1080000;
constant alienMoveClock:integer:=108000000;

constant left_arrow :STD_LOGIC_VECTOR(7 DOWNTO 0):=x"61";
constant right_arrow :STD_LOGIC_VECTOR(7 DOWNTO 0):=x"64";
constant space :STD_LOGIC_VECTOR(7 DOWNTO 0):= x"20";
constant enter :STD_LOGIC_VECTOR(7 DOWNTO 0):= x"0D";

-------- type declarations------
type RGB_array is array(1 to alienNumber)of std_logic_vector(7 downto 0);
type alienshipAddress_array is array (1 to alienNumber) of integer range 0 to (2**14)-1;
type alienshipData_array is array (1 to alienNumber) of STD_LOGIC_VECTOR(23 downto 0);
type int_array is array(1 to alienNumber)of integer;

----- Counters ------
signal twoHzcounter : integer range 0 to DIV_VALUE := 0;
signal alienMoveCounter : integer range 0 to alienMoveClock := 0;
signal playerHealthCounter: integer:=10;

-------Drawing addresses and data signals

signal spaceshipAddress: integer range 0 to (2**15)-1:=0;
signal spaceshipData : STD_LOGIC_VECTOR(23 downto 0):=(others=>'0');

signal alienshipAddress:alienshipAddress_array;
signal alienshipData :alienshipData_array;

-------- RGB signals
SIGNAL RGB: STD_LOGIC_VECTOR(7 downto 0);
signal Rx: STD_LOGIC_VECTOR(7 downto 0);
signal Gx: STD_LOGIC_VECTOR(7 downto 0);
signal Bx: STD_LOGIC_VECTOR(7 downto 0);

signal alienRx: RGB_array;
signal alienGx: RGB_array;
signal alienBx: RGB_array;

-------Position signals----------
SIGNAL SQ_X1: INTEGER RANGE 0 TO 1688:=spaceShipX;
SIGNAL SQ_Y1: INTEGER RANGE 0 TO 1688:=spaceShipY;
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;
SIGNAL SQ_XMissile1:integer:=spaceShipX+75;
SIGNAL SQ_YMissile1:integer:=spaceShipY+10;


signal SQ_X :int_array:=(600,900,1200,1500);
signal SQ_Y:int_array:=(100,200,200,100);
signal SQ_XAlienMissile:int_array:=SQ_X;
signal SQ_YAlienMissile:int_array:=SQ_Y;

--------------Drawing and hit signals
SIGNAL DRAW1,DRAW2,DRAW3:STD_LOGIC:='0';
signal alienHit1:std_logic:='0';
signal playerHit:std_logic:='0';
signal shooting:std_logic:='0';
signal alien1Move:std_logic:='0';
signal missileDraw1:std_logic:='0';

signal alienHit:std_LOGIC_VECTOR(1 to alienNumber):=(others=>'0');
signal alienDRAW:std_LOGIC_VECTOR(1 to alienNumber):=(others=>'0');
signal alienMissileDRAW:std_LOGIC_VECTOR(1 to alienNumber):=(others=>'0');

signal pressStart:std_logic:='0';

type int_long_array is array(1 to 40) of integer RANGE 0 TO 10000;
signal valCounter : integer:=1;

--signal scores : int_long_array := (0,51,122,303,454,705,1006,1477,1908,2509,2750,3000,3250,3500,3750,4000,4250,4500,4750,5000,5250,5500,5750,6000,6250,6500,6750,7000,7250,7500,7750,8000,8250,8500,8750,9000,9250,9500,9999);
constant scoresd0 : int_long_array := (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9);										 
constant scoresd1 : int_long_array := (0,5,2,0,5,0,0,7,0,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,9);											 
constant scoresd2 : int_long_array := (0,0,1,3,4,7,0,4,9,5,7,0,2,5,7,0,2,5,7,0,2,5,7,0,2,5,7,0,2,5,7,0,2,5,7,0,2,5,7,9);										 
constant scoresd3 : int_long_array := (0,0,0,0,0,0,1,1,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,9);

signal scoreIndex : integer := 1;
signal playerScore : natural := 0;
signal tempValue : natural :=0;
signal tempDigit0 : std_LOGIC_VECTOR(3 downto 0) := "0000";
signal tempDigit1 : std_LOGIC_VECTOR(3 downto 0) := "0000";
signal tempDigit2 : std_LOGIC_VECTOR(3 downto 0) := "0000";
signal d0 : integer := 0;
signal d1 : integer := 0;
signal d2 : integer := 0;

signal verti_difficulty : integer := 1;
signal hori_difficulty : integer := 1;
signal bulletSpeed : integer := 1;

constant SQ_X_Start : int_array := (600,900,1200,1500);
constant SQ_Y_Start : int_array := (100,200,200,100);
constant SQ_Start : integer := 900;
constant SQ2_Start: integer :=900;
constant gameOver: integer := 800;


BEGIN
spaceship1: spaceship port map(address=>std_LOGIC_VECTOR(to_unsigned(spaceshipAddress,15)),data_out=>spaceshipData);
--credits1  : creditsComp port map(address=>std_LOGIC_VECTOR(to_unsigned(creditsAddress,13)),data_out=>creditsData);
SQ(HPOS,VPOS,SQ_X1,SQ_Y1,Rx,Gx,Bx,RGB,DRAW1,spaceshipAddress,spaceshipData,playerHit);

SQ_missile(HPOS,VPOS,SQ_XMissile1,SQ_YMissile1,RGB,missileDraw1,playerHit);
--SQ_missile(HPOS,VPOS,SQ_XMissile2,SQ_YMissile2,RGB,missileDraw2,playerHit);
--SQ_credits(HPOS,VPOS,SQ_Xscreen,SQ_Yscreen,Rs,Gs,Bs,RGB,DRAWCredits,creditsAddress,creditsData);
generate_enemy:
	for i in 1 to alienNumber generate
		alienship1: alienship port map(address=>std_LOGIC_VECTOR(to_unsigned(alienshipAddress(i),14)),data_out=>alienshipData(i));
		SQ_alien(HPOS,VPOS,SQ_X(i),SQ_Y(i),alienRx(i),alienGx(i),alienBx(i),RGB,alienDRAW(i),alienshipAddress(i),alienshipData(i),alienHit(i));
		SQ_AlienMissile(HPOS,VPOS, SQ_XAlienMissile(i),SQ_YAlienMissile(i),RGB,alienMissileDRAW(i));
	end generate;
PROCESS(CLK)
BEGIN	

IF(CLK'EVENT AND CLK='1')THEN
		
		--playerScore <= scores(scoreIndex);

		digit0 <= std_logic_vector(to_unsigned(scoresd0(scoreIndex),4));
		digit1 <= std_logic_vector(to_unsigned(scoresd1(scoreIndex),4));
		digit2 <= std_logic_vector(to_unsigned(scoresd2(scoreIndex),4));
		digit3 <= std_logic_vector(to_unsigned(scoresd3(scoreIndex),4));
		
		if (playerHit = '1') then
			scoreIndex <= 1;
			
			SQ_X1 <= SQ_Start;
			SQ_Y1 <= SQ_Start;
			SQ_XMissile1 <= SQ2_Start+75;
			SQ_YMissile1 <= SQ2_Start+10;

			restart_position: 
			for i in 1 to 4 loop
				SQ_X(i) <= SQ_X_Start(i);
				SQ_Y(i) <= SQ_Y_Start(i);
			end loop restart_position;
			
			playerHit <= '0';
			alienHit <= "0000";
			verti_difficulty <= 1;
			hori_difficulty <= 1;
			bulletSpeed <= 1;
			
		end if;
		
		if (alienHit = "1111")then
			alienHit <= "0000";
			scoreIndex <= scoreIndex + 1;
				
			verti_difficulty <= verti_difficulty + 2;
			if verti_difficulty > 16 then
				verti_difficulty <= 16;
			end if;
			if ((verti_difficulty / 2) mod 5) = 0 then
				hori_difficulty <= hori_difficulty + 1; 
				if hori_difficulty > 5 then
					hori_difficulty <= 5;
					bulletSpeed <= 2;
				end if;
			end if;	
			alien_reposition: 
			for i in 1 to 4 loop
				SQ_X(i) <= SQ_X_Start(i);
				SQ_Y(i) <= SQ_Y_Start(i);
			end loop alien_reposition;
		end if;
		
     IF(DRAW1='1')THEN
		  IF(S(0)='1')THEN
			R<=Rx;
			G<=Gx;
			B<=Bx;
			ELSE
			R<=(others=>'1');
			G<=(others=>'1');
			B<=(others=>'1');
			END IF;
      END IF;
		 IF(missileDraw1='1')THEN
		  IF(S(1)='1' or (ps2_key=space AND ps2_new='1') or shooting='1')THEN
			R<=(others=>'1');
			G<=(others=>'1');
			B<=(others=>'0');
			ELSE
			R<=(others=>'0');
			G<=(others=>'0');
			B<=(others=>'0');
		  END IF;		
      END IF;
		for i in 1 to alienNumber loop
			if(alienMissileDRAW(i)='1')then
				R<=(others=>'0');
				G<=(others=>'0');
				B<=(others=>'1');
			end if;
		end loop;
		for i in 1 to alienNumber loop
			if(alienDRAW(i)='1')then
				R<=alienRx(i);
				G<=alienGx(i);
				B<=alienBx(i);
			end if;
		end loop;
		IF (DRAW1='0' AND DRAW2='0' AND DRAW3='0' and missileDraw1='0' AND to_integer(unsigned(alienDRAW)) = 0 AND to_integer(unsigned(alienMissileDRAW))=0)THEN
				R<=(others=>'0');
				G<=(others=>'0');
				B<=(others=>'0');
		END IF;
		
		
		IF(HPOS<1688)THEN
		HPOS<=HPOS+1;
		ELSE
		HPOS<=0;
		  IF(VPOS<1066)THEN
			  VPOS<=VPOS+1;
			  ELSE
			  VPOS<=0; 
			      IF(S(0)='1')THEN
					    IF(KEYS(0)='0' or (ps2_key=right_arrow and ps2_new='1'))THEN
						  SQ_X1<=SQ_X1+5;

						 END IF;
                   IF(KEYS(1)='0' or (ps2_key=left_arrow and ps2_new='1'))THEN
						  SQ_X1<=SQ_X1-5;
						 END IF;  
					END IF;
			      IF(S(1)='1' or (ps2_key=space and ps2_new='1')) THEN
						if(shooting='0') then
							shooting<='1';
						end if;
					ELSE
						if(shooting='0') then
								SQ_YMissile1<=SQ_Y1+10;
								SQ_XMissile1<=SQ_X1+75;

						end if;
					END IF;
		      END IF;
		END IF;
   IF((HPOS>0 AND HPOS<408) OR (VPOS>0 AND VPOS<42))THEN
	R<=(others=>'0');
	G<=(others=>'0');
	B<=(others=>'0');
	END IF;
   IF(HPOS>48 AND HPOS<160)THEN----HSYNC
	   HSYNC<='0';
	ELSE
	   HSYNC<='1';
	END IF;
   IF(VPOS>0 AND VPOS<4)THEN----------vsync
	   VSYNC<='0';
	ELSE
	   VSYNC<='1';
	END IF;
	
	if(twoHzcounter<DIV_VALUE) then
		twoHzcounter<=twoHzcounter+1;
	else 
		twoHzcounter<=0;
		for i in 1 to alienNumber loop
			SQ_YAlienMissile(i)<=SQ_YAlienMissile(i)+5;
			if(SQ_YAlienMissile(i)>1000)then
				if(alienHit(i)='0') then
					SQ_YAlienMissile(i)<=SQ_Y(i);
				end if;
			end if;
		end loop;
		
		if(shooting='1') then
			SQ_YMissile1<=SQ_YMissile1-5*bulletSpeed;
			
		end if;
		if((SQ_YMissile1< 10)) then
			shooting<='0';
		end if;
		
	end if;
	if(alienMoveCounter<alienMoveClock) then
		alienMoveCounter<=alienMoveCounter+1;
	else
		alienMoveCounter<=0;
		if(alien1Move='0') then
			alien1Move<='1';
			for i in 1 to 4 loop
				SQ_X(i)<=SQ_X(i)+20*hori_difficulty;
				SQ_Y(i)<=SQ_Y(i)+5*verti_difficulty;
			end loop;
		else
			alien1Move<='0';
			for i in 1 to 4 loop
				SQ_X(i)<=SQ_X(i)-20*hori_difficulty;
			end loop;

		end if;
	end if;
	
	shoot_aliens:
	for i in 1 to alienNumber loop
		if(((SQ_X(i)<SQ_XMissile1 AND SQ_XMissile1<SQ_X(i)+70) AND (SQ_Y(i)<SQ_YMissile1 AND SQ_YMissile1<SQ_Y(i)+70))) then
			alienHit(i)<='1';
			shooting<='0';
		end if;
	end loop;
	
	player_shot:
	for i in 1 to 4 loop
		if ((SQ_X1 < SQ_XAlienMissile(i)+20 AND SQ_X1+100 > SQ_XAlienMissile(i)) AND (SQ_YAlienMissile(i)+50 < SQ_Y1 + 100 AND SQ_Y1 < SQ_YAlienMissile(i)+50)) then
			playerHit <= '1';
		end if;
		if SQ_Y(i) > gameOver then
			playerHit <= '1';
		end if;
	end loop player_shot;
	
 END IF;
 END PROCESS;
 
 END MAIN;