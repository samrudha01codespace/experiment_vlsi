library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_alu_4bit is
end tb_alu_4bit;

architecture Behavioral of tb_alu_4bit is

    component alu_4bit
        port (
            A   : in  STD_LOGIC_VECTOR(3 downto 0);
            B   : in  STD_LOGIC_VECTOR(3 downto 0);
            SEL : in  STD_LOGIC_VECTOR(2 downto 0);
            Y   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal A   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal SEL : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Y   : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut: alu_4bit port map (A => A, B => B, SEL => SEL, Y => Y);

    stim_proc: process
    begin
        -- A = 9, B = 5, test all 8 operations
        A <= "1001"; B <= "0101";

        SEL <= "000"; wait for 10 ns;   -- A + B     = 14 (1110)
        SEL <= "001"; wait for 10 ns;   -- A - B     = 4  (0100)
        SEL <= "010"; wait for 10 ns;   -- A or B    = 13 (1101)
        SEL <= "011"; wait for 10 ns;   -- A xor B   = 12 (1100)
        SEL <= "100"; wait for 10 ns;   -- A and B   = 1  (0001)
        SEL <= "101"; wait for 10 ns;   -- A xnor B  = 3  (0011)
        SEL <= "110"; wait for 10 ns;   -- A nand B  = 14 (1110)
        SEL <= "111"; wait for 10 ns;   -- not A     = 6  (0110)

        -- Overflow test: 15 + 1 wraps to 0
        A <= "1111"; B <= "0001";
        SEL <= "000"; wait for 10 ns;   -- result 0 (0000)

        -- Zero result: 3 - 3
        A <= "0011"; B <= "0011";
        SEL <= "001"; wait for 10 ns;   -- result 0 (0000)

        wait;   -- stop
    end process;

end Behavioral;