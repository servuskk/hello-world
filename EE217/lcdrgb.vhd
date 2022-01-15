library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity lcdrgb is

	port
	(
		clk_in: in std_logic;
        ram_lcd_data1: in std_logic_vector(179 downto 0);
        ram_lcd_data2: in std_logic_vector(179 downto 0);
		ram_lcd_data3: in std_logic_vector(179 downto 0);
		ram_lcd_data4: in std_logic_vector(179 downto 0);
		ram_lcd_data5: in std_logic_vector(179 downto 0);
		ram_lcd_data6: in std_logic_vector(179 downto 0);
        lcd_bl_out: out std_logic:='1'; 					--ST7735S BL
		lcd_clk_out: out std_logic:='0'; 					--ST7735S SCL
		lcd_data_out: out std_logic; 						--ST7735S SDA
        lcd_dc_out: out std_logic; 							--ST7735S D/C
        lcd_rst_n_out: out std_logic:='0' 					--ST7735S RES

	);
end;

architecture arch of lcdrgb is

	
	type lcd_state_enum is (INIT,WIN,SHOW,WTIRE_C,WTIRE_D,SHIFT_C,SHIFT_D,RES);	--INIT window display writecommand writedata shiftcommand shiftdata reset
    constant delay_1ms: integer := 12000;
    constant delay_10ms: integer := 120000;
    constant delay_120ms: integer := 1440000;

    signal ldc_num_1: std_logic_vector(0 to 179);
    signal ldc_num_2: std_logic_vector(0 to 179);
    signal ldc_num_3: std_logic_vector(0 to 179);
    signal ldc_num_4: std_logic_vector(0 to 179);
    signal ldc_num_5: std_logic_vector(0 to 179);
    signal ldc_num_6: std_logic_vector(0 to 179);

    signal command: std_logic_vector(7 downto 0);
    signal data: std_logic_vector(7 downto 0);
    signal lcd_state: lcd_state_enum :=INIT;
    signal lcd_state_next: lcd_state_enum := INIT;
	
