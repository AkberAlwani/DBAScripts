SELECT w.idfSEcurityID,w.idfDescription,D.idfDeptID,D.idfDescription HomeDept
FROM dbo.WCSecurity w
LEFT OUTER JOIN WCDept d ON w.idfWCDeptKey=D.idfWCDeptKey

SELECT w.idfSEcurityID,w.idfDescription,D.idfDeptID,D.idfDescription HomeDept
FROM dbo.WCSecDept wd
INNER JOIN WCDept d ON wd.idfWCDeptKey=d.idfWCDeptKey
INNER JOIN dbo.WCSecurity w ON w.idfWCDeptKey=d.idfWCDeptKey




EXEC spPTIFixdb
EXEC spPTIFixPrimaryKeySequence 1
EXEC spPTIFixPrimaryKey