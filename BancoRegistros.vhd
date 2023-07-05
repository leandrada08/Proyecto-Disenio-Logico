library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoRegistros is
    port (
        clk: in std_logic;
        reset: in std_logic;
		  triState: in std_logic;
        data_in: in std_logic_vector(31 downto 0);
        read_enable: in std_logic;
        write_enable: in std_logic;
        addres: in std_logic_vector(2 downto 0);
        data_out: out std_logic_vector(31 downto 0)
    );
end entity BancoRegistros;

architecture BancoRegistros_a of BancoRegistros is
    --type Registere is array(31 downto 0) of std_logic;
    type RegisterArray is array(0 to 7) of std_logic_vector(31 downto 0);
    signal Regs: RegisterArray;
	 signal address : natural range 0 to 7;
begin
	address <= to_integer(unsigned(addres));
	
    process (clk, write_enable,reset)
    begin
		if reset = '0' then
			-- Reset values
			Regs <= (others => (others => '0'));
        elsif rising_edge(clk) then
			if write_enable = '1' then
				Regs(address) <= data_in;
			end if;
        end if;
    end process;
	 
	 process(clk, triState, read_enable)
	 begin
		if rising_edge(clk) then
			if(read_enable='1' and triState='1') then
				data_out<= regs(address);
			else
				data_out<=(others=>'Z');
			end if;
		end if;
	 end process;
	 
end architecture BancoRegistros_a;
