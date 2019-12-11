LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;


ENTITY RAM IS
	Generic(addressBits: integer :=12;
		wordSize: integer :=16);
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(addressBits - 1 DOWNTO 0);
		datain  : IN  std_logic_vector(wordSize - 1 DOWNTO 0);
		dataout : OUT std_logic_vector(wordSize - 1 DOWNTO 0));
END ENTITY RAM;

ARCHITECTURE syncrama OF RAM IS
	

	TYPE ram_type IS ARRAY(0 TO (2**addressBits) - 1) OF std_logic_vector(wordSize - 1 DOWNTO 0);
	
	impure function init_ram_bin return ram_type is
		file text_file : text open read_mode is "RAM_DATA.txt";
		variable text_line : line;	
		variable ram_content : ram_type;
		variable bv : bit_vector(ram_content(0)'range);
		begin
		for i in 0 to (2**addressBits-1) loop
			readline(text_file, text_line);
			read(text_line, bv);
			--ram_content(i):= "0000000000001100";
			ram_content(i) := To_StdLogicVector(bv);
		end loop;
  		return ram_content;
	end function;


	SIGNAL ram : ram_type := init_ram_bin;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;
