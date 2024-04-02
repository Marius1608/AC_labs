library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Test_env is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end Test_env;

architecture Behavioral of Test_env is

  
    signal currentInstruction : std_logic_vector(31 downto 0);
    signal PC_plus_4 : std_logic_vector(31 downto 0);
    signal SSD_input : std_logic_vector(31 downto 0);
    signal reset : std_logic;
    signal enable: std_logic;

   
    component MPG
        port (
            enable : out std_logic;
            btn : in std_logic;
            clk : in std_logic
        );
    end component;

    component SSD
        port(
            clk: in std_logic;
            digits: in std_logic_vector(31 downto 0);
            an: out std_logic_vector(7 downto 0);
            cat: out std_logic_vector(6 downto 0)
        );
    end component;

    component IFetch
        port ( 
            clk : in std_logic;
            jumpAddress: in std_logic_vector(31 downto 0);
            branchAddress: in std_logic_vector(31 downto 0);
            PC_4 : out std_logic_vector(31 downto 0);
            jump: in std_logic;
            pcSrc: in std_logic;
            Instruction :out std_logic_vector(31 downto 0)
        ); 
    end component;



begin
    
   
    reset<= btn(4);
    SSD_input <= currentInstruction when sw(7) = '0' else PC_plus_4;
    
    c1: MPG port map(enable, btn(0), clk);
    c2: IFetch port map(clk,X"00000000",X"00000010",PC_plus_4,sw(0),sw(1),currentInstruction );
    c3 : SSD port map(clk, SSD_input,an,cat);
  
end Behavioral;
