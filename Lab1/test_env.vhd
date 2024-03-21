library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
    signal count : unsigned(15 downto 0) := (others => '0');
    signal en : std_logic; 

    component MPG
        port (
            enable : out std_logic;
            btn : in std_logic;
            clk : in std_logic
        );
    end component;

begin

    led <= sw;
    an(7 downto 4) <= "1111";
    an(3 downto 0) <= btn(3 downto 0);
    cat <= (others => '0');
    
    monopulse : MPG port map (
        enable => en,
        btn => btn(0),
        clk => clk
    );

    process(clk)
    begin
        if rising_edge(clk) then
            if sw = "1" then
                count <= count + 1;
            else
                count <= count - 1;
            end if;
            
            if btn(0) = '1' then 
                count <= count + 1;
            end if;
        end if;
    end process;
    
      led <= std_logic_vector(count);

end Behavioral;
