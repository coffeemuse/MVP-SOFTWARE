//KIKSCP  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KIKSCP EXEC PROC=KGCC,NAME=KIKSCP1$
//COPY.SYSUT1 DD DSN=K.X.ROOT.C(KIKSCP1$),DISP=SHR
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 ENTRY KIKSCP
/*
//
