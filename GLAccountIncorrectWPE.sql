SET NOCOUNT ON
Declare @input Varchar(4000),@SQL Varchar(max),@Company varchar(200)
Declare @Result TABLE(Value varchar(max))

SELECT  @input=udfUserDefField4 FROM WCAppConnectorSetting
BEGIN
      DECLARE @str VARCHAR(20)
      DECLARE @ind Int
      IF(@input is not null)
      BEGIN
           SET @ind = CharIndex(',',@input)
            WHILE @ind > 0
            BEGIN
                  SET @str = SUBSTRING(@input,1,@ind-1)
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)
                  INSERT INTO @Result values (@str)
                  SET @ind = CharIndex(',',@input)
            END
            SET @str = @input
            INSERT INTO @Result values (@str)
      END
	  DECLARE curCompany cursor FOR
	  SELECT value 
	  FROM  @Result

	  OPEN curCompany 
	  FETCH NEXT FROM curCompany INTO @Company
	  WHILE @@FETCH_STATUS<>-1
	  BEGIN
		SET @SQL='SELECT b.*,a.ACTINDX
		    FROM '+@Company++'..GL00105 a WITH (NOLOCK)
			INNER JOIN GLAccount B WITH (NOLOCK) ON a.ACTNUMST=b.idfGLID
			AND b.idfEAICLink like ''%'+@Company+'%''
			AND convert(varchar,ACTINDX)<>SUBSTRING(idfEAICLink,0,CHARINDEX('''+@Company+''',idfEAICLink,0))'
		--PRINT @SQL
		EXEC (@SQL)
		FETCH NEXT FROM curCompany INTO @Company
	  END

	  CLOSE curCompany
	  DEALLOCATE curCompany
	  
END