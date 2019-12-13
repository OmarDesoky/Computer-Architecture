LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mdr_register IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d,d2 : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable,enable2: in std_logic
);
	
END mdr_register;
ARCHITECTURE a_mdr_register OF mdr_register IS
BEGIN
PROCESS (d,d2,Clk,Rst)
BEGIN
IF Rst = '1' THEN
q <= (OTHERS=>'0');
ELSIF (enable2='1'and rising_edge(Clk)) then
q<=d2;
ELSIF (enable='1') THEN
q <= d;
END IF;
END PROCESS;
END a_mdr_register;
