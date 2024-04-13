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
           Enable: in STD_LOGIC;
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

component UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           BranchGTZ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (5 downto 0)
           );
end component;

component EX is
    Port (  RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(5 downto 0);
           PC_4 : in STD_LOGIC_VECTOR (31 downto 0);
           GTZ : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MEM is
 port ( 
        MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        Clk: in std_logic;
        EN: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        AluResOut: out std_logic_vector(31 downto 0)   
        );
end component;

--mpg
signal enable: std_logic := '0';

--ssd
signal digits: std_logic_vector (31 downto 0) := (others => '0');

--IFECH
signal pc: std_logic_vector (31 downto 0) := (others => '0');
signal reset : STD_LOGIC :='0';
signal Jump : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC :='0';
signal Jump_Address : STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
signal Branch_Address : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
signal PC_4 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--Id(ok)
signal RegWrite : STD_LOGIC :='0';
--signal Instr : STD_LOGIC_VECTOR (25 downto 0);
signal RegDst : STD_LOGIC :='0';
signal WD : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal ExtOp : STD_LOGIC :='0';
signal RD1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal Ext_Imm : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal func : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
signal sa : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');

--UC
--signal Instr : STD_LOGIC_VECTOR (5 downto 0);
--signal RegDst : STD_LOGIC;
--signal ExtOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC := '0';
signal Branch : STD_LOGIC := '0';
signal BranchGTZ : STD_LOGIC := '0';
--signal Jump : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal MemWrite : STD_LOGIC := '0';
signal MemtoReg : STD_LOGIC := '0';
--signal RegWrite : STD_LOGIC);

--EX
signal AluRes: std_logic_vector(31 downto 0):=(others=>'0');
signal Zero: std_logic:='0';
signal GTZ : STD_LOGIC := '0';
--signal Instr : STD_LOGIC_VECTOR (25 downto 0);
--signal ALUSrc : STD_LOGIC := '0';
--signal RD1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
--signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
-- Ext_Imm : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
--signal func : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
-- sa : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');

--MEM
signal  AluResOut: std_logic_vector(31 downto 0):=(others=>'0');
signal MemData: std_logic_vector(31 downto 0):=(others=>'0');
--signal AluRes: std_logic_vector(31 downto 0):=(others=>'0');
--signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
--signal enable: std_logic := '0';
--signal MemWrite : STD_LOGIC := '0';


signal OutMux:std_logic_vector(31 downto 0):=(others=>'0');

begin
    
    reset<=btn(1);
    Jump_Address<= PC_4(31 downto 28)& (Instruction(25 downto 0) & "00");
    OutMux<=AluResOut when MemtoReg='0' else MemData;
    WD<=OutMux;
    PCSrc<=(BranchGTZ and GTZ)or(Zero and Branch);
    
    
    c1: MPG port map(enable, btn(0), clk);
    c2: IFetch port map(clk, reset,enable,Jump ,PCSrc ,Jump_Address, Branch_Address, PC_4, Instruction);
    c3: SEGMENTE port map(clk, digits, an, cat);
    c4: ID port map(clk, RegWrite, Instruction(25 downto 0), RegDst, WD, ExtOp, RD1, RD2, Ext_Imm, func, sa);
    c5: UC port map(Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, BranchGTZ, Jump, MemWrite, MemtoReg, RegWrite,ALUOp);  
    c6: EX port map(RD1,ALUSrc,RD2,Ext_Imm,sa,func,ALUOp,PC_4,GTZ,Zero,AluRes,Branch_Address);
    c7: MEM port map(MemWrite,AluRes,RD2,clk,enable,MemData,AluResOut);
    
    led(7) <= RegDst;
    led(6) <= ExtOp;
    led(5) <= ALUSrc;
    led(4) <= Branch;
    led(3) <= BranchGTZ;
    led(2) <= Jump;
    led(13 downto 8) <= ALUOp;
    led(2) <= MemWrite;
    led(1) <= MemtoReg;
    led(0) <= RegWrite;
    
    
    
    process (sw(7 downto 5),Instruction,PC_4,RD1,RD2,
Ext_Imm,AluRes,MemData,WD)
    begin
    case sw(7 downto 5) is
      when "000" => digits <= Instruction;
      when "001" => digits <= PC_4;
      when "010" => digits <= RD1;
      when "011" => digits <= RD2;
      when "100" => digits <= Ext_Imm;
      when "101" => digits <= AluRes;
      when "110" => digits <=MemData;
      when "111" => digits <= WD;
      when others => digits <= Instruction;
     end case;
    end process;

				
    
end Behavioral;