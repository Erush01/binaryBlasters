library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aux2HzClock is
  Port (
  clk : in std_logic ;
  clk_out : out std_logic 
   );
end aux2HzClock;

architecture rtl of aux2HzClock is
	
	constant DIV_VALUE : integer := 25000000; -- Adjust for desired division factor
	signal counter : integer range 0 to DIV_VALUE := 0;
	signal internal_clk : STD_LOGIC := '0';
	begin
		process(clk)
			begin
				if rising_edge(clk) then
					if (counter = DIV_VALUE) then
						counter<=0;
						internal_clk <= not internal_clk;
					else
						counter<=counter+1;
					end if;
				end if;
				clk_out <=internal_clk;

		end process;
end rtl;