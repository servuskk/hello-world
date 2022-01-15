library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity LAB8_I2C is
--INOUT sdayyds
    port
    (
    	clk:		in std_logic;						--12MHz晶振时钟
        rst:		in std_logic;						--复位
        scl:    	out std_logic;
        sda:	    inout std_logic;
    	adc_flag:	out std_logic;
    	ADC_data:	buffer std_logic_vector(7 downto 0)  	--led控制字
    );
end;

architecture arch of LAB8_I2C is

    type states is (I, C, S, P, R, W);--init control start stop read write
    signal clk_400k: std_logic;
    signal data: std_logic_vector(7 downto 0);
    signal cnt: integer;
    signal cnt_s: integer;
    signal cnt_p: integer;
    signal cnt_r: integer;
    signal cnt_w: integer;
    signal cnt_c: integer;
    signal state:states:= I;
    signal w_flag: std_logic;
    signal r_flag: std_logic;

begin
----------------------------------------------------------
--					时钟分频，400kHz
--根据PCF8591的datasheet，I2C的频率最高为100KHz，
--使用4个节拍完成1bit数据的传输，所以需要400KHz的时钟触发完成该设计
----------------------------------------------------------
process(clk)
	variable clk_cnt:integer := 0;				--时钟分频计数
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
----------------------------------------------------------
process(clk_400k)
begin
    if (rst='0')then
        scl<='1';
        sda<='1';
        cnt<=0;
        cnt_s<=5;
        cnt_p<=5;
        cnt_r<=0;
        cnt_w<=0;
        cnt_c<=0;
        adc_flag<='0';
        state<=I;
        adc_data<="11111111";
    	r_flag<='0';
    	w_flag<='0';
        else
            if (rising_edge(clk_400k))then
            case state is 
                when I =>--init/RESET
                    scl<='1';
                    sda<='1';
                    cnt<=0;
                    cnt_s<=0;
                    cnt_p<=0;
                    cnt_r<=0;
                    cnt_w<=0;
                    cnt_c<=0;
                    adc_flag<='0';
                    state<=c;
                    --adc_data<="00000000";
    				adc_data<="11111111";
    				r_flag<='0';
    				w_flag<='0';
    -------------------------------------------------------------------------------------------------------------
                when c=>--CONTROL
    				if(cnt_c>=6)then cnt_c<=6;--完成地址、控制字的写入后 一直重复的是读取采样数据
    				end if;
                    case cnt_c is
    			--第一次为配置数据，具体为：开始–写寻址–读响应–写配置数据–读响应–结束。
    				    when 0=> state<=s;cnt_c<=cnt_c+1;--start
                        when 1=> data<="10010000";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--写地址 A0 1 2 都接地 最后一位是0
                        when 2=> data<="00000000";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--control byte 选用adc0
                        when 3=> state<=P;cnt_p<=0;cnt_c<=cnt_c+1;--配置数据结束
    			--第二次为读ADC数据，具体为：开始–读寻址–读响应–[读ADC数据–写响应–]循环读-结束。
                        when 4=> state<=S;cnt_c<=cnt_c+1;--启动
                        when 5=> data<="10010001";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--读地址(最后一位是1)
                        when 6=> state <=R;r_flag<='0';--读ADC数据
                        when 7=> state <=P;--第二次结束
                        when 8=> state<= c;
                        when others => state<=i;
                    end case;	
    -------------------------------------------------------------------------------------------------------------
                when S=>--start
    				if(cnt_s>=5)then cnt_s<=0;
                    else cnt_s <=cnt_s+1;
                    end if;
                    case cnt_s is--start scl:1 sda:1->0 
                        when 0 => sda<='1';scl<='1';
                        when 1 => sda<='1';scl<='1';--拉高scl和sda 要求保持4.7μs以上
                        when 2 => sda<='0';
                        when 3 => sda<='0';--SDA拉低到SCL拉低，保持4.0μs以上
                        when 4 => scl<='0';
                        when 5 => scl<='0';state<=c;--SCL拉低，保持4.7μs以上
                        when others => state<=I;
                    end case; 
                when P=>--STOP
    				if(cnt_p>=5)then cnt_p<=0;
    				else cnt_p <=cnt_p+1;
    				end if;
                    case cnt_p is--stop scl:1 sda:0->1
                        when 0 => sda<='0';
                        when 1 => sda<='0';--4.7μs以上
                        when 2 => scl<='1';
                        when 3 => scl<='1';--4.0μs以上
                        when 4 => sda<='1';
                        when 5 => sda<='1';state<=c;--4.7μs以上
                        when others => state<=I;
                    end case;
                when R=>--READ
                    if(cnt<=6)then
                        if(cnt_r>=3)then cnt_r<=0;cnt<=cnt+1;
                        else if(r_flag='1')then cnt_r<=cnt_r+1;end if;
                        end if;
                    else 
                        if(cnt_r>=7)then cnt_r<=0;cnt<=0;
                        else cnt_r<=cnt_r+1;
                        end if;
                    end if;  
    				r_flag<='1';
                    case cnt_r is
                        when 0=> scl<='0';sda<='Z'; 
                        when 1=> scl<='1';              
                        when 2=> scl<='1';data(7-cnt)<=sda;--0.4, 读取从设备返回的数据
                        when 3=> scl<='0'; 
                        -- 最后一个bit结束后
                        when 4=> sda<='0'; adc_flag<='1';adc_data<=data;--锁存读入的8bit数据
                        when 5=> scl<='1'; 
                        when 6=> scl<='1';adc_flag<='0';--0.4
                        when 7=> scl<='0';state<=c;
                        when others=> state<=I;
                    end case;
    				--cnt_r<=cnt_r+1;--一次读8bit操作后cnt=7;cnt_r=8.这个计数器到底什么鬼/算了算了
                when W=>--WRITE 写地址/control byte
                    if (cnt<=6) then--前几位只需写入1bit，最后一位需要特殊处理
                        if(cnt_w>=3) then cnt_w<=0;cnt<=cnt+1;--四个周期完成一位地址的写入
                        else if(w_flag='1')then cnt_w<=cnt_w+1;end if;
                        end if;
                    else 
                        if(cnt_w>=7) then--写完最后一位
                            cnt_w<=0;cnt<=0;
                        else cnt_w<=cnt_w+1;--取8个周期进行特殊处理（前四个和前几位一样）
                        end if;
                    end if;
    				w_flag<='1';
                    case cnt_w is
                        when 0=> scl<='0';sda<=data(7-cnt);--sda变化时要保证scl是0
                        when 1=> scl<='1';
                        when 2=> scl<='1';--0.4
                        when 3=> scl<='0';--为下一个bit做准备
                        --最后一个周期
                        when 4=> sda<='Z';--高阻，准备离开write状态，切换到获取信号
                        when 5=> scl<='1';
                        when 6=> scl<='1';--老规矩0.4
                        when 7=> scl<='0';state<=c;
                        when others => state<=I;
                    end case;
    				--cnt_w<=cnt_w+1;--一次8bit操作后cnt=7;cnt_w=8.
                end case;
            end if;
        end if;	
    end process;

end arch;