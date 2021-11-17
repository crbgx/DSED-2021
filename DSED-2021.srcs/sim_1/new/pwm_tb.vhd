library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_tb is
end pwm_tb;

architecture Behavioral of pwm_tb is

component pwm
    Port ( clk_12megas: in std_logic;
    reset: in std_logic;
    en_2_cycles: in std_logic;
    sample_in: in std_logic_vector(7 downto 0);     --sample_size-1 downto 0 (VER CLASE 18)
    sample_request: out std_logic;
    pwm_pulse: out std_logic);
end component;

signal sample_in : std_logic_vector(7 downto 0) := (others => '0');
signal clk_12megas, reset, en_2_cycles, sample_request, pwm_pulse : std_logic := '0';
constant clk_period : time := 83 ns;

begin

UUT : pwm port map(
    clk_12megas => clk_12megas,
    reset => reset,
    en_2_cycles => en_2_cycles,
    sample_in => sample_in,
    sample_request => sample_request,
    pwm_pulse => pwm_pulse
);

process 
begin
    clk_12megas <= '1';
    wait for clk_period/2;
    clk_12megas <= '0';
    wait for clk_period/2;
end process;

process 
begin
    en_2_cycles <= '1';
    wait for clk_period;
    en_2_cycles <= '0';
    wait for clk_period;
end process;

--sample_in <= "00000000";
sample_in <= "11111111";
--sample_in <= "11000111";

end Behavioral;