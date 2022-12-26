
#line 1 "D:\4WISD\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\2-程序文件\PID.C" /0
  
#line 1 "..\..\..\..\..\..\..\..\KEIL\C51\INC\REG52.H" /0






 
 
 
 
 
 
 sfr P0    = 0x80;
 sfr P1    = 0x90;
 sfr P2    = 0xA0;
 sfr P3    = 0xB0;
 sfr PSW   = 0xD0;
 sfr ACC   = 0xE0;
 sfr B     = 0xF0;
 sfr SP    = 0x81;
 sfr DPL   = 0x82;
 sfr DPH   = 0x83;
 sfr PCON  = 0x87;
 sfr TCON  = 0x88;
 sfr TMOD  = 0x89;
 sfr TL0   = 0x8A;
 sfr TL1   = 0x8B;
 sfr TH0   = 0x8C;
 sfr TH1   = 0x8D;
 sfr IE    = 0xA8;
 sfr IP    = 0xB8;
 sfr SCON  = 0x98;
 sfr SBUF  = 0x99;
 
 
 sfr T2CON  = 0xC8;
 sfr RCAP2L = 0xCA;
 sfr RCAP2H = 0xCB;
 sfr TL2    = 0xCC;
 sfr TH2    = 0xCD;
 
 
 
 
 sbit CY    = PSW^7;
 sbit AC    = PSW^6;
 sbit F0    = PSW^5;
 sbit RS1   = PSW^4;
 sbit RS0   = PSW^3;
 sbit OV    = PSW^2;
 sbit P     = PSW^0;  
 
 
 sbit TF1   = TCON^7;
 sbit TR1   = TCON^6;
 sbit TF0   = TCON^5;
 sbit TR0   = TCON^4;
 sbit IE1   = TCON^3;
 sbit IT1   = TCON^2;
 sbit IE0   = TCON^1;
 sbit IT0   = TCON^0;
 
 
 sbit EA    = IE^7;
 sbit ET2   = IE^5;  
 sbit ES    = IE^4;
 sbit ET1   = IE^3;
 sbit EX1   = IE^2;
 sbit ET0   = IE^1;
 sbit EX0   = IE^0;
 
 
 sbit PT2   = IP^5;
 sbit PS    = IP^4;
 sbit PT1   = IP^3;
 sbit PX1   = IP^2;
 sbit PT0   = IP^1;
 sbit PX0   = IP^0;
 
 
 sbit RD    = P3^7;
 sbit WR    = P3^6;
 sbit T1    = P3^5;
 sbit T0    = P3^4;
 sbit INT1  = P3^3;
 sbit INT0  = P3^2;
 sbit TXD   = P3^1;
 sbit RXD   = P3^0;
 
 
 sbit SM0   = SCON^7;
 sbit SM1   = SCON^6;
 sbit SM2   = SCON^5;
 sbit REN   = SCON^4;
 sbit TB8   = SCON^3;
 sbit RB8   = SCON^2;
 sbit TI    = SCON^1;
 sbit RI    = SCON^0;
 
 
 sbit T2EX  = P1^1;  
 sbit T2    = P1^0;  
 
 
 sbit TF2    = T2CON^7;
 sbit EXF2   = T2CON^6;
 sbit RCLK   = T2CON^5;
 sbit TCLK   = T2CON^4;
 sbit EXEN2  = T2CON^3;
 sbit TR2    = T2CON^2;
 sbit C_T2   = T2CON^1;
 sbit CP_RL2 = T2CON^0;
 
 
#line 1 "D:\4WISD\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\2-程序文件\PID.C" /0
 
  
#line 1 "..\..\..\..\..\..\..\..\KEIL\C51\INC\STDIO.H" /0






 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 typedef unsigned int size_t;
 
 
 #pragma SAVE
 #pragma REGPARMS
 extern char _getkey (void);
 extern char getchar (void);
 extern char ungetchar (char);
 extern char putchar (char);
 extern int printf   (const char *, ...);
 extern int sprintf  (char *, const char *, ...);
 extern int vprintf  (const char *, char *);
 extern int vsprintf (char *, const char *, char *);
 extern char *gets (char *, int n);
 extern int scanf (const char *, ...);
 extern int sscanf (char *, const char *, ...);
 extern int puts (const char *);
 
 #pragma RESTORE
 
 
 
#line 2 "D:\4WISD\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\单片机直流电机转速控制（数码管显示、独立按键控制正反转、停止、开始、PID算法）【仿真+程序】 - 试用\2-程序文件\PID.C" /0
 
 
 
 
 
 unsigned char  code Duan[]={0x3F, 0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; 
 unsigned char  Data_Buffer[8]={0,0,0,0,0,0,0,0};			  
 
  unsigned char i=0;
 sbit AddSpeed=P1^1;
 sbit SubSpeed=P1^2;
 sbit TurnForward=P1^3;
 sbit TurnBackward=P1^4;
 sbit Stop=P1^5;
 
 sbit IN1=P3^0;
 sbit IN2=P3^1;
 sbit PWM_FC=P1^0;
 int e ,e1 ,e2 ;
 float uk ,uk1 ,duk ; 
 float Kp=15,Ki=12,Kd=1.6;
 int out=0;
  unsigned int SpeedSet=380;
  unsigned int cnt=0;
  unsigned int Inpluse=0,num=0; 
  unsigned int PWMTime=100; 
 unsigned char  arry[];
 void SendString(unsigned int ch);
 void PIDControl();
 void SystemInit();
 void delay(unsigned char x);
 void PWMOUT();
 void SetSpeed();
 void SegRefre();
 
 void main()
 {
 SystemInit();
 while(1)
 {
 SetSpeed();		 
 SegRefre();		 
 PWMOUT();		 
 
 }
 }
 
 void PIDControl()         
 {
 e=SpeedSet-num;		 
 duk=(Kp*(e-e1)+Ki*e+Kd*(e-2*e1+e2))/50;       
 uk=uk1+duk;	    
 out=(int)uk;    
 if(out>1000)
 {
 out=1000;
 }
 else if(out<0)
 {
 out=0;
 }
 uk1=uk;				   
 e2=e1;
 e1=e;				  
 PWMTime=out;
 }
 
 void delay(unsigned char x)
 {
  unsigned int i,j;
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
 TH0=0xf9;
 TL0=0x0f;
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
 delay(200);			   
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
 void SegRefre()		   
 {
 Data_Buffer[0]=SpeedSet/1000;		   
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
 Inpluse++;		     
 }
 void t0() interrupt 1
 {
 static unsigned char Bit=0;
 static unsigned int time=0;
 TH0=0xf9;
 TL0=0x0f;
 
 
 Bit++;
 time++;   
 if(Bit>8) Bit=0;		  
 P0=0xff;
 P2=Duan[Data_Buffer[Bit]];	 
 switch(Bit)					 
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
 cnt++;	 
 }
 
 
