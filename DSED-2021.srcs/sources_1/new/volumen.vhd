library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity volumen is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in signed (sample_size-1 downto 0);
       subir_btn: in STD_LOGIC; 
       bajar_btn: in STD_LOGIC;
       sample_out : out signed (sample_size-1 downto 0));
end volumen;

architecture Behavioral of volumen is

type state_type is (idle, subir, bajar);
signal state, state_next : state_type := idle;
type arr is ARRAY(0 to 20) of signed(15 downto 0);
constant coef : arr := ("0000000000000000","0000000000000101","0000000000001010","0000000000010001","0000000000011001","0000000000100011","0000000000101111","0000000000111110","0000000001010000","0000000001100110","0000000010000000","0000000010100000","0000000011000111","0000000011110110","0000000100110000","0000000101110110","0000000111001011","0000001000110010","0000001010101111","0000001101000111","0000010000000000");
signal vol, vol_next : unsigned(4 downto 0) := "01010";
signal mult_coef : signed (15 downto 0);
signal mult : signed (23 downto 0);

begin

process(clk)
begin
    if rising_edge(clk) then
        state <= state_next;
        vol <= vol_next;
        if reset='1' then
            state <= idle;
            vol <= "01010";
        end if;
    end if;
end process;

process(state, vol, subir_btn, bajar_btn)
begin
    state_next <= state;
    vol_next <= vol;
    case state is
        when idle =>
            if subir_btn='1' and vol<20 then
                state_next <= subir;
                vol_next <= vol + 1;
            elsif bajar_btn='1' and vol>0 then
                state_next <= bajar;
                vol_next <= vol - 1;
            end if;
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

mult_coef <= coef(to_integer(vol));
mult <= shift_right(shift_right(sample_in * mult_coef, 6)+1, 1);
sample_out <= resize(mult, 8) when abs(mult)<128 else
              "10000000" when mult < 0 else
              "01111111";

end Behavioral;
