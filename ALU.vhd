library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        ALUctl : in  std_logic_vector(1 downto 0);
        A      : in  std_logic_vector(31 downto 0);
        B      : in  std_logic_vector(31 downto 0);
        ALUOut : out std_logic_vector(31 downto 0);
        Zero   : out std_logic
    );
end entity ALU;

architecture ALU_a of ALU is
begin
    process (ALUctl, A, B)
    begin
        case ALUctl is
            when "00" =>
                ALUOut <= A and B;
            when "01" =>
                ALUOut <= A or B;
            when "10" =>
                ALUOut <=std_logic_vector(signed(A) + signed(B));
            when "11" =>
                ALUOut <=std_logic_vector(signed(A) - signed(B));
            when others =>
                ALUOut <= (others => '0');
        end case;

        Zero <= '1';
    end process;
end architecture ALU_a;