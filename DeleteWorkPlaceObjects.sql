DECLARE curDelete CURSOR
READ_ONLY
FOR 
SELECT 
	DISTINCT o.name,o.type
FROM dbo.sysobjects o 
	INNER JOIN dbo.WCInstallObject i WITH (NOLOCK) ON i.idfObjectDBName = DB_NAME() AND i.idfObjectID=o.id
WHERE o.type='TR' 
UNION ALL
SELECT 
	DISTINCT o.name,o.type
FROM dbo.sysobjects o 
WHERE o.type='TR' AND name like 'IFC_%'
	
DECLARE @name nvarchar(200),@type VARCHAR(10), @sql NVARCHAR(2000)
OPEN curDelete

FETCH NEXT FROM curDelete INTO @name,@type
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		IF @type = 'TR'
			SET @sql = N'DROP TRIGGER '+@name
		--ELSE IF @type = 'V'
		--	SET @sql = N'DROP VIEW '+@name
		--ELSE IF @type = 'U'	
		--	SET @sql = N'DROP TABLE '+@name
		--ELSE IF @type = 'FN'
		--	SET @sql = N'DROP FUNCTION '+@name
		--ELSE IF @type = 'P'
		--	SET @sql = N'DROP PROCEDURE '+@name
	
		
		EXEC sp_executesql @sql
		
		DECLARE @message varchar(100)
		SELECT @message = 'dropped: ' + @name
		PRINT @message
	END
	FETCH NEXT FROM curDelete INTO @name,@type
END

CLOSE curDelete
DEALLOCATE curDelete
GO

