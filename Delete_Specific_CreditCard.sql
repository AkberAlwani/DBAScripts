DECLARE @UserID INT
SELECT @UserID=idfWCSecurityKey from WCSecurity where idfSecurityID='WORKGROUP\motman'
SELECT * from EXPCreditCard WHERE idfWCSecurityKey=@UserID and idfAmtExtended in (130,279.80)
--DELETE from EXPCreditCard WHERE idfWCSecurityKey=@UserID and idfAmtExtended in (130,279.80)

select * from WCListDtl

	SELECT idfRestrictByValueType, idfRestrictByValue 
	FROM WCSecurity S (NOLOCK)
		INNER JOIN WCUDFTemplateDtl U (NOLOCK) ON S.idfWCUDFTemplateKey = U.idfWCUDFTemplateHdrKey 
	WHERE S.idfSecurityID = dbo.fnWCSecurity('')
		AND idfWCUDFTemplateFieldKey = 150  

select * from WCSystemSetting  where idfValue like 'New Name%'
 UPDATE dbo.WCLanguageResourceD SET idfDescription='New Name' WHERE idfResourceID='RQHdridfDescription' AND idfWCLanguageKey=2

 select * from WCLanguage

 truncate table CATCatalog
 truncate table CATCategory
 truncate table CATItem
