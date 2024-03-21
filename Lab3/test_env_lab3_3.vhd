library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env_lab3_3 is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_lab3_3;

architecture Behavioral of test_env_lab3_3 is
    
    signal en : std_logic :='0';
    signal cnt : std_logic_vector(5 downto 0):=(others=>'0');
    signal we1 : std_logic :='0';
    
   
    signal do1: std_logic_vector(31 downto 0):=(others=>'0');
    signal do2: std_logic_vector(31 downto 0):=(others=>'0');
    
    component MPG
        port (
            enable : out std_logic;
            btn : in std_logic;
            clk : in std_logic
        );
    end component;

    component SEGMENTE
        port(
            clk: in std_logic;
            digits: in std_logic_vector(31 downto 0);
            an: out std_logic_vector(7 downto 0);
            cat: out std_logic_vector(6 downto 0)
        );
    end component;
    
    component ram_wr_1st
    port(
           clk : in std_logic;
           we : in std_logic;
           --en : in std_logic;
           addr : in std_logic_vector(5 downto 0);
           di : in std_logic_vector(31 downto 0);
           do : out std_logic_vector(31 downto 0));
   
    end component;
    

begin
    
      c1:MPG port map ( en, btn(0), clk);
      c2:MPG port map ( we1, btn(1), clk);
     
      process(clk)
      begin
           if btn(2)='1' then 
           cnt<=(others=>'0');
           if rising_edge(clk) then
             if en='1'then
                if btn(0) = '1' then
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
        end if;
    end process;
    
    c3:ram_wr_1st port map(clk,we1,cnt,do2,do1);
    do2<=do1(29 downto 0) & "00";
    c4:SEGMENTE port map (clk,do2,an,cat);

end Behavioral;