library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
 port ( 
        MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        Clk: in std_logic;
        EN: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        AluResOut: out std_logic_vector(31 downto 0)   
        );
end MEM;

architecture Behavioral of MEM is

type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal MEM : ram_type := (others => X"00000000");
signal Address: std_logic_vector(5 downto 0):=(others=>'0');
signal WriteData: std_logic_vector(31 downto 0):=(others=>'0');
signal ReadData: std_logic_vector(31 downto 0):=(others=>'0');


begin
WriteData<=RD2;
Address<=ALUResIn(7 downto 2);

process(Clk)
begin
    if(rising_edge(Clk))then
        if EN='1' and MemWrite='1' then
            MEM(CONV_INTEGER(Address))<=WriteData;
         end if;
    end if;            
end process;

ReadData<=MEM(CONV_INTEGER(Address));
MemData<=ReadData;
AluResOut<=ALUResIn;

end Behavioral;
