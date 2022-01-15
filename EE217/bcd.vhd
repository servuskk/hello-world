library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity bcd is
--用于生成bcd码，这个的输出看起来用处不大
	port
	(
		clk_bcd: in std_logic;
		rst_bcd: in std_logic;
		data_inbcd:	in std_logic_vector(7 downto 0);
		bcd_out: buffer std_logic_vector(11 downto 0)--out会出现不可描述的错误。。
	);
end;

architecture behavior of bcd is

	signal adc_data_bcd: std_logic_vector(7 downto 0);
	signal clk_cnt: std_logic_vector(15 downto 0);
	signal clk_div: std_logic;
	constant f_cnt: integer := 60000; 

begin
	----------------------------------------------------------
	--					200Hz
	----------------------------------------------------------
	process(clk_bcd)
	begin
	   if (rising_edge(clk_bcd)) then
	      if clk_cnt = f_cnt then
			clk_cnt <= "0000000000000000";
			clk_div<=not clk_div;
	     else
	         clk_cnt <= clk_cnt+1;
	      end if;
	   end if;
	end process;

	process(clk_div)
		variable bcd_12bit: std_logic_vector(11 downto 0):="000000000000";--变量类型yyds
	begin

		adc_data_bcd<=not data_inbcd;
		bcd_12bit:="000000000"&adc_data_bcd(7 downto 5);
--移位加三算法！
		case bcd_12bit(3 downto 0) is
			when "0000"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0001"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0010"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0011"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0100"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when others =>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0)+3;
		end case;
		bcd_12bit:=bcd_12bit(10 downto 0)& adc_data_bcd(4);
		case bcd_12bit(3 downto 0) is
			when "0000"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0001"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0010"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0011"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0100"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when others =>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0)+3;
		end case;
		bcd_12bit:=bcd_12bit(10 downto 0)& adc_data_bcd(3);
		case bcd_12bit(3 downto 0) is
			when "0000"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0001"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0010"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0011"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0100"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when others =>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0)+3;
		end case;
		bcd_12bit:=bcd_12bit(10 downto 0)& adc_data_bcd(2);
		case bcd_12bit(3 downto 0) is
			when "0000"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0001"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0010"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0011"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0100"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when others =>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0)+3;
		end case;
		case bcd_12bit(7 downto 4) is
			when "0000"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0001"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0010"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0011"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0100"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when others =>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4)+3;
		end case;
		bcd_12bit:=bcd_12bit(10 downto 0)& adc_data_bcd(1);
		case bcd_12bit(3 downto 0) is
			when "0000"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0001"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0010"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0011"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when "0100"=>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0);
			when others =>bcd_12bit(3 downto 0):=bcd_12bit(3 downto 0)+3;
		end case;
		case bcd_12bit(7 downto 4) is
			when "0000"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0001"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0010"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0011"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when "0100"=>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4);
			when others =>bcd_12bit(7 downto 4):=bcd_12bit(7 downto 4)+3;
		end case;
		bcd_12bit:=bcd_12bit(10 downto 0)& adc_data_bcd(0);
		bcd_out<=bcd_12bit;
	end process;
end behavior;
