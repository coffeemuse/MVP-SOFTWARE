//HERC01   JOB (SMP),
//             'Install ZUM0004',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(0,0),
//             REGION=8192K,
//             NOTIFY=HERC01
//* +----------------------------------------------------------------+
//* |                                                                |
//* | Name: CBT.MVS38J.CNTL(CMDSB2)                                  |
//* |                                                                |
//* | Type: JCL to install usermod ZUM0004                           |
//* |                                                                |
//* | Desc: Add CMD1 to Subsystem Name Table                         |
//* |                                                                |
//* +----------------------------------------------------------------+
/*MESSAGE *****************************
/*MESSAGE *                           *
/*MESSAGE * To activate this usermod  *
/*MESSAGE * an IPL with the CLPA      *
/*MESSAGE * option is required        *
/*MESSAGE *                           *
/*MESSAGE *****************************
//REJECT  EXEC SMPACC
//SMPCNTL DD *
 RESTORE G(ZUM0004).
 RESETRC.
 REJECT  S(ZUM0004).
//RECEIVE EXEC SMPREC
//SMPPTFIN DD    *
++USERMOD (ZUM0004) .
++VER (Z038) FMID(EBB1102)
  /*
   Add entry to subsystem name table
  */ .
++ ZAP (IEFJESNM) .
 NAME IEFJESNM
 VER 0008 00000000   from X'00000000' empty slot
 REP 0008 C3D4C4F1     to C'CMD1'     added subsystem name
 IDRDATA ZUM0004
//SMPCNTL DD *
 RECEIVE SELECT(ZUM0004).
//APPLY EXEC SMPAPP,COND=(0,NE,RECEIVE.HMASMP)
//SMPCNTL DD *
 APPLY S(ZUM0004)
       DIS(WRITE)
       .
