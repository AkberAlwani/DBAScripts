SELECT        EDH.idfEXPExpenseSheetDtlHistKey, EDH.idfAmtTaxIncluded, EDH.idfDescription, EDH.idfFlagImported, 
                         EDH.idfImportedRefNo, EDH.idfQuantity, EDH.idfLine, EDH.idfDateCreated, EDH.idfEXPPaymentKey, 
                         EDH.idfGLAccountKey, EDH.idfPAPhaseActivityKey AS [Disbursement Type], EDH.idfPAProjectKey AS Client, 
                         EDH.idfPAProjectPhaseKey AS Matter, EDH.edfAmtExtended, AP.idfName AS [Venodr Name], WCDept.idfDeptID AS [Department ID], 
                         GLAccount.idfDescription AS [Account Description], EXPPayment.idfDescription AS [Payment Method], GLAccount_1.idfGLID,
						 EXPLog.*
FROM  EXPExpenseSheetDtlHist EDH
      LEFT JOIN APVendor AP ON EDH.idfAPVendorKey = AP.idfAPVendorKey 
      LEFT JOIN WCDept ON EDH.idfWCDeptKey = WCDept.idfWCDeptKey 
      LEFT JOIN GLAccount ON EDH.idfGLAccountKey = GLAccount.idfGLAccountKey 
      LEFT JOIN EXPPayment ON EDH.idfEXPPaymentKey = EXPPayment.idfEXPPaymentKey 
      LEFT JOIN GLAccount AS GLAccount_1 ON EDH.idfGLAccountKey = GLAccount_1.idfGLAccountKey
	  LEFT JOIN  (SELECT EH.idfEXPExpenseSheetHdrHistKey,EL.idfEXPExpenseSheetDtlHistKey ,
		            EL.idfDateCreated AS LogDate
					, CASE WHEN EL.idfWCSecurityKey > 0 THEN idfNameLast + ', ' + idfNameFirst ELSE WCRole.idfRoleID END	AS UserName
					, ISNULL(WCLogType.idfDescription,'') + ' ' + REPLACE(idfLogEntry,'16550','ALTERNATE') AS LogEntry		
			FROM dbo.EXPExpenseSheetDtlLogHist		EL WITH (NOLOCK)
			LEFT OUTER JOIN dbo.WCSecurity	   WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey	= EL.idfWCSecurityKey
			LEFT OUTER JOIN dbo.WCRole		   WITH (NOLOCK) ON WCRole.idfWCRoleKey			= EL.idfWCSecurityKey * -1
			INNER JOIN dbo.EXPExpenseSheetDtlHist ED WITH (NOLOCK) ON ED.idfEXPExpenseSheetDtlHistKey = EL.idfEXPExpenseSheetDtlHistKey
			INNER JOIN dbo.EXPExpenseSheetHdrHist	EH WITH (NOLOCK) ON EH.idfEXPExpenseSheetHdrHistKey = ED.idfEXPExpenseSheetHdrHistKey
	  LEFT OUTER JOIN dbo.WCLogType		   WITH (NOLOCK) ON WCLogType.idfWCLogTypeKey	= EL.idfWCLogTypeKey
	WHERE EL.idfWCLogTypeKey=130) EXPLog ON EDH.idfEXPExpenseSheetDtlHistKey=EXPLog.idfEXPExpenseSheetDtlHistKey


