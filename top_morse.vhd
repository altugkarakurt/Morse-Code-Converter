library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_morse is
	port(clki: in std_logic;
		clri: in std_logic; 
		ps2ci: in std_logic;
		ps2di: in std_logic;
		pulse_o: out std_logic;
		ssd_out: out std_logic_vector(11 downto 0);
		ld_top: out std_logic);
end top_morse;

architecture top_arch of top_morse is
	signal clk25sig: std_logic;
	signal clk_o: std_logic;
	signal keysig: std_logic_vector(7 downto 0);
	signal key1o: std_logic_vector(7 downto 0);
	signal busysig: std_logic;
	component clk_div
		port(clk: in std_logic; 
	  clk25: out std_logic;
	  clk_out: out std_logic);
	end component;
	component ps2_con
	  port(clr: in std_logic; 
	  clk25: in std_logic;
	  ps2c: in std_logic;
	  ps2d: in std_logic;
	  key1 : out std_logic_vector(7 downto 0));
	end component;

	component pulse_conv
	  port(key_out: in std_logic_vector(7 downto 0); 
	  clk_in: in std_logic;
	  morse_out: out std_logic;
	  ssd : out std_logic_vector(11 downto 0);
	  busy : out std_logic;
	  ld_out: out std_logic);
	end component;
	begin
		U1: clk_div port map(clk => clki, clk25 => clk25sig, clk_out => clk_o);
		U2: ps2_con port map(clr => clri, clk25 => clk25sig, ps2c => ps2ci, ps2d => ps2di, key1 => key1o);
		U3: pulse_conv port map(ssd => ssd_out, ld_out => ld_top, key1 =>keysig, morse_out => pulse_o, clk_in =>clk_o, busy => busysig, keysig => key_out);
end top_arch;