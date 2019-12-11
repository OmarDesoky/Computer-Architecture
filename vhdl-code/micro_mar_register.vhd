
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY micro_mar_register IS
GENERIC ( n : integer := 6);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable: in std_logic
);
	
END micro_mar_register;
ARCHITECTURE a_micro_mar_register OF micro_mar_register IS
BEGIN
PROCESS (d,Clk,Rst)
BEGIN
IF Rst = '1' THEN
q <= ("011010");
ELSIF (rising_edge(Clk)and enable='1') THEN
q <= d;
END IF;
END PROCESS;
END a_micro_mar_register;