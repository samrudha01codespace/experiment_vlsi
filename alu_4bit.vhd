library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_4bit is
    port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0);
        B   : in  STD_LOGIC_VECTOR(3 downto 0);
        SEL : in  STD_LOGIC_VECTOR(2 downto 0);
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
begin
    process (A, B, SEL)
    begin
        case SEL is
            when "000"  => Y <= A + B;
            when "001"  => Y <= A - B;
            when "010"  => Y <= A or B;
            when "011"  => Y <= A xor B;
            when "100"  => Y <= A and B;
            when "101"  => Y <= A xnor B;
            when "110"  => Y <= A nand B;
            when "111"  => Y <= not A;
            when others => Y <= "0000";
        end case;
    end process;
end Behavioral;