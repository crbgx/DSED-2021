library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');       --(sample_size-1 downto 0)
           sample_out_ready : out STD_LOGIC := '0');
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (start, s0, s1, s2);
signal state, state_next : state_type := start;
signal dato1, dato2, dato1_next, dato2_next : unsigned(7 downto 0) := (others => '0');
signal primer_ciclo : std_logic := '0';
signal cuenta, cuenta_next : unsigned(8 downto 0) := (others => '0');

begin

process(clk_12megas)
begin
    if rising_edge(clk_12megas) then
        state <= state_next;
        cuenta <= cuenta_next;
    end if;
end process;

process(state, cuenta, reset, micro_data)
begin
    state_next <= state;
    cuenta_next <= cuenta;
    dato1_next <= dato1;
    dato2_next <= dato2;
    if reset='1' then
        state_next <= start;
    else
        case state is
            when start =>
                cuenta_next <= (others => '0');
                dato1 <= (others => '0');
                dato2 <= (others => '0');
                primer_ciclo <= '0';
                state_next <= s0;
            when s0 =>
                cuenta_next <= cuenta + 1;
                if micro_data = '1' then
                    dato1 <= dato1 + 1;
                    dato2 <= dato2 + 1;
                end if;
                if cuenta > 104 then
                    if cuenta > 254 then
                        state_next <= s2;
                    elsif cuenta < 150 then
                        state_next <= s1;
                    end if;
                end if;
            when s1 =>
                cuenta_next <= cuenta + 1;
                if micro_data = '1' then
                    dato1 <= dato1 + 1;
                end if;
                if primer_ciclo='1' and cuenta = 106 then
                    sample_out <= std_logic_vector(dato2);
                    dato2 <= (others => '0');
                    sample_out_ready <= enable_4_cycles;
                else
                    sample_out_ready <= '0';
                end if;
                if cuenta > 148 then
                    state_next <= s0;
                end if;
            when others =>
                if micro_data = '1' then
                    dato2 <= dato2 + 1;                
                end if;
                if cuenta = 299 then
                    cuenta_next <= (others => '0');
                    primer_ciclo <= '1';
                    state_next <= s0;
                else
                    cuenta_next <= cuenta +1;
                end if;
                if cuenta = 256 then
                    --sample_out <= std_logic_vector(dato1);
                    dato1_next <= (others => '0');
                    sample_out_ready <= enable_4_cycles;
                else
                    sample_out_ready <= '0';
                end if;
                --if cuenta_next = 0 then
                  --  state_next <= s0;
                --end if;
        end case;
    end if;
end process;


--OutputLogic
sample_out <= std_logic_vector(dato1) when cuenta >= 256,
                else std_logic_vector(dato2);
                
end Behavioral;
