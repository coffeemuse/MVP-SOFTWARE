THIS IS SPUFI (DB2I) INPUT TO CREATE AND LOAD THE DB2 TABLES NEEDED
FOR THE EXAMPLE 'DB2INQ1' PROGRAM USED IN KOOKBOOK RECIPE #13. NOTE
THIS IS ONLY POSSIBLE IN Z/OS, AND ONLY IF YOU HAVE INSTALLED DB2.

IT IS ASSUMED YOU WILL UPDATE THESE MEMBERS AS NECESSARY, FOR EXAMPLE
TO ALTER THE VOLUME / ALIAS IN THE STOGR1 MEMBER.

ALSO PLEASE BE SURE TO SELECT THE APPROPRIATE DB2 SUBSYSTEM (IN DB2I
DEFAULTS) BEFORE RUNNING ANY OF THESE.

SOME SHOPS MAY NOT REQUIRE (AND/OR MAY NOT ALLOW) YOU TO DEFINE
YOUR OWN STOGROUPS, DATABASES, OR TABLESPACES SO SOME OF THESE MAY
NOT APPLY TO YOUR INSTALLATION. PLEASE CONSULT YOUR LOCAL DB2
DATABASE ADMINISTRATOR IF YOU ARE UNSURE HOW TO PROCEED.

THESE MEMBERS WOULD NORMALLY BE USED IN THE FOLLOWING ORDER:

STOGR1   - DEFINES A STOGROUP   (IF NECESSARY)
DB1      - DEFINES A DATABASE   (IF NECESSARY)
TABSP1   - DEFINES A TABLESPACE (IF NECESSARY)
CUSTDEF  - DEFINES THE CUSTOMER TABLE, PRIMARY KEY, AND INDEX
CUSTLOD  - LOADS DATA INTO THE CUSTOMER TABLE
CUSTREAD - TESTS READ OF THE CUSTOMER TABLE
INVDEF   - DEFINES THE INVOICE TABLE, PRIMARY KEY, AND INDEX
INVLOD   - LOADS DATA INTO THE INVOICE TABLE
INVREAD  - TESTS READ OF THE INVOICE TABLE
READBOTH - TESTS READ OF SELECTED CUSTOMER AND INVOICE ROWS
KILLIT   - DELETES TABLESPACE, DATABASE, STOGROUP (IF NECESSARY)

