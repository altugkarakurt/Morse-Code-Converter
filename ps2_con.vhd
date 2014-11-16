library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--Entity
entity ps2_con is
	port(clr: in std_logic; 
	  clk25: in std_logic;
	  ps2c: in std_logic;
	  ps2d: in std_logic;
	  key1 : out std_logic_vector(7 downto 0));
end ps2_con;

--Architecture
architecture key_connector of ps2_con is
	--Type Declaration
	type keystate is (initial, wtclklo1, wtclkhi1, getkey1, wtclklo2, wtclkhi2,
	  getkey2, breakey, wtclklo3, wtclkhi3, getkey3);
	--Signal Declarations
	signal state : keystate;
	signal ps2cf, ps2df: std_logic;
	signal ps2c_filter, ps2d_filter: std_logic_vector(7 downto 0);
	signal shift1, shift2, shift3: std_logic_vector(10 downto 0);
	signal keyval1, keyval2, keyval3: std_logic_vector(7 downto 0);
	signal counter: std_logic_vector(3 downto 0);
	constant counter_max: std_logic_vector(3 downto 0) := "1011";

	begin
	--Filtering the input signal from PS/2
	process(clk25, clr)
		begin
			if clr ='1' then
				ps2c_filter <= "00000000"; --(others => '0');
				ps2c_filter <= "00000000"; -- (others => '0');
				ps2cf <= '1';
				ps2df <= '1';
			elsif rising_edge(clk25) then --check for the rising edge of the clock
				ps2c_filter(7) <= ps2c;
				ps2c_filter(6 downto 0) <= ps2c_filter(7 downto 1);
				ps2d_filter(7) <= ps2d;
				ps2d_filter(6 downto 0) <= ps2d_filter(7 downto 1);
				if ps2c_filter = X"FF" then
					ps2cf <= '1';
				elsif ps2c_filter = X"00" then
					ps2cf <= '0';
				end if;
				if ps2d_filter = X"FF" then
					ps2df <= '1';
				elsif ps2d_filter = X"00" then
					ps2df <= '0';
				end if;
			end if;
	end process;

	--Finite State Machine
	process(clk25, clr)
		begin
			if clr='1' then
				state <= initial;
				counter <= "0000";   --(others => '0');
				shift1 <=  "00000000000";   --(others => '0');
				shift2 <=  "00000000000";   --(others => '0');
				shift3 <=  "00000000000";   --(others => '0');
				keyval1 <=  "00000000";   --(others => '0');
				keyval2 <=  "00000000";   --(others => '0');
				keyval3 <=  "00000000";   --(others => '0');
			elsif rising_edge(clk25) then
				case state is
					when initial =>
						if ps2df = '1' then
							state <= initial;
						else
							state <= wtclklo1;
						end if;
					when wtclklo1 =>
						if counter < counter_max then
							if ps2cf = '1' then
								state <= wtclklo1;
							else
								state <= wtclkhi1;
								shift1 <= ps2df & shift1(10 downto 1);
							end if;
						else
							state <= getkey1;
						end if;
					when wtclkhi1 =>
						if ps2cf = '0' then
							state <= wtclkhi1;
						else
							state <= wtclklo1;
							counter <= counter + 1;
						end if;
					when getkey1 =>
						keyval1 <= shift1 (8 downto 1);
						counter <=  "0000";   --(others => '0');
						state <= wtclklo2;
					when wtclklo2 =>
						if counter < counter_max then
							if ps2cf = '1' then
								state <= wtclklo2;
							else
								state <= wtclkhi2;
								shift2 <= ps2df & shift2(10 downto 1);
							end if;
						else
							state <= getkey2;
						end if;
					when wtclkhi2 =>
						if ps2cf = '0' then
							state <= wtclkhi2;
						else
							state <= wtclklo2;
							counter <= counter + 1;
						end if;
					when getkey2 =>
						keyval2 <= shift2 (8 downto 1);
						counter <=  "0000";   --(others => '0');
						state <= breakey;
					when breakey =>
						if keyval2 = X"F0" then
							state <= wtclklo1;
						else
							if keyval1 = X"E0" then
								state <= wtclklo1;
							else
								state <= wtclklo2;
							end if;
						end if;
					when wtclklo3 =>
						if counter < counter_max then
							if ps2cf = '1' then
								state <= wtclklo3;
							else
								state <= wtclkhi3;
								shift3 <= ps2df & shift3(10 downto 1);
							end if;
						else
							state <= getkey3;
						end if;
					when wtclkhi3 =>
						if ps2cf = '0' then
							state <= wtclkhi3;
						else
							state <= wtclklo3;
							counter <= counter + 1;
						end if;
					when getkey3 =>
						keyval3 <= shift3 (8 downto 1);
						counter <=  "0000";   --(others => '0');
						state <= wtclklo1;
				end case;
			end if;
	end process;

	key1 <= keyval1;
end key_connector;