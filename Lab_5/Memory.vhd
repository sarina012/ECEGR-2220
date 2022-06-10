--------------------------------------------------------------------------------
--Lab 3
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);

end entity bitstorage;
architecture memlike of bitstorage is
	signal q: std_logic := '0';

begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
   port (a : in std_logic;
         b : in std_logic;
         cin : in std_logic;
         sum : out std_logic;
         carry : out std_logic);
end fulladder;
architecture addlike of fulladder is
begin
 sum   <= a xor b xor cin;
 carry <= (a and b) or (a and cin) or (b and cin);
end architecture addlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- insert your code here.
	bit0: bitstorage port map(datain(0), enout, writein, dataout(0));
	bit1: bitstorage port map(datain(1), enout, writein, dataout(1));
	bit2: bitstorage port map(datain(2), enout, writein, dataout(2));
	bit3: bitstorage port map(datain(3), enout, writein, dataout(3));
	bit4: bitstorage port map(datain(4), enout, writein, dataout(4));
	bit5: bitstorage port map(datain(5), enout, writein, dataout(5));
	bit6: bitstorage port map(datain(6), enout, writein, dataout(6));
	bit7: bitstorage port map(datain(7), enout, writein, dataout(7));

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;	--active low
		 writein32, writein16, writein8: in std_logic;	--active high
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	   	  enout:  in std_logic;
	  	  writein: in std_logic;
	   	  dataout: out std_logic_vector(7 downto 0));
	end component;

	signal enable_a: std_logic_vector(2 downto 0);
	signal write_a: std_logic_vector(2 downto 0);
	signal enable_b: std_logic_vector(3 downto 0);
	signal write_b: std_logic_vector(3 downto 0);
begin
	-- insert code here.
	enable_a <= enout32 & enout16 & enout8;
	write_a <= writein32 & writein16 & writein8;
	
	with enable_a select
	enable_b <= 	"0000" when "011",
			"1100" when "101",
			"1110" when "110",
			"1111" when others;
	
	with write_a select
	write_b <= 	"0001" when "001",
			"0011" when "010",
			"1111" when "100",
			"0000" when others;

	register1: register8 port map (datain(31 downto 24), enable_b(3),write_b(3), dataout(31 downto 24));
	register2: register8 port map (datain(23 downto 16), enable_b(2),write_b(2), dataout(23 downto 16));
	register3: register8 port map (datain(15 downto 8), enable_b(1),write_b(1), dataout(15 downto 8));
	register4: register8 port map (datain(7 downto 0), enable_b(0),write_b(0), dataout(7 downto 0));
end architecture biggermem;

--------------------------------------------------------------------------------
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

    if falling_edge(Clock) and (WE = '1')then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	if to_integer(unsigned(Address))>=0 and to_integer(unsigned(Address))<=127 then 
		i_ram(to_integer(unsigned(Address(7 downto 0))))<=DataIn;
	end if;
    end if;

	-- Rest of the RAM implementation	
   if (OE = '0') and (to_integer(unsigned(Address))>=0) and (to_integer(unsigned(Address))<=127) then 
	DataOut<= i_ram(to_integer(unsigned(Address(7 downto 0))));
   else
	DataOut <= (others=>'Z');
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
	
	signal writingToReg: std_logic_vector (7 downto 0);
	signal xO: std_logic_vector (31 downto 0);
	signal register_a0: std_logic_vector (31 downto 0);	
	signal register_a1: std_logic_vector (31 downto 0);	
	signal register_a2: std_logic_vector (31 downto 0);	
	signal register_a3: std_logic_vector (31 downto 0);	
	signal register_a4: std_logic_vector (31 downto 0);	
	signal register_a5: std_logic_vector (31 downto 0);	
	signal register_a6: std_logic_vector (31 downto 0);	
	signal register_a7: std_logic_vector (31 downto 0);	

begin
    -- Add your code here for the Register Bank implementation
	with WriteReg select
	writingToReg <= "10000000" when "01010",
		        "01000000" when "01011",
	    	        "00100000" when "01100",
		        "00010000" when "01101",
		        "00001000" when "01110",
		        "00000100" when "01111",
	    	        "00000010" when "10000",
		        "01000001" when "10001",
		        (others => '0') when others;
	
	rbank_0: register32 port map (WriteData,'0','1','1', writingToReg(7),'0','0',register_a0);
	rbank_1: register32 port map (WriteData,'0','1','1', writingToReg(6),'0','0',register_a1);
	rbank_2: register32 port map (WriteData,'0','1','1', writingToReg(5),'0','0',register_a2);
	rbank_3: register32 port map (WriteData,'0','1','1', writingToReg(4),'0','0',register_a3);
	rbank_4: register32 port map (WriteData,'0','1','1', writingToReg(3),'0','0',register_a4);
	rbank_5: register32 port map (WriteData,'0','1','1', writingToReg(2),'0','0',register_a5);
	rbank_6: register32 port map (WriteData,'0','1','1', writingToReg(1),'0','0',register_a6);
	rbank_7: register32 port map (WriteData,'0','1','1', writingToReg(0),'0','0',register_a7);

	with ReadReg1 select
		ReadData1 <= register_a0 when "01010",
			     register_a1 when "01011",
			     register_a2 when "01100",
			     register_a3 when "01101",
			     register_a4 when "01110",
			     register_a5 when "01111",
			     register_a6 when "10000",
			     register_a7 when "10001",
			     X"00000000" when others;

	with ReadReg2 select
		ReadData2 <= register_a0 when "01010",
			     register_a1 when "01011",
			     register_a2 when "01100",
			     register_a3 when "01101",
			     register_a4 when "01110",
			     register_a5 when "01111",
			     register_a6 when "10000",
			     register_a7 when "10001",
			     X"00000000" when others;
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------