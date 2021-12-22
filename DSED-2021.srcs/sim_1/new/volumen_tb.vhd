library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

entity volumen_tb is
end volumen_tb;

architecture Behavioral of volumen_tb is

component volumen 
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in signed (sample_size-1 downto 0);
       subir_btn: in STD_LOGIC; 
       bajar_btn: in STD_LOGIC;
       sample_out : out signed (sample_size-1downto 0));
end component;

signal clk, reset, subir_btn, bajar_btn : std_logic := '0';
signal sample_in, sample_out : std_logic_vector(7 downto 0) := (others => '0');
constant clk_period : time := 10 ns;

begin

U1 : volumen port map (
    clk => clk,
    reset => reset,
    sample_in => signed(sample_in),
    subir_btn => subir_btn, 
    bajar_btn => bajar_btn,
    std_logic_vector(sample_out) => sample_out
);

process 
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process;

process
begin
    sample_in <= "11000110";
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';    
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';    
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';    
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';    
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';    
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    subir_btn <= '1';    
    wait for clk_period;
    subir_btn <= '0';
    wait for clk_period;
    -- bajar volumen
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';                                                
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    bajar_btn <= '1';
    wait for clk_period;
    bajar_btn <= '0';
    wait for clk_period;
    reset <= '1';  
    wait for clk_period;
    reset <= '1';
    wait for clk_period;
    reset <= '0';      
    wait;        
end process;

end Behavioral;

