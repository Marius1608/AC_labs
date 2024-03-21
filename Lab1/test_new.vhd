library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_new is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_new;

architecture Behavioral of test_new is

    signal count : std_logic_vector(2 downto 0) := "000";
    signal en : std_logic :='0';
    signal dcd: std_logic_vector(7 downto 0):=x"00";

    component MPG
        port (
            enable : out std_logic;
            btn : in std_logic;
            clk : in std_logic
        );
    end component;

begin

   
    conectare : MPG port map ( en, btn(0), clk);

    process(clk)
    begin
        if rising_edge(clk) then
        
            if en='1'then
            
             if sw(0) = '1' then
                 count <= count + 1;
             else
                 count <= count - 1;
             end if;
            
            if btn(0) = '1' then 
                count <= count + 1;
            end if;
       
            end if;
        end if;
    end process;

    process(count)
    begin
            case count is
                when "000" => dcd <= "00000001";
                when "001" => dcd <= "00000010";
                when "010" => dcd <= "00000100";
                when "011" => dcd <= "00001000";
                when "100" => dcd <= "00010000";
                when "101" => dcd <= "00100000";
                when "110" => dcd <= "01000000";
                when "111" => dcd <= "10000000";
                when others => dcd <= x"00";
            end case;
   
    end process;
    led(7 downto 0)<=dcd;
    led(12 downto 8)<="00000";
    led(15 downto 13)<=count;
   
    
end Behavioral;