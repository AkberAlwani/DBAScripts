use TWO
declare   
@TableName varchar(300),  
@ColumnName varchar(300),  
@SQLText varchar(max),  
@CharacterMaxLen varchar(max),  
@CollationName varchar(max),  
@IsNullable varchar(max),  
@DataType varchar(max)  
  
SET @CollationName = 'SQL_Latin1_General_CP1_CI_AS' --provide the required collation  
  
Declare MyTableCursor cursor for  
SELECT name FROM sys.tables WHERE [type] = 'U' and name <> 'sysdiagrams' ORDER BY name   
OPEN MyTableCursor  
  
FETCH NEXT FROM MyTableCursor INTO @TableName  
WHILE @@FETCH_STATUS = 0  
    BEGIN  
        DECLARE MyColumnCursor Cursor  
        FOR   
        SELECT COLUMN_NAME,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,  
            IS_NULLABLE from INFORMATION_SCHEMA.COLUMNS
            WHERE table_name = @TableName AND  (Data_Type LIKE '%char%'   
            OR Data_Type LIKE '%text%') AND COLLATION_NAME <> @CollationName  
            AND @TableName NOT LIKE 'MS%' --remove the tables which starts with MS i.e. MSpeer and MSmerge etc  
            ORDER BY ordinal_position   
        Open MyColumnCursor  
  
        FETCH NEXT FROM MyColumnCursor INTO @ColumnName, @DataType,   
              @CharacterMaxLen, @IsNullable  
        WHILE @@FETCH_STATUS = 0  
            BEGIN  
            SET @SQLText = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN [' + @ColumnName + '] ' + @DataType + CASE @DataType  WHEN 'text' THEN '' WHEN 'ntext' THEN '' ELSE + '(' + CASE WHEN @CharacterMaxLen = -1 THEN 'MAX' ELSE @CharacterMaxLen END + ')' END +' '+ 'COLLATE ' + @CollationName + ' ' +  CASE WHEN @IsNullable = 'NO' THEN 'NOT NULL' ELSE 'NULL' END  
            PRINT @SQLText   
            PRINT 'GO'  
        FETCH NEXT FROM MyColumnCursor INTO @ColumnName, @DataType,   
              @CharacterMaxLen, @IsNullable  
        END  
        CLOSE MyColumnCursor  
        DEALLOCATE MyColumnCursor  
--Print @SQLText  
FETCH NEXT FROM MyTableCursor INTO @TableName  
END  
CLOSE MyTableCursor  
DEALLOCATE MyTableCursor 