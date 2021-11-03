library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity en_4_cycles_tb is
end en_4_cycles_tb;

architecture Behavioral of en_4_cycles_tb is

component en_4_cycles
Port (  clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_3megas: out STD_LOGIC;
        en_2_cycles: out STD_LOGIC;
        en_4_cycles : out STD_LOGIC);
end component;

signal clk_12megas, clk_3megas, en_2_cycles, s_en_4_cycles : std_logic := '0';
signal reset : std_logic := '1';
constant clk_period : time := 83 ns;

begin

UUT : en_4_cycles port map(
    clk_12megas => clk_12megas,
    reset => reset,
    clk_3megas => clk_3megas,
    en_2_cycles => en_2_cycles,
    en_4_cycles => s_en_4_cycles
);

process 
begin
    wait for clk_period/2;
    reset <= '0';
    clk_12megas <= '0';
    wait for clk_period/2;
    clk_12megas <= '1';
end process;

end Behavioral;
