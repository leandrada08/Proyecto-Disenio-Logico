library ieee;
use ieee.std_logic_1164.all;

entity Register32bit is
    port (
        clk: in std_logic;
        reset: in std_logic;
		  triState: in std_logic;
        data_in: in std_logic_vector(31 downto 0);
        read_enable: in std_logic;
        write_enable: in std_logic;
        data_out: out std_logic_vector(31 downto 0)
    );
end entity Register32bit;

architecture Register32bit_a of Register32bit is
    signal reg: std_logic_vector(31 downto 0);
begin
    process (clk,reset)
    begin
		if reset = '0' then
			-- Reset value
			reg <= (others => '0');
        elsif rising_edge(clk) then
			if write_enable = '1' then
				reg <= data_in;
			end if;
        end if;
    end process;
	 
	 process(clk, triState, read_enable)
	 begin
		if rising_edge(clk) then
			if(read_enable='1' and triState='1') then
				data_out<= reg;
			else
				data_out<=(others=>'Z');
			end if;
		end if;
	 end process;
	 
end architecture Register32bit_a;

