-- Codigo de la ingeniera.
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R_uart is port (
    clk   : in std_logic;
    reset : in std_logic;

    rx : in std_logic;

    rx_done : out std_logic;
    dato    : out std_logic_vector(7 downto 0) := x"00"
);
end entity;

architecture a_R_uart of R_uart is

    type mef is (idle, start, data, stop);

    signal estado : mef;
    signal temp   : std_logic_vector(7 downto 0) := x"00";
    signal n      : natural range 0 to 7;
    signal cnt    : natural range 0 to 15;

begin

    process (clk, reset, rx) is

    begin
        if (reset = '0') then
            estado  <= idle;
            rx_done <= '0';

        elsif rising_edge (clk) then
            case estado is
                when idle =>
                    if rx = '0' then
                        estado <= start;
                        cnt    <= 0;
                    else
                        estado  <= idle;
                        rx_done <= '0';
                    end if;

                when start =>
                    if (cnt = 7) then
                        estado <= data;
                        cnt    <= 0;
                        n      <= 0;
                    else
                        estado <= start;
                        cnt    <= cnt + 1;
                    end if;

                when data =>
                    if cnt = 15 then
                        if (n = 7) then
                            estado <= stop;
                        else
                            estado <= data;
                            n      <= n + 1;
                        end if;
                        cnt      <= 0;
                        temp (n) <= rx;
                    else
                        estado <= data;
                        cnt    <= cnt + 1;
                    end if;

                when stop =>
                    if cnt = 15 then
                        estado  <= idle;
                        rx_done <= '1';
                        dato    <= temp;
                    else
                        estado <= stop;
                        cnt    <= cnt + 1;
                    end if;
            end case;
        end if;
    end process;

end architecture;