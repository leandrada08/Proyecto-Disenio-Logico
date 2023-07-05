library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProyectoFinal is
    port (
        reset : in std_logic;
        clk : in std_logic;
        inputs : in std_logic;
        uart : in std_logic;
		  OpCode : in std_logic_vector(3 downto 0);
        lcd_data : out std_logic_vector(7 downto 0);
		  lcd_enable, lcd_rs : OUT STD_LOGIC;
		  lcd_rw : out std_LOGIC:='0';
		  segmOut : out std_logic_vector(6 downto 0);
		  display : out std_logic_vector(3 downto 0)
    );
end entity ProyectoFinal;

architecture ProyectoFinal_a of ProyectoFinal is
		-- Señales intermedia entre la unidad de control y el camino de datos
	 signal enableControlBusIN,enableControlBusB,enableControlBusBanco : std_logic;
	 signal enableReadA, enableWriteA, enableReadB, enableWriteB, enableReadBanco, enableWriteBanco, enableWriteOut : std_logic;
	 signal ALU_control : std_logic_vector(1 downto 0);
	 
		-- Señal intermedia para antirrebote de entrada 
	 signal input : std_logic;
	 
	 signal clks : std_logic;
	 
		-- Señal intermedia entre la unidad de control y el display de 7 segmeto
	 signal segmIn : std_logic_vector(3 downto 0);
	 
		-- Señales intermedia entre la entrada y la unidad de control
	 signal UART_8bit: std_logic_vector(7 downto 0);
	 signal CodeReg: std_logic_vector(5 downto 0);
	 --signal OpCode: std_logic_vector(3 downto 0);
    signal BUSCpu,LCDControl : std_logic_vector(31 downto 0);
	 signal ALU_A,ALU_B : std_logic_vector(31 downto 0);
	 signal addressBanco : std_logic_vector(2 downto 0);
	 
	 signal rx_done : std_logic;
	 
    
begin
	lcd_rw<='0';
	display<="1111";
	
	-- Entrada antirrebote
	Anti: entity work.Antirebote port map(inputs,clk,input);
	
	-- Receptor Uart
	ReceptorUart: entity work.RxUart port map(clk, reset, uart,rx_done,UART_8bit);
	
	-- Bloque InputSystem
	BloqueEntrada : entity work.InputSystem port map(clk,reset, enableControlBusIN, rx_done ,UART_8bit , ALU_control,CodeReg, BUSCpu);	
	
	
	-- Bloque Unidad de Control
	ContadorControl : entity work.conta generic map(0,25000000) port map(clk, '1','1',clks,open);
	UnidadControl1 : entity work.UnidadControl port map(input,OpCode,CodeReg, clks, reset, enableControlBusIN,
																		enableControlBusB, enableControlBusBanco, enableWriteBanco,
																		enableWriteOut, enableWriteA, enableWriteB, enableReadBanco, 
																		enableReadA, enableReadB, segmIn, addressBanco);
	

	
	-- Bloque de ALU
	ALUCpu : entity work.ALU port map(ALU_control, ALU_A, BUSCpu , ALU_B, open);
	-- Registro A: Entrada a ALU
	RegistroA: entity work.Register32bit port map(clk, reset, '1', BUSCpu, enableReadA, enableWriteA,ALU_A);
	-- Registro B: Salida a ALU
	RegistroB: entity work.Register32bit port map(clk, reset, enableControlBusB, ALU_B, enableReadB, enableWriteB, BUSCpu);
	
	-- Configuracion del Banco de registro
	BancoReg : entity work.BancoRegistros port map(clk,reset,enableControlBusBanco, BUSCpu, enableReadBanco, enableWriteBanco, addressBanco, BUSCpu);

		-- Registro Out: Salida del CPU
	RegistroOut: entity work.Register32bit port map(clk, reset, '1' , BUSCpu, '1' , enableWriteOut, LCDControl);
	
		-- Configuracion LCD salida
	LCDControl1: entity work.LCD_Disp port map(LCDControl(12 downto 0), clk, lcd_data,lcd_enable, lcd_rs);


		-- Display 7 segmento para corroborar el funcionamieto del micro
	Segmentos: entity work.SieteSegmentoDisplay port map(segmIn, segmOut);

	
end architecture ProyectoFinal_a;