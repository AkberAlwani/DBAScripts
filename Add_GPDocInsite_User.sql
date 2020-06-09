DECLARE @nidfWCUDFListHdrKey INT, @nCount INT, @nNextKey INT
DECLARE @tblTemp TABLE
(
		idfKey INT IDENTITY(0,1)
	,USERID VARCHAR(255)
	,USERNAME VARCHAR(255)
)
IF NOT EXISTS (SELECT TOP 1 1 
FROM dbo.WCUDFListDtl WITH (NOLOCK)
INNER JOIN dbo.WCUDFListHdr WITH (NOLOCK) ON WCUDFListHdr.idfWCUDFListHdrKey = WCUDFListDtl.idfWCUDFListHdrKey
WHERE idfCategory = 'LISTUDF01')
BEGIN
	INSERT INTO @tblTemp
	(
		 USERID
		,USERNAME
	)
	SELECT 
		 USERID
		,USERNAME
	FROM DYNAMICS..SY01400 WITH (NOLOCK)

	SELECT @nidfWCUDFListHdrKey = idfWCUDFListHdrKey FROM dbo.WCUDFListHdr WITH (NOLOCK) WHERE idfCategory = 'LISTUDF01'

	UPDATE WCUDFListHdr SET idfDescription = 'Dynamics GP User' WHERE idfCategory = 'LISTUDF01'

	SELECT @nCount = COUNT(*) FROM @tblTemp
	EXEC spWCGetNextPK 'WCUDFListDtl',@nNextKey OUTPUT, @nCount

	INSERT INTO WCUDFListDtl (idfWCUDFListDtlKey,idfDescription,idfEAICLink,idfID,idfDateCreated,idfDateModified,idfWCUDFListHdrKey)
	SELECT @nNextKey + idfKey,USERNAME,null,USERID,getdate(),getdate(),@nidfWCUDFListHdrKey
	FROM @tblTemp
END
ELSE
BEGIN
	INSERT INTO @tblTemp
	(
		 USERID
		,USERNAME
	)
	SELECT 
		 USERID
		,USERNAME
	FROM DYNAMICS..SY01400 WITH (NOLOCK)
	WHERE USERID NOT IN (SELECT idfID 
	                       FROM dbo.WCUDFListDtl WITH (NOLOCK)
						  INNER JOIN dbo.WCUDFListHdr WITH (NOLOCK) ON WCUDFListHdr.idfWCUDFListHdrKey = WCUDFListDtl.idfWCUDFListHdrKey
						   WHERE idfCategory = 'LISTUDF01')

	SELECT @nidfWCUDFListHdrKey = idfWCUDFListHdrKey FROM dbo.WCUDFListHdr WITH (NOLOCK) WHERE idfCategory = 'LISTUDF01'

	UPDATE WCUDFListHdr SET idfDescription = 'Dynamics GP User' WHERE idfCategory = 'LISTUDF01'

	
	SELECT @nCount = COUNT(*) FROM @tblTemp
	EXEC spWCGetNextPK 'WCUDFListDtl',@nNextKey OUTPUT, @nCount

	INSERT INTO WCUDFListDtl (idfWCUDFListDtlKey,idfDescription,idfEAICLink,idfID,idfDateCreated,idfDateModified,idfWCUDFListHdrKey)
	SELECT @nNextKey + idfKey,USERNAME,null,USERID,getdate(),getdate(),@nidfWCUDFListHdrKey
	FROM @tblTemp

END


