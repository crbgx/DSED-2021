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

type state_type is (dig0, dig1);
signal state, state_next : state_type := dig0;
signal cuenta, cuenta_next : unsigned(18 downto 0) := (others => '0');
type digitos is ARRAY(0 to 10) of STD_LOGIC_VECTOR(6 downto 0);
constant n : digitos := ("1000000", "1111001", "0100100", "0110000", "0011001", "0010010", "0000010", "1111000", "0000000", "0011000", "1111111");
signal seg0, seg1 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');

begin

process(clk)
begin
    if rising_edge(clk) then
        state <= state_next;
        cuenta <= cuenta_next;
        if reset='1' then
            state <= dig0;
            cuenta <= (others => '0');
        end if;
    end if;
end process;

process(state, cuenta)
begin
    state_next <= state;
    cuenta_next <= cuenta + 1;
    case state is
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

an <= "01111111" when state=dig0 else
      "10111111";
seg <= seg0 when state=dig0 else
       seg1;
seg0 <= n(to_integer(num)) when num < 10 else
        n(to_integer(num-10)) when num < 20 else
        n(0);     
seg1 <= n(10) when num < 10 else
        n(1) when num < 20 else
        n(2);
                

end Behavioral;
