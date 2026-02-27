IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
      *----------------------------------------------------------------
      * UPGRADED HELLO WORLD - DEMONSTRATES WORKING-STORAGE VARIABLES
      *----------------------------------------------------------------

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------
      * VARIABLES ARE DEFINED HERE IN WORKING-STORAGE.
      * 01 IS THE HIGHEST LEVEL NUMBER - THINK OF IT AS A "RECORD"
      * 05 IS A FIELD (CHILD) WITHIN THAT RECORD.
      * PIC STANDS FOR "PICTURE" - IT DESCRIBES THE TYPE AND SIZE
      * OF THE DATA THE VARIABLE WILL HOLD.
      *
      * PIC X(20)  = A STRING UP TO 20 CHARACTERS WIDE
      * PIC 9(3)   = A WHOLE NUMBER UP TO 3 DIGITS (000-999)
      * PIC 9(3)V99 = A DECIMAL NUMBER (3 digits, 2 after decimal)
      *----------------------------------------------------------------
           01 WS-STUDENT-RECORD.
               05 WS-STUDENT-NAME     PIC X(20) VALUE 'WILL'.
               05 WS-STUDENT-AGE      PIC 9(3)  VALUE 21.
               05 WS-STUDENT-GPA      PIC 9(1)V99 VALUE 3.85.

           01 WS-GREETING             PIC X(40) VALUE SPACES.
           01 WS-COURSE-NAME          PIC X(30) VALUE 'LETS LEARN COBOL'.

       PROCEDURE DIVISION.
      *----------------------------------------------------------------
      * THE PROCEDURE DIVISION IS WHERE PROGRAM LOGIC LIVES.
      * MOVE COPIES A VALUE INTO A VARIABLE.
      * STRING CONCATENATES MULTIPLE VALUES INTO ONE VARIABLE.
      *   - DELIMITED BY SIZE MEANS "USE THE FULL FIELD WIDTH"
      *   - INTO SPECIFIES THE DESTINATION VARIABLE
      * DISPLAY PRINTS A VALUE TO THE SCREEN.
      *----------------------------------------------------------------
           MOVE 'WELCOME TO ' TO WS-GREETING

           STRING 'WELCOME TO ' DELIMITED BY SIZE
                  WS-COURSE-NAME DELIMITED BY SIZE
                  INTO WS-GREETING

           DISPLAY '----------------------------------------'.
           DISPLAY WS-GREETING.
           DISPLAY '----------------------------------------'.
           DISPLAY 'STUDENT NAME : ' WS-STUDENT-NAME.
           DISPLAY 'STUDENT AGE  : ' WS-STUDENT-AGE.
           DISPLAY 'STUDENT GPA  : ' WS-STUDENT-GPA.
           DISPLAY '----------------------------------------'.

           STOP RUN.