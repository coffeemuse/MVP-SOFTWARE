//CFLDSI JOB (TSO),
//             'Install CFLDSI',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//CFLDSICM  EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY
//SYSUT2 DD DSN=SYS1.CMDPROC(CFLDSI),DISP=SHR
//SYSUT1 DD DATA,DLM=@@
PROC 0 DD()

/***************************************************************/
/* CLIST:  CFLDSI                                              */
/*                                                             */
/* Description                                                 */
/* -----------                                                 */
/* List session allocated datasets using LISTA and LISTDSI     */
/*                                                             */
/*                                                             */
/* Syntax                                                      */
/* -------                                                     */
/* CFLDSI DD(xxxxxxxx)                                         */
/*    DD - optional, DD name                                   */
/*         o when NOT specificed, all TSO session allocated    */
/*           DD names and associated DSNs are listed           */
/*         o when specified, TSO session allocated DSNs        */
/*           and dataset attributes are listed for the         */
/*           specified DD                                      */
/*                                                             */
/*                                                             */
/* Example to list session allocated files                     */
/* ---------------------------------------                     */
/* CFLDSI                                                      */
/*                                                             */
/* Sample Output: (partial listing)                            */
/*                                                             */
/* ***** STEPLIB  ISP.V2R1M0.LLIB                              */
/* *****          LARRY01.REVIEW.R49M8.LOAD                    */
/* ***** SYS00004 SYS1.UCAT.TSO                                */
/* ***** SYS00002 SYS1.UCAT.MVS                                */
/* ***** SYSUDUMP JES2.TSU00038.SO0101                         */
/* ***** SYSABEND JES2.TSU00038.SO0102                         */
/* ***** SYSDBOUT JES2.TSU00038.SO0103                         */
/* ***** SYSHELP  SYS1.HELP                                    */
/* *****          SYS2.HELP                                    */
/* *****          LARRY01.REVIEW.R49M7.HELP                    */
/* ***** SYSPROC  LARRY01.CMDPROC                              */
/* *****          SYS1.CMDPROC                                 */
/* *****          SYS2.CMDPROC                                 */
/* *****          LARRY01.REVIEW.R45M0.CLIST                   */
/* *>>** SYSOUT   TERMFILE                                     */
/* *>>** DISPLAY  TERMFILE                                     */
/* .                                                           */
/* .                                                           */
/* ***** LOGIT    LARRY01.LOGIT                                */
/* LINES PROCESSED:163                                         */
/* ***                                                         */
/*                                                             */
/*                                                             */
/*                                                             */
/*                                                             */
/* Example to list session allocated files information         */
/* for DD SYSHELP                                              */
/* ---------------------------------------------------         */
/*                                                             */
/* CFLDSI DD(SYSHELP)                                          */
/*                                                             */
/* Sample Output:                                              */
/*                                                             */
/* *$$** DDNAME   VOLUME LRECL BLKSZ DATASETNAME               */
/* *$$** SYSHELP  MVSRES 00080 19040 SYS1.HELP                 */
/* *$$**          PUB000 00080 19040 SYS2.HELP                 */
/* *$$**          PUB005 00080 06480 LARRY01.REVIEW.R49M7.HELP */
/* LINES PROCESSED:163                                         */
/* ***                                                         */
/*                                                             */
/*                                                             */
/*                                                             */
/*  Disclaimer: <DSCLAIMR>                                     */
/*  ========================================================== */
/*                                                             */
/*  No guarantee; No warranty; Install / Use at your own risk. */
/*                                                             */
/*  This software is provided "AS IS" and without any expressed*/
/*  or implied warranties, including, without limitation, the  */
/*  implied warranties of merchantability and fitness for a    */
/*  particular purpose.                                        */
/*                                                             */
/*                                                             */
/*                                                             */
/***************************************************************/

/***************************************************************/
/* CLIST CONTROL statement                                     */
/***************************************************************/
CONTROL MSG

/***************************************************************/
/* Execute LISTALC STATUS and trap OUTPUT                      */
/***************************************************************/
SET LLIMIT     = 1000                           /* Line Limit  */
SET SYSOUTTRAP = &LLIMIT                        /* TRAP Limit  */

LISTALC STATUS                                  /* LISTALC     */

