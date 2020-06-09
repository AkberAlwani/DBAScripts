/****** Object:  StoredProcedure [dbo].[taSopHdrIvcInsertPre]    Script Date: 8/05/2019 1:49:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER procedure [dbo].[taSopHdrIvcInsertPre] 
@I_vSOPTYPE                smallint output 
,@I_vDOCID                 char(15) output 
,@I_vSOPNUMBE              char(21) output 
,@I_vORIGNUMB              char(21) output 
,@I_vORIGTYPE              smallint output 
,@I_vTAXSCHID              char(15) output 
,@I_vFRTSCHID              char(15) output 
,@I_vMSCSCHID              char(15) output 
,@I_vSHIPMTHD              char(15) output 
,@I_vTAXAMNT               numeric(19, 5) output 
,@I_vLOCNCODE              char(10) output 
,@I_vDOCDATE               datetime output 
,@I_vFREIGHT               numeric(19, 5) output 
,@I_vMISCAMNT              numeric(19, 5) output 
,@I_vTRDISAMT              numeric(19, 5) output 
,@I_vTRADEPCT              numeric(19, 2) output 
,@I_vDISTKNAM              numeric(19, 5) output 
,@I_vMRKDNAMT              numeric(19, 5) output 
,@I_vCUSTNMBR              char(15) output 
,@I_vCUSTNAME              char(64) output 
,@I_vCSTPONBR              char(20) output 
,@I_vShipToName            char(64) output 
,@I_vADDRESS1              char(60) output 
,@I_vADDRESS2              char(60) output 
,@I_vADDRESS3              char(60) output 
,@I_vCNTCPRSN              char(60) output 
,@I_vFAXNUMBR              char(21) output 
,@I_vCITY                  char(35) output 
,@I_vSTATE                 char(29) output 
,@I_vZIPCODE               char(10) output 
,@I_vCOUNTRY               char(60) output 
,@I_vPHNUMBR1              char(21) output 
,@I_vPHNUMBR2              char(21) output 
,@I_vPHNUMBR3              char(21) output 
,@I_vPrint_Phone_NumberGB  smallint output 
,@I_vSUBTOTAL              numeric(19, 5) output 
,@I_vDOCAMNT               numeric(19, 5) output 
,@I_vPYMTRCVD              numeric(19, 5) output 
,@I_vSALSTERR              char(15) output 
,@I_vSLPRSNID              char(15) output 
,@I_vUPSZONE               char(3) output 
,@I_vUSER2ENT              char(15) output 
,@I_vBACHNUMB              char(15) output 
,@I_vPRBTADCD              char(15) output 
,@I_vPRSTADCD              char(15) output 
,@I_vFRTTXAMT              numeric(19, 5) output 
,@I_vMSCTXAMT              numeric(19, 5) output 
,@I_vORDRDATE              datetime output 
,@I_vMSTRNUMB              int output 
,@I_vPYMTRMID              char(20) output 
,@I_vDUEDATE               datetime output 
,@I_vDISCDATE              datetime output 
,@I_vREFRENCE              char(30) output 
,@I_vUSINGHEADERLEVELTAXES int output 
,@I_vBatchCHEKBKID         char(15) output 
,@I_vCREATECOMM            smallint output 
,@I_vCOMMAMNT              numeric(19, 2) output 
,@I_vCOMPRCNT              numeric(19, 2) output 
,@I_vCREATEDIST            smallint output 
,@I_vCREATETAXES           smallint output 
,@I_vDEFTAXSCHDS           smallint output 
,@I_vCURNCYID              char(15) output 
,@I_vXCHGRATE              numeric(19, 7) output 
,@I_vRATETPID              char(15) output 
,@I_vEXPNDATE              datetime output 
,@I_vEXCHDATE              datetime output 
,@I_vEXGTBDSC              char(30) output 
,@I_vEXTBLSRC              char(50) output 
,@I_vRATEEXPR              smallint output 
,@I_vDYSTINCR              smallint output 
,@I_vRATEVARC              numeric(19, 7) output 
,@I_vTRXDTDEF              smallint output 
,@I_vRTCLCMTD              smallint output 
,@I_vPRVDSLMT              smallint output 
,@I_vDATELMTS              smallint output 
,@I_vTIME1                 datetime output 
,@I_vDISAVAMT              numeric(19, 2) output 
,@I_vDSCDLRAM              numeric(19, 5) output 
,@I_vDSCPCTAM              numeric(19, 2) output 
,@I_vFREIGTBLE             int output 
,@I_vMISCTBLE              int output 
,@I_vCOMMNTID              char(15) output 
,@I_vCOMMENT_1             char(50) output 
,@I_vCOMMENT_2             char(50) output 
,@I_vCOMMENT_3             char(50) output 
,@I_vCOMMENT_4             char(50) output 
,@I_vGPSFOINTEGRATIONID    char(30) output 
,@I_vINTEGRATIONSOURCE     smallint output 
,@I_vINTEGRATIONID         char(30) output 
,@I_vReqShipDate           datetime output 
,@I_vRequesterTrx          smallint output 
,@I_vCKCreditLimit         tinyint output 
,@I_vCKHOLD                tinyint output 
,@I_vUpdateExisting        tinyint output 
,@I_vQUOEXPDA              datetime output 
,@I_vQUOTEDAT              datetime output 
,@I_vINVODATE              datetime output 
,@I_vBACKDATE              datetime output 
,@I_vRETUDATE              datetime output 
,@I_vCMMTTEXT              varchar(500) output 
,@I_vPRCLEVEL              char(10) output 
,@I_vDEFPRICING            tinyint output 
,@I_vTAXEXMT1              char(25) output 
,@I_vTAXEXMT2              char(25) output 
,@I_vTXRGNNUM              char(25) output 
,@I_vREPTING               tinyint output 
,@I_vTRXFREQU              smallint output 
,@I_vTIMETREP              smallint output 
,@I_vQUOTEDYSTINCR         smallint output 
,@I_vNOTETEXT              varchar(8000) output 
,@I_vUSRDEFND1             char(50) output 
,@I_vUSRDEFND2             char(50) output 
,@I_vUSRDEFND3             char(50) output 
,@I_vUSRDEFND4             varchar(8000) output 
,@I_vUSRDEFND5             varchar(8000) output 
,@O_iErrorState            int output 
,@oErrString               varchar(255) output 
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
		-- WorkPlace Sales Fulfilment Transactions
			-- Set SOP Header to auto calculate subtotal
			SELECT @I_vDEFPRICING = 1

			-- Set Customer PO
			DECLARE	@idfRQDetailKey INT

			SELECT	@idfRQDetailKey = MIN(WPLine.idfRQDetailKey)
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
					AND Questions.idfSortOrder = 1

			SELECT	@I_vCSTPONBR = 
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
					AND WPLine.idfRQDetailKey = @idfRQDetailKey
					AND Questions.idfSortOrder = 1

			-- Set the Comments to the WorkPlace Header Comment
			SELECT	@I_vCMMTTEXT = WPHead.idfComment
			FROM	WPEAICSOPLog WPSOP
			LEFT	OUTER JOIN RQRevDtl WPRev ON WPSOP.idfRQRevDtlKey = WPRev.idfRQRevDtlKey
			LEFT	OUTER JOIN RQDetail WPLine ON WPRev.idfRQDetailKey = WPLine.idfRQDetailKey
			LEFT	OUTER JOIN WCDept ON WPLine.idfWCDeptKey = WCDept.idfWCDeptKey
			LEFT	OUTER JOIN RQHeader WPHead ON WPLine.idfRQHeaderKey = WPHead.idfRQHeaderKey
			LEFT	OUTER JOIN WCSecurity WPUser ON WPHead.idfWCSecurityKey = WPUser.idfWCSecurityKey
			WHERE	WPSOP.GP_SOPTYPE = @I_vSOPTYPE
					AND WPSOP.GP_SOPNUMBE = @I_vSOPNUMBE
		END

	-- End of eConnect Node Customisation

    select @O_iErrorState = 0 

    SELECT @I_vPYMTRCVD = ISNULL(Sum(AMNTPAID), 0) 
    FROM   SOP10103 
    WHERE  SOPTYPE = @I_vSOPTYPE 
           AND SOPNUMBE = @I_vSOPNUMBE 

    return ( @O_iErrorState ) 

GO


