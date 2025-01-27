//HERC01   JOB (CBT),
//             'Run BSPSETPF',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(SETPF#)                                   *
//*                                                                  *
//*  Type: JCL to run BSPSETPF                                       *
//*                                                                  *
//*  Desc: Set console PFKs from SETPFKxx members in PARMLIB         *
//*                                                                  *
//********************************************************************
//* Note:  When using UPDATE or NOREPLYU the program must run
//*        authorized||
//*SETPF1  EXEC PGM=BSPSETPF                  <=== check, do not update
//*SETPF2  EXEC PGM=BSPSETPF,PARM=UPDATE      <=== update after reply
//SETPF3  EXEC PGM=BSPSETPF,PARM=NOREPLYU    <=== update without reply
