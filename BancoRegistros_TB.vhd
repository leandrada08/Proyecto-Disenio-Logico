library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoRegistros_TB is
end entity BancoRegistros_TB;

architecture tb_arch of BancoRegistros_TB is
    -- Component declaration
    component BancoRegistros is
        port (
            clk: in std_logic;
            reset: in std_logic;
            triState: in std_logic;
            data_in: in std_logic_vector(31 downto 0);
            read_enable: in std_logic;
            write_enable: in std_logic;
            address: in std_logic_vector(2 downto 0);
            data_out: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signal declarations
    signal clks: std_logic := '0';
    signal resets: std_logic := '0';
    signal triStates: std_logic := '0';
    signal data_ins: std_logic_vector(31 downto 0) := (others => '0');
    signal read_enables: std_logic := '0';
    signal write_enables: std_logic := '0';
    signal addresss: std_logic_vector(2 downto 0) := "000";
    signal data_outs: std_logic_vector(31 downto 0);

begin
    -- Component instantiation
    dut: BancoRegistros
        port map (
            clk => clks,
            reset => resets,
            triState => triStates,
            data_in => data_ins,
            read_enable => read_enables,
            write_enable => write_enables,
            address => addresss,
            data_out => data_outs
        );


    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        resets <= '0';
        wait for 10 ns;
        resets <= '1';
		  
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
        clks <= '1';
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;

        -- Write data to registers
        data_ins <= "00000000000000000000000000000001"; -- Data to be written
        write_enables <= '1'; -- Enable write
        addresss <= "000"; -- Address of the register to write
		  wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
        clks <= '1';
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
		  
		  data_ins <= "10000000000000000000000000000001"; -- Data to be written
        write_enables <= '1'; -- Enable write
        addresss <= "111"; -- Addre
		  wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
        clks <= '1';
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;

		  assert data_outs = (others => 'Z') report "32bits output mal" severity error;
		  
		  
		  
		  
        -- Read data from registers
        read_enables <= '1'; -- Enable read
        addresss <= "000"; -- Address of the register to read
		  triStates <= '1'; -- Enable tri-state
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
        clks <= '1';
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
		  assert data_outs = "00000000000000000000000000000001" report "output mal" severity error;
		  
		  wait for 10 ns;
		  read_enables <= '0';
		  triStates <= '0';
		  wait for 10 ns;
		  
		  read_enables <= '1'; -- Enable read
        addresss <= "111"; -- Address of the register to read
		  triStates <= '1'; -- Enable tri-state
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
        clks <= '1';
        wait for 10 ns;
		  clks <= '0';
        wait for 10 ns;
		  assert data_outs = "10000000000000000000000000000001" report "output mal" severity error;
	

        -- End simulation
        wait;
    end process;

end architecture tb_arch;
