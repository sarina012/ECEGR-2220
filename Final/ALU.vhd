
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port( DataIn1: in std_logic_vector(31 downto 0);
	      DataIn2: in std_logic_vector(31 downto 0);
       	      ALUCtrl: in std_logic_vector(4 downto 0);
	      Zero: out std_logic;
	      ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port( datain_a: in std_logic_vector(31 downto 0);
		      datain_b: in std_logic_vector(31 downto 0);
		      add_sub: in std_logic;
		      dataout: out std_logic_vector(31 downto 0);
		      co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port( datain: in std_logic_vector(31 downto 0);
		      dir: in std_logic;
		      shamt: in std_logic_vector(4 downto 0);
		      dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal addersub_alu: std_logic_vector(31 downto 0);
	signal addsub_check: std_logic;
	signal shiftreg_alu: std_logic_vector(31 downto 0);
	signal and_alu: std_logic_vector(31 downto 0);
	signal or_alu: std_logic_vector(31 downto 0);
	signal addsub_dataout_alu: std_logic_vector(31 downto 0);
	signal co_alu: std_logic;
	signal temp_out: std_logic_vector(31 downto 0);

	----immediates
	signal addersubi_alu: std_logic_vector(31 downto 0);
	signal addsubi_check: std_logic;
	signal shiftregi_alu: std_logic_vector(31 downto 0);
	signal andi_alu: std_logic_vector(31 downto 0);
	signal ori_alu: std_logic_vector(31 downto 0);
	signal addsubi_dataout_alu: std_logic_vector(31 downto 0);


begin
	process (ALUCtrl) is
	begin
		if AlUCtrl = "00001" then addsub_check <= '0';
		elsif ALUCtrl = "00010" then addsub_check <= '1';
		end if;
	end process;
		
	and_alu <= DataIn1 and DataIn2;
	or_alu  <= DataIn1 or DataIn2;
	addsub_comp: component adder_subtracter port map (DataIn1, DataIn2, ALUCtrl(1), addsub_dataout_alu, co_alu);
	shiftreg_comp: component shift_register port map (DataIn1, ALUCtrl(3), ALUCtrl, shiftreg_alu);	
	
	--immediates
	andi_alu <= DataIn1 and DataIn2;
	ori_alu  <= DataIn1 or DataIn2;
	addsubi_comp: component adder_subtracter port map (DataIn1, DataIn2, ALUCtrl(1), addsubi_dataout_alu, co_alu);
	shiftregi_comp: component shift_register port map (DataIn1, ALUCtrl(3), ALUCtrl, shiftregi_alu);	

	-- Add ALU VHDL implementation here
	with ALUCtrl select
	ALUResult <= addsub_dataout_alu when "00001",
		     addsub_dataout_alu when "00010", 
		     and_alu when "00011",
		     or_alu when "00111",
		     shiftreg_alu when "01001", --Shifting left 1
		     shiftreg_alu when "01010", --Shifting left 2
		     shiftreg_alu when "01011", --Shifting left 3
		     shiftreg_alu when "01101", --Shifting right 1
		     shiftreg_alu when "01110", --Shifting right 2
		     shiftreg_alu when "01111", --Shifting right 3

		------- the stuff for the immediates -------
 		     addsubi_dataout_alu when "10001", --add imm
		     andi_alu when "10011", 	       --and imm
		     ori_alu when "10111", 	       --or imm
		     shiftregi_alu when "11001", --Shifting left imm 1
		     shiftregi_alu when "11010", --Shifting left imm 2
		     shiftregi_alu when "11011", --Shifting left imm 3
		     shiftregi_alu when "11101", --Shifting right imm 1
		     shiftregi_alu when "11110", --Shifting right imm 2
		     shiftregi_alu when "11111", --Shifting right imm 3
		     DataIn2 when others;

	process (temp_out) is
	begin
		if temp_out = 0 then Zero <='1';
		else Zero <= '0';
		end if;
	end process;

end architecture ALU_Arch;
