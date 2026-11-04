
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_n_counter_tb is
end mod_n_counter_tb;

architecture Behavioral of mod_n_counter_tb is

    component mod_n_counter
        generic (
            N : integer := 4
        );
        port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            count : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal count : STD_LOGIC_VECTOR(1 downto 0);

begin

    uut : mod_n_counter
        generic map (
            N => 4
        )
        port map (
            clk   => clk,
            reset => reset,
            count => count
        );

    -- 10 ns clock
    clk <= not clk after 10 ns;

    process
    begin

        -- Reset
        reset <= '1';
        wait for 50 ns;

        -- Start counting
        reset <= '0';

        -- Run for 200 ns
        wait for 200 ns;

        wait;

    end process;

end Behavioral;
