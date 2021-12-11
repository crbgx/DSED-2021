library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador_tb is
end controlador_tb;

architecture Behavioral of controlador_tb is

component controlador is Port (
    clk_100Mhz : in std_logic;
    reset: in std_logic;
    --Control ports
    BTNL: in STD_LOGIC;
    BTNC: in STD_LOGIC;
    BTNR: in STD_LOGIC;
    SW0: in STD_LOGIC;
    SW1: in STD_LOGIC;
    --To/From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    --To/From the mini-jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
);
end component;
signal clk_100Mhz, reset, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm, BTNL, BTNC, BTNR, SW0, SW1 : std_logic := '0';
constant clk_period : time := 100 ns;

begin

U1 : controlador port map (
clk_100Mhz => clk_100Mhz,
reset => reset,
BTNL => BTNL,
BTNC => BTNC,
BTNR => BTNR,
SW0 => SW0,
SW1 => SW1,
micro_clk => micro_clk, 
micro_data => micro_data,
micro_LR => micro_LR,
jack_sd => jack_sd,
jack_pwm => jack_pwm 
);

process 
begin
    clk_100Mhz <= '1';
    wait for clk_period/2;
    clk_100Mhz <= '0';
    wait for clk_period/2;
end process;

process
begin
    SW1 <= '1';
    BTNL <= '1';
    micro_data <= '1';
    wait for clk_period*10000;
    micro_data <= '0';
    wait for clk_period*20000;
    BTNL <= '0';
    wait for clk_period;
    BTNR <= '1';
    wait for clk_period*100;
    BTNR <= '0';
    wait;
end process;

end Behavioral;
