//CMD1   PROC  A=ASE0,
//             B='$',
//             C=CSK0,
//             D=DSD0,
//             E=ESS0,
//             F=FSF0,
//             G='$',
//             H=HSM0,
//             I=ISJ0,
//             J=JSL0,
//             K='$',
//             L=LSC0,
//             M=MSO0,
//             N=NSA0,
//             O=OSR0,
//             P=PSP0,
//             Q=QSQ0,
//             R=RSG0,
//             S=SSH0,
//             T=TSN0,
//             U='$',
//             V=VSI0,
//             W='$',
//             X='$',
//             Y='$',
//             Z=ZSZ0
//CMD1  EXEC PGM=CMDSBINT,TIME=1440,DPRTY=(15,10),
// PARM='&A&B&C&D&E&F&G&H&I&J&K&L&M&N&O&P&Q&R&S&T&U&V&W&X&Y&Z'
//SYSUDUMP  DD  SYSOUT=A
//*CSC#ASYS  DD  DUMMY
//*CSC#BSYS  DD  DUMMY
//*CSC#CSYS  DD  DUMMY
//*CSCDATA   DD  DSN=SYS1.SYSTEM.CMDSBSYS.CSCDATA,DISP=SHR
//*
//*      WHERE  -    FOR CSC#.... REPLACE .... WITH SMF SYSID OF ONE
//*                  OF THE SYSTEMS USING CROSS-SYSTEM COMMANDS.
//*                  AS MANY CSC#.... DD CARDS AS NECESSARY MAY EXIST.
//*
