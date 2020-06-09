SET NOCOUNT OFF
DECLARE   
 @nID    INT  
,@strMessage  VARCHAR(100)  
,@strQry   VARCHAR(8000)  
,@stridfSecurityID VARCHAR(256)  
,@nidfPTICompanyKey INT  
,@nPACompanyCount INT
--  
SET NOCOUNT ON
--  
-- Get Current Company ID.  
SELECT
	@nidfPTICompanyKey = idfPTICompanyKey
FROM vwFNACompany(NOLOCK)
INNER JOIN PTIMaster..PTICompany C (NOLOCK)
	ON C.edfCompanyCode = vwFNACompany.edfCompanyCode
		AND C.idfDBName = vwFNACompany.idfDBName

-- If there are multiple entries in PACompany then DO NOT UPDATE idfPTICompanyKey as Project is multi-company enabled and if the user is setup this way then  
-- all databases must be restored on seperate server and cannot be just a test database with the same control db.  
SELECT
	@nPACompanyCount = COUNT(1)
FROM dbo.PACompany WITH (NOLOCK)

IF (ISNULL(@nPACompanyCount, 0) <= 1)
BEGIN
-- ------------------------------------------------------------------------------------------------------------   
-- --- Update idfPTICompanyKey on All Tables except WCSecurity.  
-- ------------------------------------------------------------------------------------------------------------   
DECLARE curPTICompanyKey INSENSITIVE CURSOR FOR 
SELECT
	c.id
FROM syscolumns c
INNER JOIN sysobjects o
	ON c.id = o.id
WHERE c.name = 'idfPTICompanyKey'
AND o.type = 'U'

OPEN curPTICompanyKey

FETCH NEXT FROM curPTICompanyKey INTO @nID
WHILE (@@fetch_status <> -1)
BEGIN
IF (@@fetch_status <> -2)
BEGIN
-- Don't Update WCSecurity that has to be done by itself.  
IF (OBJECT_NAME(@nID) NOT IN ('WCSecurity', 'ARCustomer', 'PAProject', 'PAProjectPhase'))
BEGIN
SELECT
	@strMessage = 'Updating Table: ' + OBJECT_NAME(@nID)
PRINT @strMessage

SELECT
	@strQry = 'ALTER TABLE ' + OBJECT_NAME(@nID) + ' DISABLE TRIGGER ALL ' +
	' UPDATE ' + OBJECT_NAME(@nID) + ' SET idfPTICompanyKey = ' + CONVERT(VARCHAR(20), @nidfPTICompanyKey) + ' WHERE idfPTICompanyKey <> ' + CONVERT(VARCHAR(20), @nidfPTICompanyKey) 
	--	' ALTER TABLE ' + OBJECT_NAME(@nID) + ' ENABLE TRIGGER ALL '
	
      PRINT @strQry
EXECUTE (@strQry)
END
END
FETCH NEXT FROM curPTICompanyKey INTO @nID
END

CLOSE curPTICompanyKey
DEALLOCATE curPTICompanyKey
END