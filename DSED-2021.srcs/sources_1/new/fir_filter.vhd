library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity fir_filter is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in unsigned (sample_size-1 downto 0);
       sample_in_enable : in STD_LOGIC;
       filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
       sample_out : out signed (sample_size-1 downto 0);
       sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

type state_type is (idle, s0, s1, s2, s3, s4, s5, s6, finish);
signal state, state_next : state_type := idle;
signal x0, x1, x2, x3, x4, x0_next, x1_next, x2_next, x3_next, x4_next : signed(7 downto 0) := (others => '0');
signal r1, r2, r3, r1_next, r2_next, r3_next : signed(7 downto 0) := (others => '0');
signal sum, mult_in1, mult_in2  : signed(7 downto 0) := (others => '0');
signal sample_out_next, sample_out_int : signed(sample_size-1 downto 0) := (others => '0');
signal sample_out_ready_next, sample_out_ready_int : std_logic := '0';
type coef is ARRAY(4 downto 0) of signed(7 downto 0);
constant lpf : coef := ("00000101", "00011111", "00111001", "00011111", "00000101");
constant hpf : coef := ("11111111", "11100110", "01001101", "11100110", "11111111");
signal c0, c1, c2, c3, c4 : signed(7 downto 0) := (others => '0');

begin

-- Current state
process(clk)
begin
    if rising_edge(clk) then
        sample_out_int <= sample_out_next;
        sample_out_ready_int <= sample_out_ready_next;
        if reset='1' then
            state <= idle;
            r1 <= (others => '0');
            r2 <= (others => '0');
            r3 <= (others => '0');
            sample_out_int <= (others => '0');
            sample_out_ready_int <= '0';
            x0 <= (others => '0');
            x1 <= (others => '0');
            x2 <= (others => '0');
            x3 <= (others => '0');
            x4 <= (others => '0');
        else
            state <= state_next;
            r1 <= r1_next;
            r2 <= r2_next;
            r3 <= r3_next;
            x0 <= x0_next;
            x1 <= x1_next;
            x2 <= x2_next;
            x3 <= x3_next;
            x4 <= x4_next;
        end if;
    end if;
end process;

-- Next state logic
process(state, sample_in_enable, sample_in)
begin
    state_next <= state;
    case state is
        when idle =>
            if sample_in_enable = '1' then
                state_next <= s0;
                x0_next <= signed(sample_in);
                x1_next <= x0;
                x2_next <= x1;
                x3_next <= x2;
                x4_next <= x3;
                if filter_select='1' then
                    c0 <= hpf(0);
                    c1 <= hpf(1);
                    c2 <= hpf(2);
                    c3 <= hpf(3);
                    c4 <= hpf(4);
                else 
                    c0 <= lpf(0);
                    c1 <= lpf(1);
                    c2 <= lpf(2);
                    c3 <= lpf(3);
                    c4 <= lpf(4);
                end if;
            end if;
        when s0 =>
            state_next <= s1;
        when s1 =>
            state_next <= s2;
        when s2 =>
            state_next <= s3;
        when s3 =>
            state_next <= s4;
        when s4 =>
            state_next <= s5;
        when s5 =>
            state_next <= s6;
        when s6 =>
            state_next <= finish;
        when others =>
            state_next <= idle;
    end case;
end process;

-- Combinational logic
r3_next <= resize(shift_right(shift_right(mult_in1 * mult_in2, 6)+1, 1), 8);
mult_in1 <= c0 when state=s0 else
            c1 when state=s1 else
            c2 when state=s2 else
            c3 when state=s3 else
            c4 when state=s4 else
            (others => '0');
mult_in2 <= x0 when state=s0 else
            x1 when state=s1 else
            x2 when state=s2 else
            x3 when state=s3 else
            x4 when state=s4 else
            (others => '0');
sum <= r1 + r2;
r1_next <=  r3 when state=s1 else
            sum when state=s3 else
            sum when state=s4 else
            sum when state=s5 else
            r1;
r2_next <=  r3 when state=s2 else
            r3 when state=s3 else
            r3 when state=s4 else
            r3 when state=s5 else
            r2;
            
-- Output logic
sample_out_next <= sum when state=s6 else
                   sample_out_int;
sample_out_ready_next <= '1' when state=s6 else
                         '0';
sample_out <= sample_out_int;
sample_out_ready <= sample_out_ready_int;

end Behavioral;
