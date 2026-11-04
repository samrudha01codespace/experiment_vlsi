
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_tb is
end fifo_tb;

architecture Behavioral of fifo_tb is

    component fifo
        port (
            clk        : in std_logic;
            write_addr : in std_logic_vector(3 downto 0);
            enr        : in std_logic;
            enw        : in std_logic;
            dataout    : out std_logic_vector(7 downto 0);
            datain     : in std_logic_vector(7 downto 0);
            empty      : out std_logic;
            full       : out std_logic
        );
    end component;

    signal clk        : std_logic := '0';
    signal write_addr : std_logic_vector(3 downto 0) := "0000";
    signal enr        : std_logic := '0';
    signal enw        : std_logic := '0';
    signal datain     : std_logic_vector(7 downto 0) := "00000000";
    signal dataout    : std_logic_vector(7 downto 0);
    signal empty      : std_logic;
    signal full       : std_logic;

begin

    uut: fifo
        port map (
            clk        => clk,
            write_addr => write_addr,
            enr        => enr,
            enw        => enw,
            dataout    => dataout,
            datain     => datain,
            empty      => empty,
            full       => full
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Input stimulus
    stimulus: process
    begin

        -- Write operation
        wait for 100 ns;
        write_addr <= "0000";
        datain <= "00001111";
        enw <= '1';

        wait for 100 ns;
        enw <= '0';

        -- Read operation
        wait for 100 ns;
        enr <= '1';

        wait for 100 ns;
        enr <= '0';

        wait for 100 ns;
        wait;

    end process;

end Behavioral;

