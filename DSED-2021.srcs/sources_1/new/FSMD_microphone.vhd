library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;


entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR(sample_size-1 downto 0) := (others => '0');       --(sample_size-1 downto 0)
           sample_out_ready : out STD_LOGIC := '0');
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (start, s0, s1, s2);
signal state, state_next : state_type := start;
signal dato1, dato2, dato1_next, dato2_next : unsigned(sample_size-1 downto 0) := (others => '0');
signal primer_ciclo, primer_ciclo_next : std_logic := '0';
signal cuenta, cuenta_next : unsigned(8 downto 0) := (others => '0');

begin

process(clk_12megas, reset)
begin
    if rising_edge(clk_12megas) then
        if reset='1' then
            state <= start;
        else
            state <= state_next;
            cuenta <= cuenta_next;
            dato1 <= dato1_next;
            dato2 <= dato2_next;
            primer_ciclo <= primer_ciclo_next;
        end if;
    end if;
end process;

process(state, cuenta)
begin
    state_next <= state;
    case state is
        when start =>
            state_next <= s0;
        when s0 =>
            if cuenta > 104 then
                if cuenta > 254 then
                    state_next <= s2;
                elsif cuenta < 150 then
                    state_next <= s1;
                end if;
            end if;
        when s1 =>
            if cuenta = 149 then
                state_next <= s0;
            end if;
        when others =>
            if cuenta = 299 then
                state_next <= s0;
            end if;
    end case;
end process;

process(state, state_next, cuenta, dato1, dato2, primer_ciclo)
begin
    cuenta_next <= cuenta;
    dato1_next <= dato1;
    dato2_next <= dato2;
    case state_next is
        when start =>
            cuenta_next <= (others => '0');
            dato1_next <= (others => '0');
            dato2_next <= (others => '0');
            primer_ciclo_next <= '0';
        when s0 =>
            if cuenta=299 then
                cuenta_next <= (others => '0');
                primer_ciclo_next <= '1';
            else
                cuenta_next <= cuenta + 1;
            end if;
            if cuenta=149 then
                dato2_next <= (others => '0');
            elsif micro_data = '1' then
                dato2_next <= dato2 + 1;
            end if;
            if cuenta=256 then
                dato1_next <= (others => '0');
            elsif micro_data = '1' then
                dato1_next <= dato1 + 1;
            end if;
        when s1 =>
            cuenta_next <= cuenta + 1;
            if micro_data = '1' then
                dato1_next <= dato1 + 1;
            end if;
            if primer_ciclo='1' and cuenta = 106 then
                sample_out <= std_logic_vector(dato2);
            end if;
        when others =>
            cuenta_next <= cuenta + 1;
            if micro_data = '1' then
                dato2_next <= dato2 + 1;                
            end if;
            if cuenta = 256 then
                sample_out <= std_logic_vector(dato1);
            end if;
    end case;
end process;

sample_out_ready <= enable_4_cycles when cuenta=256 else
                    enable_4_cycles when primer_ciclo='1' and cuenta = 106 else
                    '0';
                
end Behavioral;
