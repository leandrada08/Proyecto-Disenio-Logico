library ieee;
use ieee.std_logic_1164.all;

entity Register32bit_TB is
end entity Register32bit_TB;

architecture tb_arch of Register32bit_TB is
    -- Component declaration
    component Register32bit is
        port (
            clk: in std_logic;
            reset: in std_logic;
            triState: in std_logic;
            data_in: in std_logic_vector(31 downto 0);
            read_enable: in std_logic;
            write_enable: in std_logic;
            data_out: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signal declarations
    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    signal triState: std_logic := '0';
    signal data_in: std_logic_vector(31 downto 0) := (others => '0');
    signal read_enable: std_logic := '0';
    signal write_enable: std_logic := '0';
    signal data_out: std_logic_vector(31 downto 0);

begin
    -- Component instantiation
    dut: Register32bit
        port map (
            clk => clk,
            reset => reset,
            triState => triState,
            data_in => data_in,
            read_enable => read_enable,
            write_enable => write_enable,
            data_out => data_out
        );

    -- Clock generation process
    clk_process: process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        reset <= '0';
        wait for 10 ns;
        reset <= '1';
        wait for 10 ns;

        -- Write data to register
        data_in <= "00000000000000000000000000000001"; -- Data to be written
        write_enable <= '1'; -- Enable write
        wait for 10 ns;
		  write_enable <= '0';
		  wait for 10 ns;
        -- Read data from register
        read_enable <= '1'; -- Enable read
		  triState <= '1'; -- Enable tri-state
        wait for 10 ns;
		  assert data_out = "00000000000000000000000000000001" report "output mal" severity error;
		  wait for 10 ns;
		  read_enable<='0';
		  write_enable<='1';
		  triState<='0';
		  
		  
		   -- Write data to register
        data_in <= "11000000000000000000000000000001"; -- Data to be written
        write_enable <= '1'; -- Enable write
        wait for 10 ns;
		  write_enable <= '0';
		  wait for 10 ns;
        -- Read data from register
        read_enable <= '1'; -- Enable read
		  triState <= '1'; -- Enable tri-state
        wait for 10 ns;
		  assert data_out = "11000000000000000000000000000001" report "output mal" severity error;



        -- End simulation
        wait;
    end process;

end architecture tb_arch;
