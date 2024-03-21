library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env_lab2_1 is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_lab2_1;

architecture Behavioral of test_env_lab2_1 is
    
    signal en : std_logic :='0';
    signal cnt : std_logic_vector(31 downto 0):=(others=>'0');

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
    c2:SEGMENTE port map (clk,cnt,an,cat);


    process(clk)
    begin

        if en='1'then
            if rising_edge(clk) then

                if sw(0) = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= cnt - 1;
                end if;

                if btn(0) = '1' then
                    cnt <= cnt + 1;
                end if;

            end if;
        end if;
    end process;

end Behavioral;