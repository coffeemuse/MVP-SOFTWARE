//KIKSIP1$  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KIKSIP1$
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCEL),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KIKSIP1$
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KGCCE kiksip1$
$$
// DD DSN=K.X.ROOT.C(KIKSIP1$),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCEL kiksip1$ @@main
 INCLUDE KIKENTRY
 INCLUDE KIKSIP1$
 INCLUDE KIKASRB
 INCLUDE KIKLOAD
 INCLUDE VCONSTB5
/*
/*
$$
//
