library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity fifo is
port ( clk : in std_logic;
write_addr : in std_logic_vector(3 downto 0);
enr : in std_logic; --enable read,should be '0' when not in use.
enw : in std_logic; --enable write,should be '0' when not in use.
dataout : out std_logic_vector(7 downto 0); --output data
datain : in std_logic_vector (7 downto 0); --input data
empty : out std_logic; --set as '1' when the queue is empty
full : out std_logic --set as '1' when the queue is full
);
end fifo;
architecture Behavioral of fifo is
type memory_type is array (0 to 63) of std_logic_vector(7 downto 0);
signal memory : memory_type :=(others => (others => '0')); --memory for queue.
signal readptr,writeptr : std_logic_vector(3 downto 0) :="0000"; --read/write pointers.
signal count : std_logic_vector(23 downto 0);
signal sclk : std_logic;
begin
writeptr<= write_addr;
process(clk)
begin
if(clk'event and clk='1') then
count<= count + 1;
end if;
end process;
sclk<= count(23);
process(sclk)
begin
if(sclk'event and sclk='1' and enw ='1') then
memory(conv_integer(writeptr)) <= datain;
end if;
if(sclk'event and sclk='1' and enr ='1') then
dataout<= memory(conv_integer(readptr));
readptr<= readptr + '1'; --points to next address.
end if;
if(readptr = "1111") then --resetting read pointer.
readptr<= "0000";

end if;
if(writeptr = "1111") then --checking whether queue is full or not
full<='1';
else
full<='0';
end if;
if(writeptr = "0000") then --checking whether queue is empty or not
empty<='1';
else
empty<='0';
end if;
end process;
end Behavioral;