       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------
      * VARIABLES ARE DEFINED HERE IN WORKING-STORAGE.
      *----------------------------------------------------------------
           01 WS-STUDENT-RECORD.
               05 WS-STUDENT-NAME     PIC X(20) VALUE 'WILL'.
               05 WS-STUDENT-AGE      PIC 9(3)  VALUE 21.
               05 WS-STUDENT-GPA      PIC 9(1)V99 VALUE 3.85.

           01 WS-GREETING             PIC X(40) VALUE SPACES.
           01 WS-COURSE-NAME          PIC X(30) VALUE 'LETS LEARN COBOL'.

      *----------------------------------------------------------------
      * ARRAY EXAMPLE (TABLE IN COBOL)
      * OCCURS 5 TIMES CREATES 5 ELEMENTS IN THE ARRAY
      *----------------------------------------------------------------
           01 WS-GRADES.
               05 WS-GRADE PIC 9(3) OCCURS 5 TIMES
                  VALUE 85 90 88 92 95.

           01 WS-INDEX PIC 9 VALUE 1.

       PROCEDURE DIVISION.

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

      *----------------------------------------------------------------
      * LOOP THROUGH THE ARRAY AND PRINT EACH GRADE
      *----------------------------------------------------------------
           DISPLAY 'STUDENT GRADES:'.

           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 5
               DISPLAY 'GRADE ' WS-INDEX ' : ' WS-GRADE(WS-INDEX)
           END-PERFORM.

           DISPLAY '----------------------------------------'.

           STOP RUN.