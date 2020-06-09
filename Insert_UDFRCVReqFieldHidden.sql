
Declare @rowID int
SELECT  @Rowid=Max(idfWCUDFTemplateDtlKey)+1 from WCUDFTemplateDtl
INSERT INTO WCUDFTemplateDtl (idfWCUDFTemplateDtlKey,idfDateCreated,idfDefaultValue,idfDefaultValueType,idfFlagDefault,idfFlagHidden,idfFlagReadOnly,idfFlagRequired,idfRestrictByValue
           ,idfRestrictByValueType,idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey)
SELECT @rowID+ROW_NUMBER() OVER(ORDER BY idfWCUDFTemplateHdrkey) ,getdate(),'','C',0,1,0,0,'','C',idfWCUDFTemplateHdrkey,393 
FROM WCUDFTemplateHdr a (NOLOCK) 
where Not exists (select idfWCUDFTemplateHdrkey from WCUDFTemplateDtl b (NOLOCK) 
   WHERE a.idfWCUDFTemplateHdrkey =b.idfWCUDFTemplateHdrkey and idfWCUDFTemplateFieldkey=393)

GO
exec spPTIFixPrimaryKey
exec spPTIFixPrimaryKeySequence 1


-- WPE Hide Expense > Organization Field
Declare @rowID int
EXEC spWCGetNextPK 'WCUDFTemplateDtl',@rowID OUTPUT
--SELECT @rowID+ROW_NUMBER() OVER(ORDER BY idfWCUDFTemplateHdrkey) ,getdate(),'','K',0,1,0,0,'','K',idfWCUDFTemplateHdrkey,514
--FROM WCUDFTemplateHdr a (NOLOCK) 
--where Not exists (select idfWCUDFTemplateHdrkey from WCUDFTemplateDtl b (NOLOCK) 
--   WHERE a.idfWCUDFTemplateHdrkey =b.idfWCUDFTemplateHdrkey and idfWCUDFTemplateFieldkey=514)

																							 
INSERT INTO WCUDFTemplateDtl (idfWCUDFTemplateDtlKey,idfDateCreated,idfDefaultValue,idfDefaultValueType,idfFlagDefault,idfFlagHidden,idfFlagReadOnly,idfFlagRequired,idfRestrictByValue
           ,idfRestrictByValueType,idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey)
SELECT @rowID+ROW_NUMBER() OVER(ORDER BY idfWCUDFTemplateHdrkey) ,getdate(),'','K',0,1,0,0,'','K',idfWCUDFTemplateHdrkey,514
FROM WCUDFTemplateHdr a (NOLOCK) 
where Not exists (select idfWCUDFTemplateHdrkey from WCUDFTemplateDtl b (NOLOCK) 
   WHERE a.idfWCUDFTemplateHdrkey =b.idfWCUDFTemplateHdrkey and idfWCUDFTemplateFieldkey=514)