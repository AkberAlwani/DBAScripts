SET NOCOUNT ON

DELETE PTIMaster..PTISecurity
GO

DECLARE @DBs TABLE (idfPTICompanyKey INT, idfDBName VARCHAR(60))
DECLARE @strSQL VARCHAR(2000), @DB INT

INSERT INTO @DBs SELECT idfPTICompanyKey,idfDBName FROM PTIMaster..PTICompany INNER JOIN sys.databases ON idfDBName = name

WHILE EXISTS (SELECT TOP 1 1 FROM @DBs) BEGIN
SELECT @DB = idfPTICompanyKey FROM @DBs
SELECT @strSQL = 'IF EXISTS (SELECT TOP 1 1 FROM '+idfDBName+'.sys.procedures WHERE name = ''spPTIFixDB'') '
+ 'EXEC '+idfDBName+'.dbo.spPTIFixDB' FROM @DBs WHERE idfPTICompanyKey = @DB
EXEC (@strSQL)
DELETE FROM @DBs WHERE idfPTICompanyKey = @DB
END
