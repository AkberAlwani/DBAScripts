SELECT edfItem 'Item',idfQty Quanity, edfUOM 'UOM',edfPrice 'Price',edfAmtExtended 'Total',idfDeptID 'Department', D.idfDescription 'Dept Name'
,G.idfGLID 'GL Coding',E.idfDescription 'Expense Type'
,RD.edfVendor 'Vendor', RD.edfVendorItem 'Vendor Item Number',H.idfRQDate 'Date',RD.edfPONumber 'PO Number',S.idfDescription 'Requester'
FROM RQDetail RD (NOLOCK)
INNER JOIN RQHeader H (NOLOCK) ON rd.idfRQHeaderKey=H.idfRQHeaderKey
LEFT OUTER JOIN GLAccount G (NOLOCK) ON G.idfGLAccountKey=RD.edfGL
INNER JOIN WCDept D (NOLOCK) ON RD.idfWCDeptKey=D.idfWCDeptKey
LEFT OUTER JOIN WCSecurity S (NOLOCK) ON S.idfWCSecurityKey=H.idfWCSecurityKey
LEFT OUTER JOIN EXPType E (NOLOCK) ON RD.idfEXPTypeKey=E.idfEXPTypeKey

SELECT * FROM RQHeader

•	Item 
•	Quantity 
•	UOM 
•	Price 
•	Total 
•	Department 
•	GL coding 
•	Expense Type 
•	Vendor 
•	Vendor item number 
•	Date 
•	PO Number 
•	Requester

SELECT COUNT(1),idfEXPTypeKey FROM RQDetail GROUP BY idfEXPTypeKey 
SELECT * FROM EXPType
UPDATE EXPType SET idfTypeID='COVID 19',idfDescription='COVID 19' WHERE idfEXPTypeKey=6
UPDATE RQDetail SET idfEXPTypeKey=6 WHERE idfEXPTypeKey IS null