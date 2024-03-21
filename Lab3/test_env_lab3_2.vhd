library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env_lab3_2 is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_lab3_2;

architecture Behavioral of test_env_lab3_2 is
    
    signal en : std_logic :='0';
    signal cnt : std_logic_vector(4 downto 0):=(others=>'0');
    signal reg : std_logic :='0';
    
    signal sum: std_logic_vector(31 downto 0):=(others=>'0');
    signal rd11 : std_logic_vector(31 downto 0):=(others=>'0');
    signal rd21 : std_logic_vector(31 downto 0):=(others=>'0');
    
    
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
    
    component RegisterFile
    port(
       clk : in std_logic;
       ra1 : in std_logic_vector(4 downto 0);
       ra2 : in std_logic_vector(4 downto 0);
       wa : in std_logic_vector(4 downto 0);
       wd : in std_logic_vector(31 downto 0);
       regwr : in std_logic;
       rd1 : out std_logic_vector(31 downto 0);
       rd2 : out std_logic_vector(31 downto 0)
    );
    end component;
    

begin
    
      c1:MPG port map ( en, btn(0), clk);
      c2:MPG port map (reg, btn(1), clk);
      
      process(clk)
      begin
           if btn(2)='1' then 
           cnt<="00000";
           if rising_edge(clk) then
             if en='1'then
                if btn(0) = '1' then
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
        end if;
    end process;
    
    c3:RegisterFile port map(clk,cnt,cnt,cnt,sum,reg,rd11,rd21);
    sum<=rd11+rd21;
    c4:SEGMENTE port map (clk,sum,an,cat);


end Behavioral;