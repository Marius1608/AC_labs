library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env_lab2_2 is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (7 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env_lab2_2;

architecture Behavioral of test_env_lab2_2 is
    
    signal en : std_logic :='0';
    signal cnt : std_logic_vector(1 downto 0):=(others=>'0');
    signal output: std_logic_vector(31 downto 0):=(others=>'0');
    
    signal add: std_logic_vector(31 downto 0):=(others=>'0');
    signal sub: std_logic_vector(31 downto 0):=(others=>'0');
    signal lsl: std_logic_vector(31 downto 0):=(others=>'0');
    signal lsr: std_logic_vector(31 downto 0):=(others=>'0');
    
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
    c2:SEGMENTE port map (clk,output,an,cat);
    
    add<=(X"0000000" & sw(3 downto 0))+(X"0000000" & sw(7 downto 4));
    sub<=(X"0000000" & sw(3 downto 0))-(X"0000000" & sw(7 downto 4));
    lsl<=X"0000" & "000000" & sw(7 downto 0) & "00";
    lsr<=X"0000" & "0000000000" & sw(7 downto 2);
    
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
    
    
    process (cnt,add,sub,lsl,lsr)
    begin
    case cnt is
         when "00" => output <= add;
         when "01" => output <= sub;
         when "10" => output <= lsl;
         when "11" => output <= lsr;
         when others => output <= add;
     end case;
    end process;

    led(7)<='1' when output=0; 
    
end Behavioral;