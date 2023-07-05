library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCD_Disp is
port( LCD_DataIn  : IN  STD_LOGIC_VECTOR(12 downto 0);
		Clk      	 : IN  STD_LOGIC := '0';
		LCD_DataOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		LCD_E     	: OUT STD_LOGIC;	
      LCD_RS   	 : OUT STD_LOGIC);
end entity;


architecture LCD_Disp_arc of LCD_Disp is

Type arrayData is array (0 to 12) of STD_LOGIC_VECTOR(7 downto 0);

signal Datas: arrayData;
signal TempVal   : INTEGER := 1;
signal TempVal_1 : INTEGER range 0 to 9:= 1;
signal TempVal_2 : INTEGER range 0 to 9:= 1;
signal TempVal_3 : INTEGER range 0 to 9:= 1;
signal TempVal_4 : INTEGER range 0 to 9:= 1;
signal TempVal_signal : std_logic;
begin

--Commands--

Datas(0)  <= X"38";
Datas(1)  <= X"0c";
Datas(2)  <= X"06";
Datas(3)  <= X"80";

--Datas--

Datas(4)  <= x"52";  --R
Datas(5)  <= x"73";  --s
Datas(6)  <= x"3D";	--=
Datas(7)  <= x"20";	-- ESPACIO


TempVal   <= (to_integer(UNSIGNED(LCD_DataIn)));    -- FORMULA PARA LA CONVERSION 
TempVal_1 <= (TempVal) mod 10;         -- UNIDAD
TempVal_2 <= (TempVal/10) mod 10;		-- DECIMA 
TempVal_3 <= (TempVal/100) mod 10;		-- CENTESIMA
TempVal_4 <= (TempVal/1000)mod 10;		-- MILESIMA
TempVal_signal <= LCD_DataIn(12);



with (TempVal_1) select
Datas(12) <=  x"30" when 0,
              x"31" when 1,
				  x"32" when 2,
				  x"33" when 3,
				  x"34" when 4,
				  x"35" when 5,
				  x"36" when 6,
				  x"37" when 7,
				  x"38" when 8,
				  x"39" when 9,
				  x"30" when others;



with (TempVal_2) select
Datas(11) <=  x"30" when 0,
              x"31" when 1,
				  x"32" when 2,
				  x"33" when 3,
				  x"34" when 4,
				  x"35" when 5,
				  x"36" when 6,
				  x"37" when 7,
				  x"38" when 8,
				  x"39" when 9,
				  x"30" when others;


with (TempVal_3) select
Datas(10) <=  x"30" when 0,
              x"31" when 1,
				  x"32" when 2,
				  x"33" when 3,
				  x"34" when 4,
				  x"35" when 5,
				  x"36" when 6,
				  x"37" when 7,
				  x"38" when 8,
				  x"39" when 9,
				  x"30" when others;

with (TempVal_4) select
Datas(9) <=  x"30" when 0,
              x"31" when 1,
				  x"32" when 2,
				  x"33" when 3,
				  x"34" when 4,
				  x"35" when 5,
				  x"36" when 6,
				  x"37" when 7,
				  x"38" when 8,
				  x"39" when 9,
				  x"30" when others;

				  
with (TempVal_Signal) select
Datas(8) <=  x"2B" when '0',
              x"2D" when '1',
				  x"30" when others;
		
		
	
LCD_proc: process(Clk)
       
       variable i : integer := 0;
       variable j : integer := 0;
      
   begin
       if (Clk'event and Clk = '1') then
          if(i <= 85000) then 
					i := i + 1; 
					LCD_E <= '1'; 
					if(j<=12) then
						LCD_DataOut <= DataS(j)(7 downto 0);
					else
						LCD_DataOut <= x"20";
					end if;
          elsif(i > 85000 and i < 160000) then i := i + 1; lcd_e <= '0';
          elsif(i = 160000) then j := j + 1; i := 0;
          end if;

	  if(j < 4) then LCD_RS <= '0';  						  -- Command Signal --
     elsif (j >= 4 and j < 32) then lcd_rs <= '1';   -- Data Signal -- 
     end if;

	  if(j = 32) then j := 0;                -- Repeat Data Display Routine --
          end if;
       end if;
   end process LCD_proc;

end LCD_Disp_arc;