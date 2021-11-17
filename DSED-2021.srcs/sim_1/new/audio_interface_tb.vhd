library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity audio_interface_tb is
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

component audio_interface
Port (  clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        --Recording ports
        --To/From the controller
        record_enable: in STD_LOGIC;
        sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out_ready: out STD_LOGIC;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --Playing ports
        --To/From the controller
        play_enable: in STD_LOGIC;
        sample_in: in std_logic_vector(sample_size-1 downto 0);
        sample_request: out std_logic;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC);
end component;

signal clk_12megas, reset, record_enable, sample_out_ready, micro_clk, micro_data, micro_LR, play_enable, sample_request, jack_sd, jack_pwm : std_logic := '0';
signal sample_out, sample_in : std_logic_vector(sample_size-1 downto 0) := (others => '0');
constant clk_period : time := 83 ns;

begin


U1 : audio_interface port map (  
clk_12megas => clk_12megas,
reset => reset,
record_enable => record_enable,
sample_out => sample_out,
sample_out_ready => sample_out_ready,
micro_clk => micro_clk,
micro_data => micro_data,
micro_LR => micro_LR,
play_enable => play_enable,
sample_in => sample_in,
sample_request => sample_request,
jack_sd => jack_sd,
jack_pwm => jack_pwm
);

process 
begin
    clk_12megas <= '1';
    wait for clk_period/2;
    clk_12megas <= '0';
    wait for clk_period/2;
end process;

record_enable <= '1';
micro_data <= '1';

end Behavioral;
