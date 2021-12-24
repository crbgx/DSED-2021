library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity volumen is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       -- Señales de datos
       sample_in : in std_logic_vector (sample_size-1 downto 0);
       sample_out : out std_logic_vector (sample_size-1 downto 0);
       -- Entradas de los actuadores
       subir_btn: in STD_LOGIC; 
       bajar_btn: in STD_LOGIC;
       -- Señales necesarias para controlar el display
       an : out STD_LOGIC_VECTOR (7 downto 0);
       seg : out STD_LOGIC_VECTOR (6 downto 0));
end volumen;

architecture Behavioral of volumen is

-- Controlador del display
component led_display Port ( 
   clk : in STD_LOGIC;
   reset : in STD_LOGIC;
   an : out STD_LOGIC_VECTOR (7 downto 0);
   seg : out STD_LOGIC_VECTOR (6 downto 0);
   num : in unsigned(4 downto 0));
end component;

-- Señales de la máquina de estados
type state_type is (idle, subir, bajar);
signal state, state_next : state_type := idle;
signal vol, vol_next : unsigned(4 downto 0) := "01010";
-- Coeficientes de volumen con precision <4,7> unsigned
type arr is ARRAY(0 to 20) of unsigned(10 downto 0);
constant coef : arr := ("00000000000","00000000101","00000001010","00000010001","00000011001","00000100011","00000101111","00000111110","00001010000","00001100110","00010000000","00010100000","00011000111","00011110110","00100110000","00101110110","00111001011","01000110010","01010101111","01101000111","10000000000");
-- Señales de entrada y salida del multiplicador
signal mult_coef : unsigned (10 downto 0);
signal mult : unsigned (sample_size+10 downto 0);

begin

-- Controlador del display
led : led_display port map(
    -- Mapeo directo a las señales clk, reset, an y seg
    clk => clk,
    reset => reset,
    an => an,
    seg => seg,
    -- Es necesario conectar vol a la entrada num para especificar que volumen se tiene que mostrar en el display
    num => vol
);

-- Logica del estado actual
process(clk)
begin
    if rising_edge(clk) then
        state <= state_next;
        vol <= vol_next;
        if reset='1' then
            state <= idle;
            -- El reset pone el volumen al valor de 10 (multiplicar por 1)
            vol <= "01010";
        end if;
    end if;
end process;

-- Logica del estado siguiente
process(state, vol, subir_btn, bajar_btn)
begin
    state_next <= state;
    vol_next <= vol;
    case state is
        when idle =>
            -- Solo se podra pasar al estado de subir volumen si el volumen no esta en su valor maximo (20)
            if subir_btn='1' and vol<20 then
                state_next <= subir;
                vol_next <= vol + 1;
            -- Solo se podra pasar al estado de bajar volumen si el volumen no esta en su valor minimo (0)
            elsif bajar_btn='1' and vol>0 then
                state_next <= bajar;
                vol_next <= vol - 1;
            end if;
        -- Solo pasar al estado idle si se ha terminado de presionar el boton (evita que el volumen sea incontrolable)
        when subir =>
            if subir_btn='0' then
                state_next <= idle;
            end if;
        when others =>
            if bajar_btn='0' then
                state_next <= idle;
            end if;
    end case;
end process;

-- Seleccionar el coeficiente de entrada en función de la senal vol
mult_coef <= coef(to_integer(vol));
-- Multiplicar la entrada y redondear antes de truncar la salida del multiplicador
mult <= shift_right(shift_right(unsigned(sample_in) * mult_coef, 6)+1, 1);
-- Para evitar distorsion, solo se asigna la salida del multiplicador si el resultado 
-- no sobrepasa el valor maximo de 256, en cuyo caso se asigna el valor maximo a la salida
sample_out <= std_logic_vector(resize(mult, 8)) when mult<255 else
              "11111111";

end Behavioral;
