LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY register_nbits IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
		enable: in std_logic
);
	
END register_nbits;
ARCHITECTURE a_register_nbits OF register_nbits IS
BEGIN
PROCESS (d,Clk,Rst,enable)
BEGIN
IF Rst = '1' THEN
q <= (OTHERS=>'0');
ELSIF (Clk = '1' and enable='1') THEN
q <= d;
END IF;
END PROCESS;
END a_register_nbits;