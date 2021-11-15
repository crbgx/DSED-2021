library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
port(
    clk_12megas: in std_logic;
    reset: in std_logic;
    en_2_cycles: in std_logic;
    sample_in: in std_logic_vector(7 downto 0);     --sample_size-1 downto 0 (VER CLASE 18)
    sample_request: out std_logic;
    pwm_pulse: out std_logic
);
end pwm;

architecture Behavioral of pwm is

signal cuenta, cuenta_next : unsigned(8 downto 0) := (others => '0');
signal buf_reg, buf_next : std_logic := '0';

begin
-- register & output buffer
process(clk_12megas, reset, en_2_cycles)
begin
    if (reset='1') then
        cuenta <= (others =>'0');
        buf_reg <= '0';
    elsif rising_edge(clk_12megas) and en_2_cycles='1' then
        cuenta <= cuenta_next;
        buf_reg <= buf_next;
    end if;
end process;

cuenta_next <= cuenta + 1 when cuenta < 299 else
               (others => '0');
buf_next <= '1' when (cuenta < unsigned(sample_in)) or (unsigned(sample_in) = 0) else
            '0';
pwm_pulse <= buf_reg;

end Behavioral;
