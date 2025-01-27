//HERC01  JOB  (CBT),
//             'Copy FILE35',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             COND=(0,NE),
//             REGION=2048K
//*********************************************************************
//*
//*                       CBT Installation
//*                       ================
//*
//* DESC: CBT249.FILE35 contains many useful utility programs
//*       We copy them to SYS2.LINKLIB (for BATCH utilities)
//*       and SYS2.CMDLIB (for TSO command processors)
//*CBT249.FILE35 is part of the MVS Turnkey system
//*
//*********************************************************************
//*
//COPY    EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//FILE035  DD  DISP=SHR,DSN=CBT249.FILE035
//LINKLIB  DD  DISP=SHR,DSN=SYS2.LINKLIB
//CMDLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB
//SYSIN    DD  *
 COPY INDD=FILE035,OUTDD=LINKLIB
 SELECT MEMBER=TSUPDATE
 SELECT MEMBER=RMFPRT
 SELECT MEMBER=TAPEMAP
 COPY INDD=FILE035,OUTDD=CMDLIB
 S M=(BPAGE,CPAGE,QTIME,QDATE,DEDUCT,RANKING,ST79INIT,SUPRTREK)
 S M=$VTOC
 S M=ADVENT
 S M=CPU
 S M=(VSAMADTL,VSAMAGET,VSAMAHLP,VSAMANAL,VSAMANDX,VSAMSIZE)
