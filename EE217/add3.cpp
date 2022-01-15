// ConsoleApplication1.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include<vector>
#include <bitset>
using namespace std;

int main()
{
    cout << "Hello World!\n";
    unsigned int bcd;
    unsigned int adc;
    adc = 0b11001000;

    bcd =  (adc&0b11100000)>>5;
    cout << std::bitset<12>(bcd) << endl;
    if ((bcd & 0b1111 )> 0b100)bcd += 0b11;
    cout << std::bitset<12>(bcd) << endl;
    bcd = (bcd << 1)+((adc&0b10000)>>4);
    if ((bcd & 0b1111 )> 4)bcd += 3;
    cout << std::bitset<12>(bcd) << endl;
    bcd =( bcd << 1 )+ ((adc & 0b1000) >> 3);
    if ((bcd & 0b1111) > 4)bcd += 3;
    cout << std::bitset<12>(bcd) << endl;
    bcd =(bcd << 1) + ((adc & 0b100) >> 2);
    if ((bcd & 0b11110000) > 0b100000)bcd += 0b110000;
    if ((bcd & 0b1111) > 4)bcd += 3;
    cout << std::bitset<12>(bcd) << endl;
    bcd = (bcd << 1) + ((adc & 0b10) >> 1);
    if ((bcd & 0b11110000) > 0b100000)bcd += 0b110000;
    if ((bcd & 0b1111) > 4)bcd += 3;
    cout << std::bitset<12>(bcd) << endl;

    bcd = (bcd << 1 )+ (adc & 0b1);
    cout << std::bitset<12>(bcd) << endl;

    int output;
    output = (bcd & 0b1) * 1 + ((bcd & 0b10) >> 1) * 2 + ((bcd & 0b100) >> 2) * 4 + ((bcd & 0b1000) >> 3) * 8 + 10 * (((bcd & 0b10000) >> 4) * 1 + ((bcd & 0b100000) >> 5) * 2 + ((bcd & 0b1000000) >> 6) * 4 + ((bcd & 0b10000000) >> 7) * 8) + 100 * (((bcd & 0b100000000) >> 8) * 1 + ((bcd & 0b1000000000) >> 9) * 2);
    cout << output;
}

/*
bcd_12bit="000000000"&adc_data_bcd(7 downto 5);--左移三次,检查低四位>4?
if(bcd_12bit(3 downto 0)>4)then bcd_12bit<=bcd_12bit+3;end if;
bcd_12bit=bcd_12bit(10 downto 0)& adc_data_bcd(4);--左移四次,检查低四位>4?
if(bcd_12bit(3 downto 0)>4)then bcd_12bit<=bcd_12bit+3;end if;
bcd_12bit=bcd_12bit(9 downto 0)& adc_data_bcd(3 downto 2);--左移六次,检查高四位>4?
if(bcd_12bit(7 downto 4)>4)then bcd_12bit(7 downto 4)<=bcd_12bit(7 downto 4)+3;end if;
bcd_12bit=bcd_12bit(10 downto 0)& adc_data_bcd(1);--左移七次,检查低四位>4?
if(bcd_12bit(3 downto 0)>4)then bcd_12bit<=bcd_12bit+3;end if;
bcd_12bit=bcd_12bit(10 downto 0)& adc_data_bcd(0);--左移八次(得到BCD码)
bcd_out=bcd_12bit;
*/