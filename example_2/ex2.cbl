IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES-REPORT.
       AUTHOR.     EXAMPLE.

      *----------------------------------------------------------------
      * Demonstrates: Working Storage, group/elementary items,
      * PERFORM loops, nested IF/EVALUATE, arithmetic, and
      * formatted output.
      *----------------------------------------------------------------

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT REPORT-FILE ASSIGN TO "report.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  SALES-FILE.
       01  SALES-RECORD.
           05  SR-SALESPERSON-ID   PIC X(4).
           05  SR-REGION           PIC X(2).
           05  SR-AMOUNT           PIC 9(6)V99.

       FD  REPORT-FILE.
       01  REPORT-LINE             PIC X(60).

       WORKING-STORAGE SECTION.

       01  WS-FLAGS.
           05  WS-EOF-FLAG         PIC X VALUE 'N'.
               88  END-OF-FILE     VALUE 'Y'.

       01  WS-ACCUMULATORS.
           05  WS-TOTAL-SALES      PIC 9(9)V99 VALUE 0.
           05  WS-RECORD-COUNT     PIC 9(5)    VALUE 0.
           05  WS-HIGH-SALE        PIC 9(6)V99 VALUE 0.
           05  WS-HIGH-SALESPERSON PIC X(4)    VALUE SPACES.

       01  WS-DISPLAY-FIELDS.
           05  WS-DISP-TOTAL       PIC Z,ZZZ,ZZ9.99.
           05  WS-DISP-HIGH        PIC ZZZ,ZZ9.99.
           05  WS-DISP-COUNT       PIC ZZ,ZZ9.
           05  WS-DISP-AVERAGE     PIC Z,ZZZ,ZZ9.99.
           05  WS-AVERAGE          PIC 9(9)V99 VALUE 0.

       01  WS-DETAIL-LINE.
           05  FILLER              PIC X(2)  VALUE SPACES.
           05  WDL-ID              PIC X(4).
           05  FILLER              PIC X(4)  VALUE SPACES.
           05  WDL-REGION          PIC X(2).
           05  FILLER              PIC X(4)  VALUE SPACES.
           05  WDL-AMOUNT          PIC ZZZ,ZZ9.99.
           05  FILLER              PIC X(4)  VALUE SPACES.
           05  WDL-TIER            PIC X(8).

       PROCEDURE DIVISION.

       0000-MAIN.
           PERFORM 1000-INITIALIZE
           PERFORM 2000-PROCESS-RECORDS
               UNTIL END-OF-FILE
           PERFORM 3000-WRITE-SUMMARY
           PERFORM 9000-TERMINATE
           STOP RUN.

       1000-INITIALIZE.
           OPEN INPUT  SALES-FILE
           OPEN OUTPUT REPORT-FILE
           MOVE 'N'    TO WS-EOF-FLAG
           WRITE REPORT-LINE
               FROM "ID   Region  Amount        Tier"
           WRITE REPORT-LINE
               FROM "---  ------  ------------  --------"
           READ SALES-FILE
               AT END MOVE 'Y' TO WS-EOF-FLAG
           END-READ.

       2000-PROCESS-RECORDS.
           ADD 1               TO WS-RECORD-COUNT
           ADD SR-AMOUNT       TO WS-TOTAL-SALES

           IF SR-AMOUNT > WS-HIGH-SALE
               MOVE SR-AMOUNT       TO WS-HIGH-SALE
               MOVE SR-SALESPERSON-ID TO WS-HIGH-SALESPERSON
           END-IF

           MOVE SR-SALESPERSON-ID  TO WDL-ID
           MOVE SR-REGION          TO WDL-REGION
           MOVE SR-AMOUNT          TO WDL-AMOUNT

           EVALUATE TRUE
               WHEN SR-AMOUNT >= 100000
                   MOVE 'PLATINUM' TO WDL-TIER
               WHEN SR-AMOUNT >= 50000
                   MOVE 'GOLD    ' TO WDL-TIER
               WHEN SR-AMOUNT >= 10000
                   MOVE 'SILVER  ' TO WDL-TIER
               WHEN OTHER
                   MOVE 'BRONZE  ' TO WDL-TIER
           END-EVALUATE

           WRITE REPORT-LINE FROM WS-DETAIL-LINE

           READ SALES-FILE
               AT END MOVE 'Y' TO WS-EOF-FLAG
           END-READ.

       3000-WRITE-SUMMARY.
           IF WS-RECORD-COUNT > 0
               COMPUTE WS-AVERAGE =
                   WS-TOTAL-SALES / WS-RECORD-COUNT
           END-IF

           MOVE WS-TOTAL-SALES     TO WS-DISP-TOTAL
           MOVE WS-HIGH-SALE       TO WS-DISP-HIGH
           MOVE WS-RECORD-COUNT    TO WS-DISP-COUNT
           MOVE WS-AVERAGE         TO WS-DISP-AVERAGE

           WRITE REPORT-LINE FROM SPACES
           WRITE REPORT-LINE
               FROM "--- SUMMARY ---"
           WRITE REPORT-LINE
               FROM "Records   : " & WS-DISP-COUNT
           WRITE REPORT-LINE
               FROM "Total     : " & WS-DISP-TOTAL
           WRITE REPORT-LINE
               FROM "Average   : " & WS-DISP-AVERAGE
           WRITE REPORT-LINE
               FROM "Top Sale  : " & WS-DISP-HIGH
                    & "  (" & WS-HIGH-SALESPERSON & ")".

       9000-TERMINATE.
           CLOSE SALES-FILE
           CLOSE REPORT-FILE.