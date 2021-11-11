library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR(7 downto 0);       --(sample_size-1 downto 0)
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (start, s0, s1, s2);
signal state, next_state : state_type := start;
signal cuenta : unsigned(8 downto 0) := (others => '0');
signal dato1, dato2 : unsigned(7 downto 0) := (others => '0');
signal primer_ciclo : std_logic := '0';

begin

process(clk_12megas)
begin
    if rising_edge(clk_12megas) then
        next_state <= state;
    end if;
end process;

process(next_state)
begin
    next_state <= state;
    if reset='1' then
        next_state <= start;
    else
        case state is
            when start =>
                cuenta <= (others => '0');
                dato1 <= (others => '0');
                dato2 <= (others => '0');
                primer_ciclo <= '0';
                next_state <= s0;
            when s0 =>
                cuenta <= cuenta + 1;
                if micro_data = '1' then
                    dato1 <= dato1 + 1;
                    dato2 <= dato2 + 1;
                end if;
                if cuenta > 105 then
                    if cuenta > 255 then
                        next_state <= s2;
                    else
                        next_state <= s1;
                    end if;
                end if;
            when s1 =>
                cuenta <= cuenta + 1;
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
                if cuenta > 150 then
                    next_state <= s0;
                end if;
            when others =>
                if micro_data = '1' then
                    dato2 <= dato2 + 1;                
                end if;
                if cuenta = 299 then
                    cuenta = 0;
                    primer_ciclo = '1';
                    sample_out_ready <= '0';
                else
                    cuenta = cuenta +1;
                    if cuenta = 256 then
                        sample_out <= std_logic_vector(dato1);
                        dato1 <= (others => '0');
                        sample_out_ready <= enable_4_cycles;
                    else
                        sample_out_ready <= '0';
                    end if;
                end if;
                if cuenta = 0 then
                    next_state <= s0;
                end if;
        end case;
    end if;
    
end process;

end Behavioral;
