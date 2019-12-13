LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr4 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR5 : IN std_logic;
		 R0 : OUT std_logic);

END ENTITY BitOr4;

ARCHITECTURE a_BitOr4 OF BitOr4 IS
BEGIN

	R0 <= 
	(
	( Address(0) AND (NOT Address(1)) AND Address(2) AND (NOT Address(3)) AND (NOT Address(4)) AND Address(5)) OR
	( (NOT Address(0)) AND Address(1) AND Address(2) AND (NOT Address(3)) AND (NOT Address(4)) AND Address(5)) OR
	( Address(0) AND (NOT Address(1)) AND (NOT Address(2)) AND Address(3) AND (NOT Address(4)) AND Address(5))
	) 
	AND (NOT IR5)

	;	
END a_BitOr4;
