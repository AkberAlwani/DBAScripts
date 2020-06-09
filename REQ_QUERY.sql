DECLARE @RQName VARCHAR(50);

SELECT @RQName = 
	CASE 
		WHEN dbo.fnWCLicenseAccess('RQREQUISITION') = 'YES' AND dbo.fnWCLicenseAccess('RQCHECKREQ') = 'NO' THEN 'Requisition' 
		WHEN dbo.fnWCLicenseAccess('RQREQUISITION') = 'NO' AND dbo.fnWCLicenseAccess('RQCHECKREQ') = 'YES' THEN 'Check Request' 
		ELSE 'Requisition / Check Request' 
	END
SELECT
    RH.idfDescription RequisitionName
   ,RH.idfRQHeaderKey AS Requisition_Number
   ,RH.idfDateCreated AS Created
   ,PA.idfProjectID

   ,REPLACE(LRD.idfDescription, '::RQNAME::', @RQName) AS Status_Description
   ,GL.idfGLID
FROM RQHeader RH WITH (NOLOCK) 
LEFT OUTER JOIN RQDetail RD WITH (NOLOCK) ON RH.idfRQHeaderKey = RD.idfRQHeaderKey 
LEFT OUTER JOIN RQSession RS WITH (NOLOCK) ON RD.idfRQSessionKey = RS.idfRQSessionKey 
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH(NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + RS.idfDescription + '%'
LEFT OUTER JOIN GLAccount GL (NOLOCK) ON RD.idfGLAccountKey=GL.idfGLAccountKey
LEFT OUTER JOIN RQDetailProjectDistribution PJ (NOLOCK) ON RD.idfRQDetailKey=PJ.idfRQDetailKey
LEFT OUTER JOIN PAProject PA (NOLOCK) ON PA.idfPAProjectKey=PJ.idfPAProjectKey



SELECT 'No Requisition/Check Request Created ' Flag,idfSecurityID,idfDescription 
 FROM WCSecurity AS S (NOLOCK)
WHERE idfFlagActiveRQ=1
AND NOT EXISTS (SELECT idfWCSecurityKey from RQHeader (NOLOCK) H WHERE H.idfWCSecurityKey=S.idfWCSecurityKey)

UNION
SELECT 'User was Approval ' Flag,idfSecurityID,idfDescription 
FROM (SELECT idfSecurityID,idfDescription,idfWCSecurityKey 
    FROM WCSecurity AS S (NOLOCK) 
	WHERE idfFlagActiveRQ=1
     AND NOT EXISTS (SELECT idfWCSecurityKey from RQHeader (NOLOCK) H WHERE H.idfWCSecurityKey=S.idfWCSecurityKey)) AS T
WHERE EXISTS (select idfWCSecurityKey from WCAprPath (NOLOCK) CH WHERE CH.idfWCSecurityKey=T.idfWCSecurityKey)



