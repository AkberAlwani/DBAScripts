declare @userid varchar(100)
set @userid='ali'
SELECT ImportType, idfDay, idfAmtExtended, idfPrice, idfPaymentID, idfDescription, dbo.fnPTIFormatNumber(idfQuantity,0,null) AS idfQuantity, idfTypeID, idfComment, idfImportedRefNo, idfEXPCreditCardKey, idfEXPMobileExpenseKey, edfCurrencyID, idfWCAttachKey, idfProjectL1, idfProjectL2, idfProjectL3, idfGLID, edfBillType, SS1.idfValue AS vdfEXPUSEMOBILETYPE,vdfCompanyCodeTarget,idfTaxScheduleID
               FROM (SELECT D.idfAmtExtended AS vdfAmtExtended,0 AS ImportType, CONVERT(VARCHAR(20),D.idfDay,101) AS idfDay,dbo.fnPTIFormatCurrency(Cur.edfCurrencyID,D.idfAmtExtended,null,null) AS idfAmtExtended,dbo.fnPTIFormatNumber(D.idfPrice,null,null) AS idfPrice,idfPaymentID,D.idfDescription
					,D.idfQuantity,idfTypeID,D.idfComment,D.idfImportedRefNo,D.idfEXPCreditCardKey, 0 as idfEXPMobileExpenseKey,edfCurrencyID,0 AS idfWCAttachKey
                    ,'' AS idfProjectL1,'' AS idfProjectL2,'' AS idfProjectL3, '' AS idfGLID, '' AS edfBillType
                    ,ISNULL(TC.idfCompanyCode,SC.idfCompanyCode) AS vdfCompanyCodeTarget
                    ,ISNULL(WCTaxScheduleHdr.idfTaxScheduleID,'') AS idfTaxScheduleID
                   FROM TWO.dbo.EXPCreditCard		         D    WITH (NOLOCK) 
						INNER JOIN TWO.dbo.WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey 
						LEFT OUTER JOIN TWO.dbo.vwFNACurrency   Cur WITH (NOLOCK) ON Cur.idfPTICurrencyKey  = D.idfPTICurrencyKey
						LEFT OUTER JOIN TWO.dbo.EXPPayment			WITH (NOLOCK) ON D.idfEXPPaymentKey			= EXPPayment.idfEXPPaymentKey				
						LEFT OUTER JOIN TWO.dbo.EXPType				 WITH (NOLOCK) ON D.idfEXPTypeKey			= EXPType.idfEXPTypeKey	
                        LEFT OUTER JOIN TWO.dbo.WCTaxScheduleHdr WITH (NOLOCK) ON WCTaxScheduleHdr.idfWCTaxScheduleHdrKey = EXPType.idfWCTaxScheduleHdrKey
						LEFT OUTER JOIN TWO.dbo.EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPCreditCardKey		= D.idfEXPCreditCardKey 
	                    LEFT OUTER JOIN TWO.dbo.APVendor WITH (NOLOCK) ON APVendor.idfAPVendorKey = EXPPayment.idfAPVendorKey
	                    LEFT OUTER JOIN TWO.dbo.WCICCompany TC WITH (NOLOCK) ON TC.idfWCICCompanyKey = APVendor.idfWCICCompanyKey
                        LEFT OUTER JOIN TWO.dbo.WCICCompany SC WITH (NOLOCK) ON SC.idfWCICCompanyKey = S.idfWCICCompanyKeyVendor
	                WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = @userid
				 UNION ALL
				SELECT D.idfAmtExtended AS vdfAmtExtended,1 AS ImportType, CONVERT(VARCHAR(20),D.idfDay,101) AS idfDay,dbo.fnPTIFormatCurrency(Cur.edfCurrencyID,D.idfAmtExtended,null,null) AS idfAmtExtended,dbo.fnPTIFormatNumber(D.idfPrice,null,null) AS idfPrice,D.idfPaymentID as idfPaymentID,D.idfDescription
					,D.idfQuantity,D.idfEXPTypeID AS idfTypeID,'' as idfComment,'' as idfImportedRefNo,0 as idfEXPCreditCardKey, D.idfEXPMobileExpenseKey,edfCurrencyID,CASE WHEN EA.idfEXPMobileExpenseKey IS NULL THEN 0 ELSE 1 END AS idfWCAttachKey
                    ,D.idfProjectL1,D.idfProjectL2,D.idfProjectL3, ISNULL(GLAccount.idfGLID,'') AS idfGLID, '' AS vdfCompanyCodeTarget, CASE WHEN ISNULL(PC.PAbllngtype,0) = 1 THEN 'STD' WHEN ISNULL(PC.PAbllngtype,0) = 2 THEN 'N/C' ELSE 'N/B' END AS edfBillType, ISNULL(WCTaxScheduleHdr.idfTaxScheduleID,'') AS idfTaxScheduleID
                   FROM TWO.dbo.EXPMobileExpense	         D    WITH (NOLOCK) 
						INNER JOIN TWO.dbo.WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey 
						LEFT OUTER JOIN TWO.dbo.vwFNACurrency   Cur WITH (NOLOCK) ON Cur.idfPTICurrencyKey  = D.idfPTICurrencyKey
						--LEFT OUTER JOIN TWO.dbo.EXPPayment			WITH (NOLOCK) ON D.idfEXPPaymentKey			= EXPPayment.idfEXPPaymentKey				
						LEFT OUTER JOIN TWO.dbo.EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPExpenseSheetDtlKey		= D.idfEXPExpenseSheetDtlKey  
                        LEFT OUTER JOIN TWO.dbo.PAProject P WITH (NOLOCK) ON P.idfProjectID = D.idfProjectL1
                        LEFT OUTER JOIN TWO.dbo.PAProjectPhase WITH (NOLOCK) ON PAProjectPhase.idfPAProjectKey = P.idfPAProjectKey AND PAProjectPhase.idfPhaseID = D.idfProjectL2
                        LEFT OUTER JOIN TWO.dbo.GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = PAProjectPhase.idfGLAccountKeyExpense
                        LEFT OUTER JOIN TWO.dbo.EXPType	WITH (NOLOCK) ON D.idfEXPTypeID = EXPType.idfTypeID	
                        LEFT OUTER JOIN TWO.dbo.WCTaxScheduleHdr WITH (NOLOCK) ON WCTaxScheduleHdr.idfWCTaxScheduleHdrKey = EXPType.idfWCTaxScheduleHdrKey
                        LEFT OUTER JOIN dbo.PA01301 PC WITH (NOLOCK) ON D.idfProjectL3 = PC.PACOSTCATID AND PC.PATU=5 AND PC.PASTAT NOT IN (2,3,4)  AND PC.PAPROJNUMBER = D.idfProjectL2 
						LEFT OUTER JOIN (SELECT DISTINCT D.idfEXPMobileExpenseKey FROM TWO.dbo.EXPMobileExpense D WITH (NOLOCK) 
											INNER JOIN TWO.dbo.WCSecurity		 S	  WITH (NOLOCK) ON S.idfWCSecurityKey	  = D.idfWCSecurityKey
											INNER JOIN TWO.dbo.WCAttach A WITH (NOLOCK) ON A.idfLinkTableName = 'EXPMobileExpense' AND A.idfLinkTableKey = D.idfEXPMobileExpenseKey
											LEFT OUTER JOIN TWO.dbo.EXPExpenseSheetDtl T WITH (NOLOCK) ON T.idfEXPExpenseSheetDtlKey		= D.idfEXPExpenseSheetDtlKey
										 WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = @userid) EA ON EA.idfEXPMobileExpenseKey = D.idfEXPMobileExpenseKey                                     
            WHERE ISNULL(D.idfEXPExpenseSheetDtlKey,0) = 0  AND T.idfEXPExpenseSheetHdrKey IS NULL   AND S.idfSecurityID = @userid
				) TMP 
            LEFT OUTER JOIN dbo.WCSystemSetting SS1 WITH(NOLOCK) ON SS1.idfSettingID = 'EXPUSEMOBILETYPE'
            ORDER BY idfDay,vdfAmtExtended