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
	impure function init_rom_bin return ROM_type is
		file text_file : text open read_mode is "CONTROL_STORE.txt";
		variable text_line : line;	
		variable rom_content : ROM_type;
		variable bv : bit_vector(rom_content(0)'range);
		begin
		for i in 0 to (2**addressBits-1) loop
			readline(text_file, text_line);
			read(text_line, bv);
			rom_content(i) := To_StdLogicVector(bv);
		end loop;
  		return rom_content;
	end function;
	SIGNAL ROM : ROM_type := init_rom_bin;
	
	BEGIN
		PROCESS(address) IS
		BEGIN
		dataout <= ROM(to_integer(unsigned(address)));
		END PROCESS;
END ARCHITECTURE;