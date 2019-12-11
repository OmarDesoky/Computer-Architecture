
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pc_tristate IS
GENERIC ( n : integer := 16);
PORT(  input  : IN std_logic_vector(n-1 DOWNTO 0);
       enable : IN std_logic;
       output,output2 : OUT std_logic_vector(n-1 DOWNTO 0));
END pc_tristate;

ARCHITECTURE a_tristate of pc_tristate is
BEGIN

output <= input WHEN (enable = '1')
ELSE (others =>'Z');

output2 <= input WHEN (enable = '1')
ELSE (others =>'Z');

END a_tristate; 
