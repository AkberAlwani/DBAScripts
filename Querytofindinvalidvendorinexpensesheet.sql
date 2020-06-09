SELECT S.idfSecurityID 
FROM EXPExpenseSheetDtl D
INNER JOIN EXPExpenseSheetHdr              H WITH (NOLOCK) ON H.idfEXPExpenseSheetHdrKey = D.idfEXPExpenseSheetHdrKey
LEFT OUTER JOIN WCSecurity                 S WITH (NOLOCK) ON H.idfWCSecurityKey = S.idfWCSecurityKey
LEFT OUTER JOIN dbo.APVendor VS              WITH (NOLOCK) ON VS.idfAPVendorKey = S.idfAPVendorKey
LEFT OUTER JOIN dbo.APVendor V               WITH (NOLOCK) ON D.idfAPVendorKey = V.idfAPVendorKey
LEFT OUTER JOIN dbo.PM00200 WITH (NOLOCK) ON PM00200.VENDORID = ISNULL(V.idfVendorID,ISNULL(VS.idfVendorID,''))
WHERE PM00200.VENDORID IS NULL
