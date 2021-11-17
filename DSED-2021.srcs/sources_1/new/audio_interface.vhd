library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity audio_interface is
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
end audio_interface;

architecture Behavioral of audio_interface is

component FSMD_microphone
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');       --(sample_size-1 downto 0)
           sample_out_ready : out STD_LOGIC := '0');
end component;
component en_4_cycles
Port (  clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_3megas: out STD_LOGIC;
        en_2_cycles: out STD_LOGIC;
        en_4_cycles : out STD_LOGIC);
end component;
component pwm
port(
    clk_12megas: in std_logic;
    reset: in std_logic;
    en_2_cycles: in std_logic;
    sample_in: in std_logic_vector(7 downto 0);     --sample_size-1 downto 0 (VER CLASE 18)
    sample_request: out std_logic;
    pwm_pulse: out std_logic
);
end component;

signal en_2_cycles_int, en_4_cycles_int, en_FSMD_microphone_int, en_pwm_int : std_logic;

begin

U1 : en_4_cycles port map (  
clk_12megas => clk_12megas,
reset => reset,
clk_3megas => micro_clk,
en_2_cycles => en_2_cycles_int,
en_4_cycles => en_4_cycles_int
);

U2 : pwm port map (
clk_12megas => clk_12megas,
reset => reset,
en_2_cycles => en_pwm_int,
sample_in => sample_in,
sample_request => sample_request,
pwm_pulse => jack_pwm
);

U3 : FSMD_microphone port map ( 
clk_12megas => clk_12megas,
reset => reset,
enable_4_cycles => en_FSMD_microphone_int,
micro_data => micro_data,
sample_out => sample_out,
sample_out_ready => sample_out_ready
);

en_FSMD_microphone_int <= record_enable and en_4_cycles_int;
en_pwm_int <= play_enable and en_2_cycles_int;
micro_LR <= '1';
jack_SD <= '1';



end Behavioral;
