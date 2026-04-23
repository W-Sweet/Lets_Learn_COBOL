//SALESJOB JOB  (ACCT001),'SALES REPORT',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//*
//* ---------------------------------------------------------------
//* SALES REPORT JCL
//* STEP 1 - COMPILE AND LINK THE COBOL SOURCE
//* STEP 2 - RUN THE PROGRAM
//*
//* SYMBOLIC VARIABLES
//* ---------------------------------------------------------------
//         SET LOADLIB='STUDENT.COBOL.LOADLIB'
//         SET SRCLIB='STUDENT.COBOL'
//         SET MEMBER='SALESRPT'
//*
//* ---------------------------------------------------------------
//* STEP 1 - COMPILE AND LINK EDIT
//* IGYWCL IS IBM'S COBOL COMPILE AND LINK PROC
//* ---------------------------------------------------------------
//COMPILE  EXEC IGYWCL,
//             PARM.COBOL='OFFSET,NOLIST,ADV,APOST',
//             PARM.LKED='LIST,MAP,XREF'
//*
//* POINT THE COMPILER AT YOUR SOURCE MEMBER
//COBOL.SYSIN   DD DSN=&SRCLIB(&MEMBER),DISP=SHR
//*
//* WHERE TO WRITE THE LOAD MODULE (EXECUTABLE)
//LKED.SYSLMOD  DD DSN=&LOADLIB(&MEMBER),DISP=SHR
//COBOL.SYSPRINT DD SYSOUT=*
//LKED.SYSPRINT  DD SYSOUT=*
//*
//* ---------------------------------------------------------------
//* STEP 2 - RUN THE PROGRAM
//* COND=(8,LT,COMPILE) MEANS: SKIP THIS STEP IF THE COMPILE
//* RETURNED A CODE OF 8 OR HIGHER (I.E. IT FAILED)
//* ---------------------------------------------------------------
//RUN      EXEC PGM=&MEMBER,
//             COND=(8,LT,COMPILE)
//*
//STEPLIB  DD DSN=&LOADLIB,DISP=SHR
//*
//* INPUT FILE - SALES DATA
//SALES    DD DSN=STUDENT.DATA(SALESDAT),DISP=SHR
//*
//* OUTPUT FILE - REPORT
//REPORT   DD DSN=STUDENT.REPORTS(SALESRPT),
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(5,5)),
//             RECFM=FB,
//             LRECL=60,
//             BLKSIZE=6000
//*
//SYSOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//