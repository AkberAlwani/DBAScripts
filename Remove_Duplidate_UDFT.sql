BEGIN TRAN
--SELECT * INTO WCUDFTemplateDtl_bak from WCUDFTemplateDtl a  WITH (NOLOCK)
--SELECT 'BEFORE REMOVE',* from WCUDFTemplateDtl_bak

DECLARE @UDFDtl TABLE (idfWCUDFTemplateDtlKey INT,idfWCUDFTemplateHdrKey INT,idfWCUDFTemplateFieldKey INT)
DECLARE @nidfWCUDFTemplateDtlKey INT, @nidfWCUDFTemplateHdrKey INT,@nidfWCUDFTemplateFieldKey INT

DECLARE zcurDup CURSOR
FOR SELECT idfWCUDFTemplateDtlKey,idfWCUDFTemplateHdrKey ,idfWCUDFTemplateFieldKey 
from WCUDFTemplateDtl a  WITH (NOLOCK)
where exists
(select idfWCUDFTemplateFieldKey 
from WCUDFTemplateDtl b  WITH (NOLOCK)
where a.idfWCUDFTemplateHdrKey=b.idfWCUDFTemplateHdrKey and a.idfWCUDFTemplateFieldKey=b.idfWCUDFTemplateFieldKey
group by idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey  having count(*)>1)




OPEN zcurDup

FETCH zcurDup INTO @nidfWCUDFTemplateDtlKey , @nidfWCUDFTemplateHdrKey,@nidfWCUDFTemplateFieldKey

DECLARE @nNewLineNumber INT

WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM @UDFDtl WHERE idfWCUDFTemplateFieldKey = @nidfWCUDFTemplateFieldKey)
			DELETE FROM WCUDFTemplateDtl WHERE idfWCUDFTemplateDtlKey = @nidfWCUDFTemplateDtlKey 
		ELSE
			INSERT INTO @UDFDtl (idfWCUDFTemplateDtlKey,idfWCUDFTemplateHdrKey ,idfWCUDFTemplateFieldKey) VALUES (@nidfWCUDFTemplateDtlKey,@nidfWCUDFTemplateHdrKey,@nidfWCUDFTemplateFieldKey)
	END --@@fetch_status <> -2

	FETCH zcurDup INTO @nidfWCUDFTemplateDtlKey , @nidfWCUDFTemplateHdrKey,@nidfWCUDFTemplateFieldKey
END --@@fetch_status <> -1
CLOSE zcurDup
DEALLOCATE zcurDup

SELECT 'AFTER REMOVE',*
from WCUDFTemplateDtl a  WITH (NOLOCK)
where exists
(select idfWCUDFTemplateFieldKey 
from WCUDFTemplateDtl b  WITH (NOLOCK)
where a.idfWCUDFTemplateHdrKey=b.idfWCUDFTemplateHdrKey and a.idfWCUDFTemplateFieldKey=b.idfWCUDFTemplateFieldKey
group by idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey  having count(*)>1)

SELECT * FROM WCUDFTemplateDtl a  WITH (NOLOCK)
WHERE EXISTS 
(select idfWCUDFTemplateFieldKey 
from WCUDFTemplateDtl_bak b  WITH (NOLOCK)
where a.idfWCUDFTemplateHdrKey=b.idfWCUDFTemplateHdrKey and a.idfWCUDFTemplateFieldKey=b.idfWCUDFTemplateFieldKey
group by idfWCUDFTemplateHdrKey,idfWCUDFTemplateFieldKey  having count(*)>1)

--SELECT * from @UDFDtl
SELECT COUNT(*) from WCUDFTemplateDtl
SELECT COUNT(*) from WCUDFTemplateDtl_bak
COMMIT TRAN


