DECLARE @nidfWCUDFTemplateHdrKey INT,@nidfWCUDFTemplateDtlKey INT
DECLARE  @idfDateCreated datetime,@idfDateModified datetime,@idfDefaultValue varchar(255),@idfDefaultValueType char(1)
        ,@idfFlagDefault int,@idfFlagHidden int,@idfFlagReadOnly int,@idfFlagRequired int,@idfRestrictByValue varchar(255),@idfRestrictByValueType char(1)
        ,@idfWCUDFTemplateHdrKey int,@idfWCUDFTemplateFieldKey INT

DECLARE zcurHdr CURSOR FOR 
SELECT idfDefaultValue,idfDefaultValueType,idfFlagDefault,idfFlagHidden,idfFlagReadOnly,idfFlagRequired,idfRestrictByValue,idfRestrictByValueType,
       idfWCUDFTemplateFieldKey
FROM WCUDFTemplateDtl WITH (NOLOCK)  
WHERE idfWCUDFTemplateHdrKey In (SELECT idfWCUDFTemplateHdrKey 
                                  FROM WCUDFTemplateHdr WITH (NOLOCK)  
								  WHERE idfTemplateID='DEFAULT' )
								  

SELECT @nidfWCUDFTemplateDtlKey=Max(idfWCUDFTemplateDtlKey) from WCUDFTemplateDtl WITH (NOLOCK)
DECLARE zcurCC CURSOR
FOR SELECT idfWCUDFTemplateHdrKey from WCUDFTemplateHdr WITH (NOLOCK) 
WHERE idfTemplateID<>'DEFAULT' 
AND idfWCUDFTemplateHdrKey<5


OPEN zcurCC
FETCH zcurCC INTO @nidfWCUDFTemplateHdrKey

WHILE @@fetch_status <> -1
BEGIN
	PRINT @nidfWCUDFTemplateHdrKey
	BEGIN
	    OPEN zcurHdr
	    
		FETCH zcurHdr INTO @idfDefaultValue,@idfDefaultValueType,@idfFlagDefault,@idfFlagHidden,@idfFlagReadOnly,@idfFlagRequired,@idfRestrictByValue,@idfRestrictByValueType,@idfWCUDFTemplateFieldKey
		WHILE @@fetch_status <> -1
		BEGIN
			 --IF NOT EXISTS(SELECT TOP 1 1 from WCUDFTemplateDtl WITH (NOLOCK) WHERE idfWCUDFTemplateHdrKey=@nidfWCUDFTemplateHdrKey AND idfWCUDFTemplateFieldKey=@idfWCUDFTemplateFieldKey)
			 IF EXISTS(SELECT top 1 1 from WCUDFTemplateDtl WITH (NOLOCK) WHERE idfWCUDFTemplateHdrKey=@nidfWCUDFTemplateHdrKey AND idfWCUDFTemplateFieldKey=@idfWCUDFTemplateFieldKey)
			   BEGIN 
				SELECT top 1 @nidfWCUDFTemplateDtlKey=idfWCUDFTemplateDtlKey from WCUDFTemplateDtl WITH (NOLOCK) WHERE idfWCUDFTemplateHdrKey=@nidfWCUDFTemplateHdrKey AND idfWCUDFTemplateFieldKey=@idfWCUDFTemplateFieldKey
				UPDATE WCUDFTemplateDtl SET idfDefaultValue=@idfDefaultValue,idfDefaultValueType=@idfDefaultValueType,idfFlagDefault=@idfFlagDefault,idfFlagHidden=@idfFlagHidden,
				idfFlagReadOnly=@idfFlagReadOnly,idfFlagRequired=@idfFlagRequired,idfRestrictByValue=idfRestrictByValue,idfRestrictByValueType=@idfRestrictByValueType
				WHERE idfWCUDFTemplateDtlKey=@nidfWCUDFTemplateDtlKey
			   END
			 ELSE
			   BEGIN
				SET @nidfWCUDFTemplateDtlKey=@nidfWCUDFTemplateDtlKey+1   
				INSERT INTO WCUDFTemplateDtl
				(idfWCUDFTemplateDtlKey,idfDefaultValue,idfDefaultValueType,idfFlagDefault,idfFlagHidden,idfFlagReadOnly,idfFlagRequired,idfRestrictByValue,
				idfRestrictByValueType,idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey)
				VALUES (
				@nidfWCUDFTemplateDtlKey,@idfDefaultValue,@idfDefaultValueType,@idfFlagDefault,@idfFlagHidden,@idfFlagReadOnly,@idfFlagRequired,@idfRestrictByValue,@idfRestrictByValueType,
				@nidfWCUDFTemplateHdrKey,@idfWCUDFTemplateFieldKey)
			  END
		 
		  FETCH zcurHdr INTO @idfDefaultValue,@idfDefaultValueType,@idfFlagDefault,@idfFlagHidden,@idfFlagReadOnly,@idfFlagRequired,@idfRestrictByValue,@idfRestrictByValueType,@idfWCUDFTemplateFieldKey
	END	
	CLOSE zcurHdr
  END		
	
	FETCH zcurCC INTO @nidfWCUDFTemplateHdrKey
END --@@fetch_status <> -1
DEALLOCATE zcurHdr

CLOSE zcurCC
DEALLOCATE zcurCC



