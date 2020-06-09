----------BEGIN UPDATE STATISTICS----------
SET NOCOUNT ON

DECLARE @strTableName VARCHAR(255),
		@strSQL NVARCHAR(MAX)

DECLARE curTables INSENSITIVE CURSOR FOR 
SELECT idfTableName 
FROM [dbo].[WCDataObject] D 
INNER JOIN sys.tables T ON T.name = D.idfTableName
WHERE idfDatabase = 'COMPANY'

OPEN curTables

FETCH NEXT FROM curTables INTO @strTableName

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		
		SELECT @strSQL = N'UPDATE STATISTICS [dbo].[' + @strTableName + ']' + char(13) + char(10) + 'WITH FULLSCAN' + char(13) + char(10)
		--select @strSQL
		EXEC sp_executesql @strSQL

	END
	FETCH NEXT FROM curTables INTO @strTableName
END
		
CLOSE curTables
DEALLOCATE curTables
----------END UPDATE STATISTICS----------



----------BEGIN REBUILD/DEFRAG INDEXES----------
-- Declare variables
SET NOCOUNT ON
DECLARE @tablename VARCHAR (128)
DECLARE @execstr   VARCHAR (255)
DECLARE @objectid  INT
DECLARE @indexid   INT
DECLARE @frag      DECIMAL
DECLARE @maxfrag   DECIMAL

-- Decide on the maximum fragmentation to allow
SELECT @maxfrag = 30.0

-- Declare cursor
DECLARE tables CURSOR FOR
   SELECT TABLE_NAME
   FROM INFORMATION_SCHEMA.TABLES T
   INNER JOIN WCDataObject D ON D.idfTableName = T.TABLE_NAME
   WHERE TABLE_TYPE = 'BASE TABLE'

-- Create the table
CREATE TABLE #fraglist (
   ObjectName CHAR (255),
   ObjectId INT,
   IndexName CHAR (255),
   IndexId INT,
   Lvl INT,
   CountPages INT,
   CountRows INT,
   MinRecSize INT,
   MaxRecSize INT,
   AvgRecSize INT,
   ForRecCount INT,
   Extents INT,
   ExtentSwitches INT,
   AvgFreeBytes INT,
   AvgPageDensity INT,
   ScanDensity DECIMAL,
   BestCount INT,
   ActualCount INT,
   LogicalFrag DECIMAL,
   ExtentFrag DECIMAL)

-- Open the cursor
OPEN tables

-- Loop through all the tables in the database
FETCH NEXT
   FROM tables
   INTO @tablename

WHILE @@FETCH_STATUS = 0
BEGIN
-- Do the showcontig of all indexes of the table
   INSERT INTO #fraglist 
   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''') 
      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')
   FETCH NEXT
      FROM tables
      INTO @tablename
END

-- Close and deallocate the cursor
CLOSE tables
DEALLOCATE tables

-- Declare cursor for list of indexes to be defragged
DECLARE indexes CURSOR FOR
   SELECT ObjectName, ObjectId, IndexId, LogicalFrag
   FROM #fraglist
   WHERE LogicalFrag >= @maxfrag
      AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0

-- Open the cursor
OPEN indexes

-- loop through the indexes
FETCH NEXT
   FROM indexes
   INTO @tablename, @objectid, @indexid, @frag

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT 'Executing DBCC INDEXDEFRAG (0, ' + RTRIM(@tablename) + ',
      ' + RTRIM(@indexid) + ') - fragmentation currently '
       + RTRIM(CONVERT(varchar(15),@frag)) + '%'
   SELECT @execstr = 'DBCC INDEXDEFRAG (0, ' + RTRIM(@objectid) + ',
       ' + RTRIM(@indexid) + ')'
   EXEC (@execstr)

   FETCH NEXT
      FROM indexes
      INTO @tablename, @objectid, @indexid, @frag
END

-- Close and deallocate the cursor
CLOSE indexes
DEALLOCATE indexes

-- Delete the temporary table
DROP TABLE #fraglist
GO
----------END REBUILD/DEFRAG INDEXES----------