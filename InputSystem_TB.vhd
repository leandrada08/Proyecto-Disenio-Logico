library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InputSystem_TB is
end entity InputSystem_TB;

architecture tb_arch of InputSystem_TB is
    -- Component declaration for the DUT (Design Under Test)
    component InputSystem
        port (
            clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            rx_done: in std_logic;
            input_data: in std_logic_vector(7 downto 0);
            output_data_ALU: out std_logic_vector(1 downto 0);
            output_data_OpCode: out std_logic_vector(3 downto 0);
            output_data_Reg : out std_logic_vector(5 downto 0);
            output_data_32bits: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals for testbench stimulus
    signal tb_clk: std_logic := '0';
    signal tb_reset: std_logic := '1';
    signal tb_enable: std_logic;
    signal tb_rx_done: std_logic;
    signal tb_input_data: std_logic_vector(7 downto 0);

    -- Signals for capturing DUT outputs
    signal tb_output_data_ALU: std_logic_vector(1 downto 0);
    signal tb_output_data_OpCode: std_logic_vector(3 downto 0);
    signal tb_output_data_Reg: std_logic_vector(5 downto 0);
    signal tb_output_data_32bits: std_logic_vector(31 downto 0);

begin
    -- Instantiate the DUT
    dut: InputSystem
        port map (
            clk => tb_clk,
            reset => tb_reset,
            enable => tb_enable,
            rx_done => tb_rx_done,
            input_data => tb_input_data,
            output_data_ALU => tb_output_data_ALU,
            output_data_OpCode => tb_output_data_OpCode,
            output_data_Reg => tb_output_data_Reg,
            output_data_32bits => tb_output_data_32bits
        );


		  
	 
	 
    -- Stimulus process
    stimulus: process
    begin
		
		  tb_reset <= '0'; 
		  wait for 10 ns;
        tb_reset <= '1';
		  wait for 10 ns;
		  
        -- Initialize inputs
        tb_enable <= '0';
        tb_rx_done <= '0';
        tb_input_data <= (others => '0');

        -- Wait a few clock cycles
        wait for 10 ns;

        -- Generate stimulus
        tb_input_data <= "11111111"; -- First input value
		  wait for 10 ns;
        tb_rx_done <= '1';
		  wait for 10 ns;
		  tb_rx_done <= '0';
		  wait for 10 ns;
		  tb_input_data <= "00000000";
		  wait for 10 ns;
        tb_rx_done <= '1';
		  wait for 10 ns;
		  tb_rx_done <= '0';
		  wait for 10 ns;
		  
		  
		  assert tb_output_data_ALU = "11" report "ALU output mal" severity error;
        assert tb_output_data_OpCode = "1111" report "OpCode output mal" severity error;
        assert tb_output_data_Reg = "001111" report "Reg output mal" severity error;
        assert tb_output_data_32bits = "00000000000000000000000011111111" report "32bits output mal" severity error;
		  
		  
		  
		  tb_input_data <= "01010101";
		  wait for 10 ns;
        tb_rx_done <= '1';
		  wait for 10 ns;
		  tb_rx_done <= '0';
		  wait for 10 ns;
		  tb_input_data <= "00000000";
		  wait for 10 ns;
        tb_rx_done <= '1';
		  wait for 10 ns;
		  tb_rx_done <= '0';
		  wait for 10 ns;

        tb_enable <= '1'; -- enable data storage
        wait for 10 ns;
			
			-- Aqui debereriamos tener almacena el valor:
			-- 00000000 01010101 00000000 11111111
			-- ----Cte Imm -----|--Reg --|-OpCode-|
			--                                |ALU|
		  
        -- Check outputs
        assert tb_output_data_ALU = "11" report "ALU output mal" severity error;
        assert tb_output_data_OpCode = "11111111" report "OpCode output mal" severity error;
        assert tb_output_data_Reg = "00000000" report "Reg output mal" severity error;
        assert tb_output_data_32bits = "00000000000000000000000001010101" report "32bits output mal" severity error;
		  

        wait;
    end process;

end architecture tb_arch;
