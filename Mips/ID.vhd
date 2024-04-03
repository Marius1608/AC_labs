
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ID is
  Port (
    clk: in std_logic;
    RegWrite: in std_logic;
    RegDst: in std_logic;
    ExtOp: in std_logic;
    Instr: in std_logic_vector(25 downto 0);
    WD: in std_logic_vector(31 downto 0);
    RD1: out std_logic_vector(31 downto 0);
    RD2: out std_logic_vector(31 downto 0);
    Ext_Imm: out std_logic_vector(31 downto 0);
    func: out std_logic_vector(5 downto 0);
    sa: out std_logic_vector(4 downto 0)
   );
end ID;

architecture Behavioral of ID is

signal outmux1:std_logic_vector(4 downto 0);

component reg_file is
port ( 
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
 
 c4: reg_file port map(clk,Instr(25 downto 21),Instr(20 downto 16),
                        outmux1,WD,RegWrite,RD1,RD2
 );
 outmux1 <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);
 
 process(clk)
    begin
    if ExtOp='1'then
    Ext_Imm<= x"0000" & Instr(15 downto 0);
    end if;
end process;
 
 func<=Instr(5 downto 0);
 sa<=Instr(10 downto 6);
 
end Behavioral;
