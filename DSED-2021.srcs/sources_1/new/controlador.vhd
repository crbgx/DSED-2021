library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity controlador is
Port (
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
end controlador;

architecture Behavioral of controlador is

-- Divisor de reloj
component clk_wiz_0 port (
    clk_in1 : in std_logic;
    clk_out1 : out std_logic);
end component;

-- Interfaz de audio
component audio_interface
Port (  clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        record_enable: in STD_LOGIC;
        sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out_ready: out STD_LOGIC;
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        play_enable: in STD_LOGIC;
        sample_in: in std_logic_vector(sample_size-1 downto 0);
        sample_request: out std_logic;
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC);
end component;

-- Memoria RAM
component blk_mem_gen_0 port (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end component;

-- Filtro FIR
component fir_filter Port ( 
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in unsigned (sample_size-1 downto 0);
       sample_in_enable : in STD_LOGIC;
       filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
       sample_out : out signed (sample_size-1 downto 0);
       sample_out_ready : out STD_LOGIC);
end component;

-- Señales internas
type state_type is (idle, grabar, play);
signal state, state_next : state_type := idle;
signal clk_12megas, sample_out_ready, sample_request, wea, wea_next, ena : std_logic := '0';
signal record_enable, record_enable_next, sample_in_fir_enable : std_logic := '0';
signal filter_select, sample_out_fir_ready : std_logic := '0';
signal sample_out, sample_in, douta, sample_out_fir, sample_in_fir : std_logic_vector(sample_size-1 downto 0) := (others => '0');
signal addra, addra_r, addra_r_next, addra_w, addra_w_next : STD_LOGIC_VECTOR(18 DOWNTO 0) := (others => '0');


begin

CLK : clk_wiz_0 port map (
    clk_in1 => clk_100MHz,
    clk_out1 => clk_12megas
);

audio : audio_interface port map (  
    clk_12megas => clk_12megas,
    reset => reset,
    record_enable => record_enable,
    sample_out => sample_out,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    play_enable => '1',
    sample_in => sample_in,
    sample_request => sample_request,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm
);

memoria : blk_mem_gen_0 port map (
    clka => clk_12megas,
    ena => ena,
    wea(0) => sample_out_ready,
    addra => addra,
    dina => sample_out,
    douta => douta
);
  
fir : fir_filter port map ( 
     clk => clk_12megas,
     reset => reset,
     sample_in => unsigned(sample_in_fir),
     sample_in_enable => sample_in_fir_enable,
     filter_select => filter_select,
     std_logic_vector(sample_out) => sample_out_fir,
     sample_out_ready => sample_out_fir_ready
);

process(clk_12megas)
begin
    if rising_edge(clk_12megas) then
        addra_r <= addra_r_next;
        addra_w <= addra_w_next;
        wea <= wea_next;
        record_enable <= record_enable_next;
        if reset='1' then
            state <= idle;
            addra_r <= (others => '0');
            addra_w <= (others => '0');
            wea <= '0';
            record_enable <= '0';
        else
            state <= state_next;
        end if;
    end if;
end process;

process(state, addra_r, addra_w, BTNL, BTNC, BTNR, SW0, SW1, sample_out_ready)
begin
    state_next <= state;
    addra_r_next <= addra_r;
    addra_w_next <= addra_w;
    wea_next <= wea;
    record_enable_next <= record_enable;
    case state is
        when idle =>
            if BTNL='1' then
                state_next <= grabar;
            elsif BTNC='1' then
                addra_w_next <= (others => '0');
            elsif BTNR='1' then
                state_next <= play;
                if SW1='0' then
                    if SW0='1' then
                        addra_r_next <= addra_w;
                    else
                        addra_r_next <= (others => '0');
                    end if;
                end if;
            end if;
        when grabar =>
            record_enable_next <= '1';
            if BTNL='1' then
                if sample_out_ready='1' then
                    addra_w_next <= std_logic_vector(unsigned(addra_w) + 1);
                    wea_next <= '1';
                end if;
            else
                state_next <= idle;
            end if;
        when play =>
            if sample_request='1' then
                if SW1='1' then
                    sample_in_fir_next <= douta;
                    sample_in_fir_next <= 
                else
                
                end if;
            end if;
    end case;

end process;

ena <= sample_out_ready or sample_request;
addra <= addra_w when state=grabar else
         addra_r when state=play else
         (others => '0');
sample_in <= sample_out_fir

end Behavioral;
