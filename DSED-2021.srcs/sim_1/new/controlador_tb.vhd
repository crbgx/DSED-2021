library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador_tb is
end controlador_tb;

architecture Behavioral of controlador_tb is

component controlador port (
    clk_100Mhz : in std_logic;
    reset: in std_logic;
    --To/From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    --To/From the mini-jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
);
end component;
signal clk_100Mhz, reset, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm


begin


end Behavioral;
