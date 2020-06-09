SELECT L.idfDescription AS 'Field'
              ,idfFlagHidden AS 'Hidden'
              ,idfFlagReadOnly AS 'Read Only'
              ,idfFlagRequired AS 'Required'
              ,idfFlagDefault AS 'Default'
              ,idfDefaultValue AS 'Default Value'
              ,CASE WHEN idfRestrictByValueType = 'L' THEN 'List' 
                    WHEN idfRestrictByValueType = 'K' THEN 'Individual'
                       ELSE 'N/A' END AS 'Restrict Type'
              ,idfRestrictByValue AS 'Restrict Value'
FROM WCUDFTemplateDtl D
INNER JOIN WCUDFTemplateField F ON D.idfWCUDFTemplateFieldKey = F.idfWCUDFTemplateFieldKey AND idfDataTableName LIKE 'RQ%'
INNER JOIN WCUDFTemplateHdr H ON D.idfWCUDFTemplateHdrKey = H.idfWCUDFTemplateHdrKey
INNER JOIN WCLanguageResourceD L ON L.idfResourceID = REPLACE(F.idfDescription,':','')
WHERE idfTemplateID = 'XXX' -- Replace xxx with the UDFT Name
