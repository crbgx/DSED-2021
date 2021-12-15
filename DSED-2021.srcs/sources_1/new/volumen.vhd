library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity volumen is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in unsigned (sample_size-1 downto 0);
       subir_btn: in STD_LOGIC; 
       bajar_btn: in STD_LOGIC;
       sample_out : out unsigned (sample_size-1 downto 0));
end volumen;

architecture Behavioral of volumen is

type state_type is (idle, subir, bajar);
signal state, state_next : state_type := idle;
type arr is ARRAY(20 downto 0) of unsigned(7 downto 0);
constant coef : arr := ("00000000","00000001","00000001","00000010","00000011","00000100","00000110","00001000","00001010","00001101","00010000","00010100","00011001","00011111","00100110","00101111","00111001","01000110","01010110","01101001","10000000");
signal vol, vol_next : unsigned(4 downto 0) := "00001010";

begin

process(clk)
begin
    if rising_edge(clk) then
        state <= state_next;
        vol <= vol_next;
        if reset='1' then
            state <= idle;
            vol <= "00001010";
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
                vol <= vol + 1;
            elsif bajar_btn='1' and vol>0 then
                state_next <= bajar;
                vol <= vol - 1;
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
    
sample_out <= resize(shift_right(shift_right(sample_in * coef(to_integer(vol)), 6)+1, 1), 8);

end Behavioral;
