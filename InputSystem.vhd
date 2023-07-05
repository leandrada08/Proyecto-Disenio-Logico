library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InputSystem is
    port (
        clk: in std_logic;
        reset: in std_logic;
        enable: in std_logic;
		  rx_done: in std_logic;
        input_data: in std_logic_vector(7 downto 0);
        output_data_ALU: out std_logic_vector(1 downto 0);
        --output_data_OpCode: out std_logic_vector(3 downto 0);
		  output_data_Reg : out std_logic_vector(5 downto 0);
        output_data_32bits: out std_logic_vector(31 downto 0)
    );
end entity InputSystem;

architecture InputSystem_a of InputSystem is
    signal register_data: std_logic_vector(15 downto 0):="0000000000000000"; --Nuevo
    signal state: integer range 0 to 1 := 0;
begin

	 output_data_ALU <= register_data(1 downto 0);
    --output_data_OpCode <= register_data(3 downto 0);
    output_data_Reg <= register_data(9 downto 4);
	 
    process (reset, rx_done)
    begin
		if reset = '0' then
			-- Reset values
			register_data <= "0000000000000000";
            state <= 0;
        elsif rx_done='1' then
				-- State machine
            case state is
                when 0 =>
                    register_data(7 downto 0) <= input_data;
                    state <= 1;
                when 1 =>
                    register_data(15 downto 8) <= input_data;
                    state <= 0;
            end case;
        end if;
    end process;
    

	 
    process (enable, register_data, clk)
    begin
        if enable = '1' then
            output_data_32bits(7 downto 0) <= register_data(7 downto 0);
	        output_data_32bits(31 downto 8) <=(others => '0');
        else
            output_data_32bits <= (others => 'Z');
        end if;
    end process;
    
end architecture InputSystem_a ;


