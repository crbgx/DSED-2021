library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity controlador is
Port (
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
end controlador;

architecture Behavioral of controlador is

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
component clk_wiz_0 port (
    clk_in1 : in std_logic;
    clk_out1 : out std_logic);
end component;
signal clk_12megas, sample_request : std_logic;
signal sample_out, sample_in : std_logic_vector(sample_size-1 downto 0);

begin

CLK : clk_wiz_0 port map (
    clk_in1 => clk_100MHz,
    clk_out1 => clk_12megas
);

audio : audio_interface port map (  
    clk_12megas => clk_12megas,
    reset => reset,
    record_enable => '1',
    sample_out => sample_out,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    play_enable => '1',
    sample_in => sample_out,
    sample_request => sample_request,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm
);

--process(sample_request)
--begin
--    if rising_edge(sample_request) then
--        sample_in <= sample_out;
--    end if;
--end process;

end Behavioral;
