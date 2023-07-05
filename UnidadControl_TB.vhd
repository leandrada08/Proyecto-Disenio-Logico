library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnidadControl_TB is
end entity UnidadControl_TB;

architecture Behavioral of UnidadControl_TB is
    -- Component declaration for the unit under test (UUT)
    component UnidadControl is
        port (
            enable : in std_logic;
            opcode : in std_logic_vector(3 downto 0);
            OpReg : in std_logic_vector(5 downto 0);
            clk : in std_logic;
            reset : in std_logic;
            ControlBusIN, ControlBusB, ControlBusBanco : out std_logic;
            WriteBanco, WriteOUT, WriteA, WriteB : out std_logic;
            ReadBanco, ReadA, ReadB : out std_logic;
            Addres : out std_logic_vector(2 downto 0)
        );
    end component;

    -- Signal declarations
    signal enable_sig : std_logic := '0';
    signal opcode_sig : std_logic_vector(3 downto 0) := (others => '0');
    signal OpReg_sig : std_logic_vector(5 downto 0) := (others => '0');
    signal clk_sig : std_logic := '0';
    signal reset_sig : std_logic := '0';
    signal ControlBusIN_sig, ControlBusB_sig, ControlBusBanco_sig : std_logic;
    signal WriteBanco_sig, WriteOUT_sig, WriteA_sig, WriteB_sig : std_logic;
    signal ReadBanco_sig, ReadA_sig, ReadB_sig : std_logic;
    signal Addres_sig : std_logic_vector(2 downto 0);

begin
    -- Instantiate the unit under test (UUT)
    uut : UnidadControl
        port map (
            enable => enable_sig,
            opcode => opcode_sig,
            OpReg => OpReg_sig,
            clk => clk_sig,
            reset => reset_sig,
            ControlBusIN => ControlBusIN_sig,
            ControlBusB => ControlBusB_sig,
            ControlBusBanco => ControlBusBanco_sig,
            WriteBanco => WriteBanco_sig,
            WriteOUT => WriteOUT_sig,
            WriteA => WriteA_sig,
            WriteB => WriteB_sig,
            ReadBanco => ReadBanco_sig,
            ReadA => ReadA_sig,
            ReadB => ReadB_sig,
            Addres => Addres_sig
        );

		

	
    -- Stimulus process
    stim_proc: process
    begin
		  reset_sig <= '0'; 
		  wait for 10 ns;
        reset_sig <= '1'; 
		  wait for 10 ns;
		  
		  
        -- Test case LOAD
		  opcode_sig <= "1000";
		  OpReg_sig <= "000001";
		  wait for 10 ns;
        enable_sig <= '1';
		  wait for 10 ns;
		  clk_sig <= '1';
        wait for 10 ns;
        clk_sig <= '0';
		  wait for 10 ns;
		  assert ControlBusIN_sig = '1' report "FalloControlBus1" severity error;
		  assert Addres_sig = "001" report "FalloRegistro1" severity error;
		  enable_sig<='0';
        clk_sig <= '0';
        wait for 10 ns;
        clk_sig <= '1';
        wait for 10 ns;
        clk_sig <= '0';
        wait for 10 ns;
       
		 
        -- Test case STORE
        opcode_sig <= "1001";
        OpReg_sig <= "000010";
		  wait for 10 ns;
		  enable_sig <= '1';
		  wait for 10 ns;
		  clk_sig <= '1';
        wait for 10 ns;
        clk_sig <= '0';
		  wait for 10 ns;
		  assert ControlBusBanco_sig= '1' report "FalloControlBus2" severity error;
		  assert Addres_sig = "010" report "FalloRegistro2" severity error;
		  enable_sig <= '0';
		  
		  
        clk_sig <= '0';
        wait for 10 ns;
        clk_sig <= '1';
        wait for 10 ns;
        clk_sig <= '0';
        wait for 10 ns;

        -- Test case ARI
				-- ARI1
        opcode_sig <= "0000";
        OpReg_sig <= "000010";
		  wait for 10 ns;
		  enable_sig <= '1';
		  wait for 10 ns;
		  clk_sig <= '1';
        wait for 10 ns;
        clk_sig <= '0';
		  wait for 10 ns;
		  
		  assert ControlBusBanco_sig= '1' report "FalloControlBus3" severity error;
		  assert Addres_sig = "010" report "FalloRegistro3" severity error;
		  
		  
		  wait for 10 ns;
        clk_sig <= '0';
        wait for 10 ns;
        clk_sig <= '1';
		  wait for 10 ns;
		  clk_sig <= '0';
        wait for 10 ns;
		  
				-- ARI21
		  assert ControlBusBanco_sig= '1' report "FalloControlBus4" severity error;
		  assert Addres_sig = "000" report "FalloRegistro4" severity error;
		  
		  

        wait for 10 ns;
        clk_sig <= '0';
        wait for 10 ns;
		  clk_sig <= '1';
		  wait for 10 ns;
		  clk_sig <= '0';
        wait for 10 ns;
		  
		  
				-- ARI3
		  assert ControlBusB_sig= '1' report "FalloControlBus5" severity error;
		  assert Addres_sig = "010" report "FalloRegistro5" severity error;
		  
		  wait for 10 ns;
		  
        wait;
    end process;

end architecture Behavioral;

