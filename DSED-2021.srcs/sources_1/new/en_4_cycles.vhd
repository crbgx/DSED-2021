library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity en_4_cycles is
Port (  clk_12megas : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_3megas: out STD_LOGIC;
        en_2_cycles: out STD_LOGIC;
        en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

-- Señal de cuenta interna
signal count, count_next : unsigned(1 downto 0) := (others => '0');
-- Señal para mantener a 0 en_2_cycles y en_4_cycles hasta el siguiente ciclo de reloj en el que
-- la señal de reset valga '0'
signal reset_hold : std_logic := '0';

begin

process(clk_12megas, reset)
begin
    if reset='1' then
        count <= (others => '0');
        reset_hold <= '1';
    elsif rising_edge(clk_12megas) then
        count <= count_next;
        reset_hold <= '0';
    end if;
end process;

-- Valor de cuenta para el ciclo siguiente
count_next <= count + 1 when reset_hold='0' else
              (others => '0');

-- Optimizando, el reloj de 3 MHz se mantiene activo cuando cuenta vale "01" o "10",
-- por lo que se puede obtener cuando count(1) o count(0) estan activos de forma exclusiva
clk_3megas <= count(1) xor count(0);
-- Igual que con clk_3megas, en_2_cycles se mantiene activo para "00" y "10", of
-- lo que es lo mismo, cuando count(0) vale '0'
en_2_cycles <= not count(0) and not reset_hold;
-- Igual que con en_2_cycles, en_4_cycles se mantiene activo para "01" o
-- lo que es lo mismo, cuando count(0) vale '1' y count(1) vale '0'
en_4_cycles <= (not count(1)) and count(0); 


end Behavioral;
