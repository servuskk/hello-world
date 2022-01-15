library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.ALL;

entity Lab8_74HC595 is
--从实验一复制来的
	port
	(

		clk: in std_logic;

		I_1: in std_logic_vector(7 downto 0);
		I_2: in std_logic_vector(7 downto 0);
		I_3: in std_logic_vector(7 downto 0);
		I_4: in std_logic_vector(7 downto 0);
		I_5: in std_logic_vector(7 downto 0);
		I_6: in std_logic_vector(7 downto 0);

		sck: out std_logic;					
		rck: out std_logic;						
		din: out std_logic := '0' 			
	);
end;

architecture arch of Lab8_74HC595 is

	type seg_state is (S_IN, S_WRITE, S_SHIFT, S_OUT);
	signal next_state: seg_state := s_in;				
	signal input_array: std_logic_vector(15 downto 0);	
	signal IN_cnt: integer range 0 to 7 := 0;		
	signal Shift_cnt: integer range 0 to 16 := 0;			
	constant f_cnt: integer := 60000; 					
	signal clk_cnt: std_logic_vector(15 downto 0);
	signal clk_div: std_logic;
	
begin
	----------------------------------------------------------
	--					200Hz
	----------------------------------------------------------
	process(clk)
	begin
	   if (rising_edge(clk)) then
	      if clk_cnt = f_cnt then
			clk_cnt <= "0000000000000000";
			clk_div<=not clk_div;
	     else
	         clk_cnt <= clk_cnt+1;
	      end if;
	   end if;
	end process;
	-----------------------------------------------------------
	--					74HC595
	-----------------------------------------------------------
	process(clk_div)
	begin
		if (rising_edge(clk)) then
			case(next_state) is
				when s_in =>
					case(in_cnt) is
						when 0 =>
							in_cnt<=in_cnt+1;
							input_array<="01111100"&I_1;
							next_state<=S_write;
						when 1 =>
							in_cnt<=in_cnt+1;
							input_array<="10111100"&I_2;
							next_state<=S_write;
						when 2 =>
							in_cnt<=in_cnt+1;
							input_array<="11011100"&I_3;
							next_state<=S_write;
						when 3 =>
							in_cnt<=in_cnt+1;
							input_array<="11101100"&I_4;
							next_state<=S_write;
						when 4 =>
							in_cnt<=in_cnt+1;
							input_array<="11110100"&I_5;
							next_state<=S_write;
						when 5 =>
							in_cnt<=in_cnt+1;
							input_array<="11111000"&I_6;
							next_state<=S_write;
						when others => 
							in_cnt<=0;
					end case;
				when s_write =>
					sck<='0';
					din<=input_array(0);
					shift_cnt<=shift_cnt+1;
					next_state<=s_shift;
				when s_shift =>
					sck<='1';
					if (shift_cnt =16) then
						shift_cnt<=0;
						rck<='0';
						next_state<=s_out;
					else 
						input_array<= input_array(0) & input_array(15 downto 1);
						next_state<=s_write;
					end if;
				when s_out =>
					rck<='1';
					next_state<=s_in;
			end case;
		end if;
	end process;
	
end arch;