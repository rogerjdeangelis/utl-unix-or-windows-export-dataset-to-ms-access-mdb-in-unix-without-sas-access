Unix or windows export dataset to ms access mdb without sas access

github
https://tinyurl.com/yawyuntu
https://github.com/rogerjdeangelis/utl-unix-or-windows-export-dataset-to-ms-access-mdb-in-unix-without-sas-access

SAS  Forum
https://tinyurl.com/y9hvhgcl
https://communities.sas.com/t5/SAS-Enterprise-Guide/SAS-EG-7-1-Export-to-mdb-by-code-Unix-Server/m-p/502037

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


METHOD
======

   1. Because MS Access has changed the layout of access databases many times you need to use
      the demo.mdb that SAS provides or get one off the net. Should with accdb.

      C:\Program Files\sashome\SASFoundation\9.4\access\sasmisc\demo.mdb

      %bincop(
        in=C:\Program Files\sashome\SASFoundation\9.4\access\sasmisc\demo.mdb
       ,out=d:\mdb\utl-export-a-sas-dataset-to-ms-access-mdb-in-unix.mdb
      );

   2. Create SAS dataset to export

   3. Run 32bit R ODBC script to export dataset


INPUT
=====

 SD1.HAVE total obs=19

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14     69.0      112.5
    Alice       F      13     56.5       84.0
    Barbara     F      13     65.3       98.0
    Carol       F      14     62.8      102.5
    Henry       M      14     63.5      102.5
    James       M      12     57.3       83.0
    Jane        F      12     59.8       84.5
    Janet       F      15     62.5      112.5
   ...

EXAMPLE OUTPUT
--------------

   Libref         MDB
   Engine         ACCESS
   Physical Name  d:/mdb/utl-export-a-sas-dataset-to-ms-access-mdb-in-unix.mdb
   User           Admin


                         DBMS
                 Member  Member
   #  Name       Type    Type

   1  HAVE       DATA    TABLE

   Data Set Name        MDB.have    Observations          .
   Member Type          DATA        Variables             5
   Engine               ACCESS      Indexes               0
   Created              .           Observation Length    0


            Alphabetic List of Variables and Attributes

    Variable    Type    Len    Format    Informat    Label

    NAME        Char    255    $255.     $255.       NAME
    SEX         Char    255    $255.     $255.       SEX
    AGE         Num       8                          AGE
    HEIGHT      Num       8                          HEIGHT
    WEIGHT      Num       8                          WEIGHT

   mdb.HAVE

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14     69.0      112.5
    Alice       F      13     56.5       84.0
    Barbara     F      13     65.3       98.0
    Carol       F      14     62.8      102.5


PROCESS
=======

* need 32bit R;
%utl_submit_r32("
    library(RODBC);
    library(haven);
    library(sqldf);
    library(RSQLite);
    have<-read_sas('d:/sd1/have.sas7bdat');
    head(have);
    myDB <- odbcConnectAccess('d:/mdb/utl-export-a-sas-dataset-to-ms-access-mdb-in-unix.mdb'
       ,uid='admin',pwd='');
    sqlSave(myDB,have,rownames=FALSE);
");

CHECK
-----

* I only used SAS Access to check you do not need it to expot the SAS dataset;

libname mdb "d:/mdb/utl-export-a-sas-dataset-to-ms-access-mdb-in-unix.mdb";

proc sql;
 drop table mdb.have
;quit;

libname mdb clear;

proc contents data=mdb._all_;
run;quit;

proc print data=mdb.have width=min;
run;quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  set sashelp.class;
run;quit;
libname sd1 clear;

