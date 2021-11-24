library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.package_dsed.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

component fir_filter Port ( 
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in unsigned (sample_size-1 downto 0);
       sample_in_enable : in STD_LOGIC;
       filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
       sample_out : out signed (sample_size-1 downto 0);
       sample_out_ready : out STD_LOGIC);
end component;
signal clk, reset, sample_in_enable, filter_select, sample_out_ready : std_logic := '0';
signal sample_in : unsigned (sample_size-1 downto 0) := (others => '0');
signal sample_out : signed (sample_size-1 downto 0) := (others => '0');
constant clk_period : time := 100 ns;

begin

U1 : fir_filter port map(
    clk => clk,
    reset => reset,
    sample_in => sample_in,
    sample_in_enable => sample_in_enable,
    filter_select => filter_select,
    sample_out => sample_out,
    sample_out_ready => sample_out_ready
);

process (clk)
    FILE in_file : text OPEN read_mode IS "C:\Users\efrenbg1\Desktop\DSED-2021\Matlab\sample_in.dat";
    VARIABLE in_line : line;
    VARIABLE in_int : integer;
    VARIABLE in_read_ok : BOOLEAN;
BEGIN
    if (clk'event and clk = '1') then
        if NOT endfile(in_file) then
            ReadLine(in_file,in_line);
            Read(in_line, in_int, in_read_ok);
            sample_in <= to_unsigned(in_int, 8); -- 8 = the bit width
        else
            assert false report "Simulation Finished" severity failure;
        end if;
    end if;
end process;

process 
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

--process
--begin
--    sample_in <= "00000000";
--    wait for 9*clk_period;
--    sample_in <= "01000000";
--    wait for 9*clk_period;
--    sample_in <= "00010000";
--    wait for 9*clk_period;
--    sample_in <= "00000000";
--    wait;
--end process;

sample_in_enable <= '1';

end Behavioral;
