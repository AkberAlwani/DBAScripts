/****** Object:  StoredProcedure [dbo].[taSopLineIvcInsertPre]    Script Date: 8/05/2019 1:48:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[taSopLineIvcInsertPre] 
@I_vSOPTYPE               smallint output 
,@I_vSOPNUMBE             char(21) output 
,@I_vCUSTNMBR             char(15) output 
,@I_vDOCDATE              datetime output 
,@I_vUSERDATE             datetime output 
,@I_vLOCNCODE             char(10) output 
,@I_vITEMNMBR             char(30) output 
,@I_vAutoAssignBin        smallint output 
,@I_vUNITPRCE             numeric(19, 5) output 
,@I_vXTNDPRCE             numeric(19, 5) output 
,@I_vQUANTITY             numeric(19, 5) output 
,@I_vMRKDNAMT             numeric(19, 5) output 
,@I_vMRKDNPCT             numeric(19, 2) output 
,@I_vCOMMNTID             char(15) output 
,@I_vCOMMENT_1            char(50) output 
,@I_vCOMMENT_2            char(50) output 
,@I_vCOMMENT_3            char(50) output 
,@I_vCOMMENT_4            char(50) output 
,@I_vUNITCOST             numeric (19, 5) output 
,@I_vPRCLEVEL             char(10) output 
,@I_vITEMDESC             char(100) output 
,@I_vTAXAMNT              numeric(19, 5) output 
,@I_vQTYONHND             numeric(19, 5) output 
,@I_vQTYRTRND             numeric(19, 5) output 
,@I_vQTYINUSE             numeric(19, 5) output 
,@I_vQTYINSVC             numeric(19, 5) output 
,@I_vQTYDMGED             numeric(19, 5) output 
,@I_vNONINVEN             smallint output 
,@I_vLNITMSEQ             int output 
,@I_vDROPSHIP             smallint output 
,@I_vQTYTBAOR             numeric(19, 5) output 
,@I_vDOCID                char(15) output 
,@I_vSALSTERR             char(15) output 
,@I_vSLPRSNID             char(15) output 
,@I_vITMTSHID             char(15) output 
,@I_vIVITMTXB             smallint output 
,@I_vTAXSCHID             char(15) output 
,@I_vPRSTADCD             char(15) output 
,@I_vShipToName           char(64) output 
,@I_vCNTCPRSN             char(60) output 
,@I_vADDRESS1             char(60) output 
,@I_vADDRESS2             char(60) output 
,@I_vADDRESS3             char(60) output 
,@I_vCITY                 char(35) output 
,@I_vSTATE                char(29) output 
,@I_vZIPCODE              char(10) output 
,@I_vCOUNTRY              char(60) output 
,@I_vPHONE1               char(21) output 
,@I_vPHONE2               char(21) output 
,@I_vPHONE3               char(21) output 
,@I_vFAXNUMBR             char(21)output 
,@I_vPrint_Phone_NumberGB smallint output 
,@I_vEXCEPTIONALDEMAND    tinyint output 
,@I_vReqShipDate          datetime output 
,@I_vFUFILDAT             datetime output 
,@I_vACTLSHIP             datetime output 
,@I_vSHIPMTHD             char(15) output 
,@I_vINVINDX              varchar(75) output 
,@I_vCSLSINDX             varchar(75) output 
,@I_vSLSINDX              varchar(75) output 
,@I_vMKDNINDX             varchar(75) output 
,@I_vRTNSINDX             varchar(75) output 
,@I_vINUSINDX             varchar(75) output 
,@I_vINSRINDX             varchar(75) output 
,@I_vDMGDINDX             varchar(75) output 
,@I_vAUTOALLOCATESERIAL   int output 
,@I_vAUTOALLOCATELOT      int output 
,@I_vGPSFOINTEGRATIONID   char(30) output 
,@I_vINTEGRATIONSOURCE    smallint output 
,@I_vINTEGRATIONID        char(30) output 
,@I_vRequesterTrx         smallint output 
,@I_vQTYCANCE             numeric(19, 5) output 
,@I_vQTYFULFI             numeric(19, 5) output 
,@I_vALLOCATE             smallint output 
,@I_vUpdateIfExists       smallint output 
,@I_vRecreateDist         smallint output 
,@I_vQUOTEQTYTOINV        numeric(19, 5) output 
,@I_vTOTALQTY             numeric(19, 5) output 
,@I_vCMMTTEXT             varchar(500) output 
,@I_vKitCompMan           smallint output 
,@I_vDEFPRICING           int output 
,@I_vDEFEXTPRICE          int output 
,@I_vCURNCYID             char(15) output 
,@I_vUOFM                 char(8) output 
,@I_vIncludePromo         smallint output 
,@I_vCKCreditLimit        tinyint output 
,@I_vQtyShrtOpt           smallint output 
,@I_vRECREATETAXES        smallint output 
,@I_vRECREATECOMM         smallint output 
,@I_vUSRDEFND1            char(50) output 
,@I_vUSRDEFND2            char(50) output 
,@I_vUSRDEFND3            char(50) output 
,@I_vUSRDEFND4            varchar(8000) output 
,@I_vUSRDEFND5            varchar(8000) output 
,@O_iErrorState           int output 
,@oErrString              varchar(255) output 
as 
    set nocount on 

	-- Start of eConnect Node Customisation

		-- Source Test
		DECLARE	@Source INT
		SELECT	@Source = 0
			-- WorkPlace Test, set status to 1
			SELECT	@Source = 1
			FROM	WPEAICSOPLog
			WHERE	GP_SOPNUMBE = @I_vSOPNUMBE
					AND GP_SOPTYPE = @I_vSOPTYPE

		-- WorkPlace SOP Transactions
		IF @Source = 1
		BEGIN
		-- Update the line GL accounts
			SELECT	@I_vINVINDX = @I_vCSLSINDX,
				@I_vSLSINDX = @I_vCSLSINDX,
				@I_vMKDNINDX = @I_vCSLSINDX,
				@I_vRTNSINDX = @I_vCSLSINDX,
				@I_vINUSINDX = @I_vCSLSINDX,
				@I_vINSRINDX = @I_vCSLSINDX,
				@I_vDMGDINDX = @I_vCSLSINDX

		-- Update the line unit and extended price
			SELECT	@I_vUNITPRCE = WPLine.edfPrice,
					@I_vXTNDPRCE = WPLine.edfAmtExtended
			FROM	WPEAICSOPLog WPSOP
			LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
			LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
			LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
			LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
			LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
			WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
					AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
					AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR			

		-- Update the line comment
		-- Check if a questionnaire has been used
			DECLARE	@WPExpQuestionnaire INT
			SELECT	@WPExpQuestionnaire = 0

			SELECT	@WPExpQuestionnaire = 1
			FROM	WPEAICSOPLog WPSOP
			LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
			LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
			LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
			LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
			LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
			WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
					AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
					AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
					AND WPLine.idfEXPTypeKey IS NOT NULL

		-- If no questionnaire, set default line comment (replicated to look the same as the PO line comment)
			IF (@WPExpQuestionnaire = 0)
			BEGIN
				SELECT	@I_vCMMTTEXT = ('From Req/Line: '
						+ CAST(WPHead.idfRQHeaderKey AS VARCHAR(10))
						+ '/' 
						+ CAST(WPLine.idfLine AS VARCHAR(10))
						+ '  Dept: '
						+ RTRIM(WCDept.idfDeptID)
						+ '  Requester: '
						+ WPUser.idfDescription)
				FROM	WPEAICSOPLog WPSOP
				LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
				LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
				LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
				LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
				LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
				WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
						AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
						AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
			END

		-- If questionnaire exists, populate data from questionnaire
			IF (@WPExpQuestionnaire = 1)
			BEGIN
				--Comment Line 1
				SELECT	@I_vCOMMENT_1 = CAST(Questions.idfCaption AS VARCHAR(MAX))
						+': '+
						CASE
							WHEN Questions.idfAnswerType = 'CHECKBOX'	THEN CASE WHEN Answers.idfAnswerBool = 0 THEN 'No' ELSE 'Yes' END
							WHEN Questions.idfAnswerType = 'DATE'		THEN CONVERT(VARCHAR,Answers.idfAnswerDate,106)
							WHEN Questions.idfAnswerType = 'DROPDOWN'	THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'NUMERIC'	THEN CAST(Answers.idfAnswerNumeric AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'TEXT'		THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							ELSE ''
						END
				FROM	WPEAICSOPLog WPSOP
				LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
				LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
				LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
				LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
				LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
				LEFT	OUTER JOIN RQDetailEXPTypeQuestionnaire Answers ON WPLine.idfRQDetailKey = Answers.idfRQDetailKey
				INNER	JOIN EXPTypeQuestionnaire Questions ON Answers.idfEXPTypeQuestionnaireKey = Questions.idfEXPTypeQuestionnaireKey
				INNER	JOIN EXPType ExpenseType ON Questions.idfEXPTypeKey = ExpenseType.idfEXPTypeKey
				WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
						AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
						AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
						AND Questions.idfSortOrder = 2

				--Comment Line 2
				SELECT	@I_vCOMMENT_2 = CAST(Questions.idfCaption AS VARCHAR(MAX))
						+': '+
						CASE
							WHEN Questions.idfAnswerType = 'CHECKBOX'	THEN CASE WHEN Answers.idfAnswerBool = 0 THEN 'No' ELSE 'Yes' END
							WHEN Questions.idfAnswerType = 'DATE'		THEN CONVERT(VARCHAR,Answers.idfAnswerDate,106)
							WHEN Questions.idfAnswerType = 'DROPDOWN'	THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'NUMERIC'	THEN CAST(Answers.idfAnswerNumeric AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'TEXT'		THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							ELSE ''
						END
				FROM	WPEAICSOPLog WPSOP
				LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
				LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
				LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
				LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
				LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
				LEFT	OUTER JOIN RQDetailEXPTypeQuestionnaire Answers ON WPLine.idfRQDetailKey = Answers.idfRQDetailKey
				INNER	JOIN EXPTypeQuestionnaire Questions ON Answers.idfEXPTypeQuestionnaireKey = Questions.idfEXPTypeQuestionnaireKey
				INNER	JOIN EXPType ExpenseType ON Questions.idfEXPTypeKey = ExpenseType.idfEXPTypeKey
				WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
						AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
						AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
						AND Questions.idfSortOrder = 3

				--Comment Line 3
				SELECT	@I_vCOMMENT_3 = CAST(Questions.idfCaption AS VARCHAR(MAX))
						+': '+
						CASE
							WHEN Questions.idfAnswerType = 'CHECKBOX'	THEN CASE WHEN Answers.idfAnswerBool = 0 THEN 'No' ELSE 'Yes' END
							WHEN Questions.idfAnswerType = 'DATE'		THEN CONVERT(VARCHAR,Answers.idfAnswerDate,106)
							WHEN Questions.idfAnswerType = 'DROPDOWN'	THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'NUMERIC'	THEN CAST(Answers.idfAnswerNumeric AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'TEXT'		THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							ELSE ''
						END
				FROM	WPEAICSOPLog WPSOP
				LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
				LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
				LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
				LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
				LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
				LEFT	OUTER JOIN RQDetailEXPTypeQuestionnaire Answers ON WPLine.idfRQDetailKey = Answers.idfRQDetailKey
				INNER	JOIN EXPTypeQuestionnaire Questions ON Answers.idfEXPTypeQuestionnaireKey = Questions.idfEXPTypeQuestionnaireKey
				INNER	JOIN EXPType ExpenseType ON Questions.idfEXPTypeKey = ExpenseType.idfEXPTypeKey
				WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
						AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
						AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
						AND Questions.idfSortOrder = 4

				--Comment Line 4
				SELECT	@I_vCOMMENT_4 = CAST(Questions.idfCaption AS VARCHAR(MAX))
						+': '+
						CASE
							WHEN Questions.idfAnswerType = 'CHECKBOX'	THEN CASE WHEN Answers.idfAnswerBool = 0 THEN 'No' ELSE 'Yes' END
							WHEN Questions.idfAnswerType = 'DATE'		THEN CONVERT(VARCHAR,Answers.idfAnswerDate,106)
							WHEN Questions.idfAnswerType = 'DROPDOWN'	THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'NUMERIC'	THEN CAST(Answers.idfAnswerNumeric AS VARCHAR(MAX))
							WHEN Questions.idfAnswerType = 'TEXT'		THEN CAST(Answers.idfAnswerString AS VARCHAR(MAX))
							ELSE ''
						END
				FROM	WPEAICSOPLog WPSOP
				LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
				LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
				LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
				LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
				LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
				LEFT	OUTER JOIN RQDetailEXPTypeQuestionnaire Answers ON WPLine.idfRQDetailKey = Answers.idfRQDetailKey
				INNER	JOIN EXPTypeQuestionnaire Questions ON Answers.idfEXPTypeQuestionnaireKey = Questions.idfEXPTypeQuestionnaireKey
				INNER	JOIN EXPType ExpenseType ON Questions.idfEXPTypeKey = ExpenseType.idfEXPTypeKey
				WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
						AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
						AND WPSOP.GP_ITEMNMBR = @I_vITEMNMBR
						AND Questions.idfSortOrder = 5

			END
		END

	-- End of eConnect Node Customisation

    select @O_iErrorState = 0 
    return ( @O_iErrorState ) 

GO


