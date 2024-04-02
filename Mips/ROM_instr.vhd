library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_instr is
 Port (    
           address : in STD_LOGIC_VECTOR(4 downto 0);
           instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ROM_instr;

architecture Behavioral of ROM_instr is
 type t_mem is array(0 to 31) of  std_logic_vector(31 downto 0);
    signal mem: t_mem:=(
         x"014A5026", x"00000026", x"03DEF026", x"8D410000", x"214A0004",
          x"8D420000", x"20000008", x"103E000D", x"105E000A", x"AC010000",
           x"20000004", x"AC020000", x"20000004", x"00221822", x"1C600002", x"00411022",
            x"08000008", x"00220822", x"08000008", x"AC010000", x"08000016", x"AC020000",
        others => (others => '0')  
    );
begin
instruction<=mem(CONV_INTEGER(address));
end Behavioral;
