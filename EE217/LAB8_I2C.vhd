library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity LAB8_I2C is
--INOUT sdayyds
    port
    (
    	clk:		in std_logic;						--12MHz����ʱ��
        rst:		in std_logic;						--��λ
        scl:    	out std_logic;
        sda:	    inout std_logic;
    	adc_flag:	out std_logic;
    	ADC_data:	buffer std_logic_vector(7 downto 0)  	--led������
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
--					ʱ�ӷ�Ƶ��400kHz
--����PCF8591��datasheet��I2C��Ƶ�����Ϊ100KHz��
--ʹ��4���������1bit���ݵĴ��䣬������Ҫ400KHz��ʱ�Ӵ�����ɸ����
----------------------------------------------------------
process(clk)
	variable clk_cnt:integer := 0;				--ʱ�ӷ�Ƶ����
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
    				if(cnt_c>=6)then cnt_c<=6;--��ɵ�ַ�������ֵ�д��� һֱ�ظ����Ƕ�ȡ��������
    				end if;
                    case cnt_c is
    			--��һ��Ϊ�������ݣ�����Ϊ����ʼ�CдѰַ�C����Ӧ�Cд�������ݨC����Ӧ�C������
    				    when 0=> state<=s;cnt_c<=cnt_c+1;--start
                        when 1=> data<="10010000";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--д��ַ A0 1 2 ���ӵ� ���һλ��0
                        when 2=> data<="00000000";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--control byte ѡ��adc0
                        when 3=> state<=P;cnt_p<=0;cnt_c<=cnt_c+1;--�������ݽ���
    			--�ڶ���Ϊ��ADC���ݣ�����Ϊ����ʼ�C��Ѱַ�C����Ӧ�C[��ADC���ݨCд��Ӧ�C]ѭ����-������
                        when 4=> state<=S;cnt_c<=cnt_c+1;--����
                        when 5=> data<="10010001";state <= W;w_flag<='0';cnt_c<=cnt_c+1;--����ַ(���һλ��1)
                        when 6=> state <=R;r_flag<='0';--��ADC����
                        when 7=> state <=P;--�ڶ��ν���
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
                        when 1 => sda<='1';scl<='1';--����scl��sda Ҫ�󱣳�4.7��s����
                        when 2 => sda<='0';
                        when 3 => sda<='0';--SDA���͵�SCL���ͣ�����4.0��s����
                        when 4 => scl<='0';
                        when 5 => scl<='0';state<=c;--SCL���ͣ�����4.7��s����
                        when others => state<=I;
                    end case; 
                when P=>--STOP
    				if(cnt_p>=5)then cnt_p<=0;
    				else cnt_p <=cnt_p+1;
    				end if;
                    case cnt_p is--stop scl:1 sda:0->1
                        when 0 => sda<='0';
                        when 1 => sda<='0';--4.7��s����
                        when 2 => scl<='1';
                        when 3 => scl<='1';--4.0��s����
                        when 4 => sda<='1';
                        when 5 => sda<='1';state<=c;--4.7��s����
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
                        when 2=> scl<='1';data(7-cnt)<=sda;--0.4, ��ȡ���豸���ص�����
                        when 3=> scl<='0'; 
                        -- ���һ��bit������
                        when 4=> sda<='0'; adc_flag<='1';adc_data<=data;--��������8bit����
                        when 5=> scl<='1'; 
                        when 6=> scl<='1';adc_flag<='0';--0.4
                        when 7=> scl<='0';state<=c;
                        when others=> state<=I;
                    end case;
    				--cnt_r<=cnt_r+1;--һ�ζ�8bit������cnt=7;cnt_r=8.�������������ʲô��/��������
                when W=>--WRITE д��ַ/control byte
                    if (cnt<=6) then--ǰ��λֻ��д��1bit�����һλ��Ҫ���⴦��
                        if(cnt_w>=3) then cnt_w<=0;cnt<=cnt+1;--�ĸ��������һλ��ַ��д��
                        else if(w_flag='1')then cnt_w<=cnt_w+1;end if;
                        end if;
                    else 
                        if(cnt_w>=7) then--д�����һλ
                            cnt_w<=0;cnt<=0;
                        else cnt_w<=cnt_w+1;--ȡ8�����ڽ������⴦��ǰ�ĸ���ǰ��λһ����
                        end if;
                    end if;
    				w_flag<='1';
                    case cnt_w is
                        when 0=> scl<='0';sda<=data(7-cnt);--sda�仯ʱҪ��֤scl��0
                        when 1=> scl<='1';
                        when 2=> scl<='1';--0.4
                        when 3=> scl<='0';--Ϊ��һ��bit��׼��
                        --���һ������
                        when 4=> sda<='Z';--���裬׼���뿪write״̬���л�����ȡ�ź�
                        when 5=> scl<='1';
                        when 6=> scl<='1';--�Ϲ��0.4
                        when 7=> scl<='0';state<=c;
                        when others => state<=I;
                    end case;
    				--cnt_w<=cnt_w+1;--һ��8bit������cnt=7;cnt_w=8.
                end case;
            end if;
        end if;	
    end process;

end arch;