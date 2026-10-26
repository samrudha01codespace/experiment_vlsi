library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_shift_reg_4bit is
end tb_shift_reg_4bit;

architecture Behavioral of tb_shift_reg_4bit is

    component shift_reg_4bit
        port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            datain  : in  STD_LOGIC_VECTOR(3 downto 0);
            SL_in   : in  STD_LOGIC;
            SR_in   : in  STD_LOGIC;
            sel     : in  STD_LOGIC_VECTOR(1 downto 0);
            dataout : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal clk     : STD_LOGIC := '0';
    signal reset   : STD_LOGIC := '0';
    signal datain  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal SL_in   : STD_LOGIC := '0';
    signal SR_in   : STD_LOGIC := '0';
    signal sel     : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal dataout : STD_LOGIC_VECTOR(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Unit Under Test
    uut: shift_reg_4bit
        port map (
            clk     => clk,
            reset   => reset,
            datain  => datain,
            SL_in   => SL_in,
            SR_in   => SR_in,
            sel     => sel,
            dataout => dataout
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus
    stim_proc : process
    begin
        -- 1. Asynchronous reset
        reset <= '1';
        wait for 22 ns;
        reset <= '0';
        wait until falling_edge(clk);
        assert dataout = "0000" report "Reset failed" severity error;

        -- 2. Parallel load (S1S0 = 11), load 1010
        sel    <= "11";
        datain <= "1010";
        wait until falling_edge(clk);
        assert dataout = "1010" report "Parallel load failed" severity error;

        -- 3. Hold / inhibit clock (S1S0 = 00)
        sel <= "00";
        wait until falling_edge(clk);
        assert dataout = "1010" report "Hold failed" severity error;

        -- 4. Shift right (S1S0 = 01), SR_in = 1, two clocks
        sel   <= "01";
        SR_in <= '1';
        wait until falling_edge(clk);
        assert dataout = "1101" report "Shift right 1 failed" severity error;
        wait until falling_edge(clk);
        assert dataout = "1110" report "Shift right 2 failed" severity error;

        --    Shift right, SR_in = 0, two clocks
        SR_in <= '0';
        wait until falling_edge(clk);
        assert dataout = "0111" report "Shift right 3 failed" severity error;
        wait until falling_edge(clk);
        assert dataout = "0011" report "Shift right 4 failed" severity error;

        -- 5. Shift left (S1S0 = 10), SL_in = 1, two clocks
        sel   <= "10";
        SL_in <= '1';
        wait until falling_edge(clk);
        assert dataout = "0111" report "Shift left 1 failed" severity error;
        wait until falling_edge(clk);
        assert dataout = "1111" report "Shift left 2 failed" severity error;

        --    Shift left, SL_in = 0, two clocks
        SL_in <= '0';
        wait until falling_edge(clk);
        assert dataout = "1110" report "Shift left 3 failed" severity error;
        wait until falling_edge(clk);
        assert dataout = "1100" report "Shift left 4 failed" severity error;

        -- 6. Load again, then assert reset in the middle of a clock cycle
        sel    <= "11";
        datain <= "0101";
        wait until falling_edge(clk);
        assert dataout = "0101" report "Second load failed" severity error;

        wait for 2 ns;
        reset <= '1';                 -- async clear, no clock edge needed
        wait for 1 ns;
        assert dataout = "0000" report "Async reset failed" severity error;
        wait for 10 ns;
        reset <= '0';

        wait for 20 ns;
        report "Simulation finished" severity note;
        wait;
    end process;

end Behavioral;
