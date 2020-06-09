--select * from GLAccount where idfGLID='7080-0662-01'
SET NOCOUNT ON
Declare @input Varchar(4000),@SQL nvarchar(4000),@Company varchar(200),@rowcnt INT,
@GLACcount varchar(100),@GLId varchar(100)
Declare @Result TABLE(Value varchar(max))

SELECT  @input=udfUserDefField4 FROM WCAppConnectorSetting
BEGIN
      DECLARE @str VARCHAR(20)
      DECLARE @ind Int
	  DECLARE @CompanyID int
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
	 -- where VALUE ='FACT'

	  OPEN curCompany 
	  FETCH NEXT FROM curCompany INTO @Company
	  WHILE @@FETCH_STATUS<>-1
	  BEGIN
	    SELECT @CompanyID=idfWCICCompanyKey from WCICCompany where idfCompanyCode=@Company
	    SET @SQL='SELECT @rowcnt=count(a.ACTINDX) 
				  FROM '+@Company+'..GL00105 a WITH (NOLOCK)
			INNER JOIN GLAccount B WITH (NOLOCK) ON a.ACTNUMST=b.idfGLID
			AND CHARINDEX('''+@Company+''',b.idfEAICLink)>0
			AND CONVERT(varchar,ACTINDX)<>SUBSTRING(idfEAICLink,0,CHARINDEX('''+@Company+''',idfEAICLink,0))'
		EXEC Sp_executesql @SQL,N'@Company varchar(200), @rowcnt INT OUTPUT', @Company = @Company,@rowcnt=@rowcnt OUTPUT

		IF @rowcnt >=1
		BEGIN
		    -- Declare Currsor Here
			SET @SQL='DECLARE curGLAccount cursor FOR SELECT convert(varchar,a.ACTINDX)+'''+@Company+''' GLId,rtrim(a.ACTNUMST)
			FROM '+@Company+'..GL00105 a WITH (NOLOCK)
			INNER JOIN GLAccount B WITH (NOLOCK) ON a.ACTNUMST=b.idfGLID
			AND CHARINDEX('''+@Company+''',b.idfEAICLink)>0
			AND CONVERT(varchar,ACTINDX)<>SUBSTRING(idfEAICLink,0,CHARINDEX('''+@Company+''',idfEAICLink,0))'
			EXEC sp_executesql @SQL
			

			OPEN curGLAccount
			FETCH NEXT FROM curGLAccount INTO @GLId,@GlAccount
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--PRINT @SQL
				--set @sql='UPDATE GLAccount set idfEAICLink='''+@GLID+''' where idfGLID='''+@GLACcount+''' AND idfEAICLink like ''%'+@Company+'%'''
				set @sql='UPDATE GLAccount set idfEAICLink='''+@GLID+''' where idfGLID='''+@GLACcount+''' AND idfWCIcCompanyKey ='+Convert(varchar,@CompanyID)+''

				--@CompanyID
				PRINT @SQL
				--EXEC sp_executesql @SQL
				FETCH NEXT FROM curGLAccount INTO @GLId,@GlAccount
			END
			CLOSE curGLAccount
			DEALLOCATE curGLAccount
	     END
		 
		FETCH NEXT FROM curCompany INTO @Company
	  END
	  CLOSE curCompany
	  DEALLOCATE curCompany
END