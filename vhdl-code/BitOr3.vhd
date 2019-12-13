LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr3 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		 R0 : OUT std_logic);

END ENTITY BitOr3;

ARCHITECTURE a_BitOr3 OF BitOr3 IS
BEGIN
	R0 <=
	(
	((Address(0) OR Address(1) OR Address(2) OR Address(3)) AND (NOT Address(4)) AND (NOT Address(5))) OR
	((NOT Address(0)) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4)) OR
	( Address(0) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4)) OR
	((NOT Address(0)) AND Address(1) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4))
	) 
	 AND 
	((NOT IR(3)) AND (NOT IR(4)) AND (NOT IR(5)))

	;
END a_BitOr3;
