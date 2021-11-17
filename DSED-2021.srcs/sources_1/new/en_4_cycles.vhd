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

signal count, count_next : unsigned(1 downto 0) := (others => '0');
signal reset_hold : std_logic := '0';
--signal reset_hold, clk : std_logic := '0';
--component clk_wiz_0 port (
--    clk_out1: out std_logic;
--    clk_in1: in std_logic);
--end component;

begin

--UUT : clk_wiz_0 port map(
--    clk_out1 => clk,
--    clk_in1 => clk_12megas
--);

--process(clk, reset)
--begin
--    if reset='1' then
--        count <= (others => '0');
--        reset_hold <= '1';
--    elsif rising_edge(clk) then
--        count <= count_next;
--        reset_hold <= '0';
--    end if;
--end process;
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

clk_3megas <= count(1) xor count(0);
en_2_cycles <= not count(0) and not reset_hold;
en_4_cycles <= (not count(1)) and count(0); 
count_next <= count + 1 when reset_hold='0' else
              (others => '0');

end Behavioral;
