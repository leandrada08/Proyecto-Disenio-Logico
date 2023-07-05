-- VHDL file
--
-- Autor: Andrada Luis Elian

-- Libreri­as utilizadas
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RxUart IS
    PORT (
        --input ports
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        rx : IN STD_LOGIC;
        --output ports
		  rx_done : OUT STD_LOGIC := '1';
        dato : OUT STD_logic_vector(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE RxUart_a OF RxUart IS
    SIGNAL clk_960011 : STD_LOGIC;
BEGIN
    conta9600 : ENTITY work.conta GENERIC MAP (0, 325)PORT MAP(clk, '0', '1', clk_960011, OPEN);
    ut_r_uart : ENTITY work.R_uart PORT MAP(rx,reset,clk_960011,rx_done,dato);

END RxUart_a;