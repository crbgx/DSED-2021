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
    SW14: in STD_LOGIC;
    SW15: in STD_LOGIC;
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

-- Controlador Volumen
component volumen Port ( 
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in std_logic_vector (sample_size-1 downto 0);
       subir_btn: in STD_LOGIC; 
       bajar_btn: in STD_LOGIC;
       sample_out : out std_logic_vector (sample_size-1 downto 0));
end component;

-- Se?ales internas
type state_type is (idle, grabar, play);
signal state, state_next : state_type := idle;
signal clk_12megas, sample_out_ready, sample_request, play_enable, play_enable_next, sample_in_enable_fir, sample_in_enable_fir_next : std_logic := '0';
signal record_enable, record_enable_next, sample_in_fir_enable : std_logic := '0';
signal filter_select, sample_out_fir_ready, ena, ena_next, wea, wea_next : std_logic := '0';
signal sample_out, sample_in, douta, sample_out_fir, sample_in_fir, sample_in_volumen : std_logic_vector(sample_size-1 downto 0) := (others => '0');
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

memoria : blk_mem_gen_0 port map (
    clka => clk_12megas,
    ena => ena,
    wea(0) => wea,
    addra => addra,
    dina => sample_out,
    douta => douta
);
  
fir : fir_filter port map ( 
     clk => clk_12megas,
     reset => reset,
     sample_in => unsigned(sample_in_fir),
     sample_in_enable => sample_in_enable_fir,
     filter_select => SW0,
     std_logic_vector(sample_out) => sample_out_fir,
     sample_out_ready => sample_out_fir_ready
);

vol : volumen port map (
    clk => clk_12megas,
    reset => reset,
    sample_in => sample_in_volumen,
    sample_out => sample_in,
    subir_btn => SW15,
    bajar_btn => SW14
);

process(clk_12megas)
begin
    if rising_edge(clk_12megas) then
        addra_r <= addra_r_next;
        addra_w <= addra_w_next;
        record_enable <= record_enable_next;
        play_enable <= play_enable_next;
        ena <= ena_next;
        wea <= wea_next;
        sample_in_enable_fir <= sample_in_enable_fir_next;
        if reset='1' then
            state <= idle;
            addra_r <= (others => '0');
            addra_w <= (others => '0');
            record_enable <= '0';
            play_enable <= '0';
            ena <= '0';
            wea <= '0';
            sample_in_enable_fir <= '0';
        else
            state <= state_next;
        end if;
    end if;
end process;

process(state, addra_w, addra_r, BTNL, BTNR, SW0, SW1)
begin
    state_next <= state;
    case state is
        when idle =>
            if BTNL='1' then
                state_next <= grabar;
            elsif BTNR='1' then
                state_next <= play;
            end if;
        when grabar =>
            if BTNL='0' then
                state_next <= idle;
            end if;
        when others =>
            if SW1='1' then
                if addra_r=addra_w then
                    state_next <= idle;           
                end if;
            else
                if SW0='1' and unsigned(addra_r)=0 then
                    state_next <= idle;
                end if;
                if SW0='0' and addra_r=addra_w then
                    state_next <= idle;           
                end if;
            end if;
    end case;
end process;

process(state, state_next, addra_r, addra_w, BTNL, BTNC, BTNR, SW0, SW1, sample_out_ready, sample_request)
begin
    addra_r_next <= addra_r;
    addra_w_next <= addra_w;
    record_enable_next <= '0';
    play_enable_next <= '0';
    wea_next <= '0';
    ena_next <= '0';
    sample_in_enable_fir_next <= '0';
    case state_next is
        when idle =>
            if BTNC='1' then
                addra_w_next <= (others => '0');
                addra_r_next <= (others => '0');
            elsif BTNR='1' then
                addra_r_next <= (others => '0');
                if SW0='1' and SW1='0' then
                    addra_r_next <= addra_w;
                end if;
            end if;
        when grabar =>
            record_enable_next <= '1';
            if BTNL='1' and sample_out_ready='1' then
                addra_w_next <= std_logic_vector(unsigned(addra_w) + 1);
                wea_next <= '1';
                ena_next <= '1';
            end if;
        when play =>
            play_enable_next <= '1';
            if sample_request='1' then
                ena_next <= '1';
                sample_in_enable_fir_next <= '1';
                addra_r_next <= std_logic_vector(unsigned(addra_r) + 1); 
                if SW0='1' and SW1='0' then
                    addra_r_next <= std_logic_vector(unsigned(addra_r) - 1);
                end if;
            end if;
    end case;
end process;

addra <= addra_w when state=grabar else
         addra_r when state=play else
         (others => '0');
sample_in_volumen <= not sample_out_fir(sample_out_fir'length-1) & sample_out_fir(sample_out_fir'length-2 downto 0) when SW1='1' else
                     douta;
sample_in_fir <= not douta(douta'length-1) & douta(douta'length-2 downto 0) when SW1='1' else
                 (others => '0');
                 

end Behavioral;
