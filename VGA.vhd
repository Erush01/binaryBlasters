library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY VGA IS
PORT(
CLOCK_24: IN STD_LOGIC_VECTOR(1 downto 0);
VGA_HS,VGA_VS:OUT STD_LOGIC;
SW: STD_LOGIC_VECTOR(1 downto 0);
KEY: STD_LOGIC_VECTOR(3 DOWNTO 0);
VGA_CLOCK: OUT STD_LOGIC;
VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(7 downto 0);
hex0_out : out std_LOGIC_VECTOR(6 downto 0);
hex1_out : out std_LOGIC_VECTOR(6 downto 0);
hex2_out : out std_LOGIC_VECTOR(6 downto 0);
hex3_out : out std_LOGIC_VECTOR(6 downto 0);
ps2_clk    : IN  STD_LOGIC;
ps2_data   : IN  STD_LOGIC   
);
END VGA;


ARCHITECTURE MAIN OF VGA IS
SIGNAL VGACLK,RESET:STD_LOGIC;
signal signal2Hz:std_logic;
 COMPONENT SYNC IS
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
	digit3 : out std_LOGIC_VECTOR(3 downto 0);
	KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
   S: IN STD_LOGIC_VECTOR(1 downto 0);
	ps2_key: in STD_LOGIC_VECTOR(7 DOWNTO 0);
	ps2_new  : in STD_LOGIC

	);
END COMPONENT SYNC;

	 component PLL is
        port (
				clk_out_clk : out std_logic;         -- clk
            clk_in_clk  : in  std_logic := 'X'; -- clk
            reset_reset : in  std_logic := 'X' -- reset
            
        );
    end component PLL;
	component aux2HzClock is
	  Port (
	  clk : in std_logic ;
	  clk_out : out std_logic 
		);
	end component;
	
	component hex2led IS
	PORT (
		HEX : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		LED : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
	END component;
	component ps2_keyboard_to_ascii IS
  GENERIC(
      clk_freq                  : INTEGER := 50_000_000; --system clock frequency in Hz
      ps2_debounce_counter_size : INTEGER := 8);         --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
  PORT(
      clk        : IN  STD_LOGIC;                     --system clock input
      ps2_clk    : IN  STD_LOGIC;                     --clock signal from PS2 keyboard
      ps2_data   : IN  STD_LOGIC;                     --data signal from PS2 keyboard
      ascii_new  : OUT STD_LOGIC;                     --output flag indicating new ASCII value
      ascii_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --ASCII value
	END component;
	signal myhex0 : std_LOGIC_VECTOR(3 downto 0);
	signal myhex1 : std_LOGIC_VECTOR(3 downto 0);
	signal myhex2 : std_LOGIC_VECTOR(3 downto 0);
	signal myhex3 : std_LOGIC_VECTOR(3 downto 0);
	signal ps2_new_flag:std_logic;
   signal pressed_key:STD_LOGIC_VECTOR(7 DOWNTO 0);
 BEGIN
 ps2_keyboard1: ps2_keyboard_to_ascii port map(clk=>CLOCK_24(0),ps2_clk=>ps2_clk,ps2_data=>ps2_data,ascii_new=>ps2_new_flag,ascii_code=>pressed_key);	
 C: pll PORT MAP (VGACLK,CLOCK_24(0),RESET);
 C1: SYNC PORT MAP(VGACLK,VGA_HS,VGA_VS,VGA_R,VGA_G,VGA_B,myhex0,myhex1,myhex2,myhex3,KEY,SW,pressed_key,ps2_new_flag);

 VGA_CLOCK<=VGACLK;
 
 hex0 : hex2led port map(myhex0,hex0_out);
 hex1 : hex2led port map(myhex1,hex1_out);
 hex2 : hex2led port map(myhex2,hex2_out);
 hex3 : hex2led port map(myhex3,hex3_out);
 
 END MAIN;
 