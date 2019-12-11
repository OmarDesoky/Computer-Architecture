
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY tristate IS
GENERIC ( n : integer := 16);
PORT(  input  : IN std_logic_vector(n-1 DOWNTO 0);
       enable : IN std_logic;
       output : OUT std_logic_vector(n-1 DOWNTO 0));
END tristate;

ARCHITECTURE a_tristate of tristate is
BEGIN

output <= input WHEN (enable = '1')
ELSE (others =>'Z');

END a_tristate; 