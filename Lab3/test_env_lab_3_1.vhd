library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env_lab3_1 is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_lab3_1;

architecture Behavioral of test_env_lab3_1 is
    
    signal en : std_logic :='0';
    signal cnt : std_logic_vector(4 downto 0):=(others=>'0');
    signal address : std_logic_vector(4 downto 0):=(others=>'0'); 
    signal data_out: std_logic_vector(31 downto 0):=(others=>'0');
    
    type t_mem is array(0 to 31) of  std_logic_vector(31 downto 0);
    signal mem: t_mem:=(
        0  => x"00000000",   
        1  => x"00000001",   
        2  => x"0000000A",   
        3  => x"0000000B",   
        4  => x"0000000C",   
        5  => x"0000000D",  
        6  => x"0000000E",   
        7  => x"0000000F",   
        others => (others => '0')  
    );
    
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

begin
    
      c1:MPG port map ( en, btn(0), clk);
      process(clk)
      begin
           if rising_edge(clk) then
             if en='1'then
                if btn(0) = '1' then
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;
    
    address<=cnt;
    data_out<=mem(CONV_INTEGER(address));
    c2:SEGMENTE port map (clk,data_out,an,cat);


end Behavioral;