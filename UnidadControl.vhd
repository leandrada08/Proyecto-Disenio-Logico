library ieee;
use ieee.std_logic_1164.all;

entity UnidadControl is
    port (
        enable : in std_logic;
        opcode : in std_logic_vector(3 downto 0);
		OpReg: in std_logic_vector(5 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        ControlBusIN, ControlBusB, ControlBusBanco : out std_logic;
		WriteBanco, WriteOUT, WriteA, WriteB : out std_logic;
		ReadBanco, ReadA, ReadB : out std_logic;
        Segmentos : out std_logic_vector(3 downto 0):="0000";
		Addres : out std_logic_vector(2 downto 0)
    );
end entity UnidadControl;

architecture UnidadControl_a of UnidadControl is
    type StateType is (Stop, Load, Store, Ari1, Ari21, Ari22, Ari3);
    signal currentState, nextState : StateType;
    
begin
    process (clk, reset)
    begin
        if reset = '0' then
            currentState <= Stop;
        elsif rising_edge(clk) then
            currentState <= nextState;
        end if;
    end process;
    
    process (currentState, enable, opcode,clk,OpReg)
    begin
        case currentState is
            when Stop =>
                ControlBusIN <= '0';
                ControlBusB <= '0';
                ControlBusBanco <= '0';
                WriteBanco <= '0';
                WriteOUT <= '0';
                WriteA <= '0';
                WriteB <= '0';
                ReadBanco <= '0';
					 Segmentos <="0000";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= "000";
                
                if enable = '0' then
                    if opcode = "1001" then
                        nextState <= Store;
                    elsif opcode = "1111" then
                        nextState <= Load;
                    elsif opcode(3) = '0' then
                        nextState <= Ari1;
                    else
                        nextState <= Stop;
                    end if;
                else
                    nextState <= Stop;
                end if;
                
            when Load =>
                ControlBusIN <= '1';
                ControlBusB <= '0';
                ControlBusBanco <= '0';
                WriteBanco <= '1';
                WriteOUT <= '0';
                WriteA <= '0';
                WriteB <= '0';
                ReadBanco <= '0';
                Segmentos <="0001";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= OpReg(2 downto 0);
                nextState <= Stop;
                
            when Store =>
                ControlBusIN <= '0';
                ControlBusB <= '0';
                ControlBusBanco <= '1';
                WriteBanco <= '0';
                WriteOUT <= '1';
                WriteA <= '0';
                WriteB <= '0';
                ReadBanco <= '1';
                Segmentos <="0010";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= OpReg(2 downto 0);
                nextState <= Stop;
                
            when Ari1 =>
                ControlBusIN <= '0';
                ControlBusB <= '0';
                ControlBusBanco <= '1';
                WriteBanco <= '0';
                WriteOUT <= '0';
                WriteA <= '1';
                WriteB <= '0';
                ReadBanco <= '1';
					 Segmentos <="0011";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= OpReg(2 downto 0);
                
                if opcode(2) = '1' then
                    nextState <= Ari22;
                else
                    nextState <= Ari21;
                end if;
                
            when Ari22 =>
                ControlBusIN <= '1';
                ControlBusB <= '0';
                ControlBusBanco <= '0';
                WriteBanco <= '0';
                WriteOUT <= '0';
                WriteA <= '0';
                WriteB <= '1';
                ReadBanco <= '0';
                Segmentos <="0100";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= "000";
                nextState <= Ari3;
                
            when Ari21 =>
                ControlBusIN <= '0';
                ControlBusB <= '0';
                ControlBusBanco <= '1';
                WriteBanco <= '0';
                WriteOUT <= '0';
                WriteA <= '0';
                WriteB <= '1';
                ReadBanco <= '1';
                Segmentos <="0101";
                ReadA <= '0';
                ReadB <= '0';
                Addres <= OpReg(5 downto 3);
                nextState <= Ari3;
                
            when Ari3 =>
                ControlBusIN <= '0';
                ControlBusB <= '1';
                ControlBusBanco <= '0';
                WriteBanco <= '1';
                WriteOUT <= '0';
					 Segmentos <="0110";
                WriteA <= '0';
                WriteB <= '0';
                ReadBanco <= '0';
                ReadA <= '0';
                ReadB <= '1';
                Addres <= OpReg(2 downto 0);
                nextState <= Stop;
        end case;
    end process;
    
end architecture UnidadControl_a;
