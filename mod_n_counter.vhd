library IEEE;
use IEEE.STD_LOGIC_1164.ALL; use
IEEE.NUMERIC_STD.ALL;
entity mod_n_counter is generic (
N : integer := 4
);
port (

clk : in STD_LOGIC; reset : in
STD_LOGIC;
count : out STD_LOGIC_VECTOR(1 downto 0)
);
end mod_n_counter;
architecture Behavioral of mod_n_counter is signal count_int :
integer range 0 to N-1 := 0; begin
process(clk) begin
if rising_edge(clk) then if reset =
'1' then count_int <= 0;
elsif count_int = N-1 then count_int
<= 0;

else

end if;
end if;
count_int <= count_int + 1;

end process;
count <= std_logic_vector(to_unsigned(count_int, count'length)); end
Behavioral;

