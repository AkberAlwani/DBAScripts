SELECT ImportType, idfDay, idfAmtExtended, idfPrice, idfPaymentID, idfDescription, idfQuantity, idfTypeID, idfComment, idfImportedRefNo, idfEXPCreditCardKey, idfEXPMobileExpenseKey, edfCurrencyID, idfWCAttachKey, idfProjectL1, idfProjectL2, idfProjectL3, idfGLID, edfBillType
               FROM (SELECT D.idfAmtExtended AS vdfAmtExtended,0 AS ImportType, CONVERT(VARCHAR(20),D.idfDay,101) AS idfDay,dbo.fnPTIFormatCurrency(Cur.edfCurrencyID,D.idfAmtExtended,null,null) AS idfAmtExtended,dbo.fnPTIFormatNumber(D.idfPrice,null,null) AS idfPrice,idfPaymentID,D.idfDescription
					,D.idfQuantity,idfTypeID,D.idfComment,D.idfImportedRefNo,D.idfEXPCreditCardKey, 0 as idfEXPMobileExpenseKey,edfCurrencyID,0 AS idfWCAttachKey
                    ,'' AS idfProjectL1,'' AS idfProjectL2,'' AS idfProjectL3, '' AS idfGLID, '' AS edfBillType
                   FROM EXPCreditCard		         D    WITH (NOLOCK) 
						INNER JOIN WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey 
						LEFT OUTER JOIN vwFNACurrency   Cur WITH (NOLOCK) ON Cur.idfPTICurrencyKey  = D.idfPTICurrencyKey
						LEFT OUTER JOIN EXPPayment			WITH (NOLOCK) ON D.idfEXPPaymentKey			= EXPPayment.idfEXPPaymentKey				
						LEFT OUTER JOIN EXPType				 WITH (NOLOCK) ON D.idfEXPTypeKey			= EXPType.idfEXPTypeKey			
						LEFT OUTER JOIN EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPCreditCardKey		= D.idfEXPCreditCardKey 
                 WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = 'Janet'
				 UNION ALL
				SELECT D.idfAmtExtended AS vdfAmtExtended,1 AS ImportType, CONVERT(VARCHAR(20),D.idfDay,101) AS idfDay,dbo.fnPTIFormatCurrency(Cur.edfCurrencyID,D.idfAmtExtended,null,null) AS idfAmtExtended,dbo.fnPTIFormatNumber(D.idfPrice,null,null) AS idfPrice,'' as idfPaymentID,D.idfDescription
					,D.idfQuantity,D.idfEXPTypeID AS idfTypeID,'' as idfComment,'' as idfImportedRefNo,0 as idfEXPCreditCardKey, D.idfEXPMobileExpenseKey,edfCurrencyID,CASE WHEN EA.idfEXPMobileExpenseKey IS NULL THEN 0 ELSE 1 END AS idfWCAttachKey
                    ,D.idfProjectL1,D.idfProjectL2,D.idfProjectL3, ISNULL(GLAccount.idfGLID,'') AS idfGLID, '' AS edfBillType
                   FROM EXPMobileExpense	         D    WITH (NOLOCK) 
						INNER JOIN WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey 
						LEFT OUTER JOIN vwFNACurrency   Cur WITH (NOLOCK) ON Cur.idfPTICurrencyKey  = D.idfPTICurrencyKey
						--LEFT OUTER JOIN EXPPayment			WITH (NOLOCK) ON D.idfEXPPaymentKey			= EXPPayment.idfEXPPaymentKey				
						LEFT OUTER JOIN EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPExpenseSheetDtlKey		= D.idfEXPExpenseSheetDtlKey 
                        LEFT OUTER JOIN PAProject P WITH (NOLOCK) ON P.idfProjectID = D.idfProjectL1
                        LEFT OUTER JOIN PAProjectPhase WITH (NOLOCK) ON PAProjectPhase.idfPAProjectKey = P.idfPAProjectKey AND PAProjectPhase.idfPhaseID = D.idfProjectL2
                        LEFT OUTER JOIN GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = PAProjectPhase.idfGLAccountKeyExpense
                        
						LEFT OUTER JOIN (SELECT DISTINCT D.idfEXPMobileExpenseKey FROM EXPMobileExpense D WITH (NOLOCK) 
											INNER JOIN WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey
											INNER JOIN WCAttach A WITH (NOLOCK) ON A.idfLinkTableName = 'EXPMobileExpense' AND A.idfLinkTableKey = D.idfEXPMobileExpenseKey
											LEFT OUTER JOIN EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPExpenseSheetDtlKey		= D.idfEXPExpenseSheetDtlKey
										 WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = 'Janet') EA ON EA.idfEXPMobileExpenseKey = D.idfEXPMobileExpenseKey
                 WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = 'Janet' 
				) TMP ORDER BY vdfAmtExtended,idfDay

select * from vwFNACurrency  where edfFunctional=1


