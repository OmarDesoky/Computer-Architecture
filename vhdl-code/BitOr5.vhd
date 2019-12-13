LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr5 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR11 : IN std_logic;
		 R0 : OUT std_logic);

END ENTITY BitOr5;

ARCHITECTURE a_BitOr5 OF BitOr5 IS
BEGIN

	R0 <= 
	(
	( Address(0) AND Address(1) AND Address(2) AND (NOT Address(3)) AND Address(4) AND Address(5)) OR
	( Address(0) AND (NOT Address(1)) AND (NOT Address(2)) AND Address(3) AND Address(4) AND Address(5)) OR
	( Address(0) AND (NOT Address(1)) AND Address(2) AND Address(3) AND Address(4) AND Address(5))
	) 
	AND (NOT IR11)

	;	
END a_BitOr5;