begin

    lcd_bl_out <= '1';
	
	
    process(clk_in)
    
        variable counter_1ms: integer range 0 to  delay_1ms :=0;
        variable counter_10ms: integer range 0 to  delay_10ms :=0;
        variable counter_120ms: integer range 0 to  delay_120ms :=0;
        variable counter_shift: integer range 0 to 8 :=0;

        variable command_sequence: integer :=0;
        variable data_sequence: integer :=0;
        variable ldc_num_1_sequence: integer :=0;
        variable ldc_num_2_sequence: integer :=0;
        variable ldc_num_3_sequence: integer :=0;
        variable ldc_num_4_sequence: integer :=0;
        variable ldc_num_5_sequence: integer :=0;
        variable ldc_num_6_sequence: integer :=0;

        variable test_width: integer:=0;
        variable test_height: integer:=0;

        variable flag_sleep: std_logic :='0';
    begin
         
        if rising_edge(clk_in) then

            case(lcd_state_next) is

                when INIT =>

                    lcd_state <= INIT;
                    if flag_sleep = '0' then
                        case(command_sequence) is
                            when 0 =>
                                lcd_rst_n_out <= '1';
                                if counter_10ms /= delay_10ms then
                                    counter_10ms := counter_10ms + 1;
                                else 
                                    counter_10ms := 0;
                                    command_sequence := command_sequence + 1;
                                end if;
                            when 1 =>
                                lcd_rst_n_out <= '0';
                                if counter_120ms /= delay_120ms then
                                    counter_120ms := counter_120ms + 1;
                                else
                                    counter_120ms := 0;
                                    command_sequence := command_sequence + 1;
                                end if;
                            when 2 =>
                                lcd_rst_n_out <= '1';
                                if counter_10ms /= delay_10ms then
                                    counter_10ms := counter_10ms + 1;
                                else 
                                    counter_10ms := 0;
                                    command_sequence := command_sequence + 1;
                                end if;
                            when 3 =>
                                command <= x"11";  --SLPOUT (11h): Sleep Out
                                flag_sleep := '1';
                                lcd_clk_out <= '0';
                                lcd_state_next <= WTIRE_C;
                                command_sequence := command_sequence + 1;
                            when others => command_sequence := 0;
                        end case;

                    else
                        if counter_120ms /= delay_120ms then
                            counter_120ms := counter_120ms + 1;
                        else
                            case(command_sequence) is
                                when 0 =>
                                    command <= x"b1";  --FRMCTR1 (B1h): Frame Rate Control (In normal mode/ Full colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"05";lcd_state_next <= WTIRE_D;data_sequence := 2;--RTNA=5  
                                        when 2 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 3;--EFPA=60
                                        when 3 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 4;--BPA=60
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 1 =>
                                    command <= x"b2";    --FRMCTR2 (B2h): Frame Rate Control (In Idle mode/ 8-colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"05";lcd_state_next <= WTIRE_D;data_sequence := 2;--RTNA=5  
                                        when 2 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 3;--EFPA=60
                                        when 3 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 4;--BPA=60
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 2 =>
                                    command <= x"b3";    --FRMCTR3 (B3h): Frame Rate Control (In Partial mode/ full colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"05";lcd_state_next <= WTIRE_D;data_sequence := 2;--RTNA=5  
                                        when 2 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 3;--EFPA=60
                                        when 3 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 4;--BPA=60
                                        when 4 => data <= x"05";lcd_state_next <= WTIRE_D;data_sequence := 5;--RTNA=5  
                                        when 5 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 6;--EFPA=60
                                        when 6 => data <= x"3c";lcd_state_next <= WTIRE_D;data_sequence := 7;--BPA=60
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 3 =>
                                    command <= x"b4";    --Dot inversion //INVCTR (B4h): Display Inversion Control
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"03";lcd_state_next <= WTIRE_D;data_sequence := 2;--00000011 full Colors normal mode:Dot Inversion   
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 4 =>
                                    command <= x"c0";  --PWCTR1 (C0h): Power Control 1
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"28";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when 2 => data <= x"08";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when 3 => data <= x"04";lcd_state_next <= WTIRE_D;data_sequence := 4;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 5 =>
                                    command <= x"c1";   --PWCTR2 (C1h): Power Control 2
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"c0";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 6 =>
                                    command <= x"c2";   --PWCTR3 (C2h): Power Control 3 (in Normal mode/ Full colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"0d";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 7 =>
                                    command <= x"c3";   --PWCTR4 (C3h): Power Control 4 (in Idle mode/ 8-colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"8d";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when 2 => data <= x"2a";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 8 =>
                                    command <= x"c4";   --PWCTR5 (C4h): Power Control 5 (in Partial mode/ full-colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"8d";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when 2 => data <= x"ee";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 9 =>
                                    command <= x"c5";   --PWCTR5 (C4h): Power Control 5 (in Partial mode/ full-colors)
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"18";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 10 =>
                                    command <= x"36";   --VMCTR1 (C5h): VCOM Control 1 
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"c0";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 11 =>
                                    command <= x"e0";   --GMCTRP1 (E0h): Gamma (�’polarity) Correction Characteristics Setting
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"04";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"22";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when 3 => data <= x"07";lcd_state_next <= WTIRE_D;data_sequence := 4;
                                        when 4 => data <= x"0a";lcd_state_next <= WTIRE_D;data_sequence := 5; 
                                        when 5 => data <= x"2e";lcd_state_next <= WTIRE_D;data_sequence := 6;
                                        when 6 => data <= x"30";lcd_state_next <= WTIRE_D;data_sequence := 7;
                                        when 7 => data <= x"25";lcd_state_next <= WTIRE_D;data_sequence := 8;
                                        when 8 => data <= x"2a";lcd_state_next <= WTIRE_D;data_sequence := 9;
                                        when 9 => data <= x"28";lcd_state_next <= WTIRE_D;data_sequence := 10;
                                        when 10 => data <= x"26";lcd_state_next <= WTIRE_D;data_sequence := 11;
                                        when 11 => data <= x"2e";lcd_state_next <= WTIRE_D;data_sequence := 12;
                                        when 12 => data <= x"3a";lcd_state_next <= WTIRE_D;data_sequence := 13;
                                        when 13 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 14;
                                        when 14 => data <= x"01";lcd_state_next <= WTIRE_D;data_sequence := 15;
                                        when 15 => data <= x"03";lcd_state_next <= WTIRE_D;data_sequence := 16;
                                        when 16 => data <= x"13";lcd_state_next <= WTIRE_D;data_sequence := 17;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 12 =>
                                    command <= x"e1";   --GMCTRN1 (E1h): Gamma 
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"04";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"16";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when 3 => data <= x"06";lcd_state_next <= WTIRE_D;data_sequence := 4;
                                        when 4 => data <= x"0d";lcd_state_next <= WTIRE_D;data_sequence := 5; 
                                        when 5 => data <= x"2d";lcd_state_next <= WTIRE_D;data_sequence := 6;
                                        when 6 => data <= x"26";lcd_state_next <= WTIRE_D;data_sequence := 7;
                                        when 7 => data <= x"23";lcd_state_next <= WTIRE_D;data_sequence := 8;
                                        when 8 => data <= x"27";lcd_state_next <= WTIRE_D;data_sequence := 9;
                                        when 9 => data <= x"27";lcd_state_next <= WTIRE_D;data_sequence := 10;
                                        when 10 => data <= x"25";lcd_state_next <= WTIRE_D;data_sequence := 11;
                                        when 11 => data <= x"2d";lcd_state_next <= WTIRE_D;data_sequence := 12;
                                        when 12 => data <= x"3b";lcd_state_next <= WTIRE_D;data_sequence := 13;
                                        when 13 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 14;
                                        when 14 => data <= x"01";lcd_state_next <= WTIRE_D;data_sequence := 15;
                                        when 15 => data <= x"04";lcd_state_next <= WTIRE_D;data_sequence := 16;
                                        when 16 => data <= x"13";lcd_state_next <= WTIRE_D;data_sequence := 17;
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 13 =>
                                    command <= x"3a";   --COLMOD (3Ah): Interface Pixel Format
                                    lcd_state_next <= WTIRE_C;
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"05";lcd_state_next <= WTIRE_D;data_sequence := 2;  
                                        when others => command_sequence := command_sequence + 1;data_sequence := 0;
                                    end case;
                                when 14 =>
                                    command <= x"29";   --DISPON (29h): Display On
                                    lcd_state_next <= WTIRE_C;
                                    command_sequence := command_sequence + 1;
                                when others => command_sequence := 0;lcd_state_next <= SHOW;
                            end case;
                        end if;

                    end if;

                when SHOW =>

                    lcd_state <= SHOW;
                    
                    case(command_sequence) is
                        when 0 =>
                            command <= x"2a";   --CASET (2Ah): Column Address Set
                            lcd_state_next <= WTIRE_C;
                            case(data_sequence) is
                                when 0 => data_sequence := 1;
                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                when 2 => data <= x"02";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                when 3 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 4;
                                when 4 => data <= x"81";lcd_state_next <= WTIRE_D;data_sequence := 5; 
                                when others => command_sequence := command_sequence + 1;data_sequence := 0;
                            end case;
                        when 1 =>
                            command <= x"2b";   --RASET (2Bh): Row Address Set
                            lcd_state_next <= WTIRE_C;
                            case(data_sequence) is
                                when 0 => data_sequence := 1;
                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                when 2 => data <= x"01";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                when 3 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 4;
                                when 4 => data <= x"a0";lcd_state_next <= WTIRE_D;data_sequence := 5;
                                when others => command_sequence := command_sequence + 1;data_sequence := 0;
                            end case;
                        when 2 =>
                            command <= x"2c";   --//RAMWR (2Ch): Memory Write
                            lcd_state_next <= WTIRE_C;
                            command_sequence := command_sequence + 1;
                        when 3 =>
                            if test_height < 20 then
                                if test_width /= 128 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                else 
                                    test_width := 0;
                                    test_height := test_height + 1;
                                end if;
                            elsif test_height < 35 then
                                if test_width < 24 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 36 then
                                    if ldc_num_1_sequence /= 180 then
                                        if ldc_num_1(ldc_num_1_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_1_sequence := ldc_num_1_sequence + 1;
                                            end case;
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_1_sequence := ldc_num_1_sequence + 1;
                                            end case;
                                        end if;
                                    else
                                        ldc_num_1_sequence := 0;
                                    end if;
                                elsif test_width < 38 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 50 then
                                    if ldc_num_2_sequence /= 180 then
                                        if ldc_num_2(ldc_num_2_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_2_sequence := ldc_num_2_sequence + 1;
                                            end case;                                            
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_2_sequence := ldc_num_2_sequence + 1;
                                            end case;
                                        end if;
                                    else
                                        ldc_num_2_sequence := 0;
                                    end if;
                                elsif test_width < 52 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 64 then
                                    if ldc_num_3_sequence /= 180 then
                                        if ldc_num_3(ldc_num_3_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_3_sequence := ldc_num_3_sequence + 1;
                                            end case;                                            
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_3_sequence := ldc_num_3_sequence + 1;
                                            end case;                                            
                                        end if;
                                    else
                                        ldc_num_3_sequence := 0;
                                    end if;
                                elsif test_width < 66 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 78 then
                                    if ldc_num_4_sequence /= 180 then
                                        if ldc_num_4(ldc_num_4_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_4_sequence := ldc_num_4_sequence + 1;
                                            end case;                                            
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_4_sequence := ldc_num_4_sequence + 1;
                                            end case;                                            
                                        end if;
                                    else
                                        ldc_num_4_sequence := 0;
                                    end if;
                                elsif test_width < 80 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 92 then
                                    if ldc_num_5_sequence /= 180 then
                                        if ldc_num_5(ldc_num_5_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_5_sequence := ldc_num_5_sequence + 1;
                                            end case;                                            
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_5_sequence := ldc_num_5_sequence + 1;
                                            end case;                                            
                                        end if;
                                    else
                                        ldc_num_5_sequence := 0;
                                    end if;
                                elsif test_width < 94 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                elsif test_width < 106 then
                                    if ldc_num_6_sequence /= 180 then
                                        if ldc_num_6(ldc_num_6_sequence) = '0' then
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_6_sequence := ldc_num_6_sequence + 1;
                                            end case;                                            
                                        else
                                            case(data_sequence) is
                                                when 0 => data_sequence := 1;
                                                when 1 => data <= x"ff";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                                when 2 => data <= x"e0";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                                when others => test_width := test_width + 1;data_sequence := 0;ldc_num_6_sequence := ldc_num_6_sequence + 1;
                                            end case;                                            
                                        end if;
                                    else
                                        ldc_num_6_sequence := 0;
                                    end if;
                                elsif test_width < 128 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                else 
                                    test_width := 0;
                                    test_height := test_height + 1;
                                end if;
                            elsif test_height < 160 then
                                if test_width /= 128 then
                                    case(data_sequence) is
                                        when 0 => data_sequence := 1;
                                        when 1 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 2;
                                        when 2 => data <= x"00";lcd_state_next <= WTIRE_D;data_sequence := 3;
                                        when others => test_width := test_width + 1;data_sequence := 0;
                                    end case;
                                else 
                                    test_width := 0;
                                    test_height := test_height + 1;
                                end if;
                            else
                                command_sequence := command_sequence + 1;
                                test_height := 0;
                            end if;
                        when 4 => 
							ldc_num_1 <= ram_lcd_data1;
							ldc_num_2 <= ram_lcd_data2;
							ldc_num_3 <= ram_lcd_data3;
							ldc_num_4 <= ram_lcd_data4;
							ldc_num_5 <= ram_lcd_data5;
							ldc_num_6 <= ram_lcd_data6;
							command_sequence := command_sequence - 1;
                        when others => command_sequence := 0;
                            
                    end case;


                
                when WTIRE_C =>
                    lcd_dc_out <= '0';
                    if counter_shift = 8 then
                        lcd_clk_out <= '0';
                        counter_shift := 0;
                        lcd_state_next <= lcd_state;
                    else
                        lcd_state_next <= SHIFT_C;
                        lcd_clk_out <= '0';
                        lcd_data_out <= command(7);
                    end if;

                
                when WTIRE_D =>
                    lcd_dc_out <= '1';
                    if counter_shift = 8 then
                        lcd_clk_out <= '0';
                        counter_shift := 0;
                        lcd_state_next <= lcd_state;
                    else
                        lcd_state_next <= SHIFT_D;
                        lcd_clk_out <= '0';
                        lcd_data_out <= data(7);
                    end if;

                when SHIFT_C =>
                    lcd_clk_out <= '1';
                    command <= command(6 downto 0) & command(7);
                    counter_shift := counter_shift + 1;
                    lcd_state_next <= WTIRE_C;

                when SHIFT_D =>
                    lcd_clk_out <= '1';
                    data <= data(6 downto 0) & data(7);
                    counter_shift := counter_shift + 1;
                    lcd_state_next <= WTIRE_D;
                when others => null;

                end case;

        end if;
		
    end process;
	
end arch;