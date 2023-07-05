library ieee;
use ieee.std_logic_1164.all;

entity Antirebote is
    port (
        tecla_in  : in  std_logic;
        clk       : in  std_logic;
        tecla_out : out std_logic
    );
end Antirebote;

architecture a_Antirebote of Antirebote is
    signal tecla_prev : std_logic := '0';
    signal cnt        : integer range 0 to 20 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if tecla_in /= tecla_prev then
                cnt <= 0;
                tecla_prev <= tecla_in;
            elsif cnt < 20 then
                cnt <= cnt + 1;
            else
                tecla_out <= tecla_prev;
            end if;
        end if;
    end process;
end a_Antirebote;

