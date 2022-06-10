--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result);
	
	tb : PROCESS
	BEGIN
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 		-- result = 0x124578AB  and zeroOut = 0
		control  <= "00001";
		wait for 20 ns; 		-- testing subtraction
		control  <= "00010";
		wait for 20 ns; 		-- testing and
		control  <= "00011";
		wait for 20 ns; 		-- testing or
		control  <= "00111";
		wait for 20 ns; 		-- testing shift left 1
		control  <= "01001";
		wait for 20 ns; 		-- testing shift left 2
		control  <= "01010";
		wait for 20 ns; 		-- testing shift left 3
		control  <= "01011";
		wait for 20 ns; 		-- testing shift right 1
		control  <= "01101";
		wait for 20 ns; 		-- testing shift right 2
		control  <= "01110";
		wait for 20 ns; 		-- testing shift right 3
		control  <= "01111";

		--------immediates ----------
		wait for 20 ns; 		-- testing addi
		control  <= "10001";
		wait for 20 ns; 		-- testing andi
		control  <= "10011";
		wait for 20 ns; 		-- testing ori
		control  <= "10111";
		wait for 20 ns; 		-- testing shift imm left 1
		control  <= "11001";
		wait for 20 ns; 		-- testing shift imm left 2
		control  <= "11010";
		wait for 20 ns; 		-- testing shift imm left 3
		control  <= "11011";
		wait for 20 ns; 		-- testing shift imm right 1
		control  <= "11101";
		wait for 20 ns; 		-- testing shift imm right 2
		control  <= "11110";
		wait for 20 ns; 		-- testing shift imm right 3
		control  <= "11111";

		wait; -- will wait forever
	END PROCESS;

END;