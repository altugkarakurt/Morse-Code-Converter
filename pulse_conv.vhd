library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity pulse_conv is
	port(key_to_conv: in std_logic_vector(7 downto 0); 
	  clk_in: in std_logic;
	  morse_out: out std_logic;
	  ssd : out std_logic_vector(11 downto 0);
	  busy : out std_logic;
	  ld_out: out std_logic);
end pulse_conv;

architecture pulse_arch of pulse_conv is 
	signal length_i: integer range 0 to 17:= 0;
	signal temp: std_logic_vector(17 downto 0); 
	signal morsesig: std_logic;
	signal busysig: std_logic:= '0'; 
	signal counter : integer range 0 to 17:= 0;
	constant AN : std_logic_vector(4 downto 0):= "11110";
	constant DOT	: std_logic_vector(1 downto 0):="10";		
	constant DASH	: std_logic_vector(3 downto 0):="1110";		
	constant CHEND	: std_logic_vector(2 downto 0):="000";		-- separator between characters
	constant ZERO	: std_logic_vector (17 DOWNTO 0):=(others => '0');
	begin
	morse_out <= morsesig;
	ld_out <= morsesig;
	busy <= busysig;
	process(clk_in, key_to_conv, length_i)
		begin
		if rising_edge(clk_in) then
			if (length_i > counter) then
				morsesig <= temp(17 - counter);
				counter <= counter + 1;
				busysig <= '1';
			elsif (length_i <= counter) then
				counter <= 0;
				morsesig <= '0';
				busysig <= '0';
				temp <= (others => '0');
				length_i <= 0;
			end if;
		end if;
		if (busysig = '0') then
			case key_to_conv is
				when X"1C"  => length_i<=9 ; 
					temp <= DOT & DASH & CHEND & ZERO(17-9 downto 0); -- A
					ssd <= "0001000" & AN;
				when X"32"  => length_i<=13;
					temp <= DASH & DOT & DOT & DOT & CHEND & ZERO(17-13 downto 0); -- B
					ssd <= "1100000" & AN;
				when X"21"  => length_i<=15; 
					temp <= DASH & DOT & DASH & DOT & CHEND & ZERO(17-15 downto 0); -- C
					ssd <= "0110001" & AN;
				when X"23"  => length_i<=11; 
					temp <= DASH & DOT & DOT & CHEND & ZERO(17-11 downto 0); -- D
					ssd <= "1000010" & AN;
				when X"24"  => length_i<=5 ; 
					temp <= DOT & CHEND & ZERO(17-5 downto 0); -- E
					ssd <= "0110000" & AN;
				when X"2B"  => length_i<=13; 
					temp <= DOT & DOT & DASH & DOT & CHEND & ZERO(17-13 downto 0); -- F
					ssd <= "0111000" & AN;
				when X"34"  => length_i<=13; 
					temp <= DASH & DASH & DOT & CHEND & ZERO(17-13 downto 0); -- G
					ssd <= "0100000" & AN;
				when X"33"  => length_i<=11; 
					temp <= DOT & DOT & DOT & DOT & CHEND & ZERO(17-11 downto 0); -- H
					ssd <= "1101000" & AN;
				when X"43"  => length_i<=7 ; 
					temp <= DOT & DOT & CHEND & ZERO(17-7 downto 0); -- I
					ssd <= "1001111" & AN;
				when X"3B"  => length_i<=17; 
					temp <= DOT & DASH & DASH & DASH & CHEND & ZERO(17-17 downto 0); -- J
					ssd <= "1000111" & AN;
				when X"42"  => length_i<=13; 
					temp <= DASH & DOT & DASH & CHEND & ZERO(17-13 downto 0); -- K
					ssd <= "1001000" & AN;
				when X"4B"  => length_i<=13; 
					temp <= DOT & DASH & DOT & DOT & CHEND & ZERO(17-13 downto 0); -- L						
					ssd <= "1110001" & AN;
				when X"3A"  => length_i<=11; 
					temp <= DASH & DASH & CHEND & ZERO(17-11 downto 0); -- M
					ssd <= "0101010" & AN;
				when X"31"  => length_i<=9 ; 
					temp <= DASH & DOT & CHEND & ZERO(17-9 downto 0); -- N
					ssd <= "1101010" & AN;
				when X"44"  => length_i<=15; 
					temp <= DASH & DASH & DASH & CHEND & ZERO(17-15 downto 0); -- O
					ssd <= "1100010" & AN;
				when X"4D"  => length_i<=15; 
					temp <= DOT & DASH & DASH & DOT & CHEND & ZERO(17-15 downto 0); -- P
					ssd <= "0011000" & AN;
				when X"15"  => length_i<=17; 
					temp <= DASH & DASH & DOT & DASH & CHEND & ZERO(17-17 downto 0); -- Q
					ssd <= "0001100" & AN;
				when X"2D"  => length_i<=11; 
					temp <= DOT & DASH & DOT & CHEND & ZERO(17-11 downto 0); -- R
					ssd <= "1111010" & AN;
				when X"1B"  => length_i<=9 ; 
					temp <= DOT & DOT & DOT & CHEND & ZERO(17-9 downto 0); -- S
					ssd <= "0100100" & AN;
				when X"2C"  => length_i<=7 ; 
					temp <= DASH & CHEND & ZERO(17-7 downto 0); -- T
					ssd <= "1110000" & AN;
				when X"3C"  => length_i<=11; 
					temp <= DOT & DOT & DASH & CHEND & ZERO(17-11 downto 0); -- U
					ssd <= "1000001" & AN;
				when X"2A"  => length_i<=13; 
					temp <= DOT & DOT & DOT & DASH & CHEND & ZERO(17-13 downto 0); -- V
					ssd <= "1100011" & AN;
				when X"1D"  => length_i<=13; 
					temp <= DOT & DASH & DASH & CHEND & ZERO(17-13 downto 0); -- W
					ssd <= "0000110" & AN;
				when X"22"  => length_i<=15; 
					temp <= DASH & DOT & DOT & DASH & CHEND & ZERO(17-15 downto 0); -- X
					ssd <= "1011100" & AN;
				when X"35"  => length_i<=17; 
					temp <= DASH & DOT & DASH & DASH & CHEND & ZERO(17-17 downto 0); -- Y
					ssd <= "1001100" & AN;
				when X"1A"  => length_i<=15; 
					temp <= DASH & DASH & DOT & DOT & CHEND & ZERO(17-15 downto 0); -- Z	
					ssd <= "0010010" & AN;
				when others => length_i<=0; 
					temp <= ZERO(17 downto 0);
					ssd <= "1111111" & AN;
			end case;
		end if;
	end process;
	
end pulse_arch;