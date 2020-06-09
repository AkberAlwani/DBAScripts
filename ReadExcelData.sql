IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ReadCSVFile')
DROP PROCEDURE sp_ReadCSVFile
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ReadExcelFile')
DROP PROCEDURE sp_ReadExcelFile
GO

IF EXISTS (
SELECT * FROM sysobjects WHERE id = object_id(N'fn_SplitString')
AND xtype IN (N'FN', N'IF', N'TF')
)
DROP FUNCTION fn_SplitString
GO

/*

Remember to put a file Schema.ini in same folder as csv file. Also '@TargetTable’ parameter should be csv file name (but without Extension)

exec sp_ReadCSVFile 'C:\tmp’, 'EmpData’

[EmpData.csv]
FORMAT=Delimited(;)
ColNameHeader=True
MaxScanRows=0
CharacterSet=ANSI
TextDelimiter=`
DecimalSymbol=.
COL1=EmpId TEXT
COL2=FirstName TEXT
COL3=LastName TEXT
COL4=MiddleName TEXT
COL5=EmailAddr TEXT
*/
CREATE PROCEDURE sp_ReadCSVFile
(
@TargetFolder varchar(255),
@TargetTable varchar(255)
)
AS
BEGIN
declare @SqlStmt nvarchar(max)

set @SqlStmt = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N"[dbo].[' + @TargetTable + ']") AND type in (N"U"))'
set @SqlStmt = @SqlStmt + ' TRUNCATE TABLE ' + @TargetTable
PRINT @SqlStmt
exec sp_executesql @SqlStmt

set @SqlStmt = ' SELECT * INTO ' + @TargetTable
+ ' FROM OpenDataSource ("Microsoft.ACE.OLEDB.12.0", "Data Source="' + @TargetFolder + '";Extended properties=Text")…['
+ @TargetTable + '#csv]'
PRINT @SqlStmt
exec sp_executesql @SqlStmt
END
GO

--/*
--Usage:
--exec sp_ReadExcelFile 'C:\Receive', 'GLAccount', 'GLAccount.xls’, '[Sheet1$]', 'Col1,Col2,Col3,Col4,Col5'
--*/

CREATE PROCEDURE sp_ReadExcelFile
(
@TargetFolder varchar(255), /* For example, 'C:\tmp’ */
@TargetTable varchar(255), /* For example, 'EmpData’ */
@ExcelFile varchar(255), /* For example, 'EmpData.xls’ */
@ExcelSheet varchar(255), /* For example, '[Sheet1$]’ */
@ExcelFields varchar(8000) /* Comma separate list, for example: 'Col1,Col2,Col3,Col4,Col5′ */
)
AS
BEGIN
declare @SqlStmt nvarchar(max)
declare @FirstColumn nvarchar(255)

set @SqlStmt = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N"[dbo].[' + @TargetTable + ']") AND type in (N"U"))'
set @SqlStmt = @SqlStmt + ' DROP TABLE '+ @TargetTable
PRINT @SqlStmt
exec sp_executesql @SqlStmt

select top 1 @FirstColumn=[part] from dbo.fn_SplitString(@ExcelFields, ',')
print 'FirstColumn: ' + @FirstColumn

set @SqlStmt = 'SELECT ' + @ExcelFields + ' INTO ' + @TargetTable + ' FROM OPENROWSET("Microsoft.ACE.OLEDB.12.0","Excel 12.0;DATABASE=' + @TargetFolder + '\' + @ExcelFile + ';IMEX=1", "Select * from ' + @ExcelSheet + ''' )'
+ 'WHERE NOT ' + @FirstColumn + ' IS NULL'
PRINT @SqlStmt
exec sp_executesql @SqlStmt
END
GO

/*
Taken from: http://stackoverflow.com/questions/697519/split-function-equivalent-in-t-sql
Usage: select top 1 part from fn_SplitString('aaa,bbb,ccc,ddd,eee’,’,’)
*/

CREATE FUNCTION [dbo].[fn_SplitString]
(
@sString nvarchar(2048),
@cDelimiter nchar(1)
)
RETURNS @tParts TABLE ( part nvarchar(2048) )
AS
BEGIN
if @sString is null return
declare @iStart int,
@iPos int
if substring( @sString, 1, 1 ) = @cDelimiter
begin
set @iStart = 2
insert into @tParts
values( null )
end
else
set @iStart = 1
while 1=1
begin
	set @iPos = charindex( @cDelimiter, @sString, @iStart )
	if @iPos = 0
	set @iPos = len( @sString )+1
	if @iPos - @iStart > 0
		insert into @tParts
			values ( substring( @sString, @iStart, @iPos-@iStart ))
	else
		insert into @tParts values( null )
	set @iStart = @iPos+1
	if @iStart > len( @sString )
		break
	end
RETURN
END
GO



use master
EXEC sp_addlinkedserver
     @server = N'EXCELDATA',
     @srvproduct = N'Excel',
     @provider = N'Microsoft.ACE.OLEDB.12.0',
     @datasrc = N'C:\Receive\GLAccount.xlsx',
     @provstr = N'Excel 12.0';
 
EXEC sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
EXEC sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE WITH OVERRIDE
 
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\Receive\GLAccount.xlsx;', 'SELECT * FROM [Sheet1$]')
SELECT * FROM EXCELDATA...[Sheet1$]
 
