      *------------------------------------------------------------*
      * PROGRAM:    EX3                                            *
      * LANGUAGE:   COBOL with Embedded DB2 SQL                   *
      * PURPOSE:    Retrieve a single employee record from the     *
      *             EMPLOYEE table and display its fields.         *
      *                                                            *
      *------------------------------------------------------------*
       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EX3.
       AUTHOR.        STUDENT EXERCISE.
       DATE-WRITTEN.  2026-04-03.
 
      *------------------------------------------------------------*
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-3090.
       OBJECT-COMPUTER. IBM-3090.
 
      *------------------------------------------------------------*
       DATA DIVISION.
 
       WORKING-STORAGE SECTION.
 
      *--- SQL COMMUNICATION AREA ---------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
 
      *--- HOST VARIABLES -----------------------------------------*
      *    These variables are used to pass data between COBOL     *
      *    and DB2. They are prefixed with ':' inside SQL blocks.  *
       01  WS-HOST-VARS.
           05  WS-EMP-ID         PIC X(6).
           05  WS-EMP-NAME       PIC X(30).
           05  WS-EMP-SALARY     PIC 9(7)V99   COMP-3.
           05  WS-EMP-DEPT       PIC X(3).
 
      *--- DISPLAY WORK FIELDS ------------------------------------*
       01  WS-DISPLAY-SALARY     PIC ZZZ,ZZZ.99.
       01  WS-SQLCODE-DISPLAY    PIC S9(9)     SIGN LEADING SEPARATE.
 
      *--- PROGRAM FLAGS ------------------------------------------*
       01  WS-SQL-STATUS         PIC X(1).
           88  SQL-SUCCESS       VALUE '0'.
           88  SQL-NOT-FOUND     VALUE 'N'.
           88  SQL-ERROR         VALUE 'E'.
 
      *------------------------------------------------------------*
       PROCEDURE DIVISION.
 
      *------------------------------------------------------------*
       0000-MAIN.
      *------------------------------------------------------------*
      *    Entry point. Set the employee ID to look up, fetch the  *
      *    record, and display results if found.                   *
      *------------------------------------------------------------*
           MOVE 'E00100'    TO WS-EMP-ID
 
           PERFORM 1000-FETCH-EMPLOYEE
 
           IF SQL-SUCCESS
               PERFORM 2000-DISPLAY-RESULTS
           END-IF
 
           PERFORM 9999-STOP-RUN.
 
      *------------------------------------------------------------*
       1000-FETCH-EMPLOYEE.
      *------------------------------------------------------------*
      *    Execute a SELECT INTO to retrieve one row from the      *
      *    EMPLOYEE table matching WS-EMP-ID.                      *
      *    Evaluate SQLCODE to set WS-SQL-STATUS.                  *
      *------------------------------------------------------------*
           EXEC SQL
               SELECT EMP_ID,
                      LAST_NAME,
                      SALARY,
                      DEPT_CODE
               INTO  :WS-EMP-ID,
                     :WS-EMP-NAME,
                     :WS-EMP-SALARY,
                     :WS-EMP-DEPT
               FROM   EMPLOYEE
               WHERE  EMP_ID = :WS-EMP-ID
           END-EXEC
 
           EVALUATE TRUE
               WHEN SQLCODE = 0
                   MOVE '0'  TO WS-SQL-STATUS
                   DISPLAY 'RECORD FOUND FOR EMP-ID: ' WS-EMP-ID
 
               WHEN SQLCODE = +100
                   MOVE 'N'  TO WS-SQL-STATUS
                   DISPLAY 'NO RECORD FOUND FOR EMP-ID: ' WS-EMP-ID
 
               WHEN SQLCODE < 0
                   MOVE 'E'  TO WS-SQL-STATUS
                   MOVE SQLCODE TO WS-SQLCODE-DISPLAY
                   DISPLAY 'SQL ERROR - SQLCODE: ' WS-SQLCODE-DISPLAY
                   PERFORM 9999-STOP-RUN
 
               WHEN OTHER
                   MOVE 'E'  TO WS-SQL-STATUS
                   DISPLAY 'UNEXPECTED SQLCODE - REVIEW SQLCA'
                   PERFORM 9999-STOP-RUN
           END-EVALUATE.
 
      *------------------------------------------------------------*
       2000-DISPLAY-RESULTS.

      *------------------------------------------------------------*

 
      *------------------------------------------------------------*
       9999-STOP-RUN.
      *------------------------------------------------------------*
           STOP RUN.
 