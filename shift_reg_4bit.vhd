library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_reg_4bit is
    port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;                      -- direct overriding clear
        datain  : in  STD_LOGIC_VECTOR(3 downto 0);   -- parallel input
        SL_in   : in  STD_LOGIC;                      -- serial input for left shift
        SR_in   : in  STD_LOGIC;                      -- serial input for right shift
        sel     : in  STD_LOGIC_VECTOR(1 downto 0);   -- sel(1)=S1, sel(0)=S0
        dataout : out STD_LOGIC_VECTOR(3 downto 0)    -- parallel output (QA..QD)
    );
end shift_reg_4bit;

architecture Behavioral of shift_reg_4bit is
    signal q : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process (clk, reset)
    begin
        if reset = '1' then
            q <= "0000";                              -- asynchronous clear
        elsif rising_edge(clk) then
            case sel is
                when "00"   => q <= q;                          -- hold (inhibit clock)
                when "01"   => q <= SR_in & q(3 downto 1);      -- shift right
                when "10"   => q <= q(2 downto 0) & SL_in;      -- shift left
                when "11"   => q <= datain;                     -- parallel load
                when others => q <= q;
            end case;
        end if;
    end process;

    dataout <= q;
end Behavioral;
