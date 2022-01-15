library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity lab8_top is

port(
		clk: in std_logic;
		
		lcd_bl_out: out std_logic:='1'; 	--ST7735S BL
		lcd_clk_out: out std_logic:='0';	--ST7735S SCL
		lcd_data_out: out std_logic; 		--ST7735S SDA
        lcd_dc_out: out std_logic; 			--ST7735S D/C
        lcd_rst_n_out: out std_logic:='0'; --ST7735S RES		

		rst_in:	 		in std_logic;
		scl_out:    	out std_logic;
		sda_inout:  	inout std_logic;
		flag_out:		out std_logic;
		ADC_data_out:	buffer std_logic_vector(7 downto 0);
		lab8_sck: 		out 	std_logic;	
		lab8_rck: 		out 	std_logic;	
		lab8_din: 		out 	std_logic; 
		disp_mod:		in      std_logic
	);
end;

architecture arch of lab8_top is
	component LAB8_I2C is
		port(
			clk:		in std_logic; 
			rst:		in std_logic;						
			scl:    	out std_logic;
			sda:	    inout std_logic;
			adc_flag:	out std_logic;
			ADC_data:	buffer std_logic_vector(7 downto 0) 
			);
	end component;

	component BCD is
		port(
			clk_bcd:		in std_logic; 
			rst_bcd:		in std_logic;
			data_inbcd:	in std_logic_vector(7 downto 0);  
			bcd_out:		buffer std_logic_vector(11 downto 0)
			);
	end component;

	component Lab8_74HC595 
	port(
		clk: 	in std_logic;				
		I_1: 	in std_logic_vector(7 downto 0);
		I_2: 	in std_logic_vector(7 downto 0);
		I_3: 	in std_logic_vector(7 downto 0);
		I_4: 	in std_logic_vector(7 downto 0);
		I_5: 	in std_logic_vector(7 downto 0);
		I_6: 	in std_logic_vector(7 downto 0);
		sck: 	out std_logic;					
		rck: 	out std_logic;						
		din: 	out std_logic := '0' 			
	);  
	end component;

	component LAB8_voltage
	port(
		clk_v:			in std_logic;						
		rst_v:	 		in std_logic;			
		FLAG:      		IN STD_LOGIC;
		lcdbcd:			buffer std_logic_vector(19 downto 0);
		vin:			in std_logic_vector(7 downto 0);
		bcdin:			in std_logic_vector(11 downto 0);
		out0:		    out std_logic_vector(7 downto 0);
    	out1:		    out std_logic_vector(7 downto 0);
		out2:			out std_logic_vector(7 downto 0);
		out3:			out std_logic_vector(7 downto 0);
		out4:			out std_logic_vector(7 downto 0);
		out5:			out std_logic_vector(7 downto 0)
	);
	end component;
	component lcdram
	port
	(
		clk_in: in std_logic;
		bcd_num: in std_logic_vector(19 downto 0);
		data1_out: out std_logic_vector(0 to 179);
		data2_out: out std_logic_vector(0 to 179);
		data3_out: out std_logic_vector(0 to 179);
		data4_out: out std_logic_vector(0 to 179);
		data5_out: out std_logic_vector(0 to 179);
		data6_out: out std_logic_vector(0 to 179)
	);
	end component;

	component lcdrgb
	port
	(
		clk_in: in std_logic;

		ram_lcd_data1: in std_logic_vector(0 to 179);
        ram_lcd_data2: in std_logic_vector(0 to 179);
		ram_lcd_data3: in std_logic_vector(0 to 179);
		ram_lcd_data4: in std_logic_vector(0 to 179);
		ram_lcd_data5: in std_logic_vector(0 to 179);
		ram_lcd_data6: in std_logic_vector(0 to 179);
        lcd_bl_out: out std_logic:='1'; 				--ST7735S BL
		lcd_clk_out: out std_logic:='0'; 				--ST7735S SCL
		lcd_data_out: out std_logic; 					--ST7735S SDA
        lcd_dc_out: out std_logic; 						--ST7735S D/C
        lcd_rst_n_out: out std_logic:='0' 				--ST7735S RES
	);
	end component;
	signal bcd_num: std_logic_vector(19 downto 0);
	signal data1_out: std_logic_vector(0 to 179);
	signal data2_out: std_logic_vector(0 to 179);
	signal data3_out: std_logic_vector(0 to 179);
	signal data4_out: std_logic_vector(0 to 179);
	signal data5_out: std_logic_vector(0 to 179);
	signal data6_out: std_logic_vector(0 to 179);

	signal clk_400k:std_logic;
	signal Segment_1: 	std_logic_vector(7 downto 0);
	signal Segment_2: 	std_logic_vector(7 downto 0);
	signal Segment_3: 	std_logic_vector(7 downto 0);
	signal Segment_4: 	std_logic_vector(7 downto 0);
	signal Segment_5: 	std_logic_vector(7 downto 0);
	signal Segment_6: 	std_logic_vector(7 downto 0);
	signal bcd_code:	std_logic_vector(11 downto 0);
	signal adc_code:	std_logic_vector(7 downto 0);
	signal num:		integer;
	signal adc_result:	integer;

begin
	
	process(clk)
		variable clk_cnt:integer := 0;
	begin
		if (rising_edge(clk)) then
				clk_cnt := clk_cnt+1;
		end if;
		if (clk_cnt < 30) then
			clk_400k <= '0';						
		else
			clk_400k <= '1';
			clk_cnt := 0;						
		end if;
	end process;
I2C: lab8_i2c port map
	(
		clk => clk,						
		rst => rst_in,						
		scl => scl_out,						
		sda => sda_inout,						
		adc_flag => flag_out,				
		ADC_data => ADC_data_out
	);

BINARY2BCD: bcd port map
	(
		clk_bcd => clk,						
		rst_bcd => rst_in,						
		data_inbcd => ADC_data_out,
		bcd_out => bcd_code
	);

HC595: Lab8_74HC595 port map  
	(  	
		clk => clk,
		I_1 => segment_1,
		I_2 => segment_2,
		I_3 => segment_3,
		I_4 => segment_4,
		I_5 => segment_5,
		I_6 => segment_6,	
		sck => Lab8_sck,
		rck => Lab8_rck,
		din => Lab8_din
	);

disp_mod2: LAB8_voltage port map
	(
		clk_v => clk,						
		rst_v => rst_in,						
		vin=>ADC_data_out,
		flag=>disp_mod,
		bcdin=>bcd_code,
		lcdbcd => bcd_num,
		out0 => segment_1,
		out1 => segment_2,
		out2 => segment_3,
		out3 => segment_4,
		out4 => segment_5,
		out5 => segment_6
	);

LCD1: lcdram
	port map
	(
		clk_in => clk,
		bcd_num => bcd_num,
		data1_out => data1_out,
		data2_out => data2_out,
		data3_out => data3_out,
		data4_out => data4_out,
		data5_out => data5_out,
		data6_out => data6_out
	);

LCD2: lcdrgb
	port map
	(
		clk_in => clk,
		ram_lcd_data1 => data1_out,
		ram_lcd_data2 => data2_out,
		ram_lcd_data3 => data3_out,
		ram_lcd_data4 => data4_out,
		ram_lcd_data5 => data5_out,
		ram_lcd_data6 => data6_out,
        lcd_bl_out => lcd_bl_out,
		lcd_clk_out => lcd_clk_out,
		lcd_data_out => lcd_data_out,
        lcd_dc_out => lcd_dc_out,
        lcd_rst_n_out => lcd_rst_n_out
	);

end arch;