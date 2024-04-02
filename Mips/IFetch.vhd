library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port ( 
         clk : in std_logic;
         jumpAddress: in std_logic_vector(31 downto 0);
         branchAddress: in std_logic_vector(31 downto 0);
         PC_4 : out std_logic_vector(31 downto 0);
         jump: in std_logic;
         pcSrc: in std_logic;
         Instruction :out std_logic_vector(31 downto 0)
         ); 
end IFetch;

architecture Behavioral of IFetch is
signal reset: std_logic:='0';
signal enable: std_logic:='0';
signal PC: std_logic_vector(31 downto 0):=(others=>'0');
signal sum: std_logic_vector(31 downto 0):=(others=>'0');
signal outputMux1: std_logic_vector(31 downto 0):=(others=>'0');
signal outputMux2: std_logic_vector(31 downto 0):=(others=>'0');

component ROM_instr
    port(
        address : in STD_LOGIC_VECTOR(4 downto 0);
        Instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

begin
    process(clk, reset)
        begin
        if reset = '1' then
            PC <= (others => '0');  
        elsif rising_edge(clk) then
            if enable = '1' then
                PC <= PC + 1;  
            end if;
        end if;
    end process;
    
c1:ROM_instr port map(PC(6 downto 2),Instruction);    
sum<=PC+4;
PC_4<=sum;

outputMux1 <= sum WHEN pcSrc ='1' ELSE
            branchAddress;
            
outputMux2 <= jumpAddress WHEN jump ='1' ELSE
            outputMux1;
PC<=outputMux2;

end Behavioral;
