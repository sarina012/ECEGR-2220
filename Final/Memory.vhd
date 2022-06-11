--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

	--Storing at Address
    if falling_edge(Clock) AND WE = '1' AND (to_integer(unsigned(Address(7 DOWNTO 0))) >= 0) AND (to_integer(unsigned(Address)) <= 127) then
	    i_ram(to_integer(unsigned(Address(7 DOWNTO 0)))) <= DataIn;	
    end if;


	--Reading from Address
    if (OE = '0') AND (to_integer(unsigned(Address)) < 127) AND (to_integer(unsigned(Address)) >= 0) then
	DataOut <= i_ram(to_integer(unsigned(Address(7 DOWNTO 0))));
    else 
	DataOut <= (others => 'Z');
    end if;

 
	
  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	SIGNAL x0out: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a0: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a1: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a2: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a3: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a4: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a5: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a6: std_logic_vector(31 DOWNTO 0);
	SIGNAL register_a7: std_logic_vector(31 DOWNTO 0);
	SIGNAL writeSel: std_logic_vector(7 DOWNTO 0);
	SIGNAL writer: std_logic_vector(5 DOWNTO 0);

begin
	writer <= WriteCmd & WriteReg;
	WITH writer SELECT
	writeSel <= "10000000" WHEN "101010",
		"01000000" WHEN "101011",
		"00100000" WHEN "101100",
		"00010000" WHEN "101101",
		"00001000" WHEN "101110",
		"00000100" WHEN "101111",
		"00000010" WHEN "110000",
		"00000001" WHEN "110001",
		(others => '0') WHEN OTHERS;
	


    -- Add your code here for the Register Bank implementation
	rbank_0: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(7), '0', '0', register_a0);
	rbank_1: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(6), '0', '0', register_a1);
	rbank_2: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(5), '0', '0', register_a2);
	rbank_3: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(4), '0', '0', register_a3);
	rbank_4: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(3), '0', '0', register_a4);
	rbank_5: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(2), '0', '0', register_a5);
	rbank_6: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(1), '0', '0', register_a6);
	rbank_7: register32 PORT MAP (WriteData, '0', '1', '1', writeSel(0), '0', '0', register_a7);
	
	
	WITH ReadReg1 SELECT
	ReadData1 <= register_a0 WHEN "01010",
		register_a1 WHEN "01011",
		register_a2 WHEN "01100",
		register_a3 WHEN "01101",
		register_a4 WHEN "01110",
		register_a5 WHEN "01111",
		register_a6 WHEN "10000",
		register_a7 WHEN "10001",
		(others => '0') WHEN OTHERS;
	
	WITH ReadReg2 SELECT
	ReadData2 <= register_a0 WHEN "01010",
	register_a1 WHEN "01011",
	register_a2 WHEN "01100",
	register_a3 WHEN "01101",
	register_a4 WHEN "01110",
	register_a5 WHEN "01111",
	register_a6 WHEN "10000",
	register_a7 WHEN "10001",
	(others => '0') WHEN OTHERS;

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
