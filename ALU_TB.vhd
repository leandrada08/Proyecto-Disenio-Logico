library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_TB is
end entity ALU_TB;

architecture tb_arch of ALU_TB is
    -- Component declaration
    component ALU is
        port (
            ALUctl : in  std_logic_vector(1 downto 0);
            A      : in  std_logic_vector(31 downto 0);
            B      : in  std_logic_vector(31 downto 0);
            ALUOut : out std_logic_vector(31 downto 0);
            Zero   : out std_logic
        );
    end component;

    -- Signal declarations
    signal ALUctl: std_logic_vector(1 downto 0) := "00";
    signal A: std_logic_vector(31 downto 0) := (others => '0');
    signal B: std_logic_vector(31 downto 0) := (others => '0');
    signal ALUOut: std_logic_vector(31 downto 0);
    signal Zero: std_logic;

begin
    -- Component instantiation
    dut: ALU
        port map (
            ALUctl => ALUctl,
            A => A,
            B => B,
            ALUOut => ALUOut,
            Zero => Zero
        );

    -- Stimulus process
    stimulus_process: process
    begin
        -- Test case 1: AND operation
        ALUctl <= "00"; -- AND operation
        A <= "00101010101010101010101010101010";
        B <= "01110000111100001111000011110000";
        wait for 10 ns;
		  assert (ALUOut= ("00101010101010101010101010101010" and "01110000111100001111000011110000")) report "32bits output mal 1" severity error;
		  wait for 10 ns;
		  
		  
        -- Test case 2: OR operation
        ALUctl <= "01"; -- OR operation
        wait for 10 ns;
		  assert (ALUOut= ("00101010101010101010101010101010" or "01110000111100001111000011110000")) report "32bits output mal 2" severity error;
		  wait for 10 ns;
			
        -- Test case 3: Addition operation
        ALUctl <= "10"; -- Addition operation
        wait for 10 ns;
		  assert (ALUOut = "10011011100110111001101110011010") report "32bits output mal 3" severity error;
		  wait for 10 ns;

        -- Test case 4: Subtraction operation
		  A <= "00000000000000000000000000000010";
        B <= "00000000000000000000000000000111";
        ALUctl <= "11"; -- Subtraction operation
        wait for 10 ns;
		  assert (ALUOut=  "11111111111111111111111111111011") report "32bits output mal 4" severity error;
		  wait for 10 ns;

        -- End simulation
        wait;
    end process;

end architecture tb_arch;
