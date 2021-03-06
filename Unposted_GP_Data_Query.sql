--UNPOSTED LINE SUMMARY FOR GP DATA
--***ADD GRANT NAME BELOW TO SEE BREAKDOWN***
--SET @GRANTID = 'ENTER GRANT ID'
DECLARE @GRANTID VARCHAR(100)
SET @GRANTID = 'NHMRC 1029467'

-- Received but not Submitted Unposted
SELECT (D.DEBITAMT - D.CRDTAMNT -  
	CASE WHEN POP10110.RATECALC = 1 
	THEN ROUND(ISNULL(POP10500.QtyShipped,0.0) * ROUND((POP10110.ORUNTCST * (D.aaAssignedPercent / 10000.00000)),2) / CASE WHEN POP10110.XCHGRATE = 0 THEN 1 ELSE POP10110.XCHGRATE END,2)	 
	ELSE ROUND(ISNULL(POP10500.QtyShipped,0.0) * ROUND((POP10110.ORUNTCST * (D.aaAssignedPercent / 10000.00000)),2) * CASE WHEN POP10110.XCHGRATE = 0 THEN 1 ELSE POP10110.XCHGRATE END,2) END) AS [Unposted Amount = Db - Cr - PO]   

	,D.DEBITAMT	AS [Debit]			
	,D.CRDTAMNT AS [Credit]
	,CASE WHEN POP10110.RATECALC = 1 
	THEN ROUND(ISNULL(POP10500.QtyShipped,0.0) * ROUND((POP10110.ORUNTCST * (D.aaAssignedPercent / 10000.00000)),2) / CASE WHEN POP10110.XCHGRATE = 0 THEN 1 ELSE POP10110.XCHGRATE END,2)	 
	ELSE ROUND(ISNULL(POP10500.QtyShipped,0.0) * ROUND((POP10110.ORUNTCST * (D.aaAssignedPercent / 10000.00000)),2) * CASE WHEN POP10110.XCHGRATE = 0 THEN 1 ELSE POP10110.XCHGRATE END,2) END AS [PO Amt = PO Cost By AA * QTY SHP]

	,POP10110.PONUMBER AS [PO Number]
	,POP10110.ORD / 16384 AS [PO Line]
	,POP10110.ORUNTCST AS [PO Cost]
	,ROUND((POP10110.ORUNTCST * (D.aaAssignedPercent / 10000.00000)),2) AS [PO Cost by AA Code]
	,POP10110.QTYORDER AS [PO Ordered]
	,ISNULL(POP10500.QtyShipped,0.0) AS [QTY Shipped] 
	
	,POP10110.RATECALC AS [Exchange Rate Calc Type]
	,POP10110.XCHGRATE AS [Exchange Rate]
FROM dbo.AAG20003 AS A 
	INNER JOIN dbo.AAG00400 AS B ON A.aaTrxDimID = B.aaTrxDimID 
	INNER JOIN dbo.AAG00401 AS C ON A.aaTrxDimID = C.aaTrxDimID AND B.aaTrxDimID = C.aaTrxDimID AND A.aaTrxCodeID = C.aaTrxDimCodeID 
	INNER JOIN dbo.AAG20002 AS D ON A.aaSubLedgerHdrID = D.aaSubLedgerHdrID AND A.aaSubLedgerDistID = D.aaSubLedgerDistID AND A.aaSubLedgerAssignID = D.aaSubLedgerAssignID 
	LEFT OUTER JOIN dbo.WMI_AAG20000_AAG20001 AS E ON A.aaSubLedgerHdrID = E.aaSubLedgerHdrID AND D.aaSubLedgerHdrID = E.aaSubLedgerHdrID AND D.aaSubLedgerDistID = E.aaSubLedgerDistID 
	INNER JOIN dbo.POP10100 AS G ON E.DOCNUMBR = G.PONUMBER 
	INNER JOIN dbo.GL00100 AS H ON E.ACTINDX = H.ACTINDX 
	INNER JOIN dbo.GL00105 AS I ON I.ACTINDX = H.ACTINDX AND E.ACTINDX = H.ACTINDX 
	INNER JOIN dbo.GTM01100 AS J ON B.aaTrxDim = J.aaTrxDim AND C.aaTrxDimCode = J.aaTrxDimCode 
	INNER JOIN dbo.POP10110 ON E.DOCNUMBR = dbo.POP10110.PONUMBER AND E.SEQNUMBR = dbo.POP10110.ORD
	INNER JOIN WMIAAGMBudgetSummary ON WMIAAGMBudgetSummary.GRANTID = J.GRANTID AND WMIAAGMBudgetSummary.BUDGETID = J.BUDGETID
	LEFT OUTER JOIN (SELECT SUM(QTYSHPPD)  QtyShipped,PONUMBER, POLNENUM 
					FROM POP10500 P WITH (NOLOCK)
					WHERE Status = 1
					GROUP BY PONUMBER, POLNENUM) POP10500 ON POP10500.PONUMBER = POP10110.PONUMBER AND POP10500.POLNENUM = POP10110.ORD
