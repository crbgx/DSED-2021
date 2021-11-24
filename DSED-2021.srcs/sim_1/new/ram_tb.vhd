library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_tb is
end ram_tb;

architecture Behavioral of ram_tb is

component blk_mem_gen_0 port (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end component;

signal clka, ena : std_logic := '0';
signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
signal addra : STD_LOGIC_VECTOR(18 DOWNTO 0) := (others => '0');
signal dina, douta : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
constant clk_period : time := 83 ns;

begin

U1 : blk_mem_gen_0 port map(
clka => clka,
ena => ena,
wea => wea,
addra => addra,
dina => dina,
douta => douta
);

process 
begin
    clka <= '1';
    wait for clk_period/2;
    clka <= '0';
    wait for clk_period/2;
end process;

process
begin
    wait for 200ns;
    wea <= "1";
    dina <= "10100110";
    ena <= '0';
    wait for 200 ns;
    wea <= "0";
    ena <= '0';
    wait for 200 ns;
    ena <= '1';
    wait;
end process;


end Behavioral;
