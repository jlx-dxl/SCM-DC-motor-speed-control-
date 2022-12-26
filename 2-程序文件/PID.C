#include<reg52.h>
#include<stdio.h>
#define uchar unsigned char 
#define uint unsigned int
#define THC0 0xf9
#define TLC0 0x0f   //2ms
unsigned char  code Duan[]={0x3F, 0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};//共阴极数码管，0-9段码表
unsigned char  Data_Buffer[8]={0,0,0,0,0,0,0,0};			 //	显示缓冲
 
uchar i=0;
sbit AddSpeed=P1^1;
sbit SubSpeed=P1^2;
sbit TurnForward=P1^3;
sbit TurnBackward=P1^4;
sbit Stop=P1^5;

sbit IN1=P3^0;
sbit IN2=P3^1;
sbit PWM_FC=P1^0;
int e ,e1 ,e2 ;
float uk ,uk1 ,duk ;//pid输出值
float Kp=15,Ki=12,Kd=1.6;
int out=0;
uint SpeedSet=380;
uint cnt=0;
uint Inpluse=0,num=0;//脉冲计数
uint PWMTime=100;//脉冲宽度
unsigned char  arry[];
void SendString(uint ch);
void PIDControl();
void SystemInit();
void delay(uchar x);
void PWMOUT();
void SetSpeed();
void SegRefre();
/**************主函数************/
void main()
{
	SystemInit();
	while(1)
	{
		SetSpeed();		//按键设定速度
		SegRefre();		//数码管显示刷新
		PWMOUT();		//输出PWM
 
	}
}

void PIDControl()        //pid偏差计算
{
	e=SpeedSet-num;		 
	duk=(Kp*(e-e1)+Ki*e+Kd*(e-2*e1+e2))/50;       
	uk=uk1+duk;	    
	out=(int)uk;   //输出为占空比
	if(out>1000)
	{
		out=1000;
	}
	else if(out<0)
	{
		out=0;
	}
	uk1=uk;				  //变量值移位
	e2=e1;
	e1=e;				  
	PWMTime=out;
}

void delay(uchar x)
{
	uint i,j;
	for(i=x;i>0;i--)
		for(j=50;j>0;j--);
}

void PWMOUT()		  
{
	if(cnt<PWMTime)	       
	{
		PWM_FC=1;
	}
	else
	{
		PWM_FC=0;
	}
	if(cnt>1000) cnt=0;	 
}
void SystemInit()
{
	TMOD=0X21;     
	TH0=THC0;
	TL0=TLC0;
	TH1=0xC0;
	TL1=0XC0;
	ET1=1;
	ET0=1;
	TR0=1;
	TR1=1;
	EX0=1;     
	IT0=1;
	EA=1;
	e =0;		
	e1=0;
	e2=0;
	IN1 = 1;
	IN2 = 0;
}
void SetSpeed()
{
	if(AddSpeed==0)
	{
		delay(200);			  //消抖处理
		if(AddSpeed==0)
		{
			SpeedSet+=10;
			if(SpeedSet>1500)
			{
				SpeedSet=1500;
			}
		}
	}
	if(SubSpeed==0)
	{
		delay(200);
		if(SubSpeed==0)
		{
			SpeedSet-=10;
			if(SpeedSet<0) SpeedSet=0;
		}
	}
	if(TurnForward==0)
	{
		delay(200);
		if(TurnForward==0)
		{
		   IN1 = 1;
		   IN2 = 0;
		   while(TurnForward==0);
		}
	}
	if(TurnBackward==0)
	{
		delay(200);
		if(TurnBackward==0)
		{
		   IN1 = 0;
		   IN2 = 1;
		   while(TurnBackward==0);
		}
	}
	if(Stop==0)
	{
		delay(200);
		if(Stop==0)
		{
		   IN1 = 1;
		   IN2 = 1;
		   while(Stop==0);
		}
	}

}
void SegRefre()		  //显示刷新
{
	 Data_Buffer[0]=SpeedSet/1000;		  //分离设定值各位
	 Data_Buffer[1]=SpeedSet%1000/100;
	 Data_Buffer[2]=SpeedSet%100/10;
	 Data_Buffer[3]=SpeedSet%10;
	 Data_Buffer[4]=num/1000;			 
	 Data_Buffer[5]=num%1000/100;
	 Data_Buffer[6]=num%100/10;
	 Data_Buffer[7]=num%10;
}

void int0() interrupt 0
{
	Inpluse++;		    //采集外部脉冲
}
void t0() interrupt 1
{
	static unsigned char Bit=0;
	static unsigned int time=0;
	TH0=THC0;
	TL0=TLC0;

 
	Bit++;
	time++;  //转速测量周期
	if(Bit>8) Bit=0;		  
	P0=0xff;
	P2=Duan[Data_Buffer[Bit]];	//显示段码
	switch(Bit)					//数码管位选
	{
		case 0:P0=0X7F;break;
		case 1:P0=0XBF;break;
		case 2:P0=0XDF;break;
		case 3:P0=0XEF;break;
		case 4:P0=0XF7;break;
		case 5:P0=0XFB;break;
		case 6:P0=0XFD;break;
		case 7:P0=0XFE;break;
	}
	if(time>100)
	{
		time=0;
		num=Inpluse*5;		   
		Inpluse=0;			   
		PIDControl();		   
	}
}
void timer_1()  interrupt 3
{
   	cnt++;	//cnt越大占空比越高2.5Khz
}
  