SET CRC = &LASTCC                               /* CP RC       */
SET SYSOUTTRAP = 0                              /* Reset TRAP  */
SET MAXLINE = &SYSOUTLINE                       /* Total Lines */
SET NUM = 1                                     /*             */
SET XX = 0                                      /* Heading Flag*/

/***************************************************************/
/* Check for no SYSOUT or CP does not use TPUT                 */
/***************************************************************/
IF &MAXLINE = 0 THEN -
  DO
    WRITE NO OUTPUT DETECTED FROM COMMAND
    EXIT
  END

/***************************************************************/
/* Check for excess SYSOUT from CP                             */
/***************************************************************/
IF &MAXLINE > &LLIMIT THEN -
  DO
    WRITE EXCEEDED CP SYSOUT OF &MAXLINE BY &MAXLINE-&LLIMIT LINES
    EXIT
  END

/***************************************************************/
/* Process captured output                                     */
/***************************************************************/
DO WHILE &NUM ^> &MAXLINE
  SET SYSSCAN = 0
  SET HVAL1 = &SYSOUTLINE
  SET SYSSCAN = 1
  SET HVAL2 = &STR(&HVAL1&NUM)
  SET SYSSCAN = 16

  SET COL01 = &STR(&HVAL2)                      /* Output line */

  /*************************************************************/
  /* SKIP Null lines                                           */
  /*************************************************************/
  IF &LENGTH(&STR(&COL01)) = 0 THEN GOTO SKIPME
  /*************************************************************/
  /* SKIP Heading lines fro LISTA                              */
  /*************************************************************/
  IF &SUBSTR(1:2,&STR(&COL01)) = &STR(--) THEN +
    GOTO SKIPME

  /*************************************************************/
  /* DSN line if BYTE 1 > ' '                                  */
  /*************************************************************/
  IF &SUBSTR(1:1,&STR(&COL01)) > &STR( ) THEN +
    DO
      SET DSNL = &LENGTH(&STR(&COL01))
      SET DSN  = &SUBSTR(1:&DSNL,&COL01)
    END

  /*************************************************************/
  /* Assume DD  line if BTYE 1 = ' '                           */
  /*  Otherwise, must be TERMFILE or similar                   */
  /*************************************************************/
  IF &SUBSTR(1:1,&STR(&COL01)) = &STR( ) THEN +
    DO
      SET DDN = &SUBSTR(3:10,&COL01)
      IF &DDN > &STR( ) THEN +
        SET DDH = &DDN
      IF &DD = &STR() THEN +
        WRITE ***** &DDN &DSN
      ELSE +
        IF &DD = &DDH THEN +
          DO
            IF &XX = 0 THEN +
              DO
                WRITE *$$** DDNAME   VOLUME LRECL BLKSZ DatasetName
                SET XX = &XX +1
              END
            LISTDSI '&DSN'
            SET RC=&LASTCC
            WRITE *$$** &DDN &SYSVOLUME &SYSLRECL &SYSBLKSIZE &DSN
          END
    END
  ELSE +
    IF &LENGTH(&STR(&COL01)) > 10 THEN +
      IF &SUBSTR(9:10,&STR(&COL01)) = &STR(  ) THEN +
        DO
          SET DSN = &SUBSTR(1:08,&COL01)
          SET DDN = &SUBSTR(11:18,&COL01)
          IF &DD = &STR() THEN +
            WRITE *>>** &DDN &DSN
          ELSE +
            IF &DD = &DDN THEN +
              WRITE *>>** &DDN &DSN
        END

  SKIPME: +
  SET NUM = &NUM + 1

END

/***************************************************************/
/* Done!                                                       */
/***************************************************************/
WRITE LINES PROCESSED:&NUM
EXIT CODE(0)
@@
//CFLDSICM  EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY
//SYSUT2 DD DSN=SYS2.HELP(CFLDSI),DISP=SHR
//SYSUT1 DD DATA,DLM=@@
)F FUNCTION -
  The CFLDSI CLIST displays session allocations using LISTALC and
  LISTDSI.

)X SYNTAX  -
         CFLDSI DD(xxxx)

  REQUIRED - NONE
  DEFAULTS - NONE
  ALIAS    -
)O OPERANDS -

))DD       - optional, DD (data definition name) to be listed


  Sample Commands

  1) CFLDSI
     Displays all session allocated DDs w/ associated DSNs

  2) CFLDSI DD(ISPCLIB)
     Displays allocated datasets ONLY for DD ISPCLIB including some
     dataset attributes
