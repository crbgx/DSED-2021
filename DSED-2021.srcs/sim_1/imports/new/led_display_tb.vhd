library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity led_display_tb is
--  Port ( );
end led_display_tb;

architecture Behavioral of led_display_tb is

component led_display Port ( 
   clk : in STD_LOGIC;
   reset : in STD_LOGIC;
   an : out STD_LOGIC_VECTOR (7 downto 0);
   seg : out STD_LOGIC_VECTOR (6 downto 0);
   num : in unsigned(4 downto 0));
end component;

signal clk, reset : std_logic;
signal an : std_logic_vector(7 downto 0);
signal seg : std_logic_vector(6 downto 0);
signal num : unsigned(4 downto 0);
constant clk_period : time := 1 ns;

begin

U1 : led_display port map(
    clk => clk,
    reset => reset,
    an => an,
    seg => seg,
    num => num
);

process 
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

process
begin
    num <= "10010";
    wait;
end process;

end Behavioral;
