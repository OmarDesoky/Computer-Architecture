LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY FRenable IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		 Enable : OUT std_logic);

END ENTITY FRenable;

ARCHITECTURE a_FRenable OF FRenable IS
BEGIN

	Enable <=
	(
	((Address(0) OR Address(1) OR Address(2) OR Address(3)) AND (NOT Address(4)) AND (NOT Address(5))) OR
	((NOT Address(0)) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(4)) AND (NOT Address(5))) OR
	((NOT Address(0)) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4)) OR
	( Address(0) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4)) OR
	((NOT Address(0)) AND Address(1) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(5)) AND Address(4))
	);

END a_FRenable;
