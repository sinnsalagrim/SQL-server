-----------  session 2 -----------
--- database creation commands
create database db1
on primary --- a file spec
(
name = DB1_datafile1
filename = 'c:\db\DB1_datafile1.mdf' ---where is it located
size = 100MB ---size when it is created
maxsize = 120MB
filegrowth = 10%
)

log on
 (
name = DB1_name = DB1_datafile1
filename = 'c:\db\DB1_datafile1.ldf' 
size = 100MB 
maxsize = 120MB
filegrowth = 10%
 )

create database db2
on primary
(
name = DB2_datafile1
filename = 'c:\db\DB2_datafile1.mdf' 
size = 100MB 
maxsize = 120MB
filegrowth = 10%
), filegroup FG2
 (
name = DB2_datafile3
filename = 'c:\db\DB2_datafile3.ndf' 
size = 100MB 
maxsize = 120MB
filegrowth = 10%
 )

log on
 (
name = DB2_name = DB2_datafile1
filename = 'c:\db\DB1_datafile1.ldf' 
size = 100MB 
maxsize = 120MB
filegrowth = 10%
 ),
  (
name = DB2_name = DB2_datafile2
filename = 'c:\db\DB1_datafile2.ldf' 
size = 100MB 
maxsize = 120MB
filegrowth = 10%
 )

 --- recovery model (on log files) 
 alter database databaseName
 set recovery = {full|simple|bulk logged}

 --- create statistics
 create statistics on databaseName tableName
 
 --- create a new table
 use testdb
 go -- if we do not use go, creates table in Master
 create table Students AS s -- alliasing
 (
 ID int primary key IDENTITY(1,1) NOT NULL
 [Name] nvarchar(60)
 ,Family nvarchar(60) --put comma at the start of the line to facilitate commenting
 );

 parse('2017-08-03' AS DATE using 'en-US')

 ---natively compiled (in memory) stored procedure
 create procedure dbo.table1
 @table1 dbo.tt.table1 readonly
 with native_compilation schemabinding
 as
 being atomic
 with (transation isolation level = snapshot, language= N'us_english')

