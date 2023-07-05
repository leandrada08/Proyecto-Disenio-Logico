library ieee;
use ieee.std_logic_1164.all;

entity SieteSegmentoDisplay is
    port (
        input_vector : in std_logic_vector(3 downto 0);
        output_vector : out std_logic_vector(6 downto 0)
    );
end entity SieteSegmentoDisplay;

architecture SieteSegmentoDisplay_a of SieteSegmentoDisplay  is
begin
    process(input_vector)
    begin
        case input_vector is
            when "0000" =>
                output_vector <= not("1000000"); -- '0'
            when "0001" =>
                output_vector <= not("1111001"); -- '1'
            when "0010" =>
                output_vector <= not("0100100"); -- '2'
            when "0011" =>
                output_vector <= not("0110000"); -- '3'
            when "0100" =>
                output_vector <= not("0011001"); -- '4'
            when "0101" =>
                output_vector <= not("0010010"); -- '5'
            when "0110" =>
                output_vector <= not("0000010"); -- '6'
            when "0111" =>
                output_vector <= not("1111000"); -- '7'
            when "1000" =>
                output_vector <= not("0000000"); -- '8'
            when "1001" =>
                output_vector <= not("0010000"); -- '9'
            when others =>
                output_vector <= not("1111111"); -- Invalid input, display '-'
        end case;
    end process;
end architecture SieteSegmentoDisplay_a;