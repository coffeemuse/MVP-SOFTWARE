//HERC01   JOB (CBT),
//             'Install ZUM0001',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(0,0),
//             REGION=8192K,
//             NOTIFY=HERC01
//* +----------------------------------------------------------------+
//* |                                                                |
//* | Name: CBT.MVS38J.CNTL(CMDSB8)                                  |
//* |                                                                |
//* | Type: JCL to install usermod ZUM0001                           |
//* |                                                                |
//* | Desc: Build the table of authorized commands in TSO            |
//* |       The usermod/table source is in SYS1.UMODSRC(IKJEFTE2)    |
//* |                                                                |
//* +----------------------------------------------------------------+
/*MESSAGE *****************************
/*MESSAGE *                           *
/*MESSAGE * To activate this usermod  *
/*MESSAGE * an IPL with the CLPA      *
/*MESSAGE * option is required        *
/*MESSAGE *                           *
/*MESSAGE *****************************
//ASM     EXEC SMPASML,M=IKJEFTE2
//REJECT  EXEC SMPREC
//SMPCNTL  DD  *
 REJECT SELECT(ZUM0001).
//RECEIVE EXEC SMPREC
//SMPPTFIN DD  *
++ USERMOD(ZUM0001).
++ VER(Z038) FMID(EBB1102).
++ MOD(IKJEFTE2) DISTLIB(AOST4) LKLIB(UMODLIB).
//SMPCNTL  DD  *
 RECEIVE SELECT(ZUM0001).
//APPLY   EXEC SMPAPP,COND=(0,NE,RECEIVE.HMASMP)
//SMPCNTL  DD  *
 APPLY SELECT(ZUM0001) DIS(WRITE).
/*
