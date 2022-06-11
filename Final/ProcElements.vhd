--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here

	with selector select
	Result <= In1 when '1',
	In0 when others;

end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
	signal identity: std_logic_vector(9 DOWNTO 0);
	signal resultbit: std_logic_vector(13 DOWNTO 0);
begin
-- Add your code here

	identity <= funct3 & opcode;
	--Instruction  Branch  MemRead  MemtoReg  ALUCtrl  MemWrite  ALUSrc  RegWrite  ImmGen  funct7   funct 3   opcode  Type
	--add            00       1        0      00000       0        0         1       00   0000000     000    0110011  R-Type
	--sub            00       1        0      00001       0        0         1       00   0100000     000    0110011  R-Type
	--addi           00       1        0      00010       0        1         1       10   xxxxxxx     000    0010011  I-Type
	--and            00       1        0      00011       0        0         1       00   0000000     111    0110011  R-Type
	--or             00       1        0      00101       0        0         1       00   0000000     110    0110011  R-Type
	--sll            00       1        0      00111       0        0         1       00   0000000     001    0110011  R-Type
	--srl            00       1        0      01001       0        0         1       00   0000000     101    0110011  R-Type
	--lw             00       0        1      00010       0        1         1       10   xxxxxxx     010    0000011  S-Type
	--sw             00       1        0      00010       1        1         0       11   xxxxxxx     010    0100011  S-Type
	--beq            10       1        0      00001       0        0         0       01   xxxxxxx     000    1100011  B-Type
	--bne            01       1        0      00001       0        0         0       01   xxxxxxx     001    1100011  B-Type
	--lui            00       1        0      xxxxx       0        1         1       00   xxxxxxx     xxx    0110111  U-Type
	--andi           00       1        0      00100       0        1         1       10   xxxxxxx     000    0010011  I-Type
	--ori            00       1        0      00110       0        1         1       10   xxxxxxx     110    0010011  I-Type
	--slli           00       1        0      01000       0        1         1       10   0000000     001    0010011  I-Type
	--srli           00       1        0      01010       0        1         1       10   0000000     101    0010011  I-Type
	

	
	resultbit <= ("00"&"1"&"0"&"00000"&"0"&"0"&"1"&"00") WHEN (funct7 = "0000000" AND identity = "0000110011") ELSE
		     ("00"&"1"&"0"&"00001"&"0"&"0"&"1"&"00") WHEN (funct7 = "0100000" AND identIty = "0000110011") ELSE
		     ("00"&"1"&"0"&"00010"&"0"&"1"&"1"&"10") WHEN (identity = "0000010011") ELSE
		     ("00"&"1"&"0"&"00011"&"0"&"0"&"1"&"00") WHEN (funct7 = "0000000" AND identity = "1110110011") ELSE
		     ("00"&"1"&"0"&"00101"&"0"&"0"&"1"&"00") WHEN (funct7 = "0000000" AND identity = "1100110011") ELSE
		     ("00"&"1"&"0"&"00111"&"0"&"0"&"1"&"00") WHEN (funct7 = "0000000" AND identity = "0010110011") ELSE
		     ("00"&"1"&"0"&"01001"&"0"&"0"&"1"&"00") WHEN (funct7 = "0000000" AND identity = "1010110011") ELSE
		     ("00"&"0"&"1"&"00010"&"0"&"1"&"1"&"10") WHEN (identity = "0100000011") ELSE
		     ("00"&"1"&"0"&"00010"&"1"&"1"&"0"&"11") WHEN (identity = "0100100011") ELSE
		     ("10"&"1"&"0"&"00001"&"0"&"0"&"0"&"01") WHEN (identity = "0001100011") ELSE
		     ("01"&"1"&"0"&"00001"&"0"&"0"&"0"&"01") WHEN (identity = "0011100011") ELSE
		     ("00"&"1"&"0"&"00000"&"0"&"1"&"1"&"00") WHEN (identity(6 DOWNTO 0) = "0110111") ELSE
		     ("00"&"1"&"0"&"00100"&"0"&"1"&"1"&"10") WHEN (identity = "0000010011") ELSE
		     ("00"&"1"&"0"&"00110"&"0"&"1"&"1"&"10") WHEN (identity = "1100010011") ELSE
		     ("00"&"1"&"0"&"01000"&"0"&"1"&"1"&"10") WHEN (funct7 = "0000000" AND identity = "0010010011") ELSE
		     ("00"&"1"&"0"&"01010"&"0"&"1"&"1"&"10") WHEN (funct7 = "0000000" AND identity = "1010010011") ELSE
		     "00100000000000";     

	Branch <= resultbit(13 DOWNTO 12);
	MemRead <= resultbit(11);
	MemtoReg <= resultbit(10);
	ALUCtrl <= resultbit(9 DOWNTO 5);
	MemWrite <= resultbit(4);
	ALUSrc <= resultbit(3);
	RegWrite <= resultbit(2);
	ImmGen <= resultbit(1 DOWNTO 0);

end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;



architecture executive of ProgramCounter is
begin
-- Add your code here
	process(Reset, Clock)
		begin
		if Reset = '1' then 
			PCout <= X"00400000";
		end if;
		if rising_edge(Clock) then
			PCout <= PCin;
		end if;
	
	end process;
	

end executive;
--------------------------------------------------------------------------------
