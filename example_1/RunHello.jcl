//HELLOJOB JOB (COBOL),'LETS LEARN COBOL',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//*
//* ---------------------------------------------------------------
//* UPGRADED JCL - DEMONSTRATES JCL SYMBOLIC VARIABLES (PARAMETERS)
//*
//* IN JCL, SYMBOLIC VARIABLES BEGIN WITH AN AMPERSAND (&).
//* THEY ARE DEFINED ON A SET STATEMENT AND SUBSTITUTED
//* WHEREVER THAT SYMBOL APPEARS IN THE JCL BELOW IT.
//* THIS IS SIMILAR TO ENVIRONMENT VARIABLES IN BASH OR
//* CONSTANTS AT THE TOP OF A PROGRAM.
//* ---------------------------------------------------------------
//*
//* DEFINE OUR SYMBOLIC VARIABLES (JCL'S VERSION OF VARIABLES)
//         SET LOADLIB='SYS2.LINKLIB'
//         SET SRCLIB='STUDENT.COBOL'
//         SET STUDENT='ALICE'
//*
//* ---------------------------------------------------------------
//* STEP 1: COMPILE THE COBOL SOURCE CODE
//* EXEC CALLS A UTILITY PROGRAM - HERE IKFCBL00 IS THE COBOL COMPILER
//* PARM= PASSES OPTIONS TO THE COMPILER
//* ---------------------------------------------------------------
//COMPILE  EXEC IKFCBL00,
//             PARM.COB='LOAD,APOST'
//*
//* SYSIN IS WHERE THE COMPILER READS YOUR COBOL SOURCE FROM
//COB.SYSIN DD DSN=&SRCLIB(&STUDENT),DISP=SHR
//*
//* SYSLIN IS WHERE THE COMPILER WRITES THE OBJECT (COMPILED) CODE
//COB.SYSLIN DD DSN=&&OBJSET,
//             DISP=(NEW,PASS),
//             SPACE=(TRK,(3,3))
//*
//* ---------------------------------------------------------------
//* STEP 2: LINK-EDIT (LINK THE COMPILED CODE INTO AN EXECUTABLE)
//* HEWL IS THE LINKAGE EDITOR - IT TURNS OBJECT CODE INTO
//* A LOAD MODULE (MAINFRAME TERM FOR AN EXECUTABLE)
//* ---------------------------------------------------------------
//LKED     EXEC PGM=HEWL,
//             COND=(8,LT,COMPILE),
//             PARM='LIST,LET,XREF'
//*
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SYSLMOD  DD DSN=&LOADLIB(&STUDENT),DISP=SHR
//SYSPRINT DD SYSOUT=*
//*
//* ---------------------------------------------------------------
//* STEP 3: RUN THE LINKED PROGRAM
//* PGM= REFERENCES OUR SYMBOLIC VARIABLE &STUDENT TO FIND
//* THE LOAD MODULE WE JUST CREATED IN &LOADLIB
//* ---------------------------------------------------------------
//RUN      EXEC PGM=&STUDENT,
//             COND=(8,LT,LKED)
//*
//STEPLIB  DD DSN=&LOADLIB,DISP=SHR
//SYSOUT   DD SYSOUT=*
//