library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity clk_div is
	port(clk: in std_logic; 
	  clk25: out std_logic;
	  clk_out: out std_logic);
end clk_div;

--converts the 50 MHz clock to 25 MHz
architecture clk_divide of clk_div is 
	signal clk25sig: std_logic;
	signal clkosig: std_logic;
	constant OUTHZ : integer := 12500000;
	begin
	process(clk)
		variable divider25 : integer range 0 to 2;
		variable div_out : integer range 0 to OUTHZ;
		begin
		clk_out <= clkosig;
		clk25 <= clk25sig;
			if(rising_edge(clk)) then
				clk25sig <= '0';
				clkosig <= '0';
				divider25 := divider25 +1;
				div_out := div_out + 1;
				if(divider25 = 2) then
					clk25sig <= not(clk25sig);
					divider25 := 0;
				end if;
				if (div_out = OUTHZ) then
					clkosig <= not(clkosig);
					div_out := 0;
				end if;
			end if;
	end process;
end clk_divide;