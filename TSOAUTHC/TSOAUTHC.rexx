/* REXX */

/* BREXX SCRIPT TO CREATE AND ACCEPT A USERMOD ADDING A PROGRAM */
/* TO THE TSO AUTHORIZED PROGRAMS                               */
/* ARGUMENTS:                                                   */
/*      RMID   (OBTAINED BY RUNNING LISTCDS MOD(IKJEFTE2) IF    */
/*              LISTCDS IS NOT INSTALLED INSTALL IT WITH TSO:   */
/*                INSTALL LISTCDS )                             */
/*      PROGRAM NAME TO BE TSO AUTHORIZED                       */
/*      COMMENT OPTIONAL COMMENT FOR SOURCE OUTPUT              */
/* LICENSE GPLV2                                                */
/* AUTHOR PHILIP 'SOLDIER OF FORTRAN' YOUNG                     */
PARSE ARG ID PROGRAM COMMENT
IF ID == '' THEN DO
  SAY '*** MISSING RMID ARGUMENT'
  SAY '*** TO GET RMID ISSUE COMMAND LISTCDS MOD(IKJEFTE2)'
  SAY 'USAGE: RX TSOAUTHC <RMID> <TSO PROGRAM TO AUTHORIZR> <COMMENT>'
  RETURN 1
END
IF PROGRAM == '' THEN DO
  SAY '*** MISSING PROGRAM ARGUMENT'
  SAY '*** PROVIDE THE PROGRAM NAME YOU WISH TO TSO AUTHORIZE'
  RETURN 1
END

X=SYSDSN("'SYS1.UMODSRC(IKJEFTE2)'")
IF X \= 'OK' THEN DO
  SAY "*** SYS1.UMODSRC(IKJEFTE2) DOES NOT EXIST"
  RETURN 1
END

IDNUM = RIGHT(ID,1)
IDNUM = RIGHT(IDNUM+1,4,'0')
RMID="TSA"||IDNUM
DDNAME = "IJKEFTE2"

JCL.1 = "//"||RMID||"  JOB (SYSGEN),'"||RMID||"',"
JCL.2 = "//             CLASS=A,"
JCL.3 = "//             MSGCLASS=H,"
JCL.4 = "//             MSGLEVEL=(1,1),"
JCL.5 = "//             REGION=4096K,USER=IBMUSER,PASSWORD=SYS1"
JCL.6 = "/*JOBPARM LINES=100"
JCL.7 = "/*MESSAGE ******* REQUIRES IPL WITH R 00,CLPA **********"
JCL.8 = "//STEP1   EXEC PGM=PDSLOAD"
JCL.9 = "//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR"
JCL.10 = "//SYSPRINT DD  SYSOUT=*"
JCL.11 = "//SYSUT2   DD  DSN=SYS1.UMODSRC,DISP=SHR"
JCL.12 = "//SYSUT1   DD  DATA,DLM=@@"
JCL.13 = "./ ADD NAME=IKJEFTE2"
JCL.0 = 13

ADDRESS TSO "ALLOCATE FILE("DDNAME")" ,
  "DA('SYS1.UMODSRC(IKJEFTE2)') SHR REUSE"
"EXECIO * DISKR "DDNAME" (FINIS STEM INDATA."
IF RC > 0 THEN DO
  SAY "(T_T) ERROR READING SYS1.UMODSRC(IKJEFTE2)" RC
  EXIT 1
END
ADDRESS TSO "FREE FILE("DDNAME")"

NOTFOUND = 1
DO I=1 TO INDATA.0
  IF INDEX(INDATA.I,"DC    C'        '") \= 0 THEN DO
    NOTFOUND=0
    Y=I+JCL.0
    JCL.Y = "         DC    C'"||LEFT(UPPER(PROGRAM),8)||"'"||,
            LEFT("",13)||LEFT(COMMENT,31)
  END
  IF NOTFOUND THEN DO
    Y=I+JCL.0
    JCL.Y = INDATA.I
  END
  ELSE DO
    Y=I+JCL.0+1
    JCL.Y = INDATA.I
  END
END
JCL.0 = JCL.0 + INDATA.0 + 1
X = JCL.0
X = X + 1
JCL.X = "@@"
X = X + 1
JCL.X = "/*"
X = X + 1
JCL.X = "//*"
X = X + 1
JCL.X = "//SMPASM02 EXEC SMPASML,M=IKJEFTE2,COND=(0,NE)"
X = X + 1
JCL.X = "//*"
X = X + 1
JCL.X = "//RECV03   EXEC SMPAPP,COND=(0,NE),WORK=SYSALLDA"
X = X + 1
JCL.X = "//SMPPTFIN DD  *"
X = X + 1
JCL.X = "++USERMOD("||RMID||")"
X = X + 1
JCL.X = "  ."
X = X + 1
JCL.X = "++VER(Z038) FMID(EBB1102) PRE("||ID||")"
X = X + 1
JCL.X = "  ."
X = X + 1
JCL.X = "++MOD(IKJEFTE2)"
X = X + 1
JCL.X = "  DISTLIB(AOST4)"
X = X + 1
JCL.X = "  LKLIB(UMODLIB)"
X = X + 1
JCL.X = "  ."
X = X + 1
JCL.X = "/*"
X = X + 1
JCL.X = "//SMPCNTL  DD  *"
X = X + 1
JCL.X = "REJECT  S ("||RMID||") ."
X = X + 1
JCL.X = " RESETRC ."
X = X + 1
JCL.X = " RECEIVE"
X = X + 1
JCL.X = "         SELECT("||RMID||")"
X = X + 1
JCL.X = "         ."
X = X + 1
JCL.X = "  APPLY"
X = X + 1
JCL.X = "        SELECT("||RMID||")"
X = X + 1
JCL.X = "        DIS(WRITE)"
X = X + 1
JCL.X = "        ."
X = X + 1
JCL.X = "//"
JCL.0 = X

  /*                                          */
 /* JCL CREATION COMPLETED TIME TO SUBMIT IT */
/*                                          */


ADDRESS TSO
"FREE FILE(TMP)"
"FREE ATTR(@DECK)"
"ATTR @DECK RECFM(F B) LRECL(80) BLKSIZE(19040) DSORG(PS)"
"ALLOC FILE(TMP) NEW REU UNIT(VIO) USING(@DECK)"

IF RC <> 0 THEN DO
    SAY 'ERROR ALLOCATING TEMPORARY JCL FILE. RC =' RC
    RETURN 16
END

X=LISTDSI('TMP FILE')
TEMP = SYSDSNAME

ADDRESS SYSTEM
FP=OPEN("TMP","W")
DO I = 1 TO JCL.0
  JCLREC = LEFT(JCL.I,80)
  NC = WRITE(FP,JCLREC)
END
CALL CLOSE(FP)

ADDRESS TSO
"SUBMIT '"TEMP"'"
"FREE ATTR(@DECK)"
"FREE FILE(TMP)"
RETURN RC
