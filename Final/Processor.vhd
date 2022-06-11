--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	signal pcOut: std_logic_vector(31 DOWNTO 0);
	signal instruction1: std_logic_vector(31 DOWNTO 0);
	signal WriteCMD1: std_logic;
	signal immidiatepart: std_logic_vector(31 downto 0);
	signal signExtend: std_logic_vector(19 downto 0);

	--CONTROL VARIABLES
	signal branch: std_logic_vector(1 DOWNTO 0);
	signal memRead: std_logic;
	signal memToReg: std_logic;
	signal aluCtrl: std_logic_vector(4 DOWNTO 0);
	signal memWrite: std_logic;
	signal aluSrc: std_logic;
	signal regWrite: std_logic;
	signal immGen: std_logic_vector(1 downto 0);

	--Registers
	signal readData1: std_logic_vector(31 downto 0);
	signal readData2: std_logic_vector(31 downto 0);

	--ALU
	signal aluInput2: std_logic_vector(31 downto 0);
	signal isZero: std_logic;
	signal aluResult: std_logic_vector(31 downto 0);

	--Data Memory
	signal dataMem: std_logic_vector(31 downto 0);
	signal dataMemMuxoutput: std_logic_vector(31 downto 0);
	signal dataTemp: std_logic_vector(31 downto 0);
	signal newDataMemaddress: std_logic_vector(29 downto 0);

	--Top part of processor
	signal rightAddSum: std_logic_vector(31 downto 0);
	signal leftAddSum: std_logic_vector(31 downto 0);
	signal throwaway1: std_logic;
	signal throwaway2: std_logic;
	signal throwaway3: std_logic;

	--Branch
	signal BranchEqNotEq: std_logic;
	signal finWire: std_logic_vector(31 downto 0);
	signal branchSel: std_logic_vector(2 downto 0);

begin
	-- Add your code here
	--3
	WriteCMD1 <= '1' WHEN (falling_edge(clock) AND regWrite = '1') ELSE
	'0';

	--For immidiate select
	with instruction1(31) select
	signExtend <= (others => '1') when '1',
	(others => '0') when others;
	
	with immGen select
	immidiatepart <= (signExtend(19 downto 0) & instruction1(31 downto 20)) when "10", --I-type
	(signExtend(18 downto 0) & instruction1(31) & instruction1(7) & instruction1(30 downto 25) & instruction1(11 downto 8) & '0') when "01", --B-type
	(signExtend(19 downto 0) & instruction1(31 downto 25) & instruction1(11 downto 7)) when "11", --S-type
	(instruction1(31 downto 12) & "000000000000") when others; --U-type/R-type
	
	--Branching Logic
	--10 BEQ
	--01 BNE
	branchSel <= isZero & branch;
	with branchSel select
	BranchEqNotEq <= '1' When "001",
	'0' when "101",
	'1' when "110",
	'0' when "010",
	'0' when others;
	


	
	PC: ProgramCounter PORT MAP (reset, clock, finWire, pcOut);

	InstructionMemory: InstructionRAM PORT MAP (reset, clock, pcOut(31 DOWNTO 2), instruction1);
	
	ctrl: Control PORT MAP (clock, instruction1(6 DOWNTO 0), instruction1(14 DOWNTO 12), instruction1(31 DOWNTO 25), branch, memRead, memtoReg, aluCtrl, memWrite, aluSrc, regWrite, immGen);
	
	reg: Registers PORT MAP (instruction1(19 DOWNTO 15), instruction1(24 DOWNTO 20), instruction1(11 DOWNTO 7), dataMemMuxoutput, WriteCMD1, readData1, readData2);
	
	Reg2AluMUX: BusMux2to1 PORT MAP (aluSrc, readData2, immidiatepart, aluInput2);
	
	ALUModule: ALU PORT MAP (readData1, aluInput2, aluCtrl, isZero, aluResult);

	offsetSubtractor: adder_subtracter PORT MAP (aluResult, X"10000000", '1', dataTemp, throwaway3); 
	
	newDataMemaddress <= dataTemp(31 downto 2);

	DataMemory: RAM PORT MAP (reset, clock, memRead, memWrite, newDataMemaddress, readData2, dataMem);

	Data2MemMUX: BusMux2to1 PORT MAP (memToReg, aluResult, dataMem, dataMemMuxoutput);




	Adder1: adder_subtracter PORT MAP (pcOut, immidiatepart, '0', rightAddSum, throwaway1);

	Adder2: adder_subtracter PORT MAP (pcOut, "00000000000000000000000000000100", '0', leftAddSum, throwaway2);

	rightAdderMux: BusMux2to1 PORT MAP (BranchEqNotEq, leftAddSum, rightAddSum, finWire);
	
			
end holistic;

