LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ROM IS
	Generic(addressBits: integer :=6;
		wordSize: integer :=21);
	PORT(
		address : IN  std_logic_vector(addressBits - 1 DOWNTO 0);
		dataout : OUT std_logic_vector(wordSize - 1 DOWNTO 0));
END ENTITY ROM;

ARCHITECTURE MyROM OF ROM IS

	TYPE ROM_type IS ARRAY(0 TO (2**addressBits) - 1) OF std_logic_vector(wordSize - 1 DOWNTO 0);
	SIGNAL ROM : ROM_type ;
	
	BEGIN
		PROCESS(address) IS
		BEGIN
		dataout <= ROM(to_integer(unsigned(address)));
		END PROCESS;
END ARCHITECTURE;