WHERE (H.ACTNUMBR_2 >= '6000' and H.ACTNUMBR_2 <= '7000') and dbo.POP10110.POLNESTA < 4 AND WMIAAGMBudgetSummary.GRANTID = @GRANTID 

--Work Unposted
SELECT 
	(ROUND((D.DEBITAMT * (D.aaAssignedPercent / 10000.00000)),2)- ROUND((D.CRDTAMNT * (D.aaAssignedPercent / 10000.00000)),2)) AS  [UnpostedAmount = Debit - Credit]
	,ROUND((D.DEBITAMT * (D.aaAssignedPercent / 10000.00000)),2) AS [Debit]
	,ROUND((D.CRDTAMNT * (D.aaAssignedPercent / 10000.00000)),2) AS [Credit]
	,GL10000.JRNENTRY AS [Journal Number]
	,GL10000.BACHNUMB AS [Batch Number] 
	,A.aaGLWorkHdrID AS [GL Work Hdr]
	,A.aaGLWorkDistID AS [GL Work Dtl]
FROM AAG10003 AS A 
	INNER JOIN AAG00400 AS B ON A.aaTrxDimID=B.aaTrxDimID
	INNER JOIN AAG00401 AS C ON A.aaTrxDimID=C.aaTrxDimID AND B.aaTrxDimID=C.aaTrxDimID	AND A.aaTrxCodeID=C.aaTrxDimCodeID
	INNER JOIN AAG10002 AS D ON A.aaGLWorkHdrID=D.aaGLWorkHdrID	AND A.aaGLWorkDistID=D.aaGLWorkDistID AND A.aaGLWorkAssignID=D.aaGLWorkAssignID
	LEFT OUTER JOIN AAG10001 AS E ON A.aaGLWorkHdrID=E.aaGLWorkHdrID AND D.aaGLWorkHdrID=E.aaGLWorkHdrID AND D.aaGLWorkDistID=E.aaGLWorkDistID
	INNER JOIN AAG10000 AS F ON A.aaGLWorkHdrID=F.aaGLWorkHdrID	AND E.aaGLWorkHdrID=F.aaGLWorkHdrID
	INNER JOIN GL00100 AS H ON E.ACTINDX=H.ACTINDX
	INNER JOIN GL00105 AS I ON I.ACTINDX=H.ACTINDX AND E.ACTINDX=H.ACTINDX
	INNER JOIN GTM01100 AS J ON B.aaTrxDim=J.aaTrxDim AND C.aaTrxDimCode=J.aaTrxDimCode
	INNER JOIN WMIAAGMBudgetSummary ON WMIAAGMBudgetSummary.GRANTID = J.GRANTID AND WMIAAGMBudgetSummary.BUDGETID = J.BUDGETID
	INNER JOIN GL10000 WITH (NOLOCK) ON GL10000.JRNENTRY = F.JRNENTRY
WHERE (H.ACTNUMBR_2 >= '6000' and H.ACTNUMBR_2 <= '7000') AND WMIAAGMBudgetSummary.GRANTID = @GRANTID 
