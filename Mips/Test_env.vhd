library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SEGMENTE is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component IFetch is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump_Address : in STD_LOGIC_VECTOR(31 downto 0);
           Branch_Address : in STD_LOGIC_VECTOR(31 downto 0);
           PC_4 : out STD_LOGIC_VECTOR(31 downto 0);
           Instruction : out STD_LOGIC_VECTOR(31 downto 0)
           );
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
           RegDst : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0));
end component;

signal enable: std_logic := '0';
signal digits: std_logic_vector (31 downto 0) := (others => '0');

signal pc: std_logic_vector (31 downto 0) := (others => '0');
signal instr: std_logic_vector (31 downto 0) := (others => '0');

signal reset : STD_LOGIC :='0';
signal Jump : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC :='0';
signal Jump_Address : STD_LOGIC_VECTOR(31 downto 0) := x"0000000F";
signal Branch_Address : STD_LOGIC_VECTOR(31 downto 0) := x"00000014";
signal PC_4 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');


signal RegWrite : STD_LOGIC :='0';
signal RegDst : STD_LOGIC :='0';
signal WD : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal ExtOp : STD_LOGIC :='0';
signal RD1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal Ext_Imm : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal func : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
signal sa : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');


begin

    c1: MPG port map(enable, btn(0), clk);
    reset <= btn(1);
    Jump <= sw(0);
    PCSrc <= sw(1);
    c2: IFetch port map(enable, reset, Jump ,PCSrc , x"0000000F", x"00000014", pc, instr);
    digits <= instr when sw(7) = '0' else pc;
    c3: SEGMENTE port map(clk, digits, an, cat);
    c4: ID port map(enable, RegWrite, Instruction, RegDst, WD, ExtOp, RD1, RD2, Ext_Imm, func, sa);

end Behavioral;