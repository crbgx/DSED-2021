library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity led_display is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           num : in unsigned(4 downto 0));
end led_display;

architecture Behavioral of led_display is

-- Señales de la máquina de estados
type state_type is (dig0, dig1);
signal state, state_next : state_type := dig0;
signal cuenta, cuenta_next : unsigned(18 downto 0) := (others => '0');
-- Valores seg para mostras los números de 0 a 9 y apagar el display
type digitos is ARRAY(0 to 10) of STD_LOGIC_VECTOR(6 downto 0);
constant n : digitos := ("1000000", "1111001", "0100100", "0110000", "0011001", "0010010", "0000010", "1111000", "0000000", "0011000", "1111111");
-- Señales intermedias de salida para el display 0 y 1
signal seg0, seg1 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');

begin

-- Logica del estado actual
process(clk)
begin
    if rising_edge(clk) then
        state <= state_next;
        cuenta <= cuenta_next;
        if reset='1' then
            -- Aunque no es necesario, en el caso del reset se pasa al estado dig0
            state <= dig0;
            cuenta <= (others => '0');
        end if;
    end if;
end process;

-- Logica del estado siguiente
process(state, cuenta)
begin
    state_next <= state;
    -- Incremenetar siempre el valor de la cuenta
    cuenta_next <= cuenta + 1;
    case state is
        -- Cada estado activa el digito 0 o 1. De esta forma se barre el display pintando cada digito
        -- durante 10ms para un reloj de 12 MHz
        when dig0 =>
            if cuenta=119999 then
                state_next <= dig1;
                cuenta_next <= (others => '0');
            end if;
        when dig1 =>
           if cuenta=119999 then
               state_next <= dig0;
               cuenta_next <= (others => '0');
           end if;
    end case;
end process;

-- Activar el digito 0 o 1 en funcion del estado de la maquina de estados
an <= "01111111" when state=dig0 else
      "10111111";
-- Conectar la señal seg en funcion de que digito se este pintando
seg <= seg0 when state=dig0 else
       seg1;
-- Para el primer digito se asigna directamente n con el indice num o para valores mayores o iguales a 20 es 
-- necesario restar 10 a numeric_bit
-- Esto resulta en el mismo resultado que convertir num a BCD
seg0 <= n(to_integer(num)) when num < 10 else
        n(to_integer(num-10)) when num < 20 else
        n(0); 
-- Los valores del volumen oscilan solo entre 0 y 20, por lo que el digito 1 solo mostrará los valores 
-- 0 (o blanco en este caso), 1 y 2    
seg1 <= n(10) when num < 10 else
        n(1) when num < 20 else
        n(2);
                

end Behavioral;
