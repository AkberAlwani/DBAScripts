USE WPELIVE
DECLARE @StringInput VARCHAR(8000)
DECLARE @String    VARCHAR(10)
DECLARE @Delimiter NVARCHAR(1) = ','
DECLARE @OutputTable TABLE (String VARCHAR(10) )

SELECT @StringInput = udfUserDefField5
FROM WCAppConnectorSetting

SELECT @StringInput = REPLACE(@StringInput,' ','')

WHILE LEN(@StringInput) > 0
BEGIN
      SET @String      = LEFT(@StringInput, 
                                    ISNULL(NULLIF(CHARINDEX(@Delimiter, @StringInput) - 1, -1),
                                    LEN(@StringInput)))
      SET @StringInput = SUBSTRING(@StringInput,
                                          ISNULL(NULLIF(CHARINDEX(@Delimiter, @StringInput), 0),
                                          LEN(@StringInput)) + 1, LEN(@StringInput))

      INSERT INTO @OutputTable (String)
      VALUES (@String)
END

SELECT 'DELETE '+String+'..WPEAICLog' FROM @OutputTable

