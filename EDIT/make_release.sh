#!/bin/bash

# builds the JCL needed to install EDIT

cat << 'END'
//EDIT JOB (JOB),
//             'INSTALL EDIT',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//* Create temp dataset for objects
//IEFBR14 EXEC PGM=IEFBR14
//OBJ      DD  DSN=&&OBJ,UNIT=SYSDA,
//             SPACE=(CYL,(1,1,5)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200),
//             DISP=(,PASS,DELETE)
END


# add maclibs


cat << 'END'
//MACLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=&&MACLIBS,UNIT=SYSDA,
//             DISP=(,PASS,DELETE),
//             SPACE=(TRK,(04,02,02)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=32000,DSORG=PS)
//SYSUT1   DD  DATA,DLM=@@
END

for i in CBT.V504.FILE068.PDS/SYCONVHX.txt; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//ASM     PROC MEMBER=DUMMY,
//             ASMPARM=''
//ASM     EXEC PGM=IFOX00,PARM='OBJ,NODECK,LINECOUNT(51)&ASMPARM'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=SYSDA,SPACE=(3200,(100,200))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(3200,(100,200))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(3200,(100,200))
//SYSGO    DD  DSN=&&OBJ(&MEMBER),DISP=OLD
//SYSLIB   DD  DSN=&&MACLIBS,DISP=OLD
//         DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//SYSIN    DD  DUMMY
//        PEND
END


cat << 'END'
//TSTVS  EXEC ASM,MEMBER=TSTVS
//ASM.SYSIN DD DATA,DLM=@@
END

cat CBT.V504.FILE068.PDS/TSTVS.txt

cat << 'END'
@@
//TSTVSALL  EXEC ASM,MEMBER=TSTVSALL,ASMPARM=',SYSPARM(MVS)'
//ASM.SYSIN DD DATA,DLM=@@
END

cat CBT.V504.FILE068.PDS/TSTVSALL.txt

cat << 'END'
@@
//TSTVSCOM  EXEC ASM,MEMBER=TSTVSCOM
//ASM.SYSIN DD DATA,DLM=@@
END

cat CBT.V504.FILE068.PDS/TSTVSCOM.txt

cat << 'END'
@@
//TSTVSSEC  EXEC ASM,MEMBER=TSTVSSEC,ASMPARM=',SYSPARM(MVS)'
//ASM.SYSIN DD DATA,DLM=@@
END

cat CBT.V504.FILE068.PDS/TSTVSSEC.txt

echo "@@"

cat << 'END'
//*
//LKED    EXEC PGM=IEWL,PARM='XREF,LIST,NCAL'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=SYSDA,SPACE=(3200,(100,300))
//SYSLMOD  DD  DSN=SYS2.LINKLIB,DISP=SHR
//OBJ      DD  DSN=&&OBJ,DISP=OLD
//SYSLIN   DD  DDNAME=SYSIN
//SYSIN DD *
 INCLUDE OBJ(TSTVS,TSTVSCOM,TSTVSALL)
 INCLUDE OBJ(TSTVSSEC)
 SETCODE AC(1)
 ENTRY TSTVS
 NAME TSTVS(R)
END

cat << 'END'
//PROCLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=EDIT
//EDIT    PROC ROUT=2
//TSTVS   EXEC PGM=TSTVS,PARM='&ROUT',TIME=1440
//STEPLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR
@@
//*
//* Add the RAKF permissions
//*
//RAKFUPDT EXEC PGM=IKJEFT01,                  
//       REGION=8192K                                         
//TSOLIB   DD   DSN=BREXX.CURRENT.RXLIB,DISP=SHR                             
//RXLIB    DD   DSN=BREXX.CURRENT.RXLIB,DISP=SHR                             
//SYSEXEC  DD   DSN=SYS2.EXEC,DISP=SHR                         
//SYSPRINT DD   SYSOUT=*                                      
//SYSTSPRT DD   SYSOUT=*                                      
//SYSTSIN  DD   *
 RX RDEFINE 'FACILITY $TSTVS UACC(NONE)'
 RX PERMIT '$TSTVS CLASS(FACILITY) ID(ADMIN,STCGROUP) ACCESS(READ)'
//STDOUT   DD   SYSOUT=*,DCB=(RECFM=FB,LRECL=140,BLKSIZE=5600)
//STDERR   DD   SYSOUT=*,DCB=(RECFM=FB,LRECL=140,BLKSIZE=5600)
//STDIN    DD   DUMMY  
END