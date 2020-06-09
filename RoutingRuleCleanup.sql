UPDATE dbo.WCRRTemplateDtl
SET idfRQStoredProc = WCRRTemplate.idfRQStoredProc
FROM dbo.WCRRTemplateDtl WITH (NOLOCK)
INNER JOIN dbo.WCRRTemplate WITH (NOLOCK) ON WCRRTemplateDtl.idfWCRRTemplateKey = WCRRTemplate.idfWCRRTemplateKey
WHERE WCRRTemplate.idfWCRRTemplateKey = 6 AND ISNULL(WCRRTemplateDtl.idfRQStoredProc,'') = ''
GO

UPDATE dbo.WCRRTemplateDtl
SET idfRCVStoredProc = WCRRTemplate.idfRCVStoredProc
FROM dbo.WCRRTemplateDtl WITH (NOLOCK)
INNER JOIN dbo.WCRRTemplate WITH (NOLOCK) ON WCRRTemplateDtl.idfWCRRTemplateKey = WCRRTemplate.idfWCRRTemplateKey
WHERE WCRRTemplate.idfWCRRTemplateKey = 348 AND ISNULL(WCRRTemplateDtl.idfRCVStoredProc,'') = ''
GO

EXEC spWCRRTemplateDtlSetRuleAll
GO