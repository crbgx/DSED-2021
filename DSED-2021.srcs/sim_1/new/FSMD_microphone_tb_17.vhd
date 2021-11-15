library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSMD_microphone_tb_17 is
end FSMD_microphone_tb_17;

architecture Behavioral of FSMD_microphone_tb_17 is

component FSMD_microphone
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR(7 downto 0);       --(sample_size-1 downto 0)
           sample_out_ready : out STD_LOGIC);
end component;

signal clk_12megas, reset, enable_4_cycles, micro_data, sample_out_ready : std_logic := '0';
signal sample_out : std_logic_vector(7 downto 0) := (others => '0');
signal a, b, c : STD_LOGIC := '0';
constant clk_period : time := 83 ns;

begin

UUT : FSMD_microphone port map(
    clk_12megas => clk_12megas,
    reset => reset,
    enable_4_cycles => enable_4_cycles,
    micro_data => micro_data,
    sample_out => sample_out,
    sample_out_ready => sample_out_ready
);

process 
begin
    wait for clk_period/2;
    clk_12megas <= '1';
    wait for clk_period/2;
    clk_12megas <= '0';
end process;

process
begin
    a <= not a after 1300 ns;
    b <= not b after 2100 ns;
    c <= not c after 3700 ns;
    wait;
end process;
micro_data <= a xor b xor c;

end Behavioral;
