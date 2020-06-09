USE [TWO]
GO

/****** Object:  StoredProcedure [dbo].[spWCSecurity]    Script Date: 1/16/2019 12:44:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 93 $ $Modtime: 2/27/06 2:47p $
ALTER PROCEDURE [dbo].[spWCSecurity]
 @xochErrSP				CHAR(32)      	= 'spWCSecurity'	OUTPUT
,@xonErrNum				INT          	= 0			OUTPUT
,@xostrErrInfo			VARCHAR(255) 	= ''			OUTPUT
,@xchAction				CHAR(2)			= 0
,@xnRQMaxUsers 			INT				= 0
,@xnPAMaxUsers 			INT				= 0
,@xnTEMaxUsers 			INT				= 0
,@xnEXPMaxUsers			INT				= 0
,@xnEMPLMaxUsers		INT				= 0
,@xnHCMaxUsers			INT				= 0
,@xstridfPassword		VARCHAR(512)	= null
,@xstridfEncryptedPass 	VARCHAR(512)	= null
,@xstridfEncodedPass	VARCHAR(512)	= null
,@xstrEnforcePWPolicy	VARCHAR(5)		= null
,@xstrServerAuthType	VARCHAR(10)		= null
,@xstrCaller			VARCHAR(60)		= ''
AS
DECLARE
 @nWCValHdrKey		INT
,@nidfRowKey		INT
,@nNewKey		INT
,@stridfUDFDescription01	VARCHAR(60)
,@stridfUDFDescription02	VARCHAR(60)
,@nidfFlagForced	INT
,@nNewidfWCSecurityKey	INT
-- WCSecurity
,@nidfWCSecurityKey	INT
,@stridfAddr1		VARCHAR(40)
,@stridfAddr2		VARCHAR(40)
,@stridfAddr3		VARCHAR(40)
,@stridfAltPhone1	VARCHAR(40)
,@stridfAltPhone2	VARCHAR(40)
,@stridfAltPhoneExt1	VARCHAR(20)
,@stridfAltPhoneExt2	VARCHAR(20)
,@stridfCity		VARCHAR(40)
,@stridfCountry		VARCHAR(40)
,@stridfDescription	VARCHAR(60)
,@stridfEmail		VARCHAR(255)
,@stridfEmailFormat	CHAR(4)
,@stridfEmailSubject	VARCHAR(255)
,@stridfFax		VARCHAR(40)
,@nidfFlagActive	INT
,@nidfFlagActivePA	INT
,@nidfFlagActiveRQ	INT
,@nidfFlagActiveTE	INT
,@nidfFlagActiveEXP	INT
,@nidfFlagActiveEMPL INT
,@nidfFlagActiveHC  INT
,@nidfFlagExempt	INT
,@nidfFlagMgr		INT

				,@nidfFlagNotifyAPVFromApr INT
	
				,@nidfFlagNotifyAPVNotApr INT
	
				,@nidfFlagNotifyAPVToApr INT
	
				,@nidfFlagNotifyCCImport INT
	
				,@nidfFlagNotifyEXPFromApr INT
	
				,@nidfFlagNotifyEXPFromRev INT
	
				,@nidfFlagNotifyEXPImport INT
	
				,@nidfFlagNotifyEXPNotApr INT
	
				,@nidfFlagNotifyEXPToApr INT
	
				,@nidfFlagNotifyFromApr INT
	
				,@nidfFlagNotifyFromAprFilter INT
	
				,@nidfFlagNotifyFromInv INT
	
				,@nidfFlagNotifyFromRcv INT
	
				,@nidfFlagNotifyFromRev INT
	
				,@nidfFlagNotifyFromRevInclPO INT
	
				,@nidfFlagNotifyInvCaptureNeedAttn INT
	
				,@nidfFlagNotifyInvNotRcv INT
	
				,@nidfFlagNotifyIVRdyToShip INT
	
				,@nidfFlagNotifyNotApr INT
	
				,@nidfFlagNotifyPAFromApr INT
	
				,@nidfFlagNotifyPANotApr INT
	
				,@nidfFlagNotifyPAToApr INT
	
				,@nidfFlagNotifyPOFromApr INT
	
				,@nidfFlagNotifyPOFromAprFilter INT
	
				,@nidfFlagNotifyPONotApr INT
	
				,@nidfFlagNotifyPOToApr INT
	
				,@nidfFlagNotifyRCVCancelled INT
	
				,@nidfFlagNotifyRCVFromApr INT
	
				,@nidfFlagNotifyRCVFromAprFilter INT
	
				,@nidfFlagNotifyRCVNotApr INT
	
				,@nidfFlagNotifyRCVNotMatch INT
	
				,@nidfFlagNotifyRCVReturnProcess INT
	
				,@nidfFlagNotifyRCVToApr INT
	
				,@nidfFlagNotifyRQFromDelegate INT
	
				,@nidfFlagNotifyRQNotApr INT
	
				,@nidfFlagNotifyRQNotFullyRcv INT
	
				,@nidfFlagNotifyRQPOTranError INT
	
				,@nidfFlagNotifyRQRevCancelled INT
	
				,@nidfFlagNotifyRQToDelegate INT
	
				,@nidfFlagNotifyTEFromApr INT
	
				,@nidfFlagNotifyTEFromRev INT
	
				,@nidfFlagNotifyTENotApr INT
	
				,@nidfFlagNotifyTENotSub INT
	
				,@nidfFlagNotifyTEToApr INT
	
				,@nidfFlagNotifyToApr INT
	
				,@nidfFlagNotifyToRev INT
	
,@nidfFlagShowAddr1	INT
,@nidfFlagShowAddr2	INT
,@nidfFlagShowAddr3	INT
,@nidfFlagShowCity	INT
,@nidfFlagShowCountry	INT
,@nidfFlagShowEmail	INT
,@nidfFlagShowFax	INT
,@nidfFlagShowHomePage	INT
,@nidfFlagShowPager	INT
,@nidfFlagShowPhone	INT
,@nidfFlagShowPhone2	INT
,@nidfFlagShowPhoneCar	INT
,@nidfFlagShowPhoneHome	INT
,@nidfFlagShowPhoneOffice	INT
,@nidfFlagShowState	INT
,@nidfFlagShowTimeZone	INT
,@nidfFlagShowZipCode	INT
,@nidfHireDate		DATETIME
,@stridfHomePage	VARCHAR(255)
,@stridfNameFirst	VARCHAR(30)
,@stridfNameLast	VARCHAR(30)
,@stridfNameMiddle	VARCHAR(30)
,@nidfNotifyCountApr	INT
,@stridfPager		VARCHAR(40)
,@stridfPassword	VARCHAR(60)
,@nidfPasswordLen	INT
,@stridfPhoneCar	VARCHAR(40)
,@stridfPhoneExtOffice	VARCHAR(20)
,@stridfPhoneHome	VARCHAR(40)
,@stridfPhoneOffice	VARCHAR(40)
,@stridfSecurityID	VARCHAR(256)
,@stridfSecurityType	VARCHAR(5)
,@stridfSocialSec	VARCHAR(20)
,@stridfState		VARCHAR(40)
,@stridfTimeZone	VARCHAR(20)
,@stridfZipCode			VARCHAR(20)
,@nidfListUDF01Key		INT
,@nidfWCUDFListDtlKey02		INT
,@nidfWCUDFTemplateKey		INT
,@nidfRQFDefaultKey		INT
,@nidfRQFReadOnlyKey		INT
,@nidfRQFRequiredKey		INT
,@nidfPTICompanyKey		INT
,@nidfWCDeptKey			INT
,@nidfWCEmailDocDtlKeyFromApr	INT
,@nidfWCEmailDocDtlKeyFromRev	INT
,@nidfWCEmailDocDtlKeyFromRcv	INT
,@nidfWCEmailDocDtlKeyFromInv	INT
,@nidfWCEmailDocDtlKeyInvNotRcv INT
,@nidfWCEmailDocDtlKeyNotApr	INT
,@nidfWCEmailDocDtlKeyToApr 	INT
,@nidfWCEmailDocDtlKeyToRev 	INT
,@nidfWCEmailDocDtlKeyFrmAprFtr INT
,@nidfWCEmailDocDtlKeyTENotSub	INT
,@nidfWCFilterHdrKeyFromAprFilter INT
,@chvdfListUDF01ID		CHAR(20)
,@chvdfListUDF02ID		CHAR(20)
,@chvdfTemplateID		CHAR(20)
,@chvdfUDFTemplateID		CHAR(20)
,@nCurrentEXPUsers  		INT
,@nCurrentPAUsers  		INT
,@nCurrentRQUsers  		INT
,@nCurrentTEUsers  		INT
,@nCurrentEMPLUsers  	INT
,@nCurrentHCUsers		INT
,@stredfAgent    		CHAR(8)
,@stredfBuyer			CHAR(15)
,@stredfVendor			VARCHAR(15)
,@stridfEmployeeID		VARCHAR(15)
,@strvdfLaborGroupID		VARCHAR(20)
,@strvdfEarningCodeID		VARCHAR(20)
,@nidfPALaborGroupKey		INT
,@nidfTEEarningCodeKey		INT
,@nidfWCUDFListHdrKey01		INT
,@nidfWCUDFListHdrKey02		INT
,@nidfFlagForced01		INT
,@nidfFlagForced02		INT
,@nidfFlagCreateUser		INT
,@stridfOldidfSecurityID	VARCHAR(255)
,@stridfNewidfSecurityID	VARCHAR(256)
,@nidfFlagActiveOld		INT
,@nidfFlagActiveNew		INT
,@nUserAllreadyExists		INT
,@strCurrentidfRowAction	VARCHAR(2)
,@nLoginExists 			INT
,@strvdfSecurityIDSupervisor	VARCHAR(256)
,@nidfWCSecurityKeySupervisor	INT
,@strENABLESUPERVISORAPR	INT
,@nidfWCSecurityKeyNew		INT
,@nidfWCSecurityKeyOld		INT
,@nENABLESUPERVISORALTERNATE	INT
,@strvdfPositionID				VARCHAR(64)
,@nidfWCPositionKey				INT
,@strvdfSecurityIDAprAltr		VARCHAR(256)
,@nidfWCSecurityKeyAprAltr		INT
,@nidfFlagSVCUser               INT
,@stridfRowAction		VARCHAR(2)
--
SET NOCOUNT ON 
--
--CDB 1/14/10: Users will be idfWCSecTypeKey of 1 for now.
UPDATE #WCSecurity SET  idfWCSecTypeKey = 1
					   ,idfNotifyAPVCountApr = 1
					   ,idfNotifyCountApr = 1
					   ,idfNotifyEXPCountApr = 1
					   ,idfNotifyPOCountApr = 1
					   ,idfNotifyRCVCountApr = 1
					   ,idfNotifyRQCountRev = 1
					   ,idfNotifyTECountApr = 1

--Assign System Language Key to New Users
UPDATE #WCSecurity SET idfWCLanguageKey = WCLanguage.idfWCLanguageKey
FROM #WCSecurity
INNER JOIN dbo.WCLanguage WITH (NOLOCK) ON idfFlagSystem = 1 
WHERE #WCSecurity.idfRowAction = 'IN' AND #WCSecurity.idfWCLanguageKey = 0

 CREATE TABLE #WCSecurityWork
	  (
	  idfWCSecurityKey INT
		,idfAddr1 VARCHAR(40)
		,idfAddr2 VARCHAR(40)
		,idfAddr3 VARCHAR(40)
		,idfAltPhone1 VARCHAR(40)
		,idfAltPhone2 VARCHAR(40)
		,idfAltPhoneExt1 VARCHAR(20)
		,idfAltPhoneExt2 VARCHAR(20)
		,idfCity VARCHAR(40)
		,idfCommuteDistance NUMERIC(19, 5)
		,idfCommuteUOM INT
		,idfCompany NVARCHAR(120)
		,idfCountry VARCHAR(40)
		,idfCreatedBy VARCHAR(255)
		,idfDescription VARCHAR(60)
		,idfEmail VARCHAR(255)
		,idfEmailFormat CHAR(4)
		,idfEmailSubject VARCHAR(255)
		,idfEmployeeID VARCHAR(20)
		,idfFax VARCHAR(40)
		,idfFlagActive INT
		,idfFlagActiveEMPL INT
		,idfFlagActiveEXP INT
		,idfFlagActiveHC INT
		,idfFlagActivePA INT
		,idfFlagActiveRQ INT
		,idfFlagActiveTE INT
		,idfFlagAltrActive INT
		,idfFlagAltrActiveSupervisor INT
		,idfFlagAltrEmail INT
		,idfFlagChangePassword INT
		,idfFlagExempt INT
		,idfFlagMgr INT
		,idfFlagNotifyAPVFromApr INT
		,idfFlagNotifyAPVNotApr INT
		,idfFlagNotifyAPVToApr INT
		,idfFlagNotifyCCImport INT
		,idfFlagNotifyEXPFromApr INT
		,idfFlagNotifyEXPFromRev INT
		,idfFlagNotifyEXPImport INT
		,idfFlagNotifyEXPNotApr INT
		,idfFlagNotifyEXPToApr INT
		,idfFlagNotifyFromApr INT
		,idfFlagNotifyFromAprFilter INT
		,idfFlagNotifyFromInv INT
		,idfFlagNotifyFromRcv INT
		,idfFlagNotifyFromRev INT
		,idfFlagNotifyFromRevInclPO INT
		,idfFlagNotifyIVRdyToShip INT
		,idfFlagNotifyNotApr INT
		,idfFlagNotifyPAFromApr INT
		,idfFlagNotifyPANotApr INT
		,idfFlagNotifyPAToApr INT
		,idfFlagNotifyPOFromApr INT
		,idfFlagNotifyPOFromAprFilter INT
		,idfFlagNotifyPONotApr INT
		,idfFlagNotifyPOToApr INT
		,idfFlagNotifyRCVCancelled INT
		,idfFlagNotifyRCVFromApr INT
		,idfFlagNotifyRCVFromAprFilter INT
		,idfFlagNotifyRCVNotApr INT
		,idfFlagNotifyRCVNotMatch INT
		,idfFlagNotifyRCVReturnProcess INT
		,idfFlagNotifyRCVToApr INT
		,idfFlagNotifyRQFromDelegate INT
		,idfFlagNotifyRQNotApr INT
		,idfFlagNotifyRQNotFullyRcv INT
		,idfFlagNotifyRQPOTranError INT
		,idfFlagNotifyRQRevCancelled INT
		,idfFlagNotifyRQToDelegate INT
		,idfFlagNotifyTEFromApr INT
		,idfFlagNotifyTEFromRev INT
		,idfFlagNotifyTENotApr INT
		,idfFlagNotifyTENotSub INT
		,idfFlagNotifyTEToApr INT
		,idfFlagNotifyToApr INT
		,idfFlagNotifyToRev INT
		,idfFlagShowAddr1 INT
		,idfFlagShowAddr2 INT
		,idfFlagShowAddr3 INT
		,idfFlagShowCity INT
		,idfFlagShowCountry INT
		,idfFlagShowEmail INT
		,idfFlagShowFax INT
		,idfFlagShowHomePage INT
		,idfFlagShowPager INT
		,idfFlagShowPhone INT
		,idfFlagShowPhone2 INT
		,idfFlagShowPhoneCar INT
		,idfFlagShowPhoneHome INT
		,idfFlagShowPhoneOffice INT
		,idfFlagShowState INT
		,idfFlagShowTimeZone INT
		,idfFlagShowZipCode INT
		,idfFlagSVCUser INT
		,idfHireDate DATETIME
		,idfHomePage VARCHAR(255)
		,idfHoursTEMax NUMERIC(19, 5)
		,idfHoursTEMin NUMERIC(19, 5)
		,idfNameFirst VARCHAR(30)
		,idfNameLast VARCHAR(30)
		,idfNameMiddle VARCHAR(30)
		,idfNotifyAPVCountApr INT
		,idfNotifyCountApr INT
		,idfNotifyEXPCountApr INT
		,idfNotifyPOCountApr INT
		,idfNotifyRCVCountApr INT
		,idfNotifyRQCountRev INT
		,idfNotifyTECountApr INT
		,idfPager VARCHAR(40)
		,idfPassword VARCHAR(60)
		,idfPasswordLen INT
		,idfPasswordSVC NVARCHAR(1024)
		,idfPhoneCar VARCHAR(40)
		,idfPhoneExtOffice VARCHAR(20)
		,idfPhoneHome VARCHAR(40)
		,idfPhoneOffice VARCHAR(40)
		,idfRateBill NUMERIC(19, 5)
		,idfRateCost NUMERIC(19, 5)
		,idfRQPOTranErrorTimeToSend DATETIME
		,idfRQPOTranErrorTimeToSendLast DATETIME
		,idfSecurityID VARCHAR(256)
		,idfSecurityType VARCHAR(5)
		,idfSocialSec VARCHAR(20)
		,idfState VARCHAR(40)
		,idfTimeZone VARCHAR(20)
		,idfZipCode VARCHAR(20)
		,idfDateCreated DATETIME
		,idfDateModified DATETIME
		,idfAPVendorKey INT
		,idfEXPEventKey INT
		,idfListUDF01Key INT
		,idfPALaborGroupKey INT
		,idfPTICompanyKey INT
		,idfTEEarningCodeKey INT
		,idfWCDeptKey INT
		,idfWCEmailDocDtlKeyAPVFromApr INT
		,idfWCEmailDocDtlKeyAPVNotApr INT
		,idfWCEmailDocDtlKeyAPVToApr INT
		,idfWCEmailDocDtlKeyCCImport INT
		,idfWCEmailDocDtlKeyDelegatedRQCancelled INT
		,idfWCEmailDocDtlKeyEXPFromApr INT
		,idfWCEmailDocDtlKeyEXPFromRev INT
		,idfWCEmailDocDtlKeyEXPImport INT
		,idfWCEmailDocDtlKeyEXPNotApr INT
		,idfWCEmailDocDtlKeyEXPToApr INT
		,idfWCEmailDocDtlKeyFrmAprFtr INT
		,idfWCEmailDocDtlKeyFromApr INT
		,idfWCEmailDocDtlKeyFromInv INT
		,idfWCEmailDocDtlKeyFromRcv INT
		,idfWCEmailDocDtlKeyFromRev INT
		,idfWCEmailDocDtlKeyIVRdyToShip INT
		,idfWCEmailDocDtlKeyNotApr INT
		,idfWCEmailDocDtlKeyPAFromApr INT
		,idfWCEmailDocDtlKeyPANotApr INT
		,idfWCEmailDocDtlKeyPAToApr INT
		,idfWCEmailDocDtlKeyPOFromApr INT
		,idfWCEmailDocDtlKeyPOFromAprFilter INT
		,idfWCEmailDocDtlKeyPONotApr INT
		,idfWCEmailDocDtlKeyPOToApr INT
		,idfWCEmailDocDtlKeyRCVCancelled INT
		,idfWCEmailDocDtlKeyRCVFromApr INT
		,idfWCEmailDocDtlKeyRCVFromAprFilter INT
		,idfWCEmailDocDtlKeyRCVNotApr INT
		,idfWCEmailDocDtlKeyRCVNotMatch INT
		,idfWCEmailDocDtlKeyRCVReturnProcess INT
		,idfWCEmailDocDtlKeyRCVToApr INT
		,idfWCEmailDocDtlKeyRQDelagate INT
		,idfWCEmailDocDtlKeyRQNotApr INT
		,idfWCEmailDocDtlKeyRQNotFullyRcv INT
		,idfWCEmailDocDtlKeyRQPOTranError INT
		,idfWCEmailDocDtlKeyRQRevCancelled INT
		,idfWCEmailDocDtlKeyTEFromApr INT
		,idfWCEmailDocDtlKeyTEFromRev INT
		,idfWCEmailDocDtlKeyTENotApr INT
		,idfWCEmailDocDtlKeyTENotSub INT
		,idfWCEmailDocDtlKeyTEToApr INT
		,idfWCEmailDocDtlKeyToApr INT
		,idfWCEmailDocDtlKeyToRev INT
		,idfWCFilterHdrKeyFromAprFilter INT
		,idfWCFilterHdrKeyLoadRcv INT
		,idfWCFilterHdrKeyLoadRev INT
		,idfWCFilterHdrKeyPOFromAprFilter INT
		,idfWCFilterHdrKeyRCVFromAprFilter INT
		,idfWCICCompanyKeyVendor INT
		,idfWCLanguageKey INT
		,idfWCPositionKey INT
		,idfWCSecTypeKey INT
		,idfWCSecurityKeyAprAltr INT
		,idfWCSecurityKeySupervisor INT
		,idfWCUDFListDtlKey02 INT
		,idfWCUDFTemplateHdrKey INT
		,idfWCUDFTemplateKey INT
		,idfWCUDFTemplateKeyApr INT
		,idfWCUDFTemplateKeyRcv INT
		,idfWCUDFTemplateKeyRev INT
		,edfBuyer CHAR(15)
		,edfVendor VARCHAR(15)
		,idfFlagNotifyInvCaptureNeedAttn INT
		,idfWCEmailDocDtlKeyInvCaptureNeedAttn INT
		,idfFlagNotifyInvNotRcv INT
		,idfWCEmailDocDtlKeyInvNotRcv INT
		,vdfCopyFromKey INT
		,vdfDeptID CHAR(20)
		,vdfTemplateID CHAR(20)
		,vdfWCICCompanyIDVendor VARCHAR(60)
		,vdfEmailIDAPVFromApr CHAR(20)
		,vdfEmailIDAPVNotApr CHAR(20)
		,vdfEmailIDAPVToApr CHAR(20)
		,vdfEmailIDCCIMPORT CHAR(20)
		,vdfEmailIDDelegatedRQCancelled CHAR(20)
		,vdfEmailIDEXPFromApr CHAR(20)
		,vdfEmailIDEXPFromRev CHAR(20)
		,vdfEmailIDEXPImport CHAR(20)
		,vdfEmailIDEXPNotApr CHAR(20)
		,vdfEmailIDEXPToApr CHAR(20)
		,vdfEmailIDFromApr CHAR(20)
		,vdfEmailIDFromInv CHAR(20)
		,vdfEmailIDFromRcv CHAR(20)
		,vdfEmailIDFromRev CHAR(20)
		,vdfEmailIDInvCaptureNeedAttn CHAR(20)
		,vdfEmailIDInvNotRcv CHAR(20)
		,vdfEmailIDIVRdyToShip CHAR(20)
		,vdfEmailIDNotApr CHAR(20)
		,vdfEmailIDPAFromApr CHAR(20)
		,vdfEmailIDPANotApr CHAR(20)
		,vdfEmailIDPAToApr CHAR(20)
		,vdfEmailIDPOFromApr CHAR(20)
		,vdfEmailIDPOFromAprFilter CHAR(20)
		,vdfEmailIDPONotApr CHAR(20)
		,vdfEmailIDPOToApr CHAR(20)
		,vdfEmailIDRCVCancelled CHAR(20)
		,vdfEmailIDRCVFromApr CHAR(20)
		,vdfEmailIDRCVFromAprFilter CHAR(20)
		,vdfEmailIDRCVNotApr CHAR(20)
		,vdfEmailIDRCVNotMatch CHAR(20)
		,vdfEmailIDRCVReturnProcess CHAR(20)
		,vdfEmailIDRCVToApr CHAR(20)
		,vdfEmailIDRQDelagate CHAR(20)
		,vdfEmailIDRQNotApr CHAR(20)
		,vdfEmailIDRQNotFullyRcv CHAR(20)
		,vdfEmailIDRQRevCancelled CHAR(20)
		,vdfEmailIDTEFromApr CHAR(20)
		,vdfEmailIDTEFromRev CHAR(20)
		,vdfEmailIDTENotApr CHAR(20)
		,vdfEmailIDTENotSub CHAR(20)
		,vdfEmailIDTEToApr CHAR(20)
		,vdfEmailIDToApr CHAR(20)
		,vdfEmailIDToRev CHAR(20)
		,vdfEventID VARCHAR(20)
		,vdfRQPOTranErrorTimeToSend CHAR(20)
		,vdfTwoFactorEnabled NVARCHAR(2048)
		,vdfWCEmailDocDtlKeyFrmAprFtr CHAR(20)
		,vdfEarningCodeID CHAR(20)
		,vdfListUDF01ID CHAR(20)
		,vdfListUDF02ID CHAR(20)
		,vdfPositionID VARCHAR(64)
		,vdfLaborGroupID CHAR(20)
		,vdfFilterIDRcvTol CHAR(20)
		,vdfFilterIDRevTol CHAR(20)
		,vdfWCFilterHdrKeyFromAprFilter CHAR(20)
		,vdfWCFilterHdrKeyPOFromAprFilter CHAR(20)
		,vdfWCFilterHdrKeyRCVFromAprFilter CHAR(20)
		,vdfVendorID NVARCHAR(60)
		,vdfEmployeeIDSupervisor VARCHAR(256)
		,vdfSecurityIDAprAltr VARCHAR(256)
		,vdfSecurityIDSupervisor VARCHAR(256)
		,idfRowKey INT
	  ,idfRowAction	CHAR(2)
	  )
	  CREATE CLUSTERED INDEX idfRowKey ON #WCSecurityWork (idfRowKey)
	  CREATE INDEX idfRowAction ON #WCSecurityWork (idfRowAction)
	  EXEC sp_executesql N'INSERT INTO #WCSecurityWork
	  SELECT	 idfWCSecurityKey
			,idfAddr1
			,idfAddr2
			,idfAddr3
			,idfAltPhone1
			,idfAltPhone2
			,idfAltPhoneExt1
			,idfAltPhoneExt2
			,idfCity
			,idfCommuteDistance
			,idfCommuteUOM
			,idfCompany
			,idfCountry
			,idfCreatedBy
			,idfDescription
			,idfEmail
			,idfEmailFormat
			,idfEmailSubject
			,idfEmployeeID
			,idfFax
			,idfFlagActive
			,idfFlagActiveEMPL
			,idfFlagActiveEXP
			,idfFlagActiveHC
			,idfFlagActivePA
			,idfFlagActiveRQ
			,idfFlagActiveTE
			,idfFlagAltrActive
			,idfFlagAltrActiveSupervisor
			,idfFlagAltrEmail
			,idfFlagChangePassword
			,idfFlagExempt
			,idfFlagMgr
			,idfFlagNotifyAPVFromApr
			,idfFlagNotifyAPVNotApr
			,idfFlagNotifyAPVToApr
			,idfFlagNotifyCCImport
			,idfFlagNotifyEXPFromApr
			,idfFlagNotifyEXPFromRev
			,idfFlagNotifyEXPImport
			,idfFlagNotifyEXPNotApr
			,idfFlagNotifyEXPToApr
			,idfFlagNotifyFromApr
			,idfFlagNotifyFromAprFilter
			,idfFlagNotifyFromInv
			,idfFlagNotifyFromRcv
			,idfFlagNotifyFromRev
			,idfFlagNotifyFromRevInclPO
			,idfFlagNotifyIVRdyToShip
			,idfFlagNotifyNotApr
			,idfFlagNotifyPAFromApr
			,idfFlagNotifyPANotApr
			,idfFlagNotifyPAToApr
			,idfFlagNotifyPOFromApr
			,idfFlagNotifyPOFromAprFilter
			,idfFlagNotifyPONotApr
			,idfFlagNotifyPOToApr
			,idfFlagNotifyRCVCancelled
			,idfFlagNotifyRCVFromApr
			,idfFlagNotifyRCVFromAprFilter
			,idfFlagNotifyRCVNotApr
			,idfFlagNotifyRCVNotMatch
			,idfFlagNotifyRCVReturnProcess
			,idfFlagNotifyRCVToApr
			,idfFlagNotifyRQFromDelegate
			,idfFlagNotifyRQNotApr
			,idfFlagNotifyRQNotFullyRcv
			,idfFlagNotifyRQPOTranError
			,idfFlagNotifyRQRevCancelled
			,idfFlagNotifyRQToDelegate
			,idfFlagNotifyTEFromApr
			,idfFlagNotifyTEFromRev
			,idfFlagNotifyTENotApr
			,idfFlagNotifyTENotSub
			,idfFlagNotifyTEToApr
			,idfFlagNotifyToApr
			,idfFlagNotifyToRev
			,idfFlagShowAddr1
			,idfFlagShowAddr2
			,idfFlagShowAddr3
			,idfFlagShowCity
			,idfFlagShowCountry
			,idfFlagShowEmail
			,idfFlagShowFax
			,idfFlagShowHomePage
			,idfFlagShowPager
			,idfFlagShowPhone
			,idfFlagShowPhone2
			,idfFlagShowPhoneCar
			,idfFlagShowPhoneHome
			,idfFlagShowPhoneOffice
			,idfFlagShowState
			,idfFlagShowTimeZone
			,idfFlagShowZipCode
			,idfFlagSVCUser
			,idfHireDate
			,idfHomePage
			,idfHoursTEMax
			,idfHoursTEMin
			,idfNameFirst
			,idfNameLast
			,idfNameMiddle
			,idfNotifyAPVCountApr
			,idfNotifyCountApr
			,idfNotifyEXPCountApr
			,idfNotifyPOCountApr
			,idfNotifyRCVCountApr
			,idfNotifyRQCountRev
			,idfNotifyTECountApr
			,idfPager
			,idfPassword
			,idfPasswordLen
			,idfPasswordSVC
			,idfPhoneCar
			,idfPhoneExtOffice
			,idfPhoneHome
			,idfPhoneOffice
			,idfRateBill
			,idfRateCost
			,idfRQPOTranErrorTimeToSend
			,idfRQPOTranErrorTimeToSendLast
			,idfSecurityID
			,idfSecurityType
			,idfSocialSec
			,idfState
			,idfTimeZone
			,idfZipCode
			,idfDateCreated
			,idfDateModified
			,idfAPVendorKey
			,idfEXPEventKey
			,idfListUDF01Key
			,idfPALaborGroupKey
			,idfPTICompanyKey
			,idfTEEarningCodeKey
			,idfWCDeptKey
			,idfWCEmailDocDtlKeyAPVFromApr
			,idfWCEmailDocDtlKeyAPVNotApr
			,idfWCEmailDocDtlKeyAPVToApr
			,idfWCEmailDocDtlKeyCCImport
			,idfWCEmailDocDtlKeyDelegatedRQCancelled
			,idfWCEmailDocDtlKeyEXPFromApr
			,idfWCEmailDocDtlKeyEXPFromRev
			,idfWCEmailDocDtlKeyEXPImport
			,idfWCEmailDocDtlKeyEXPNotApr
			,idfWCEmailDocDtlKeyEXPToApr
			,idfWCEmailDocDtlKeyFrmAprFtr
			,idfWCEmailDocDtlKeyFromApr
			,idfWCEmailDocDtlKeyFromInv
			,idfWCEmailDocDtlKeyFromRcv
			,idfWCEmailDocDtlKeyFromRev
			,idfWCEmailDocDtlKeyIVRdyToShip
			,idfWCEmailDocDtlKeyNotApr
			,idfWCEmailDocDtlKeyPAFromApr
			,idfWCEmailDocDtlKeyPANotApr
			,idfWCEmailDocDtlKeyPAToApr
			,idfWCEmailDocDtlKeyPOFromApr
			,idfWCEmailDocDtlKeyPOFromAprFilter
			,idfWCEmailDocDtlKeyPONotApr
			,idfWCEmailDocDtlKeyPOToApr
			,idfWCEmailDocDtlKeyRCVCancelled
			,idfWCEmailDocDtlKeyRCVFromApr
			,idfWCEmailDocDtlKeyRCVFromAprFilter
			,idfWCEmailDocDtlKeyRCVNotApr
			,idfWCEmailDocDtlKeyRCVNotMatch
			,idfWCEmailDocDtlKeyRCVReturnProcess
			,idfWCEmailDocDtlKeyRCVToApr
			,idfWCEmailDocDtlKeyRQDelagate
			,idfWCEmailDocDtlKeyRQNotApr
			,idfWCEmailDocDtlKeyRQNotFullyRcv
			,idfWCEmailDocDtlKeyRQPOTranError
			,idfWCEmailDocDtlKeyRQRevCancelled
			,idfWCEmailDocDtlKeyTEFromApr
			,idfWCEmailDocDtlKeyTEFromRev
			,idfWCEmailDocDtlKeyTENotApr
			,idfWCEmailDocDtlKeyTENotSub
			,idfWCEmailDocDtlKeyTEToApr
			,idfWCEmailDocDtlKeyToApr
			,idfWCEmailDocDtlKeyToRev
			,idfWCFilterHdrKeyFromAprFilter
			,idfWCFilterHdrKeyLoadRcv
			,idfWCFilterHdrKeyLoadRev
			,idfWCFilterHdrKeyPOFromAprFilter
			,idfWCFilterHdrKeyRCVFromAprFilter
			,idfWCICCompanyKeyVendor
			,idfWCLanguageKey
			,idfWCPositionKey
			,idfWCSecTypeKey
			,idfWCSecurityKeyAprAltr
			,idfWCSecurityKeySupervisor
			,idfWCUDFListDtlKey02
			,idfWCUDFTemplateHdrKey
			,idfWCUDFTemplateKey
			,idfWCUDFTemplateKeyApr
			,idfWCUDFTemplateKeyRcv
			,idfWCUDFTemplateKeyRev
			,edfBuyer
			,edfVendor
			,idfFlagNotifyInvCaptureNeedAttn
			,idfWCEmailDocDtlKeyInvCaptureNeedAttn
			,idfFlagNotifyInvNotRcv
			,idfWCEmailDocDtlKeyInvNotRcv
			,vdfCopyFromKey
			,vdfDeptID
			,vdfTemplateID
			,vdfWCICCompanyIDVendor
			,vdfEmailIDAPVFromApr
			,vdfEmailIDAPVNotApr
			,vdfEmailIDAPVToApr
			,vdfEmailIDCCIMPORT
			,vdfEmailIDDelegatedRQCancelled
			,vdfEmailIDEXPFromApr
			,vdfEmailIDEXPFromRev
			,vdfEmailIDEXPImport
			,vdfEmailIDEXPNotApr
			,vdfEmailIDEXPToApr
			,vdfEmailIDFromApr
			,vdfEmailIDFromInv
			,vdfEmailIDFromRcv
			,vdfEmailIDFromRev
			,vdfEmailIDInvCaptureNeedAttn
			,vdfEmailIDInvNotRcv
			,vdfEmailIDIVRdyToShip
			,vdfEmailIDNotApr
			,vdfEmailIDPAFromApr
			,vdfEmailIDPANotApr
			,vdfEmailIDPAToApr
			,vdfEmailIDPOFromApr
			,vdfEmailIDPOFromAprFilter
			,vdfEmailIDPONotApr
			,vdfEmailIDPOToApr
			,vdfEmailIDRCVCancelled
			,vdfEmailIDRCVFromApr
			,vdfEmailIDRCVFromAprFilter
			,vdfEmailIDRCVNotApr
			,vdfEmailIDRCVNotMatch
			,vdfEmailIDRCVReturnProcess
			,vdfEmailIDRCVToApr
			,vdfEmailIDRQDelagate
			,vdfEmailIDRQNotApr
			,vdfEmailIDRQNotFullyRcv
			,vdfEmailIDRQRevCancelled
			,vdfEmailIDTEFromApr
			,vdfEmailIDTEFromRev
			,vdfEmailIDTENotApr
			,vdfEmailIDTENotSub
			,vdfEmailIDTEToApr
			,vdfEmailIDToApr
			,vdfEmailIDToRev
			,vdfEventID
			,vdfRQPOTranErrorTimeToSend
			,vdfTwoFactorEnabled
			,vdfWCEmailDocDtlKeyFrmAprFtr
			,vdfEarningCodeID
			,vdfListUDF01ID
			,vdfListUDF02ID
			,vdfPositionID
			,vdfLaborGroupID
			,vdfFilterIDRcvTol
			,vdfFilterIDRevTol
			,vdfWCFilterHdrKeyFromAprFilter
			,vdfWCFilterHdrKeyPOFromAprFilter
			,vdfWCFilterHdrKeyRCVFromAprFilter
			,vdfVendorID
			,vdfEmployeeIDSupervisor
			,vdfSecurityIDAprAltr
			,vdfSecurityIDSupervisor
			,idfRowKey
			,idfRowAction
		FROM #WCSecurity'
CREATE TABLE #spWCValDtl
	(
		 idfRowKey		INT
		,idfErrInfo		VARCHAR(255)
		,idfErrNum		INT
		,idfOBJName		CHAR(128)
		,idfIsWarning 	INT
		,idfTableName	VARCHAR(60)
		,ErrorNumber	INT
		,idfRowAction	CHAR(2)
		,idfKey			INT
		,idfParam01		VARCHAR(255)
		,idfParam02		VARCHAR(255)
		,idfParam03		VARCHAR(255)
		,idfFlagTableSpecific	INT
    )	

-- This was added So the User Import can be applied to customer builds
IF (@xnRQMaxUsers = 0 AND @xnPAMaxUsers = 0 AND @xnTEMaxUsers = 0 AND @xnEXPMaxUsers = 0 AND @xnEMPLMaxUsers = 0 AND @xnHCMaxUsers = 0 AND @xstrCaller IN ('','IMPORT'))
BEGIN 
	UPDATE #WCSecurityWork SET idfRowAction = 'CP' WHERE ISNULL(vdfCopyFromKey,0) <> 0
	
	SELECT @xnRQMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='RQUSERCOUNT'

	SELECT @xnPAMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='PAUSERCOUNT'

	SELECT @xnTEMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='TEUSERCOUNT'

	SELECT @xnEXPMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='EXPUSERCOUNT'

	SELECT @xnEMPLMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='EMPLOYEECOUNT'

	SELECT @xnHCMaxUsers = ISNULL(idfValue,0) FROM PTIMaster.dbo.PTILicenseAttr WITH (NOLOCK)
	WHERE idfModule IN (SELECT TOP 1 'WorkPlace '
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,1,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,4,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,7,2)))+'.'+
			+CONVERT(VARCHAR(2),CONVERT(INT,SUBSTRING(idfVersion,10,2))) FROM WCInstall WITH (NOLOCK) ORDER BY idfWCInstallKey DESC)
		AND idfAttribute='HCUSERCOUNT'
END


-- Change To system flag
SELECT @nidfFlagCreateUser = idfFlagCreateUser 
FROM WCSystem (NOLOCK)
--This stored procedure is can only handle one record at a time.
SELECT @nWCValHdrKey = null

DECLARE @Security TABLE 
(
	idfNewidfSecurityID VARCHAR(256),
	idfOldidfSecurityID VARCHAR(256),
	idfFlagActiveOld	INT,
	idfFlagActiveNew	INT,
	nLoginExists		INT
)

IF @xstrCaller = 'EAIC' BEGIN
	UPDATE #WCSecurityWork
	SET idfWCSecurityKey = DTL.idfWCSecurityKey, idfWCSecurityKeySupervisor = SUPER.idfWCSecurityKey, idfRowAction = 'UN'
	FROM #WCSecurityWork TMP
	LEFT OUTER JOIN dbo.WCSecurity DTL WITH (NOLOCK) ON DTL.idfEmployeeID = TMP.idfEmployeeID
	LEFT OUTER JOIN dbo.WCSecurity SUPER WITH (NOLOCK) ON SUPER.idfEmployeeID = TMP.vdfEmployeeIDSupervisor
	WHERE (TMP.idfSecurityID = '' OR TMP.idfSecurityID IS NULL) AND TMP.vdfEmployeeIDSupervisor > ''

	UPDATE WCSecurity
	SET idfWCSecurityKeySupervisor = TMP.idfWCSecurityKeySupervisor
	FROM dbo.WCSecurity DTL WITH (NOLOCK)
	INNER JOIN #WCSecurityWork TMP ON TMP.idfWCSecurityKey = DTL.idfWCSecurityKey
END

IF @xstrCaller = 'DIAPI' BEGIN
	UPDATE #WCSecurityWork
	SET idfSecurityID = DTL.idfSecurityID
	FROM #WCSecurityWork TMP
	LEFT OUTER JOIN dbo.WCSecurity DTL WITH (NOLOCK) ON DTL.idfEmployeeID = TMP.idfEmployeeID
	WHERE TMP.idfSecurityID = '' OR TMP.idfSecurityID IS NULL

	UPDATE #WCSecurityWork
	SET vdfSecurityIDSupervisor = ISNULL(DTL.idfSecurityID,'')
	FROM #WCSecurityWork TMP
	LEFT OUTER JOIN dbo.WCSecurity DTL WITH (NOLOCK) ON DTL.idfEmployeeID = TMP.vdfEmployeeIDSupervisor
	WHERE TMP.vdfEmployeeIDSupervisor > ''

	SELECT @nidfPTICompanyKey = idfPTICompanyKey FROM PTIMaster.dbo.PTICompany WHERE idfDBName = db_name()

	UPDATE #WCSecurityWork
	SET  idfRowAction = CASE WHEN TMP.idfRowAction NOT IN ('IN','') THEN idfRowAction WHEN DTL.idfWCSecurityKey IS NULL THEN 'IN' ELSE 'UP' END
	    ,idfWCSecurityKey = CASE WHEN DTL.idfWCSecurityKey IS NULL THEN 0 ELSE DTL.idfWCSecurityKey END
		,idfPTICompanyKey = @nidfPTICompanyKey
		,idfEmailFormat ='HTML'
	FROM #WCSecurityWork TMP
	LEFT OUTER JOIN dbo.WCSecurity DTL WITH (NOLOCK) ON DTL.idfSecurityID = TMP.idfSecurityID

	--Employee ID Not Found
	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
		SELECT idfRowKey,-166,'IN' 
		FROM #WCSecurityWork
		WHERE idfRowAction = 'UP' AND idfWCSecurityKey = 0 AND (idfSecurityID = '' OR idfSecurityID IS NULL)

	--User ID Not Found
	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
		SELECT idfRowKey,-165,'IN' 
		FROM #WCSecurityWork
		WHERE idfRowAction = 'UP' AND idfWCSecurityKey = 0 AND idfSecurityID > ''

	--Supervisor ID not found
	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
		SELECT idfRowKey,-159,'IN' 
		FROM #WCSecurityWork
		WHERE idfRowAction = 'UP' AND vdfEmployeeIDSupervisor > '' AND vdfSecurityIDSupervisor = ''
END


IF @xchAction = 'VL' OR @xchAction = 'CM'
--Validate all rows
BEGIN
	UPDATE #WCSecurityWork 
	SET #WCSecurityWork.idfWCICCompanyKeyVendor = WCICCompany.idfWCICCompanyKey
	   ,#WCSecurityWork.idfSecurityID = LTRIM(#WCSecurityWork.idfSecurityID)
	   ,#WCSecurityWork.idfCommuteDistance = ROUND(#WCSecurityWork.idfCommuteDistance,1)
	FROM #WCSecurityWork
		LEFT OUTER JOIN WCICCompany WITH (NOLOCK) ON WCICCompany.idfCompanyCode = vdfWCICCompanyIDVendor

	-- Validate vendor
	UPDATE dbo.#WCSecurityWork SET
	idfAPVendorKey = APVendor.idfAPVendorKey
	FROM dbo.#WCSecurityWork
	INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'APVendor'
	LEFT OUTER JOIN dbo.APVendor WITH (NOLOCK) ON #WCSecurityWork.vdfVendorID = APVendor.idfVendorID AND APVendor.idfFlagActive = 1
	AND (	 APVendor.idfWCICCompanyKey IS NULL
	OR (LT.idfLinkType='SOURCE' AND APVendor.idfWCICCompanyKey = #WCSecurityWork.idfWCICCompanyKeyVendor)
	OR (LT.idfLinkType='TARGET' AND APVendor.idfWCICCompanyKey = #WCSecurityWork.idfWCICCompanyKeyVendor))
	OPTION (KEEPFIXED PLAN)

	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
	SELECT idfRowKey,-158,'IN' 
		FROM #WCSecurityWork
		WHERE vdfVendorID > '' AND idfAPVendorKey IS NULL

   	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
	SELECT idfRowKey,-154,'IN' 
		FROM #WCSecurityWork
		WHERE vdfVendorID = '' AND idfFlagActiveEXP = 1

	UPDATE #spWCValDtl SET idfErrNum = ErrorNumber, idfOBJName = 'spWCSecurity'
	
	EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT

	DELETE FROM #spWCValDtl	

	UPDATE #WCSecurityWork SET idfDescription = RTRIM(#WCSecurityWork.idfNameFirst) + CASE WHEN LEN(RTRIM(#WCSecurityWork.idfNameMiddle)) = 0 THEN '' ELSE ' '+RTRIM(#WCSecurityWork.idfNameMiddle) END + ' ' + RTRIM(#WCSecurityWork.idfNameLast)
    
	--Lookup FilterKey for Review Tolarance
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCFilterHdrKeyLoadRev = WCFilterHdr.idfWCFilterHdrKey
	FROM #WCSecurityWork
	    INNER JOIN WCFilterHdr (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfFilterIDRevTol)) = RTRIM(LTRIM(WCFilterHdr.idfFilterID)) AND #WCSecurityWork.idfPTICompanyKey = WCFilterHdr.idfPTICompanyKey	

    --Lookup FilterKey for Receive Tolarance
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCFilterHdrKeyLoadRcv = WCFilterHdr.idfWCFilterHdrKey
	FROM #WCSecurityWork
	    INNER JOIN WCFilterHdr (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfFilterIDRcvTol)) = RTRIM(LTRIM(WCFilterHdr.idfFilterID)) AND #WCSecurityWork.idfPTICompanyKey = WCFilterHdr.idfPTICompanyKey

	--Lookup DeptKey for all rows where DeptKey is Null
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCDeptKey = WCDept.idfWCDeptKey
	FROM #WCSecurityWork , WCDept (NOLOCK)
	WHERE RTRIM(LTRIM(#WCSecurityWork.vdfDeptID)) = RTRIM(LTRIM(WCDept.idfDeptID)) AND
		#WCSecurityWork.idfPTICompanyKey = WCDept.idfPTICompanyKey

	--Lookup UDFTemplate Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCUDFTemplateKey = WCUDFTemplateHdr.idfWCUDFTemplateHdrKey
	FROM #WCSecurityWork , WCUDFTemplateHdr (NOLOCK)
	WHERE RTRIM(LTRIM(#WCSecurityWork.vdfTemplateID)) = RTRIM(LTRIM(WCUDFTemplateHdr.idfTemplateID)) AND
		#WCSecurityWork.idfPTICompanyKey = WCUDFTemplateHdr.idfPTICompanyKey
		

	-- CDB 4/26/04 - Get udf list hdr's
	SELECT @nidfWCUDFListHdrKey01 = idfWCUDFListHdrKey, @nidfFlagForced01 = idfFlagForced, @stridfUDFDescription01 = idfDescription
	FROM WCUDFListHdr (NOLOCK) WHERE idfCategory = 'LISTUDF01' AND idfModule = 'SECURITY' 

	SELECT @nidfWCUDFListHdrKey02 = idfWCUDFListHdrKey, @nidfFlagForced02 = idfFlagForced, @stridfUDFDescription02 = idfDescription
	FROM WCUDFListHdr (NOLOCK) WHERE idfCategory = 'LISTUDF02' AND idfModule = 'SECURITY' 

	--Lookup UDFListDtl Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfListUDF01Key = WCUDFListDtl.idfWCUDFListDtlKey
	FROM #WCSecurityWork, WCUDFListDtl (NOLOCK), WCUDFListHdr (NOLOCK)
	WHERE RTRIM(LTRIM(#WCSecurityWork.vdfListUDF01ID)) = RTRIM(LTRIM(WCUDFListDtl.idfID)) AND
		WCUDFListDtl.idfWCUDFListHdrKey = WCUDFListHdr.idfWCUDFListHdrKey AND
		WCUDFListDtl.idfWCUDFListHdrKey = @nidfWCUDFListHdrKey01

	--Lookup UDFListDtl Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCUDFListDtlKey02 = WCUDFListDtl.idfWCUDFListDtlKey
	FROM #WCSecurityWork, WCUDFListDtl (NOLOCK), WCUDFListHdr (NOLOCK)
	WHERE RTRIM(LTRIM(#WCSecurityWork.vdfListUDF02ID)) = RTRIM(LTRIM(WCUDFListDtl.idfID)) AND
		WCUDFListDtl.idfWCUDFListHdrKey = WCUDFListHdr.idfWCUDFListHdrKey AND
		WCUDFListDtl.idfWCUDFListHdrKey = @nidfWCUDFListHdrKey02

	--Lookup Supervisor Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCSecurityKeySupervisor = WCSecurity.idfWCSecurityKey
	FROM #WCSecurityWork
	LEFT OUTER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfSecurityID = #WCSecurityWork.vdfSecurityIDSupervisor

	SELECT @strENABLESUPERVISORAPR = idfValue FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'ENABLESUPERVISORAPR'

	-- Lookup Position Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCPositionKey = P.idfWCPositionKey
	FROM #WCSecurityWork W
		LEFT OUTER JOIN dbo.WCPosition P WITH (NOLOCK) ON W.vdfPositionID = P.idfPositionID

	-- Lookup Alternate Approver
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCSecurityKeyAprAltr = S.idfWCSecurityKey
	FROM #WCSecurityWork W
		LEFT OUTER JOIN dbo.WCSecurity S WITH (NOLOCK) ON W.vdfSecurityIDAprAltr = S.idfSecurityID

	--Clear out WCEmailDocDtl Keys and lookup based on VDF fields.
	UPDATE #WCSecurityWork 
		SET  idfWCEmailDocDtlKeyFromApr		= NULL
			,idfWCEmailDocDtlKeyFromRev		= NULL
			,idfWCEmailDocDtlKeyFromRcv		= NULL
			,idfWCEmailDocDtlKeyFromInv		= NULL
			,idfWCEmailDocDtlKeyInvNotRcv   = NULL
			,idfWCEmailDocDtlKeyIVRdyToShip	= NULL
			,idfWCEmailDocDtlKeyNotApr		= NULL
			,idfWCEmailDocDtlKeyToApr		= NULL
			,idfWCEmailDocDtlKeyRCVFromApr	= NULL      
			,idfWCEmailDocDtlKeyRCVFromAprFilter = NULL
			,idfWCEmailDocDtlKeyRCVNotApr	= NULL      
			,idfWCEmailDocDtlKeyRCVToApr	= NULL
			,idfWCEmailDocDtlKeyRCVNotMatch = NULL
			,idfWCEmailDocDtlKeyRCVReturnProcess = NULL
			,idfWCEmailDocDtlKeyToRev		= NULL
			,idfWCEmailDocDtlKeyTEFromApr	= NULL
			,idfWCEmailDocDtlKeyTEFromRev	= NULL
			,idfWCEmailDocDtlKeyTENotApr	= NULL
			,idfWCEmailDocDtlKeyTENotSub	= NULL
			,idfWCEmailDocDtlKeyTEToApr		= NULL
			,idfWCEmailDocDtlKeyEXPFromApr	= NULL
			,idfWCEmailDocDtlKeyEXPFromRev	= NULL
			,idfWCEmailDocDtlKeyEXPNotApr	= NULL
			,idfWCEmailDocDtlKeyEXPToApr	= NULL
			,idfWCEmailDocDtlKeyEXPImport	= NULL
			,idfWCEmailDocDtlKeyFrmAprFtr	= NULL
			,idfWCEmailDocDtlKeyRQDelagate	= NULL
			,idfWCEmailDocDtlKeyDelegatedRQCancelled = NULL
			,idfWCEmailDocDtlKeyPOFromApr		= NULL       
			,idfWCEmailDocDtlKeyPOFromAprFilter = NULL 
			,idfWCEmailDocDtlKeyPONotApr		= NULL       
			,idfWCEmailDocDtlKeyPOToApr			= NULL       
			,idfWCEmailDocDtlKeyRQRevCancelled	= NULL
			,idfWCEmailDocDtlKeyRQNotFullyRcv	= NULL
			,idfWCEmailDocDtlKeyRQNotApr	= NULL
			,idfWCEmailDocDtlKeyAPVNotApr	= NULL
			,idfWCEmailDocDtlKeyAPVFromApr	= NULL
			,idfWCEmailDocDtlKeyAPVToApr	= NULL
			,idfWCEmailDocDtlKeyCCImport = NULL
			,idfWCEmailDocDtlKeyPAToApr = NULL
			,idfWCEmailDocDtlKeyPANotApr = NULL
			,idfWCEmailDocDtlKeyPAFromApr = NULL
			,idfWCEmailDocDtlKeyInvCaptureNeedAttn = NULL
			,vdfEmailIDEXPFromApr 			= CASE WHEN vdfEmailIDEXPFromApr	= '' THEN '<DEFAULT>' ELSE vdfEmailIDEXPFromApr END 
			,vdfEmailIDEXPFromRev 			= CASE WHEN vdfEmailIDEXPFromRev	= '' THEN '<DEFAULT>' ELSE vdfEmailIDEXPFromRev END 
			,vdfEmailIDEXPNotApr 			= CASE WHEN vdfEmailIDEXPNotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDEXPNotApr END 
			,vdfEmailIDEXPToApr 			= CASE WHEN vdfEmailIDEXPToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDEXPToApr END 
			,vdfEmailIDEXPImport 			= CASE WHEN vdfEmailIDEXPImport		= '' THEN '<DEFAULT>' ELSE vdfEmailIDEXPImport END 
			,vdfEmailIDFromApr				= CASE WHEN vdfEmailIDFromApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDFromApr END 
			,vdfEmailIDFromRcv 				= CASE WHEN vdfEmailIDFromRcv		= '' THEN '<DEFAULT>' ELSE vdfEmailIDFromRcv END 
			,vdfEmailIDFromInv 				= CASE WHEN vdfEmailIDFromInv		= '' THEN '<DEFAULT>' ELSE vdfEmailIDFromInv END 
			,vdfEmailIDFromRev 				= CASE WHEN vdfEmailIDFromRev		= '' THEN '<DEFAULT>' ELSE vdfEmailIDFromRev END 
			,vdfEmailIDIVRdyToShip			= CASE WHEN vdfEmailIDIVRdyToShip	= '' THEN '<DEFAULT>' ELSE vdfEmailIDIVRdyToShip END 
			,vdfEmailIDNotApr 				= CASE WHEN vdfEmailIDNotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDNotApr END 
			,vdfEmailIDTEFromApr 			= CASE WHEN vdfEmailIDTEFromApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDTEFromApr END 
			,vdfEmailIDTEFromRev 			= CASE WHEN vdfEmailIDTEFromRev		= '' THEN '<DEFAULT>' ELSE vdfEmailIDTEFromRev END 
			,vdfEmailIDTENotApr 			= CASE WHEN vdfEmailIDTENotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDTENotApr END 
			,vdfEmailIDTENotSub 			= CASE WHEN vdfEmailIDTENotSub		= '' THEN '<DEFAULT>' ELSE vdfEmailIDTENotSub END 
			,vdfEmailIDTEToApr 				= CASE WHEN vdfEmailIDTEToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDTEToApr END 
			,vdfEmailIDToApr 				= CASE WHEN vdfEmailIDToApr			= '' THEN '<DEFAULT>' ELSE vdfEmailIDToApr END 
			,vdfEmailIDPOFromApr 			= CASE WHEN vdfEmailIDPOFromApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPOFromApr END 
			,vdfEmailIDPOFromAprFilter 		= CASE WHEN vdfEmailIDPOFromAprFilter	= '' THEN '<DEFAULT>' ELSE vdfEmailIDPOFromAprFilter END 
			,vdfEmailIDPONotApr 			= CASE WHEN vdfEmailIDPONotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPONotApr END 
			,vdfEmailIDPOToApr 				= CASE WHEN vdfEmailIDPOToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPOToApr END 
			,vdfEmailIDRCVFromApr 			= CASE WHEN vdfEmailIDRCVFromApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVFromApr END 
			,vdfEmailIDRCVFromAprFilter		= CASE WHEN vdfEmailIDRCVFromAprFilter	= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVFromAprFilter END 
			,vdfEmailIDRCVNotApr 			= CASE WHEN vdfEmailIDRCVNotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVNotApr END 
			,vdfEmailIDRCVToApr 			= CASE WHEN vdfEmailIDRCVToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVToApr END 
			,vdfEmailIDRCVNotMatch			= CASE WHEN vdfEmailIDRCVNotMatch		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVNotMatch END 
			,vdfEmailIDRCVReturnProcess		= CASE WHEN vdfEmailIDRCVReturnProcess		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVReturnProcess END 
			,vdfEmailIDRCVCancelled 		= CASE WHEN vdfEmailIDRCVCancelled	= '' THEN '<DEFAULT>' ELSE vdfEmailIDRCVCancelled END 
			,vdfEmailIDToRev 				= CASE WHEN vdfEmailIDToRev			= '' THEN '<DEFAULT>' ELSE vdfEmailIDToRev END 
			,vdfWCEmailDocDtlKeyFrmAprFtr	= CASE WHEN vdfWCEmailDocDtlKeyFrmAprFtr	= '' THEN '<DEFAULT>' ELSE vdfWCEmailDocDtlKeyFrmAprFtr END  
			,vdfEmailIDRQDelagate			= CASE WHEN vdfEmailIDRQDelagate			= '' THEN '<DEFAULT>' ELSE vdfEmailIDRQDelagate END 
			,vdfEmailIDDelegatedRQCancelled	= CASE WHEN vdfEmailIDDelegatedRQCancelled	= '' THEN '<DEFAULT>' ELSE vdfEmailIDDelegatedRQCancelled END
			,vdfEmailIDRQRevCancelled		= CASE WHEN vdfEmailIDRQRevCancelled		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRQRevCancelled END
			,vdfEmailIDRQNotFullyRcv		= CASE WHEN vdfEmailIDRQNotFullyRcv		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRQNotFullyRcv END
			,vdfEmailIDRQNotApr				= CASE WHEN vdfEmailIDRQNotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDRQNotApr END
			,vdfEmailIDAPVNotApr			= CASE WHEN vdfEmailIDAPVNotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDAPVNotApr END
			,vdfEmailIDAPVFromApr			= CASE WHEN vdfEmailIDAPVFromApr	= '' THEN '<DEFAULT>' ELSE vdfEmailIDAPVFromApr END
			,vdfEmailIDAPVToApr				= CASE WHEN vdfEmailIDAPVToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDAPVToApr  END
			,vdfEmailIDCCIMPORT				= CASE WHEN vdfEmailIDCCIMPORT		= '' THEN '<DEFAULT>' ELSE vdfEmailIDCCIMPORT END
			,vdfEmailIDPAToApr				= CASE WHEN vdfEmailIDPAToApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPAToApr  END
			,vdfEmailIDPAFromApr			= CASE WHEN vdfEmailIDPAFromApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPAFromApr  END
			,vdfEmailIDPANotApr				= CASE WHEN vdfEmailIDPANotApr		= '' THEN '<DEFAULT>' ELSE vdfEmailIDPANotApr  END
			,vdfEmailIDInvCaptureNeedAttn	= CASE WHEN vdfEmailIDInvCaptureNeedAttn = '' THEN '<DEFAULT>' ELSE vdfEmailIDInvCaptureNeedAttn END
			,idfWCFilterHdrKeyFromAprFilter = NULL
			,idfWCFilterHdrKeyPOFromAprFilter	= NULL
			,idfWCFilterHdrKeyRCVFromAprFilter	= NULL
			,idfRQPOTranErrorTimeToSend		= vdfRQPOTranErrorTimeToSend
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup REQUISITION email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCFilterHdrKeyFromAprFilter = isnull(WCFilterHdr.idfWCFilterHdrKey,0),
	#WCSecurityWork.vdfWCFilterHdrKeyFromAprFilter = isnull(WCFilterHdr.idfFilterID,'')
	FROM #WCSecurityWork
		INNER JOIN WCFilterHdr (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfWCFilterHdrKeyFromAprFilter))=RTRIM(LTRIM(WCFilterHdr.idfFilterID))

	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyFrmAprFtr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfWCEmailDocDtlKeyFrmAprFtr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APPROVEDFILTER'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyFrmAprFtr IS NULL	
	
	--Lookup vdfEmailIDRQRevCancelled Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRQRevCancelled = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRQRevCancelled))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RQREVCANCELLED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRQRevCancelled IS NULL 

	--Lookup vdfEmailIDRQRevCancelled Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRQNotFullyRcv = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRQNotFullyRcv))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RQNOTFULLYRCV'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRQNotFullyRcv IS NULL 
	------------------------------------------------------------------------------------------------------------------------------------
	--Lookup vdfEmailIDRQDelagate Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRQDelagate = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRQDelagate))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'DELEGATEAPRNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRQDelagate IS NULL
	
	--Lookup vdfEmailIDDelegatedRQCancelled Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyDelegatedRQCancelled = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDDelegatedRQCancelled))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'DELEGATECANCELLED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyDelegatedRQCancelled IS NULL
	
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRQPOTranError = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON '<DEFAULT>'=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'POTRANERROR'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRQPOTranError IS NULL
	------------------------------------------------------------------------------------------------------------------------------------
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyFromApr IS NULL

	--Lookup vdfEmailIDFromRev Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyFromRev = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDFromRev))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'PROCESSED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyFromRev IS NULL

	--Lookup vdfEmailIDFromRev Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyToRev = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDToRev))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'REVIEWNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyToRev IS NULL

	--Lookup vdfEmailIDTENotSub Key 
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyTENotSub = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDTENotSub))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'TESUBMITNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyTENotSub IS NULL

	--Lookup vdfEmailIDFromRcv Key 
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyFromRcv = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDFromRcv))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RECEIVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyFromRcv IS NULL

	--Lookup vdfEmailIDFromInv Key 
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyFromInv = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDFromInv))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'INVOICED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyFromInv IS NULL

	--Lookup vdfEmailIDInvNotRcv Key 
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyInvNotRcv = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDInvNotRcv))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVNOTINV'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyInvNotRcv IS NULL

	--Lookup vdfEmailIDNotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDNotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'DISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyNotApr IS NULL

	--Lookup vdfEmailIDToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyToApr IS NULL

		--Lookup vdfEmailIDRQNotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRQNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRQNotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RQNOTAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRQNotApr IS NULL
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup EXPENSE email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SELECT idfDocumentID FROM WCEmailDocHdr
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDEXPFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'EXPAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromApr IS NULL

	--Lookup vdfEmailIDEXPFromRev Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromRev = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDEXPFromRev))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'EXPPROCESSED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromRev IS NULL

	--Lookup vdfEmailIDRCVToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVToApr IS NULL

	--Lookup vdfEmailIDRCVNotMatch Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotMatch = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVNotMatch))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVMATCHNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotMatch IS NULL

	--Lookup vdfEmailIDRCVReturnProcess Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVReturnProcess = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVReturnProcess))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVRETURNPROCESS'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVReturnProcess IS NULL

	--Lookup vdfEmailIDRCVCancelled Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVCancelled = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVCancelled))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVCancelled IS NULL

	--Lookup vdfEmailIDEXPNotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyEXPNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDEXPNotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'EXPDISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyEXPNotApr IS NULL

	--Lookup vdfEmailIDEXPToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyEXPToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDEXPToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'EXPAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyEXPToApr IS NULL
	
	--Lookup vdfEmailIDEXPImport Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyEXPImport = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDEXPImport))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'EXPIMPORTED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyEXPImport IS NULL
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup TIME email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SELECT idfDocumentID FROM WCEmailDocHdr
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyTEFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDTEFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'TEAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyTEFromApr IS NULL

	--Lookup vdfEmailIDTEFromRev Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyTEFromRev = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDTEFromRev))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'TEPROCESSED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyTEFromRev IS NULL

	--Lookup vdfEmailIDTENotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyTENotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDTENotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'TEDISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyTENotApr IS NULL

	--Lookup vdfEmailIDTEToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyTEToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDTEToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'TEAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyTEToApr IS NULL
	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup Purchase Order email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- Lookup vdfEmailIDPOToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPOToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPOToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'POAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPOToApr IS NULL

	--Lookup vdfEmailIDPOFromApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPOFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPOFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'POAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPOFromApr IS NULL

	--Lookup vdfEmailIDPOFromAprFilter Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPOFromAprFilter = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPOFromAprFilter))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'POAPPROVEDFILTER'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPOFromAprFilter IS NULL

	--Lookup vdfEmailIDPONotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPONotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPONotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'PODISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPONotApr IS NULL
	
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCFilterHdrKeyPOFromAprFilter = isnull(WCFilterHdr.idfWCFilterHdrKey,0),
	#WCSecurityWork.vdfWCFilterHdrKeyPOFromAprFilter = isnull(WCFilterHdr.idfFilterID,'')
	FROM #WCSecurityWork
		INNER JOIN WCFilterHdr (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfWCFilterHdrKeyPOFromAprFilter))=RTRIM(LTRIM(WCFilterHdr.idfFilterID))
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default Match Invoice email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------	
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCFilterHdrKeyRCVFromAprFilter = isnull(WCFilterHdr.idfWCFilterHdrKey,0),
	#WCSecurityWork.vdfWCFilterHdrKeyRCVFromAprFilter = isnull(WCFilterHdr.idfFilterID,'')
	FROM #WCSecurityWork
 		INNER JOIN WCFilterHdr (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfWCFilterHdrKeyRCVFromAprFilter))=RTRIM(LTRIM(WCFilterHdr.idfFilterID))
		
	--Lookup vdfEmailIDPONotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromApr IS NULL
	
	--Lookup vdfEmailIDRCVFromAprFilter Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromAprFilter = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVFromAprFilter))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVAPPROVEDFILTER'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromAprFilter IS NULL
	
	--Lookup vdfEmailIDRCVNotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDRCVNotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'RCVDISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotApr IS NULL
	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup Vendor email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- Lookup vdfEmailIDAPVToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDAPVToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APVAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyAPVToApr IS NULL

	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDAPVFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APVAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyAPVFromApr IS NULL
	
	--Lookup vdfEmailIDAPVNotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDAPVNotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'APVDISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyAPVNotApr IS NULL

	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyInvCaptureNeedAttn = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDInvCaptureNeedAttn))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'INVCAPTUREREJECT'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyInvCaptureNeedAttn IS NULL

	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyCCImport = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDCCIMPORT))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'CCIMPORT'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyCCImport IS NULL

	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- lookup Vendor email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------
	-- Lookup vdfEmailIDPAToApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPAToApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPAToApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'PAAPPROVALNEEDED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPAToApr IS NULL

	-- Lookup vdfEmailIDPANotApr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPANotApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPANotApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'PADISAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPANotApr IS NULL

	-- Lookup vdfEmailIDPAFrom,Apr Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyPAFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDPAFromApr))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'PAAPPROVED'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyPAFromApr IS NULL	
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default REQUISITION email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- CDB 2/4/02 - Default non-specified email templates to system default.
	--Lookup vdfEmailIDFromApr Key

	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyFrmAprFtr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfWCEmailDocDtlKeyFrmAprFtr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APPROVEDFILTER'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfWCEmailDocDtlKeyFrmAprFtr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyFromApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDFromApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDFromApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDFromRev Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyFromRev	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDFromRev		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'PROCESSED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDFromRev = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDFromRcv Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyFromRcv	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDFromRcv		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'RECEIVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDFromRcv = '' AND WCEmailDocDtl.idfFlagSystem = 1

		--Lookup vdfEmailIDFromInv Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyFromInv	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDFromInv		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'INVOICED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDFromInv = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDInvNotRcv Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyInvNotRcv	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDInvNotRcv		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'RCVNOTINV'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDInvNotRcv = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDTENotSub Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyTENotSub	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDTENotSub		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'TESUBMITNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDTENotSub = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDNotApr Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyNotApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDNotApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'DISAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDNotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDToApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyToApr 	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDToApr				= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APPROVALNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDToApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDRQNotApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyRQNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDRQNotApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'RQNOTAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDRQNotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default Inventory email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	--Lookup vdfEmailIDIVRdyToShip Key
	UPDATE #WCSecurityWork SET #WCSecurityWork.idfWCEmailDocDtlKeyIVRdyToShip = WCEmailDocDtl.idfWCEmailDocDtlKey
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocDtl (NOLOCK) ON RTRIM(LTRIM(#WCSecurityWork.vdfEmailIDIVRdyToShip))=RTRIM(LTRIM(WCEmailDocDtl.idfEmailID))
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocDtl.idfWCEmailDocHdrKey = WCEmailDocHdr.idfWCEmailDocHdrKey
			AND WCEmailDocHdr.idfDocumentID = 'IVQTYRDYTOSHIP'
	WHERE #WCSecurityWork.idfWCEmailDocDtlKeyIVRdyToShip IS NULL	


	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default TIME email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- CDB 2/4/02 - Default non-specified email templates to system default.
	--Lookup vdfEmailIDTEFromApr Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyTEFromApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDTEFromApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'TEAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDTEFromApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDTEFromRev Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyTEFromRev	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDTEFromRev		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'TEPROCESSED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDTEFromRev = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDTENotApr Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyTENotApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDTENotApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'TEDISAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDTENotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDTEToApr Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyTEToApr 	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDTEToApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'TEAPPROVALNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDTEToApr = '' AND WCEmailDocDtl.idfFlagSystem = 1
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default EXPENSE email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- CDB 2/4/02 - Default non-specified email templates to system default.
	--Lookup vdfEmailIDEXPFromApr Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyEXPFromApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDEXPFromApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'EXPAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDEXPFromApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDEXPFromRev Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyEXPFromRev	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDEXPFromRev		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'EXPPROCESSED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDEXPFromRev = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDEXPNotApr Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyEXPNotApr	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDEXPNotApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'EXPDISAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDEXPNotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1
	
	--Lookup vdfEmailIDEXPImport Key
	UPDATE #WCSecurityWork 
		SET	#WCSecurityWork.idfWCEmailDocDtlKeyEXPImport	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDEXPImport				= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'EXPIMPORTED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDEXPImport = '' AND WCEmailDocDtl.idfFlagSystem = 1
	
	--Lookup vdfEmailIDEXPToApr Key
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfWCEmailDocDtlKeyEXPToApr 	= WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDEXPToApr		= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'EXPAPPROVALNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDEXPToApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default Vendor email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
		--Lookup vdfEmailIDAPVToApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVToApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDAPVToApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APVAPPROVALNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDAPVToApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDAPVFromApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APVAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDAPVFromApr = '' AND WCEmailDocDtl.idfFlagSystem = 1
	
	--Lookup vdfEmailIDAPVNotApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyAPVNotApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDAPVNotApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'APVDISAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDAPVNotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyInvCaptureNeedAttn = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDInvCaptureNeedAttn			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'INVCAPTUREREJECT'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDInvCaptureNeedAttn = '' AND WCEmailDocDtl.idfFlagSystem = 1

	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyCCImport = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDCCIMPORT			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'CCIMPORT'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDCCIMPORT = '' AND WCEmailDocDtl.idfFlagSystem = 1

	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	-- default PA email keys.
	-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	--Lookup vdfEmailIDPAToApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyPAToApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDPAToApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'PAAPPROVALNEEDED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDPAToApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDPAFromApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyPAFromApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDPAFromApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'PAAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDPAFromApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup vdfEmailIDPANotApr Key
	UPDATE #WCSecurityWork 
		SET #WCSecurityWork.idfWCEmailDocDtlKeyPANotApr = WCEmailDocDtl.idfWCEmailDocDtlKey,
			#WCSecurityWork.vdfEmailIDPANotApr			= WCEmailDocDtl.idfEmailID
	FROM #WCSecurityWork
		INNER JOIN WCEmailDocHdr (NOLOCK) ON WCEmailDocHdr.idfDocumentID = 'PADISAPPROVED'
		INNER JOIN WCEmailDocDtl (NOLOCK) ON WCEmailDocHdr.idfWCEmailDocHdrKey = WCEmailDocDtl.idfWCEmailDocHdrKey
	WHERE #WCSecurityWork.vdfEmailIDPANotApr = '' AND WCEmailDocDtl.idfFlagSystem = 1

	--Lookup idfLaborGroupKey
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfPALaborGroupKey = PALaborGroup.idfPALaborGroupKey
	FROM #WCSecurityWork
		LEFT OUTER JOIN PALaborGroup (NOLOCK) ON #WCSecurityWork.vdfLaborGroupID = PALaborGroup.idfLaborGroupID

	--Lookup idfTEEarningCodeKey
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfTEEarningCodeKey = TEEarningCode.idfTEEarningCodeKey
	FROM #WCSecurityWork
		LEFT OUTER JOIN TEEarningCode (NOLOCK) ON #WCSecurityWork.vdfEarningCodeID = TEEarningCode.idfEarningCodeID

	--Lookup idfEXPEventKey
	UPDATE #WCSecurityWork 
		SET 	#WCSecurityWork.idfEXPEventKey = EXPEvent.idfEXPEventKey
	FROM #WCSecurityWork
		LEFT OUTER JOIN EXPEvent (NOLOCK) ON #WCSecurityWork.vdfEventID = EXPEvent.idfEventID

	INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
	SELECT idfRowKey,-161,'IN' 
		FROM #WCSecurityWork
		WHERE vdfWCICCompanyIDVendor > '' AND idfWCICCompanyKeyVendor IS NULL

	UPDATE #spWCValDtl SET idfErrNum = ErrorNumber, idfOBJName = 'spWCSecurity'
	
	EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT

		-- Update email keys to 0 if none where found for default.
	UPDATE #WCSecurityWork 
		SET  idfWCEmailDocDtlKeyFromApr = CASE WHEN idfWCEmailDocDtlKeyFromApr IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyFromApr END
			,idfWCEmailDocDtlKeyFromRev = CASE WHEN idfWCEmailDocDtlKeyFromRev IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyFromRev END
			,idfWCEmailDocDtlKeyFromRcv = CASE WHEN idfWCEmailDocDtlKeyFromRcv IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyFromRcv END
			,idfWCEmailDocDtlKeyFromInv = CASE WHEN idfWCEmailDocDtlKeyFromInv IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyFromInv END
			,idfWCEmailDocDtlKeyInvNotRcv = CASE WHEN idfWCEmailDocDtlKeyInvNotRcv IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyInvNotRcv END
			,idfWCEmailDocDtlKeyNotApr  = CASE WHEN idfWCEmailDocDtlKeyNotApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyNotApr  END
			,idfWCEmailDocDtlKeyToApr   = CASE WHEN idfWCEmailDocDtlKeyToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyToApr   END
			,idfWCEmailDocDtlKeyIVRdyToShip   = CASE WHEN idfWCEmailDocDtlKeyIVRdyToShip   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyIVRdyToShip   END
			,idfWCEmailDocDtlKeyTEFromApr = CASE WHEN idfWCEmailDocDtlKeyTEFromApr IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyTEFromApr END
			,idfWCEmailDocDtlKeyTEFromRev = CASE WHEN idfWCEmailDocDtlKeyTEFromRev IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyTEFromRev END
			,idfWCEmailDocDtlKeyTENotApr  = CASE WHEN idfWCEmailDocDtlKeyTENotApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyTENotApr  END
			,idfWCEmailDocDtlKeyTENotSub = CASE WHEN idfWCEmailDocDtlKeyTENotSub IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyTENotSub END
			,idfWCEmailDocDtlKeyTEToApr   = CASE WHEN idfWCEmailDocDtlKeyTEToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyTEToApr   END
			,idfWCEmailDocDtlKeyEXPFromApr = CASE WHEN idfWCEmailDocDtlKeyEXPFromApr IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyEXPFromApr END
			,idfWCEmailDocDtlKeyEXPFromRev = CASE WHEN idfWCEmailDocDtlKeyEXPFromRev IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyEXPFromRev END
			,idfWCEmailDocDtlKeyEXPNotApr  = CASE WHEN idfWCEmailDocDtlKeyEXPNotApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyEXPNotApr  END
			,idfWCEmailDocDtlKeyEXPToApr   = CASE WHEN idfWCEmailDocDtlKeyEXPToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyEXPToApr   END
			,idfWCEmailDocDtlKeyEXPImport  = CASE WHEN idfWCEmailDocDtlKeyEXPImport  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyEXPImport  END
			,idfWCEmailDocDtlKeyFrmAprFtr  = CASE WHEN idfWCEmailDocDtlKeyFrmAprFtr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyFrmAprFtr  END
			,idfWCEmailDocDtlKeyPOFromApr		= CASE WHEN idfWCEmailDocDtlKeyPOFromApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPOFromApr  END
			,idfWCEmailDocDtlKeyPOFromAprFilter = CASE WHEN idfWCEmailDocDtlKeyPOFromAprFilter IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPOFromAprFilter END
			,idfWCEmailDocDtlKeyPONotApr		= CASE WHEN idfWCEmailDocDtlKeyPONotApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPONotApr   END
			,idfWCEmailDocDtlKeyPOToApr			= CASE WHEN idfWCEmailDocDtlKeyPOToApr    IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPOToApr    END
			,idfWCEmailDocDtlKeyRCVFromApr		= CASE WHEN idfWCEmailDocDtlKeyRCVFromApr IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVFromApr END
			,idfWCEmailDocDtlKeyRCVFromAprFilter= CASE WHEN idfWCEmailDocDtlKeyRCVFromAprFilter IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVFromAprFilter END
			,idfWCEmailDocDtlKeyRCVNotApr		= CASE WHEN idfWCEmailDocDtlKeyRCVNotApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVNotApr  END
			,idfWCEmailDocDtlKeyRCVToApr		= CASE WHEN idfWCEmailDocDtlKeyRCVToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVToApr   END
			,idfWCEmailDocDtlKeyRCVNotMatch		= CASE WHEN idfWCEmailDocDtlKeyRCVNotMatch   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVNotMatch   END
			,idfWCEmailDocDtlKeyRCVReturnProcess = CASE WHEN idfWCEmailDocDtlKeyRCVReturnProcess   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRCVReturnProcess   END
			,idfWCEmailDocDtlKeyRQRevCancelled	= CASE WHEN idfWCEmailDocDtlKeyRQRevCancelled   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRQRevCancelled   END
			,idfWCEmailDocDtlKeyRQNotFullyRcv	= CASE WHEN idfWCEmailDocDtlKeyRQNotFullyRcv   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRQNotFullyRcv   END
			,idfWCEmailDocDtlKeyRQNotApr		= CASE WHEN idfWCEmailDocDtlKeyRQNotApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyRQNotApr   END
			,idfWCEmailDocDtlKeyAPVNotApr		= CASE WHEN idfWCEmailDocDtlKeyAPVNotApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyAPVNotApr  END
			,idfWCEmailDocDtlKeyAPVFromApr		= CASE WHEN idfWCEmailDocDtlKeyAPVFromApr  IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyAPVFromApr  END
			,idfWCEmailDocDtlKeyAPVToApr		= CASE WHEN idfWCEmailDocDtlKeyAPVToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyAPVToApr   END
			,idfWCEmailDocDtlKeyCCImport		= CASE WHEN idfWCEmailDocDtlKeyCCImport   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyCCImport   END
			,idfWCEmailDocDtlKeyPAToApr			= CASE WHEN idfWCEmailDocDtlKeyPAToApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPAToApr   END
			,idfWCEmailDocDtlKeyPANotApr		= CASE WHEN idfWCEmailDocDtlKeyPANotApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPANotApr   END
			,idfWCEmailDocDtlKeyPAFromApr		= CASE WHEN idfWCEmailDocDtlKeyPAFromApr   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyPAFromApr   END
			,idfWCEmailDocDtlKeyInvCaptureNeedAttn		= CASE WHEN idfWCEmailDocDtlKeyInvCaptureNeedAttn   IS NULL THEN 0 ELSE idfWCEmailDocDtlKeyInvCaptureNeedAttn   END

	DECLARE zcurspWCSecurity CURSOR FOR SELECT
		 idfWCSecurityKey
		,idfAddr1
		,idfAddr2
		,idfAddr3
		,idfAltPhone1
		,idfAltPhone2
		,idfAltPhoneExt1
		,idfAltPhoneExt2
		,idfCity
		,idfCountry
		,idfDescription
		,idfEmail
		,idfEmailFormat
		,idfEmailSubject
		,idfEmployeeID
		,idfFax
		,idfFlagActive
		,idfFlagActiveEXP
		,idfFlagActiveHC
		,idfFlagActivePA
		,idfFlagActiveRQ
		,idfFlagActiveTE
		,idfFlagActiveEMPL
		,idfFlagExempt
		,idfFlagMgr

				,idfFlagNotifyAPVFromApr
	
				,idfFlagNotifyAPVNotApr
	
				,idfFlagNotifyAPVToApr
	
				,idfFlagNotifyCCImport
	
				,idfFlagNotifyEXPFromApr
	
				,idfFlagNotifyEXPFromRev
	
				,idfFlagNotifyEXPImport
	
				,idfFlagNotifyEXPNotApr
	
				,idfFlagNotifyEXPToApr
	
				,idfFlagNotifyFromApr
	
				,idfFlagNotifyFromAprFilter
	
				,idfFlagNotifyFromInv
	
				,idfFlagNotifyFromRcv
	
				,idfFlagNotifyFromRev
	
				,idfFlagNotifyFromRevInclPO
	
				,idfFlagNotifyInvCaptureNeedAttn
	
				,idfFlagNotifyInvNotRcv
	
				,idfFlagNotifyIVRdyToShip
	
				,idfFlagNotifyNotApr
	
				,idfFlagNotifyPAFromApr
	
				,idfFlagNotifyPANotApr
	
				,idfFlagNotifyPAToApr
	
				,idfFlagNotifyPOFromApr
	
				,idfFlagNotifyPOFromAprFilter
	
				,idfFlagNotifyPONotApr
	
				,idfFlagNotifyPOToApr
	
				,idfFlagNotifyRCVCancelled
	
				,idfFlagNotifyRCVFromApr
	
				,idfFlagNotifyRCVFromAprFilter
	
				,idfFlagNotifyRCVNotApr
	
				,idfFlagNotifyRCVNotMatch
	
				,idfFlagNotifyRCVReturnProcess
	
				,idfFlagNotifyRCVToApr
	
				,idfFlagNotifyRQFromDelegate
	
				,idfFlagNotifyRQNotApr
	
				,idfFlagNotifyRQNotFullyRcv
	
				,idfFlagNotifyRQPOTranError
	
				,idfFlagNotifyRQRevCancelled
	
				,idfFlagNotifyRQToDelegate
	
				,idfFlagNotifyTEFromApr
	
				,idfFlagNotifyTEFromRev
	
				,idfFlagNotifyTENotApr
	
				,idfFlagNotifyTENotSub
	
				,idfFlagNotifyTEToApr
	
				,idfFlagNotifyToApr
	
				,idfFlagNotifyToRev
	
		,idfFlagShowAddr1
		,idfFlagShowAddr2
		,idfFlagShowAddr3
		,idfFlagShowCity
		,idfFlagShowCountry
		,idfFlagShowEmail
		,idfFlagShowFax
		,idfFlagShowHomePage
		,idfFlagShowPager
		,idfFlagShowPhone
		,idfFlagShowPhone2
		,idfFlagShowPhoneCar
		,idfFlagShowPhoneHome
		,idfFlagShowPhoneOffice
		,idfFlagShowState
		,idfFlagShowTimeZone
		,idfFlagShowZipCode
		,idfHireDate
		,idfHomePage
		,idfNameFirst
		,idfNameLast
		,idfNameMiddle
		,idfNotifyCountApr
		,idfPager
		,idfPassword
		,idfPasswordLen
		,idfPhoneCar
		,idfPhoneExtOffice
		,idfPhoneHome
		,idfPhoneOffice
		,idfSecurityID
		,idfSecurityType
		,idfSocialSec
		,idfState
		,idfTimeZone
		,idfZipCode
		,idfListUDF01Key
		,idfWCUDFListDtlKey02
		,idfWCUDFTemplateKey
--		,idfRQFDefaultKey
--		,idfRQFReadOnlyKey
--		,idfRQFRequiredKey
		,idfPTICompanyKey
		,idfWCDeptKey
		,idfWCEmailDocDtlKeyFromApr
		,idfWCEmailDocDtlKeyFromRev
		,idfWCEmailDocDtlKeyFromRcv
		,idfWCEmailDocDtlKeyFromInv
		,idfWCEmailDocDtlKeyInvNotRcv
		,idfWCEmailDocDtlKeyNotApr
		,idfWCEmailDocDtlKeyToApr
		,idfWCEmailDocDtlKeyToRev
		,idfWCEmailDocDtlKeyFrmAprFtr
		,idfWCFilterHdrKeyFromAprFilter
        	,edfBuyer
			,edfVendor
		,idfRowKey
		,vdfListUDF01ID
		,vdfListUDF02ID
		,vdfTemplateID
		,vdfLaborGroupID		
		,vdfEarningCodeID		
		,idfPALaborGroupKey
		,idfTEEarningCodeKey
		,vdfSecurityIDSupervisor
		,idfWCSecurityKeySupervisor
		,vdfPositionID
		,idfWCPositionKey
		,vdfSecurityIDAprAltr
		,idfWCSecurityKeyAprAltr
        ,idfFlagSVCUser
	FROM #WCSecurityWork
	WHERE idfRowAction IN ('IN','UP','CP')

	OPEN zcurspWCSecurity

	FETCH zcurspWCSecurity INTO
		 @nidfWCSecurityKey
		,@stridfAddr1
		,@stridfAddr2
		,@stridfAddr3
		,@stridfAltPhone1
		,@stridfAltPhone2
		,@stridfAltPhoneExt1
		,@stridfAltPhoneExt2
		,@stridfCity
		,@stridfCountry
		,@stridfDescription
		,@stridfEmail
		,@stridfEmailFormat
		,@stridfEmailSubject
		,@stridfEmployeeID
		,@stridfFax
		,@nidfFlagActive
		,@nidfFlagActiveEXP
		,@nidfFlagActiveHC
		,@nidfFlagActivePA
		,@nidfFlagActiveRQ
		,@nidfFlagActiveTE
		,@nidfFlagActiveEMPL
		,@nidfFlagExempt
		,@nidfFlagMgr

				,@nidfFlagNotifyAPVFromApr
	
				,@nidfFlagNotifyAPVNotApr
	
				,@nidfFlagNotifyAPVToApr
	
				,@nidfFlagNotifyCCImport
	
				,@nidfFlagNotifyEXPFromApr
	
				,@nidfFlagNotifyEXPFromRev
	
				,@nidfFlagNotifyEXPImport
	
				,@nidfFlagNotifyEXPNotApr
	
				,@nidfFlagNotifyEXPToApr
	
				,@nidfFlagNotifyFromApr
	
				,@nidfFlagNotifyFromAprFilter
	
				,@nidfFlagNotifyFromInv
	
				,@nidfFlagNotifyFromRcv
	
				,@nidfFlagNotifyFromRev
	
				,@nidfFlagNotifyFromRevInclPO
	
				,@nidfFlagNotifyInvCaptureNeedAttn
	
				,@nidfFlagNotifyInvNotRcv
	
				,@nidfFlagNotifyIVRdyToShip
	
				,@nidfFlagNotifyNotApr
	
				,@nidfFlagNotifyPAFromApr
	
				,@nidfFlagNotifyPANotApr
	
				,@nidfFlagNotifyPAToApr
	
				,@nidfFlagNotifyPOFromApr
	
				,@nidfFlagNotifyPOFromAprFilter
	
				,@nidfFlagNotifyPONotApr
	
				,@nidfFlagNotifyPOToApr
	
				,@nidfFlagNotifyRCVCancelled
	
				,@nidfFlagNotifyRCVFromApr
	
				,@nidfFlagNotifyRCVFromAprFilter
	
				,@nidfFlagNotifyRCVNotApr
	
				,@nidfFlagNotifyRCVNotMatch
	
				,@nidfFlagNotifyRCVReturnProcess
	
				,@nidfFlagNotifyRCVToApr
	
				,@nidfFlagNotifyRQFromDelegate
	
				,@nidfFlagNotifyRQNotApr
	
				,@nidfFlagNotifyRQNotFullyRcv
	
				,@nidfFlagNotifyRQPOTranError
	
				,@nidfFlagNotifyRQRevCancelled
	
				,@nidfFlagNotifyRQToDelegate
	
				,@nidfFlagNotifyTEFromApr
	
				,@nidfFlagNotifyTEFromRev
	
				,@nidfFlagNotifyTENotApr
	
				,@nidfFlagNotifyTENotSub
	
				,@nidfFlagNotifyTEToApr
	
				,@nidfFlagNotifyToApr
	
				,@nidfFlagNotifyToRev
	
		,@nidfFlagShowAddr1
		,@nidfFlagShowAddr2
		,@nidfFlagShowAddr3
		,@nidfFlagShowCity
		,@nidfFlagShowCountry
		,@nidfFlagShowEmail
		,@nidfFlagShowFax
		,@nidfFlagShowHomePage
		,@nidfFlagShowPager
		,@nidfFlagShowPhone
		,@nidfFlagShowPhone2
		,@nidfFlagShowPhoneCar
		,@nidfFlagShowPhoneHome
		,@nidfFlagShowPhoneOffice
		,@nidfFlagShowState
		,@nidfFlagShowTimeZone
		,@nidfFlagShowZipCode
		,@nidfHireDate
		,@stridfHomePage
		,@stridfNameFirst
		,@stridfNameLast
		,@stridfNameMiddle
		,@nidfNotifyCountApr
		,@stridfPager
		,@stridfPassword
		,@nidfPasswordLen
		,@stridfPhoneCar
		,@stridfPhoneExtOffice
		,@stridfPhoneHome
		,@stridfPhoneOffice
		,@stridfSecurityID
		,@stridfSecurityType
		,@stridfSocialSec
		,@stridfState
		,@stridfTimeZone
		,@stridfZipCode
		,@nidfListUDF01Key
		,@nidfWCUDFListDtlKey02
		,@nidfWCUDFTemplateKey
--		,@nidfRQFDefaultKey
--		,@nidfRQFReadOnlyKey
--		,@nidfRQFRequiredKey
		,@nidfPTICompanyKey
		,@nidfWCDeptKey
		,@nidfWCEmailDocDtlKeyFromApr
		,@nidfWCEmailDocDtlKeyFromRev
		,@nidfWCEmailDocDtlKeyFromRcv
		,@nidfWCEmailDocDtlKeyFromInv
		,@nidfWCEmailDocDtlKeyInvNotRcv
		,@nidfWCEmailDocDtlKeyNotApr
		,@nidfWCEmailDocDtlKeyToApr
		,@nidfWCEmailDocDtlKeyToRev
		,@nidfWCEmailDocDtlKeyFrmAprFtr
		,@nidfWCFilterHdrKeyFromAprFilter
       	,@stredfBuyer
		,@stredfVendor
		,@nidfRowKey
		,@chvdfListUDF01ID
		,@chvdfListUDF02ID
		,@chvdfTemplateID
		,@strvdfLaborGroupID		
		,@strvdfEarningCodeID		
		,@nidfPALaborGroupKey
		,@nidfTEEarningCodeKey
		,@strvdfSecurityIDSupervisor
		,@nidfWCSecurityKeySupervisor
		,@strvdfPositionID
		,@nidfWCPositionKey
		,@strvdfSecurityIDAprAltr
		,@nidfWCSecurityKeyAprAltr
        ,@nidfFlagSVCUser

	WHILE @@fetch_status <> -1
	BEGIN
		IF @@fetch_status <> -2
		BEGIN
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
				SELECT @stridfOldidfSecurityID = S.idfSecurityID
				, @stridfNewidfSecurityID = T.idfSecurityID
				, @nidfFlagActiveOld = S.idfFlagActive
				, @nidfFlagActiveNew = T.idfFlagActive
				, @strCurrentidfRowAction = idfRowAction
				FROM #WCSecurityWork T
					LEFT OUTER JOIN WCSecurity S (NOLOCK) ON T.idfWCSecurityKey = S.idfWCSecurityKey 
				WHERE T.idfWCSecurityKey = @nidfWCSecurityKey

			
				IF @nidfFlagCreateUser = 1 AND @strCurrentidfRowAction <> 'DL'
				BEGIN
					-- Find out if user is setup allready for workplace.
					IF EXISTS(SELECT role.name 
							FROM sysusers u (NOLOCK)
								INNER JOIN sysmembers m (NOLOCK) ON u.uid = m.memberuid
								INNER JOIN sysusers role (NOLOCK) ON role.uid = m.groupuid AND role.issqlrole = 1 AND role.name IN ('PTIWorkPlaceUser','PTIWorkPlaceAdmin') 
							WHERE u.name = @stridfNewidfSecurityID)
							SELECT @nUserAllreadyExists = 1
					ELSE
							SELECT @nUserAllreadyExists = 0


					IF EXISTS(SELECT 1 FROM master..syslogins WHERE name = @stridfNewidfSecurityID) 
						SELECT @nLoginExists = 1
					ELSE
						SELECT @nLoginExists = 0

					INSERT INTO @Security(idfNewidfSecurityID,idfOldidfSecurityID,idfFlagActiveOld,idfFlagActiveNew,nLoginExists)
					VALUES(@stridfNewidfSecurityID,@stridfOldidfSecurityID,@nidfFlagActiveOld,@nidfFlagActiveNew,@nLoginExists)


					-- Only do this if user is going active or is new.
					IF (ISNULL(@nidfFlagActiveOld,0) = 0 AND @nidfFlagActiveNew = 1) OR (@nLoginExists = 0 AND @nidfFlagActiveNew = 1) BEGIN
						IF (IS_SRVROLEMEMBER ('sysadmin') = 0) BEGIN
							IF @nUserAllreadyExists = 0
								EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, 0, -151, 'spWCSecurity'
							ELSE IF @xstridfPassword IS NOT NULL
								EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, 0, -152, 'spWCSecurity'
						END
						ELSE
						BEGIN
							IF @xstridfPassword IS NULL AND @nUserAllreadyExists = 0 
								EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, 0, -153, 'spWCSecurity'			 
	
	
							IF @xstridfPassword IS NOT NULL AND @xstrEnforcePWPolicy = 'FALSE'
							BEGIN
								DECLARE 
									 @nidfPasswordMinLength		INT
									,@nidfPasswordMinSpecial	INT
									,@nPassCounter			INT
									,@nSpecialCount			INT
									,@chChar			CHAR
	
								SELECT @nidfPasswordMinLength = idfPasswordMinLength, @nidfPasswordMinSpecial = idfPasswordMinSpecial
								FROM PTIMaster..PTISystem (NOLOCK)
	
								IF LEN(@xstridfPassword) < @nidfPasswordMinLength 
									EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, 0, -149, 'spWCSecurity',@xstrParam1 =  @nidfPasswordMinLength
	
								SELECT @nPassCounter = 1, @nSpecialCount = 0
	
								WHILE @nPassCounter <= LEN(@xstridfPassword)
								BEGIN
									SELECT @chChar = SUBSTRING(@xstridfPassword, @nPassCounter,1)
									IF NOT((@chChar >= 'A' AND @chChar <='Z')
										OR (@chChar >= 'a' AND @chChar <='z')
										OR (@chChar >= '0' AND @chChar <='9'))
										SELECT @nSpecialCount = @nSpecialCount + 1
									SELECT @nPassCounter = @nPassCounter + 1
								END
	
								IF @nSpecialCount < @nidfPasswordMinSpecial
									EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, 0, -150, 'spWCSecurity',@xstrParam1 =  @nidfPasswordMinSpecial
	
							END
						END
					END
				END

				SELECT @nidfPTICompanyKey = idfPTICompanyKey FROM DYNAMICS.dbo.vwWCCompany  WITH (NOLOCK) WHERE idfDBName = db_name()
				IF ((@stridfOldidfSecurityID <> @stridfNewidfSecurityID) AND (@strCurrentidfRowAction = 'UP'))
				BEGIN
					IF NOT EXISTS (SELECT TOP 1 1 FROM PTIMaster.dbo.PTISecurity WITH (NOLOCK) WHERE idfSecurityID = @stridfNewidfSecurityID)
						BEGIN 
							INSERT INTO PTIMaster.dbo.PTIAnnouncementConfirm 
							(               
								 idfSecurityID                              
								,idfPTIAnnouncementKey        
							)
							SELECT 
								 @stridfNewidfSecurityID                              
								,idfPTIAnnouncementKey 
							FROM PTIMaster.dbo.PTIAnnouncementConfirm WITH (NOLOCK)
							WHERE idfSecurityID = @stridfOldidfSecurityID
               
						   INSERT INTO PTIMaster.dbo.PTIAnnouncementAccess
						   (
								  idfDeptID                    
								 ,idfRoleID                    
								 ,idfSecurityID                             
								 ,idfPTIAnnouncementKey        
								 ,idfPTICompanyKey      
							)     
							SELECT   
								  idfDeptID                    
								 ,idfRoleID                    
								 ,@stridfNewidfSecurityID                             
								 ,idfPTIAnnouncementKey        
								 ,idfPTICompanyKey 
							FROM PTIMaster.dbo.PTIAnnouncementAccess WITH (NOLOCK)
							WHERE idfSecurityID = @stridfOldidfSecurityID
						END
				END

				IF (@strCurrentidfRowAction IN ('UP','DL'))
				BEGIN
					IF NOT EXISTS (SELECT TOP 1 1 FROM PTIMaster.dbo.PTISecurity WITH (NOLOCK) WHERE idfSecurityID = @stridfOldidfSecurityID AND idfPTICompanyKey <> @nidfPTICompanyKey)
					BEGIN
						DELETE FROM PTIMaster.dbo.PTIAnnouncementConfirm WHERE idfSecurityID = @stridfOldidfSecurityID
						DELETE FROM PTIMaster.dbo.PTIAnnouncementAccess WHERE idfSecurityID = @stridfOldidfSecurityID
					END
				END
			------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------

			IF (@xstrCaller NOT IN ('DIAPI','IMPORT'))
			BEGIN
				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Requisition License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentRQUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfModule = 'REQUISITION'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'REQUISITION')
					BEGIN
		    			IF @nCurrentRQUsers >= @xnRQMaxUsers AND @nidfFlagActive = 1 AND @nidfFlagActiveRQ = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -134, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Requisition License Count
				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Project License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentPAUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfModule = 'PROJECT'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'PROJECT')
					BEGIN
		    			IF @nCurrentPAUsers >= @xnPAMaxUsers AND @nidfFlagActive = 1 AND @nidfFlagActivePA = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -137, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Project License Count
				-- ------------------------------------------------------------------------------------------------------------------------
				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Time License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentTEUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfModule = 'TIME'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'TIME')
					BEGIN
		    			IF @nCurrentTEUsers >= @xnTEMaxUsers AND @nidfFlagActive = 1 AND @nidfFlagActiveTE = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -138, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Time License Count
				-- ------------------------------------------------------------------------------------------------------------------------

				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Employee License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentEMPLUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfModule = 'EMPLOYEE'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'EMPLOYEE')
					BEGIN
		    			IF @nCurrentEMPLUsers >= @xnEMPLMaxUsers AND @nidfFlagActiveEMPL = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -162, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Employee License Count
				-- ------------------------------------------------------------------------------------------------------------------------

				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Expense License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentEXPUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfModule = 'EXPENSE'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'EXPENSE')
					BEGIN
		    			IF @nCurrentEXPUsers >= @xnEXPMaxUsers AND @nidfFlagActive = 1 AND @nidfFlagActiveEXP = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -139, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Expense License Count
				-- ------------------------------------------------------------------------------------------------------------------------

				-- ------------------------------------------------------------------------------------------------------------------------
				-- BEGIN Handheld License Count
				-- ------------------------------------------------------------------------------------------------------------------------
					SELECT @nCurrentHCUsers = COUNT(DISTINCT(idfSecurityID)) FROM PTIMaster..PTISecurity WITH (NOLOCK) WHERE idfModule = 'HANDHELD'
		        
					IF NOT EXISTS(SELECT 1 FROM PTIMaster..PTISecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfModule = 'HANDHELD')
					BEGIN
		    			IF @nCurrentHCUsers >= @xnHCMaxUsers AND @nidfFlagActiveHC = 1
			    		BEGIN
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -163, 'spWCSecurity'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE zcurspWCSecurity
								DEALLOCATE zcurspWCSecurity
								RETURN @xonErrNum
							END
						END
					END
				-- ------------------------------------------------------------------------------------------------------------------------
				-- END Handheld License Count
				-- ------------------------------------------------------------------------------------------------------------------------
			END

		--Supervisior cannot be user
		IF ((ISNULL(@nidfWCSecurityKeySupervisor,0) > 0) AND (ISNULL(@nidfWCSecurityKey,0) = ISNULL(@nidfWCSecurityKeySupervisor,0)))
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -160, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		
		--Make sure User ID is specified
		IF  (@stridfSecurityID = '')
            EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -147, 'spWCSecurity'

		--Make sure User ID is not a duplicate
		IF EXISTS (SELECT 1 FROM WCSecurity (NOLOCK) WHERE idfSecurityID = @stridfSecurityID AND idfWCSecurityKey != @nidfWCSecurityKey AND idfPTICompanyKey = @nidfPTICompanyKey)
		BEGIN
            EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -102, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END

		END
		--Make sure Employee ID is not a duplicate
		IF (@stridfEmployeeID <> '') AND  EXISTS (SELECT 1 FROM WCSecurity (NOLOCK) WHERE idfEmployeeID = @stridfEmployeeID AND idfWCSecurityKey != @nidfWCSecurityKey AND idfPTICompanyKey = @nidfPTICompanyKey)
		BEGIN
            EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -146, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		--If DeptKey is Null then lookup for DeptKey failed
		IF @nidfWCDeptKey IS NULL AND @nidfFlagSVCUser <> 1
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -105, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		--Make sure WCDeptKey is valid (it must exist in the WCDept table)
		IF @nidfWCDeptKey IS NOT NULL AND NOT EXISTS(SELECT 1 FROM WCDept (NOLOCK) WHERE idfWCDeptKey = @nidfWCDeptKey)
		BEGIN
	        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -106, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		--Make sure UDFListDtlKey is valid
		IF (RTRIM(@chvdfListUDF01ID) <> '' AND @nidfListUDF01Key IS NULL) OR (@nidfListUDF01Key IS NOT NULL AND NOT EXISTS (SELECT 1 FROM WCUDFListDtl (NOLOCK) WHERE idfWCUDFListDtlKey = @nidfListUDF01Key))
		BEGIN
			SELECT @xostrErrInfo = @stridfUDFDescription01 + ' is invalid.'

	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -113, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
			SELECT @xostrErrInfo = ''
		END
		--Make sure UDFListDtlKey is valid
		IF (RTRIM(@chvdfListUDF02ID) <> '' AND @nidfWCUDFListDtlKey02 IS NULL) OR (@nidfWCUDFListDtlKey02 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM WCUDFListDtl (NOLOCK) WHERE idfWCUDFListDtlKey = @nidfWCUDFListDtlKey02))
		BEGIN
			SELECT @xostrErrInfo = @stridfUDFDescription02 + ' is invalid.'

	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -145, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
			SELECT @xostrErrInfo = ''
		END
		IF IsNull(RTRIM(LTRIM(@stridfNameLast)),'') = '' AND @nidfFlagSVCUser <> 1
		BEGIN
	        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -116, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfFlagActiveEXP = 1) BEGIN
			IF @stredfVendor = '' 
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -154, 'spWCSecurity'
			ELSE		
				IF NOT EXISTS(SELECT TOP 1 1 FROM PM00200 (NOLOCK) WHERE VENDORID = @stredfVendor AND VENDSTTS <> 2)
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -155, 'spWCSecurity'
		END
		
		-- CDB 4/12/04 - if user is to receive email message then require email address.
		IF 
			(@nidfFlagNotifyFromApr=1 

				OR @nidfFlagNotifyAPVFromApr=1
				OR @nidfFlagNotifyAPVNotApr=1
				OR @nidfFlagNotifyAPVToApr=1
				OR @nidfFlagNotifyCCImport=1
				OR @nidfFlagNotifyEXPFromApr=1
				OR @nidfFlagNotifyEXPFromRev=1
				OR @nidfFlagNotifyEXPImport=1
				OR @nidfFlagNotifyEXPNotApr=1
				OR @nidfFlagNotifyEXPToApr=1
				OR @nidfFlagNotifyFromApr=1
				OR @nidfFlagNotifyFromAprFilter=1
				OR @nidfFlagNotifyFromInv=1
				OR @nidfFlagNotifyFromRcv=1
				OR @nidfFlagNotifyFromRev=1
				OR @nidfFlagNotifyFromRevInclPO=1
				OR @nidfFlagNotifyInvCaptureNeedAttn=1
				OR @nidfFlagNotifyInvNotRcv=1
				OR @nidfFlagNotifyIVRdyToShip=1
				OR @nidfFlagNotifyNotApr=1
				OR @nidfFlagNotifyPAFromApr=1
				OR @nidfFlagNotifyPANotApr=1
				OR @nidfFlagNotifyPAToApr=1
				OR @nidfFlagNotifyPOFromApr=1
				OR @nidfFlagNotifyPOFromAprFilter=1
				OR @nidfFlagNotifyPONotApr=1
				OR @nidfFlagNotifyPOToApr=1
				OR @nidfFlagNotifyRCVCancelled=1
				OR @nidfFlagNotifyRCVFromApr=1
				OR @nidfFlagNotifyRCVFromAprFilter=1
				OR @nidfFlagNotifyRCVNotApr=1
				OR @nidfFlagNotifyRCVNotMatch=1
				OR @nidfFlagNotifyRCVReturnProcess=1
				OR @nidfFlagNotifyRCVToApr=1
				OR @nidfFlagNotifyRQFromDelegate=1
				OR @nidfFlagNotifyRQNotApr=1
				OR @nidfFlagNotifyRQNotFullyRcv=1
				OR @nidfFlagNotifyRQPOTranError=1
				OR @nidfFlagNotifyRQRevCancelled=1
				OR @nidfFlagNotifyRQToDelegate=1
				OR @nidfFlagNotifyTEFromApr=1
				OR @nidfFlagNotifyTEFromRev=1
				OR @nidfFlagNotifyTENotApr=1
				OR @nidfFlagNotifyTENotSub=1
				OR @nidfFlagNotifyTEToApr=1
				OR @nidfFlagNotifyToApr=1
				OR @nidfFlagNotifyToRev=1
			) AND
			(IsNull(RTRIM(LTRIM(@stridfEmail)),'') = '')
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -117, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		
		IF IsNull(RTRIM(LTRIM(@stridfNameFirst)),'') = '' AND @nidfFlagSVCUser <> 1
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -118, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF @nidfFlagForced01 = 1 and @nidfListUDF01Key IS NULL
		BEGIN
			SELECT @xostrErrInfo = 'A valid ' + @stridfUDFDescription01 + ' is required.'

	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -119, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END

			SELECT @xostrErrInfo = ''

		END

		IF @nidfFlagForced02 = 1 and @nidfWCUDFListDtlKey02 IS NULL
		BEGIN
			SELECT @xostrErrInfo = 'A valid ' + @stridfUDFDescription02 + ' is required.'

	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -119, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END

			SELECT @xostrErrInfo = ''

		END

		IF (@nidfNotifyCountApr IS NULL) OR (@nidfFlagNotifyToApr = 1 AND @nidfNotifyCountApr = 0)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -120, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END

		IF (IsNull(RTRIM(@stridfEmailFormat),'') = '') OR ((@stridfEmailFormat <> 'TEXT') AND (@stridfEmailFormat <> 'HTML'))
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -128, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END

		IF (@nidfWCEmailDocDtlKeyToApr IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -129, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyFromApr IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -130, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyFrmAprFtr IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -156, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
--		IF (@nidfWCFilterHdrKeyFromAprFilter IS NULL)
--		BEGIN
--	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -157, 'spWCSecurity'
--			IF @xonErrNum <> 0
--			BEGIN
--				CLOSE zcurspWCSecurity
--				DEALLOCATE zcurspWCSecurity
--				RETURN @xonErrNum
--			END
--		END
		IF (@nidfWCEmailDocDtlKeyNotApr IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -131, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyFromRev IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -132, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyToRev IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -148, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyFromRcv IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -135, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyFromInv IS NULL)
		BEGIN
	        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -170, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@nidfWCEmailDocDtlKeyInvNotRcv IS NULL)
		BEGIN
	        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -171, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF (@chvdfTemplateID <> '' AND @nidfWCUDFTemplateKey IS NULL)
		BEGIN
	                EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -133, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END
		IF @stredfBuyer <> '' AND NOT EXISTS(SELECT 1 FROM POP00101 (NOLOCK) WHERE BUYERID = @stredfBuyer)
		BEGIN
	        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -136, 'spWCSecurity'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE zcurspWCSecurity
				DEALLOCATE zcurspWCSecurity
				RETURN @xonErrNum
			END
		END

		IF (@strvdfLaborGroupID <> '' AND @nidfPALaborGroupKey IS NULL) 
		        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -141, 'spWCSecurity'

		IF (@strvdfEarningCodeID <> '' AND @nidfTEEarningCodeKey IS NULL) 
		        EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -142, 'spWCSecurity'

		IF (@strvdfSecurityIDSupervisor <> '' AND @nidfWCSecurityKeySupervisor IS NULL) 
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -159, 'spWCSecurity'

		IF (@strvdfPositionID <> '' AND @nidfWCPositionKey IS NULL) 
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -167, 'spWCSecurity'

		IF (@strvdfSecurityIDAprAltr <> '' AND @nidfWCSecurityKeyAprAltr IS NULL) 
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -168, 'spWCSecurity'
		
		IF @nidfFlagCreateUser = 1 AND IS_SRVROLEMEMBER ('sysadmin') = 1 
		BEGIN
			IF (@stridfOldidfSecurityID IS NOT NULL AND (@stridfOldidfSecurityID <> @stridfNewidfSecurityID  OR @strCurrentidfRowAction='DL' OR @nidfFlagActiveNew = 0))
			BEGIN
				EXEC spPTISQLRevokeAccess @xstridfSecurityID = @stridfOldidfSecurityID
			END
		END

        IF(@nidfFlagActive=1 AND @nidfFlagSVCUser=1)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT, @nidfRowKey, -169, 'spWCSecurity'


		END --@@fetch_status <> -2

		FETCH zcurspWCSecurity INTO
			 @nidfWCSecurityKey
			,@stridfAddr1
			,@stridfAddr2
			,@stridfAddr3
			,@stridfAltPhone1
			,@stridfAltPhone2
			,@stridfAltPhoneExt1
			,@stridfAltPhoneExt2
			,@stridfCity
			,@stridfCountry
			,@stridfDescription
			,@stridfEmail
			,@stridfEmailFormat
			,@stridfEmailSubject
			,@stridfEmployeeID
			,@stridfFax
			,@nidfFlagActive
			,@nidfFlagActiveEXP
			,@nidfFlagActiveHC
			,@nidfFlagActivePA
			,@nidfFlagActiveRQ
			,@nidfFlagActiveTE
			,@nidfFlagActiveEMPL
			,@nidfFlagExempt
			,@nidfFlagMgr

				,@nidfFlagNotifyAPVFromApr
	
				,@nidfFlagNotifyAPVNotApr
	
				,@nidfFlagNotifyAPVToApr
	
				,@nidfFlagNotifyCCImport
	
				,@nidfFlagNotifyEXPFromApr
	
				,@nidfFlagNotifyEXPFromRev
	
				,@nidfFlagNotifyEXPImport
	
				,@nidfFlagNotifyEXPNotApr
	
				,@nidfFlagNotifyEXPToApr
	
				,@nidfFlagNotifyFromApr
	
				,@nidfFlagNotifyFromAprFilter
	
				,@nidfFlagNotifyFromInv
	
				,@nidfFlagNotifyFromRcv
	
				,@nidfFlagNotifyFromRev
	
				,@nidfFlagNotifyFromRevInclPO
	
				,@nidfFlagNotifyInvCaptureNeedAttn
	
				,@nidfFlagNotifyInvNotRcv
	
				,@nidfFlagNotifyIVRdyToShip
	
				,@nidfFlagNotifyNotApr
	
				,@nidfFlagNotifyPAFromApr
	
				,@nidfFlagNotifyPANotApr
	
				,@nidfFlagNotifyPAToApr
	
				,@nidfFlagNotifyPOFromApr
	
				,@nidfFlagNotifyPOFromAprFilter
	
				,@nidfFlagNotifyPONotApr
	
				,@nidfFlagNotifyPOToApr
	
				,@nidfFlagNotifyRCVCancelled
	
				,@nidfFlagNotifyRCVFromApr
	
				,@nidfFlagNotifyRCVFromAprFilter
	
				,@nidfFlagNotifyRCVNotApr
	
				,@nidfFlagNotifyRCVNotMatch
	
				,@nidfFlagNotifyRCVReturnProcess
	
				,@nidfFlagNotifyRCVToApr
	
				,@nidfFlagNotifyRQFromDelegate
	
				,@nidfFlagNotifyRQNotApr
	
				,@nidfFlagNotifyRQNotFullyRcv
	
				,@nidfFlagNotifyRQPOTranError
	
				,@nidfFlagNotifyRQRevCancelled
	
				,@nidfFlagNotifyRQToDelegate
	
				,@nidfFlagNotifyTEFromApr
	
				,@nidfFlagNotifyTEFromRev
	
				,@nidfFlagNotifyTENotApr
	
				,@nidfFlagNotifyTENotSub
	
				,@nidfFlagNotifyTEToApr
	
				,@nidfFlagNotifyToApr
	
				,@nidfFlagNotifyToRev
	
			,@nidfFlagShowAddr1
			,@nidfFlagShowAddr2
			,@nidfFlagShowAddr3
			,@nidfFlagShowCity
			,@nidfFlagShowCountry
			,@nidfFlagShowEmail
			,@nidfFlagShowFax
			,@nidfFlagShowHomePage
			,@nidfFlagShowPager
			,@nidfFlagShowPhone
			,@nidfFlagShowPhone2
			,@nidfFlagShowPhoneCar
			,@nidfFlagShowPhoneHome
			,@nidfFlagShowPhoneOffice
			,@nidfFlagShowState
			,@nidfFlagShowTimeZone
			,@nidfFlagShowZipCode
			,@nidfHireDate
			,@stridfHomePage
			,@stridfNameFirst
			,@stridfNameLast
			,@stridfNameMiddle
			,@nidfNotifyCountApr
			,@stridfPager
			,@stridfPassword
			,@nidfPasswordLen
			,@stridfPhoneCar
			,@stridfPhoneExtOffice
			,@stridfPhoneHome
			,@stridfPhoneOffice
			,@stridfSecurityID
			,@stridfSecurityType
			,@stridfSocialSec
			,@stridfState
			,@stridfTimeZone
			,@stridfZipCode
			,@nidfListUDF01Key
			,@nidfWCUDFListDtlKey02
			,@nidfWCUDFTemplateKey
--			,@nidfRQFDefaultKey
--			,@nidfRQFReadOnlyKey
--			,@nidfRQFRequiredKey
			,@nidfPTICompanyKey
			,@nidfWCDeptKey
			,@nidfWCEmailDocDtlKeyFromApr
			,@nidfWCEmailDocDtlKeyFromRev
			,@nidfWCEmailDocDtlKeyFromRcv
			,@nidfWCEmailDocDtlKeyFromInv
			,@nidfWCEmailDocDtlKeyInvNotRcv
			,@nidfWCEmailDocDtlKeyNotApr
			,@nidfWCEmailDocDtlKeyToApr
			,@nidfWCEmailDocDtlKeyToRev
			,@nidfWCEmailDocDtlKeyFrmAprFtr
			,@nidfWCFilterHdrKeyFromAprFilter
       		,@stredfBuyer
			,@stredfVendor
			,@nidfRowKey
			,@chvdfListUDF01ID
			,@chvdfListUDF02ID
			,@chvdfTemplateID
			,@strvdfLaborGroupID		
			,@strvdfEarningCodeID		
			,@nidfPALaborGroupKey
			,@nidfTEEarningCodeKey
			,@strvdfSecurityIDSupervisor
			,@nidfWCSecurityKeySupervisor
			,@strvdfPositionID
			,@nidfWCPositionKey
			,@strvdfSecurityIDAprAltr
			,@nidfWCSecurityKeyAprAltr
            ,@nidfFlagSVCUser

	END --@@fetch_status <> -1
	CLOSE zcurspWCSecurity
	DEALLOCATE zcurspWCSecurity

	IF @xonErrNum IS NULL OR @xonErrNum = 0
	BEGIN
		IF @nWCValHdrKey IS NULL
			SELECT @xonErrNum = 0
	     	ELSE
	       		SELECT @xonErrNum = @nWCValHdrKey
	END
END --IF @xchAction = 'VL' or 'CM'

IF @xchAction = 'CM' AND @nWCValHdrKey IS NULL
BEGIN
	BEGIN TRANSACTION
	--Delete
	
	DECLARE @nidfWCTableAuditHdrKey INT 
	IF EXISTS(SELECT TOP 1 1 FROM #WCSecurityWork WHERE idfRowAction IN ('DL','IN','UP')) AND EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'WCENABLEAUDIT' AND idfValue = 1)
	BEGIN 
		UPDATE WCTableAuditHdr SET idfOwnerSPID = -1 WHERE idfOwnerSPID = @@SPID
		INSERT INTO WCTableAuditHdr (idfUserID,idfTableName,idfDateModified,idfOwnerSPID,idfOwnerCreated,idfOwnerProcess,idfWCAuditReportTypeKey)
		SELECT dbo.fnWCSecurity(''),'WCSecurity',getdate(),@@SPID,GETDATE(),'spWCSecurity',15
		SELECT @nidfWCTableAuditHdrKey = SCOPE_IDENTITY()
	END

	DELETE WCSecurity
	FROM WCSecurity, #WCSecurityWork
	WHERE WCSecurity.idfWCSecurityKey = #WCSecurityWork.idfWCSecurityKey
	AND #WCSecurityWork.idfRowAction = 'DL'

	DELETE #WCSecurityWork
	WHERE #WCSecurityWork.idfRowAction = 'DL'

	--Insert
	DECLARE zcurspWCSecurityIN INSENSITIVE CURSOR
	FOR SELECT
		 idfWCSecurityKey
		,idfAddr1
		,idfAddr2
		,idfAddr3
		,idfAltPhone1
		,idfAltPhone2
		,idfAltPhoneExt1
		,idfAltPhoneExt2
		,idfCity
		,idfCountry
		,idfDescription
		,idfEmail
		,idfEmailFormat
		,idfEmailSubject
		,idfEmployeeID
		,idfFax
		,idfFlagActive
		,idfFlagActivePA
		,idfFlagActiveRQ
		,idfFlagExempt
		,idfFlagMgr
		,idfFlagNotifyFromApr
		,idfFlagNotifyFromRev
		,idfFlagNotifyFromRcv
		,idfFlagNotifyFromInv
		,idfFlagNotifyInvNotRcv
		,idfFlagNotifyNotApr
		,idfFlagNotifyToApr
		,idfFlagShowAddr1
		,idfFlagShowAddr2
		,idfFlagShowAddr3
		,idfFlagShowCity
		,idfFlagShowCountry
		,idfFlagShowEmail
		,idfFlagShowFax
		,idfFlagShowHomePage
		,idfFlagShowPager
		,idfFlagShowPhone
		,idfFlagShowPhone2
		,idfFlagShowPhoneCar
		,idfFlagShowPhoneHome
		,idfFlagShowPhoneOffice
		,idfFlagShowState
		,idfFlagShowTimeZone
		,idfFlagShowZipCode
		,idfHireDate
		,idfHomePage
		,idfNameFirst
		,idfNameLast
		,idfNameMiddle
		,idfNotifyCountApr
		,idfPager
		,idfPassword
		,idfPasswordLen
		,idfPhoneCar
		,idfPhoneExtOffice
		,idfPhoneHome
		,idfPhoneOffice
		,idfSecurityID
		,idfSecurityType
		,idfSocialSec
		,idfState
		,idfTimeZone
		,idfZipCode
		,idfListUDF01Key
		,idfWCUDFListDtlKey02
--		,idfRQFDefaultKey
--		,idfRQFReadOnlyKey
--		,idfRQFRequiredKey
		,idfPTICompanyKey
		,idfWCDeptKey
		,idfWCEmailDocDtlKeyFromApr
		,idfWCEmailDocDtlKeyFromRev
		,idfWCEmailDocDtlKeyFromRcv
		,idfWCEmailDocDtlKeyFromInv
		,idfWCEmailDocDtlKeyInvNotRcv
		,idfWCEmailDocDtlKeyNotApr
		,idfWCEmailDocDtlKeyToApr
		,idfWCEmailDocDtlKeyFrmAprFtr
		,idfWCFilterHdrKeyFromAprFilter
		,edfBuyer
		,idfRowKey
	FROM #WCSecurityWork
	WHERE idfRowAction IN ('IN','CP')

	OPEN zcurspWCSecurityIN

	FETCH zcurspWCSecurityIN INTO
		 @nidfWCSecurityKey
		,@stridfAddr1
		,@stridfAddr2
		,@stridfAddr3
		,@stridfAltPhone1
		,@stridfAltPhone2
		,@stridfAltPhoneExt1
		,@stridfAltPhoneExt2
		,@stridfCity
		,@stridfCountry
		,@stridfDescription
		,@stridfEmail
		,@stridfEmailFormat
		,@stridfEmailSubject
		,@stridfEmployeeID
		,@stridfFax
		,@nidfFlagActive
		,@nidfFlagActivePA
		,@nidfFlagActiveRQ
		,@nidfFlagExempt
		,@nidfFlagMgr
		,@nidfFlagNotifyFromApr
		,@nidfFlagNotifyFromRev
		,@nidfFlagNotifyFromRcv
		,@nidfFlagNotifyFromInv
		,@nidfFlagNotifyInvNotRcv
		,@nidfFlagNotifyNotApr
		,@nidfFlagNotifyToApr
		,@nidfFlagShowAddr1
		,@nidfFlagShowAddr2
		,@nidfFlagShowAddr3
		,@nidfFlagShowCity
		,@nidfFlagShowCountry
		,@nidfFlagShowEmail
		,@nidfFlagShowFax
		,@nidfFlagShowHomePage
		,@nidfFlagShowPager
		,@nidfFlagShowPhone
		,@nidfFlagShowPhone2
		,@nidfFlagShowPhoneCar
		,@nidfFlagShowPhoneHome
		,@nidfFlagShowPhoneOffice
		,@nidfFlagShowState
		,@nidfFlagShowTimeZone
		,@nidfFlagShowZipCode
		,@nidfHireDate
		,@stridfHomePage
		,@stridfNameFirst
		,@stridfNameLast
		,@stridfNameMiddle
		,@nidfNotifyCountApr
		,@stridfPager
		,@stridfPassword
		,@nidfPasswordLen
		,@stridfPhoneCar
		,@stridfPhoneExtOffice
		,@stridfPhoneHome
		,@stridfPhoneOffice
		,@stridfSecurityID
		,@stridfSecurityType
		,@stridfSocialSec
		,@stridfState
		,@stridfTimeZone
		,@stridfZipCode
		,@nidfListUDF01Key
		,@nidfWCUDFListDtlKey02
--		,@nidfRQFDefaultKey
--		,@nidfRQFReadOnlyKey
--		,@nidfRQFRequiredKey
		,@nidfPTICompanyKey
		,@nidfWCDeptKey
		,@nidfWCEmailDocDtlKeyFromApr
		,@nidfWCEmailDocDtlKeyFromRev
		,@nidfWCEmailDocDtlKeyFromRcv
		,@nidfWCEmailDocDtlKeyFromInv
		,@nidfWCEmailDocDtlKeyInvNotRcv
		,@nidfWCEmailDocDtlKeyNotApr
		,@nidfWCEmailDocDtlKeyToApr
		,@nidfWCEmailDocDtlKeyFrmAprFtr
		,@nidfWCFilterHdrKeyFromAprFilter
		,@stredfBuyer
		,@nidfRowKey

	WHILE @@fetch_status <> -1
	BEGIN
		IF @@fetch_status <> -2
		BEGIN
			EXEC spWCGetNextPK 'WCSecurity',@nNewKey OUTPUT

			UPDATE #WCSecurityWork SET
			#WCSecurityWork.idfWCSecurityKey = @nNewKey
			WHERE idfRowKey = @nidfRowKey
		END -- @@fetch_status <> -2

		FETCH zcurspWCSecurityIN INTO
			 @nidfWCSecurityKey
			,@stridfAddr1
			,@stridfAddr2
			,@stridfAddr3
			,@stridfAltPhone1
			,@stridfAltPhone2
			,@stridfAltPhoneExt1
			,@stridfAltPhoneExt2
			,@stridfCity
			,@stridfCountry
			,@stridfDescription
			,@stridfEmail
			,@stridfEmailFormat
			,@stridfEmailSubject
			,@stridfEmployeeID
			,@stridfFax
			,@nidfFlagActive
			,@nidfFlagActivePA
			,@nidfFlagActiveRQ
			,@nidfFlagExempt
			,@nidfFlagMgr
			,@nidfFlagNotifyFromApr
			,@nidfFlagNotifyFromRev
			,@nidfFlagNotifyFromRcv
			,@nidfFlagNotifyFromInv
			,@nidfFlagNotifyInvNotRcv
			,@nidfFlagNotifyNotApr
			,@nidfFlagNotifyToApr
			,@nidfFlagShowAddr1
			,@nidfFlagShowAddr2
			,@nidfFlagShowAddr3
			,@nidfFlagShowCity
			,@nidfFlagShowCountry
			,@nidfFlagShowEmail
			,@nidfFlagShowFax
			,@nidfFlagShowHomePage
			,@nidfFlagShowPager
			,@nidfFlagShowPhone
			,@nidfFlagShowPhone2
			,@nidfFlagShowPhoneCar
			,@nidfFlagShowPhoneHome
			,@nidfFlagShowPhoneOffice
			,@nidfFlagShowState
			,@nidfFlagShowTimeZone
			,@nidfFlagShowZipCode
			,@nidfHireDate
			,@stridfHomePage
			,@stridfNameFirst
			,@stridfNameLast
			,@stridfNameMiddle
			,@nidfNotifyCountApr
			,@stridfPager
			,@stridfPassword
			,@nidfPasswordLen
			,@stridfPhoneCar
			,@stridfPhoneExtOffice
			,@stridfPhoneHome
			,@stridfPhoneOffice
			,@stridfSecurityID
			,@stridfSecurityType
			,@stridfSocialSec
			,@stridfState
			,@stridfTimeZone
			,@stridfZipCode
			,@nidfListUDF01Key
			,@nidfWCUDFListDtlKey02
--			,@nidfRQFDefaultKey
--			,@nidfRQFReadOnlyKey
--			,@nidfRQFRequiredKey
			,@nidfPTICompanyKey
			,@nidfWCDeptKey
			,@nidfWCEmailDocDtlKeyFromApr
			,@nidfWCEmailDocDtlKeyFromRev
			,@nidfWCEmailDocDtlKeyFromRcv
			,@nidfWCEmailDocDtlKeyFromInv
			,@nidfWCEmailDocDtlKeyInvNotRcv
			,@nidfWCEmailDocDtlKeyNotApr
			,@nidfWCEmailDocDtlKeyToApr
			,@nidfWCEmailDocDtlKeyFrmAprFtr
			,@nidfWCFilterHdrKeyFromAprFilter
			,@stredfBuyer
			,@nidfRowKey

	END --@@fetch_status <> -1
	CLOSE zcurspWCSecurityIN
	DEALLOCATE zcurspWCSecurityIN

	-- Remove all Paging Records if Paging Size is Changed.
	IF (NOT EXISTS (SELECT TOP 1 1 FROM #WCSecurityWork 
				INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = #WCSecurityWork.idfWCSecurityKey
				WHERE WCSecurity.idfWCUDFTemplateKey <> #WCSecurityWork.idfWCUDFTemplateKey))
	BEGIN
		DELETE PTIPagingPageDetail
		DELETE PTIPagingPageHeader
		DELETE PTIPagingHeader
	END

	INSERT INTO WCSecurity
	(
		idfWCSecurityKey

				,edfBuyer
				,edfVendor
				,idfAddr1
				,idfAddr2
				,idfAddr3
				,idfAltPhone1
				,idfAltPhone2
				,idfAltPhoneExt1
				,idfAltPhoneExt2
				,idfAPVendorKey
				,idfCity
				,idfCommuteDistance
				,idfCommuteUOM
				,idfCompany
				,idfCountry
				,idfCreatedBy
				,idfDateCreated
				,idfDateModified
				,idfDescription
				,idfEmail
				,idfEmailFormat
				,idfEmailSubject
				,idfEmployeeID
				,idfEXPEventKey
				,idfFax
				,idfFlagActive
				,idfFlagActiveEMPL
				,idfFlagActiveEXP
				,idfFlagActiveHC
				,idfFlagActivePA
				,idfFlagActiveRQ
				,idfFlagActiveTE
				,idfFlagAltrActive
				,idfFlagAltrActiveSupervisor
				,idfFlagAltrEmail
				,idfFlagChangePassword
				,idfFlagExempt
				,idfFlagMgr
				,idfFlagNotifyAPVFromApr
				,idfFlagNotifyAPVNotApr
				,idfFlagNotifyAPVToApr
				,idfFlagNotifyCCImport
				,idfFlagNotifyEXPFromApr
				,idfFlagNotifyEXPFromRev
				,idfFlagNotifyEXPImport
				,idfFlagNotifyEXPNotApr
				,idfFlagNotifyEXPToApr
				,idfFlagNotifyFromApr
				,idfFlagNotifyFromAprFilter
				,idfFlagNotifyFromInv
				,idfFlagNotifyFromRcv
				,idfFlagNotifyFromRev
				,idfFlagNotifyFromRevInclPO
				,idfFlagNotifyInvCaptureNeedAttn
				,idfFlagNotifyInvNotRcv
				,idfFlagNotifyIVRdyToShip
				,idfFlagNotifyNotApr
				,idfFlagNotifyPAFromApr
				,idfFlagNotifyPANotApr
				,idfFlagNotifyPAToApr
				,idfFlagNotifyPOFromApr
				,idfFlagNotifyPOFromAprFilter
				,idfFlagNotifyPONotApr
				,idfFlagNotifyPOToApr
				,idfFlagNotifyRCVCancelled
				,idfFlagNotifyRCVFromApr
				,idfFlagNotifyRCVFromAprFilter
				,idfFlagNotifyRCVNotApr
				,idfFlagNotifyRCVNotMatch
				,idfFlagNotifyRCVReturnProcess
				,idfFlagNotifyRCVToApr
				,idfFlagNotifyRQFromDelegate
				,idfFlagNotifyRQNotApr
				,idfFlagNotifyRQNotFullyRcv
				,idfFlagNotifyRQPOTranError
				,idfFlagNotifyRQRevCancelled
				,idfFlagNotifyRQToDelegate
				,idfFlagNotifyTEFromApr
				,idfFlagNotifyTEFromRev
				,idfFlagNotifyTENotApr
				,idfFlagNotifyTENotSub
				,idfFlagNotifyTEToApr
				,idfFlagNotifyToApr
				,idfFlagNotifyToRev
				,idfFlagShowAddr1
				,idfFlagShowAddr2
				,idfFlagShowAddr3
				,idfFlagShowCity
				,idfFlagShowCountry
				,idfFlagShowEmail
				,idfFlagShowFax
				,idfFlagShowHomePage
				,idfFlagShowPager
				,idfFlagShowPhone
				,idfFlagShowPhone2
				,idfFlagShowPhoneCar
				,idfFlagShowPhoneHome
				,idfFlagShowPhoneOffice
				,idfFlagShowState
				,idfFlagShowTimeZone
				,idfFlagShowZipCode
				,idfFlagSVCUser
				,idfHireDate
				,idfHomePage
				,idfHoursTEMax
				,idfHoursTEMin
				,idfListUDF01Key
				,idfNameFirst
				,idfNameLast
				,idfNameMiddle
				,idfNotifyAPVCountApr
				,idfNotifyCountApr
				,idfNotifyEXPCountApr
				,idfNotifyPOCountApr
				,idfNotifyRCVCountApr
				,idfNotifyRQCountRev
				,idfNotifyTECountApr
				,idfPager
				,idfPALaborGroupKey
				,idfPassword
				,idfPasswordLen
				,idfPasswordSVC
				,idfPhoneCar
				,idfPhoneExtOffice
				,idfPhoneHome
				,idfPhoneOffice
				,idfPTICompanyKey
				,idfRateBill
				,idfRateCost
				,idfRQPOTranErrorTimeToSend
				,idfRQPOTranErrorTimeToSendLast
				,idfSecurityID
				,idfSecurityType
				,idfSocialSec
				,idfState
				,idfTEEarningCodeKey
				,idfTimeZone
				,idfWCDeptKey
				,idfWCEmailDocDtlKeyAPVFromApr
				,idfWCEmailDocDtlKeyAPVNotApr
				,idfWCEmailDocDtlKeyAPVToApr
				,idfWCEmailDocDtlKeyCCImport
				,idfWCEmailDocDtlKeyDelegatedRQCancelled
				,idfWCEmailDocDtlKeyEXPFromApr
				,idfWCEmailDocDtlKeyEXPFromRev
				,idfWCEmailDocDtlKeyEXPImport
				,idfWCEmailDocDtlKeyEXPNotApr
				,idfWCEmailDocDtlKeyEXPToApr
				,idfWCEmailDocDtlKeyFrmAprFtr
				,idfWCEmailDocDtlKeyFromApr
				,idfWCEmailDocDtlKeyFromInv
				,idfWCEmailDocDtlKeyFromRcv
				,idfWCEmailDocDtlKeyFromRev
				,idfWCEmailDocDtlKeyInvCaptureNeedAttn
				,idfWCEmailDocDtlKeyInvNotRcv
				,idfWCEmailDocDtlKeyIVRdyToShip
				,idfWCEmailDocDtlKeyNotApr
				,idfWCEmailDocDtlKeyPAFromApr
				,idfWCEmailDocDtlKeyPANotApr
				,idfWCEmailDocDtlKeyPAToApr
				,idfWCEmailDocDtlKeyPOFromApr
				,idfWCEmailDocDtlKeyPOFromAprFilter
				,idfWCEmailDocDtlKeyPONotApr
				,idfWCEmailDocDtlKeyPOToApr
				,idfWCEmailDocDtlKeyRCVCancelled
				,idfWCEmailDocDtlKeyRCVFromApr
				,idfWCEmailDocDtlKeyRCVFromAprFilter
				,idfWCEmailDocDtlKeyRCVNotApr
				,idfWCEmailDocDtlKeyRCVNotMatch
				,idfWCEmailDocDtlKeyRCVReturnProcess
				,idfWCEmailDocDtlKeyRCVToApr
				,idfWCEmailDocDtlKeyRQDelagate
				,idfWCEmailDocDtlKeyRQNotApr
				,idfWCEmailDocDtlKeyRQNotFullyRcv
				,idfWCEmailDocDtlKeyRQPOTranError
				,idfWCEmailDocDtlKeyRQRevCancelled
				,idfWCEmailDocDtlKeyTEFromApr
				,idfWCEmailDocDtlKeyTEFromRev
				,idfWCEmailDocDtlKeyTENotApr
				,idfWCEmailDocDtlKeyTENotSub
				,idfWCEmailDocDtlKeyTEToApr
				,idfWCEmailDocDtlKeyToApr
				,idfWCEmailDocDtlKeyToRev
				,idfWCFilterHdrKeyFromAprFilter
				,idfWCFilterHdrKeyLoadRcv
				,idfWCFilterHdrKeyLoadRev
				,idfWCFilterHdrKeyPOFromAprFilter
				,idfWCFilterHdrKeyRCVFromAprFilter
				,idfWCICCompanyKeyVendor
				,idfWCLanguageKey
				,idfWCPositionKey
				,idfWCSecTypeKey
				,idfWCSecurityKeyAprAltr
				,idfWCSecurityKeySupervisor
				,idfWCUDFListDtlKey02
				,idfWCUDFTemplateHdrKey
				,idfWCUDFTemplateKey
				,idfWCUDFTemplateKeyApr
				,idfWCUDFTemplateKeyRcv
				,idfWCUDFTemplateKeyRev
				,idfZipCode
	)
	SELECT
		idfWCSecurityKey

				,edfBuyer
				,edfVendor
				,idfAddr1
				,idfAddr2
				,idfAddr3
				,idfAltPhone1
				,idfAltPhone2
				,idfAltPhoneExt1
				,idfAltPhoneExt2
				,idfAPVendorKey
				,idfCity
				,idfCommuteDistance
				,idfCommuteUOM
				,idfCompany
				,idfCountry
				,idfCreatedBy
				,idfDateCreated
				,idfDateModified
				,idfDescription
				,idfEmail
				,idfEmailFormat
				,idfEmailSubject
				,idfEmployeeID
				,idfEXPEventKey
				,idfFax
				,idfFlagActive
				,idfFlagActiveEMPL
				,idfFlagActiveEXP
				,idfFlagActiveHC
				,idfFlagActivePA
				,idfFlagActiveRQ
				,idfFlagActiveTE
				,idfFlagAltrActive
				,idfFlagAltrActiveSupervisor
				,idfFlagAltrEmail
				,idfFlagChangePassword
				,idfFlagExempt
				,idfFlagMgr
				,idfFlagNotifyAPVFromApr
				,idfFlagNotifyAPVNotApr
				,idfFlagNotifyAPVToApr
				,idfFlagNotifyCCImport
				,idfFlagNotifyEXPFromApr
				,idfFlagNotifyEXPFromRev
				,idfFlagNotifyEXPImport
				,idfFlagNotifyEXPNotApr
				,idfFlagNotifyEXPToApr
				,idfFlagNotifyFromApr
				,idfFlagNotifyFromAprFilter
				,idfFlagNotifyFromInv
				,idfFlagNotifyFromRcv
				,idfFlagNotifyFromRev
				,idfFlagNotifyFromRevInclPO
				,idfFlagNotifyInvCaptureNeedAttn
				,idfFlagNotifyInvNotRcv
				,idfFlagNotifyIVRdyToShip
				,idfFlagNotifyNotApr
				,idfFlagNotifyPAFromApr
				,idfFlagNotifyPANotApr
				,idfFlagNotifyPAToApr
				,idfFlagNotifyPOFromApr
				,idfFlagNotifyPOFromAprFilter
				,idfFlagNotifyPONotApr
				,idfFlagNotifyPOToApr
				,idfFlagNotifyRCVCancelled
				,idfFlagNotifyRCVFromApr
				,idfFlagNotifyRCVFromAprFilter
				,idfFlagNotifyRCVNotApr
				,idfFlagNotifyRCVNotMatch
				,idfFlagNotifyRCVReturnProcess
				,idfFlagNotifyRCVToApr
				,idfFlagNotifyRQFromDelegate
				,idfFlagNotifyRQNotApr
				,idfFlagNotifyRQNotFullyRcv
				,idfFlagNotifyRQPOTranError
				,idfFlagNotifyRQRevCancelled
				,idfFlagNotifyRQToDelegate
				,idfFlagNotifyTEFromApr
				,idfFlagNotifyTEFromRev
				,idfFlagNotifyTENotApr
				,idfFlagNotifyTENotSub
				,idfFlagNotifyTEToApr
				,idfFlagNotifyToApr
				,idfFlagNotifyToRev
				,idfFlagShowAddr1
				,idfFlagShowAddr2
				,idfFlagShowAddr3
				,idfFlagShowCity
				,idfFlagShowCountry
				,idfFlagShowEmail
				,idfFlagShowFax
				,idfFlagShowHomePage
				,idfFlagShowPager
				,idfFlagShowPhone
				,idfFlagShowPhone2
				,idfFlagShowPhoneCar
				,idfFlagShowPhoneHome
				,idfFlagShowPhoneOffice
				,idfFlagShowState
				,idfFlagShowTimeZone
				,idfFlagShowZipCode
				,idfFlagSVCUser
				,idfHireDate
				,idfHomePage
				,idfHoursTEMax
				,idfHoursTEMin
				,idfListUDF01Key
				,idfNameFirst
				,idfNameLast
				,idfNameMiddle
				,idfNotifyAPVCountApr
				,idfNotifyCountApr
				,idfNotifyEXPCountApr
				,idfNotifyPOCountApr
				,idfNotifyRCVCountApr
				,idfNotifyRQCountRev
				,idfNotifyTECountApr
				,idfPager
				,idfPALaborGroupKey
				,idfPassword
				,idfPasswordLen
				,idfPasswordSVC
				,idfPhoneCar
				,idfPhoneExtOffice
				,idfPhoneHome
				,idfPhoneOffice
				,idfPTICompanyKey
				,idfRateBill
				,idfRateCost
				,idfRQPOTranErrorTimeToSend
				,idfRQPOTranErrorTimeToSendLast
				,idfSecurityID
				,idfSecurityType
				,idfSocialSec
				,idfState
				,idfTEEarningCodeKey
				,idfTimeZone
				,idfWCDeptKey
				,idfWCEmailDocDtlKeyAPVFromApr
				,idfWCEmailDocDtlKeyAPVNotApr
				,idfWCEmailDocDtlKeyAPVToApr
				,idfWCEmailDocDtlKeyCCImport
				,idfWCEmailDocDtlKeyDelegatedRQCancelled
				,idfWCEmailDocDtlKeyEXPFromApr
				,idfWCEmailDocDtlKeyEXPFromRev
				,idfWCEmailDocDtlKeyEXPImport
				,idfWCEmailDocDtlKeyEXPNotApr
				,idfWCEmailDocDtlKeyEXPToApr
				,idfWCEmailDocDtlKeyFrmAprFtr
				,idfWCEmailDocDtlKeyFromApr
				,idfWCEmailDocDtlKeyFromInv
				,idfWCEmailDocDtlKeyFromRcv
				,idfWCEmailDocDtlKeyFromRev
				,idfWCEmailDocDtlKeyInvCaptureNeedAttn
				,idfWCEmailDocDtlKeyInvNotRcv
				,idfWCEmailDocDtlKeyIVRdyToShip
				,idfWCEmailDocDtlKeyNotApr
				,idfWCEmailDocDtlKeyPAFromApr
				,idfWCEmailDocDtlKeyPANotApr
				,idfWCEmailDocDtlKeyPAToApr
				,idfWCEmailDocDtlKeyPOFromApr
				,idfWCEmailDocDtlKeyPOFromAprFilter
				,idfWCEmailDocDtlKeyPONotApr
				,idfWCEmailDocDtlKeyPOToApr
				,idfWCEmailDocDtlKeyRCVCancelled
				,idfWCEmailDocDtlKeyRCVFromApr
				,idfWCEmailDocDtlKeyRCVFromAprFilter
				,idfWCEmailDocDtlKeyRCVNotApr
				,idfWCEmailDocDtlKeyRCVNotMatch
				,idfWCEmailDocDtlKeyRCVReturnProcess
				,idfWCEmailDocDtlKeyRCVToApr
				,idfWCEmailDocDtlKeyRQDelagate
				,idfWCEmailDocDtlKeyRQNotApr
				,idfWCEmailDocDtlKeyRQNotFullyRcv
				,idfWCEmailDocDtlKeyRQPOTranError
				,idfWCEmailDocDtlKeyRQRevCancelled
				,idfWCEmailDocDtlKeyTEFromApr
				,idfWCEmailDocDtlKeyTEFromRev
				,idfWCEmailDocDtlKeyTENotApr
				,idfWCEmailDocDtlKeyTENotSub
				,idfWCEmailDocDtlKeyTEToApr
				,idfWCEmailDocDtlKeyToApr
				,idfWCEmailDocDtlKeyToRev
				,idfWCFilterHdrKeyFromAprFilter
				,idfWCFilterHdrKeyLoadRcv
				,idfWCFilterHdrKeyLoadRev
				,idfWCFilterHdrKeyPOFromAprFilter
				,idfWCFilterHdrKeyRCVFromAprFilter
				,idfWCICCompanyKeyVendor
				,idfWCLanguageKey
				,idfWCPositionKey
				,idfWCSecTypeKey
				,idfWCSecurityKeyAprAltr
				,idfWCSecurityKeySupervisor
				,idfWCUDFListDtlKey02
				,idfWCUDFTemplateHdrKey
				,idfWCUDFTemplateKey
				,idfWCUDFTemplateKeyApr
				,idfWCUDFTemplateKeyRcv
				,idfWCUDFTemplateKeyRev
				,idfZipCode
	FROM #WCSecurityWork
	WHERE #WCSecurityWork.idfRowAction IN ('IN','CP')

	
	IF @xstrServerAuthType = 'APP'
	BEGIN
		UPDATE PTIMaster.dbo.PTIWPUser
			SET	 idfUserID = S.idfSecurityID
				,idfPassword = ISNULL(@xstridfEncryptedPass,PTIWPUser.idfPassword)
				,idfDateModified = getdate()
				,idfFlagChangePassword = S.idfFlagChangePassword
		FROM PTIMaster.dbo.PTIWPUser PTIWPUser WITH (NOLOCK)
		INNER JOIN dbo.WCSecurity W WITH (NOLOCK) ON W.idfSecurityID = PTIWPUser.idfUserID
		INNER JOIN #WCSecurityWork S ON S.idfWCSecurityKey = W.idfWCSecurityKey
		--INNER JOIN #WCSecurityWork S ON PTIWPUser.idfUserID = S.idfSecurityID 
		--INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = S.idfWCSecurityKey
		WHERE PTIWPUser.idfUserID = W.idfSecurityID AND idfRowAction = 'UP'
			
		IF NOT EXISTS(SELECT TOP 1 1 FROM PTIMaster.dbo.PTIWPUser PTIWPUser WITH (NOLOCK) INNER JOIN #WCSecurityWork ON #WCSecurityWork.idfSecurityID = PTIWPUser.idfUserID) 
			INSERT INTO PTIMaster.dbo.PTIWPUser
			(idfPTIWPUserKey,idfUserID,idfPassword,idfDateCreated,idfDateModified,idfFlagChangePassword,idfPWRequestChange)
			SELECT  0,
					idfSecurityID,
					ISNULL(@xstridfEncryptedPass,''),
					getdate(),
					getdate(),
					0,
					''
			FROM #WCSecurityWork
			WHERE idfRowAction <> 'DL'
	END



	--Update
	UPDATE WCSecurity SET
		 WCSecurity.idfWCSecurityKey = #WCSecurityWork.idfWCSecurityKey

		,WCSecurity.edfBuyer = #WCSecurityWork.edfBuyer
		,WCSecurity.edfVendor = #WCSecurityWork.edfVendor
		,WCSecurity.idfAddr1 = #WCSecurityWork.idfAddr1
		,WCSecurity.idfAddr2 = #WCSecurityWork.idfAddr2
		,WCSecurity.idfAddr3 = #WCSecurityWork.idfAddr3
		,WCSecurity.idfAltPhone1 = #WCSecurityWork.idfAltPhone1
		,WCSecurity.idfAltPhone2 = #WCSecurityWork.idfAltPhone2
		,WCSecurity.idfAltPhoneExt1 = #WCSecurityWork.idfAltPhoneExt1
		,WCSecurity.idfAltPhoneExt2 = #WCSecurityWork.idfAltPhoneExt2
		,WCSecurity.idfAPVendorKey = #WCSecurityWork.idfAPVendorKey
		,WCSecurity.idfCity = #WCSecurityWork.idfCity
		,WCSecurity.idfCommuteDistance = #WCSecurityWork.idfCommuteDistance
		,WCSecurity.idfCommuteUOM = #WCSecurityWork.idfCommuteUOM
		,WCSecurity.idfCompany = #WCSecurityWork.idfCompany
		,WCSecurity.idfCountry = #WCSecurityWork.idfCountry
		,WCSecurity.idfCreatedBy = #WCSecurityWork.idfCreatedBy
		,WCSecurity.idfDescription = #WCSecurityWork.idfDescription
		,WCSecurity.idfEmail = #WCSecurityWork.idfEmail
		,WCSecurity.idfEmailFormat = #WCSecurityWork.idfEmailFormat
		,WCSecurity.idfEmailSubject = #WCSecurityWork.idfEmailSubject
		,WCSecurity.idfEmployeeID = #WCSecurityWork.idfEmployeeID
		,WCSecurity.idfEXPEventKey = #WCSecurityWork.idfEXPEventKey
		,WCSecurity.idfFax = #WCSecurityWork.idfFax
		,WCSecurity.idfFlagActive = #WCSecurityWork.idfFlagActive
		,WCSecurity.idfFlagActiveEMPL = #WCSecurityWork.idfFlagActiveEMPL
		,WCSecurity.idfFlagActiveEXP = #WCSecurityWork.idfFlagActiveEXP
		,WCSecurity.idfFlagActiveHC = #WCSecurityWork.idfFlagActiveHC
		,WCSecurity.idfFlagActivePA = #WCSecurityWork.idfFlagActivePA
		,WCSecurity.idfFlagActiveRQ = #WCSecurityWork.idfFlagActiveRQ
		,WCSecurity.idfFlagActiveTE = #WCSecurityWork.idfFlagActiveTE
		,WCSecurity.idfFlagAltrActive = #WCSecurityWork.idfFlagAltrActive
		,WCSecurity.idfFlagAltrActiveSupervisor = #WCSecurityWork.idfFlagAltrActiveSupervisor
		,WCSecurity.idfFlagAltrEmail = #WCSecurityWork.idfFlagAltrEmail
		,WCSecurity.idfFlagChangePassword = #WCSecurityWork.idfFlagChangePassword
		,WCSecurity.idfFlagExempt = #WCSecurityWork.idfFlagExempt
		,WCSecurity.idfFlagMgr = #WCSecurityWork.idfFlagMgr
		,WCSecurity.idfFlagNotifyAPVFromApr = #WCSecurityWork.idfFlagNotifyAPVFromApr
		,WCSecurity.idfFlagNotifyAPVNotApr = #WCSecurityWork.idfFlagNotifyAPVNotApr
		,WCSecurity.idfFlagNotifyAPVToApr = #WCSecurityWork.idfFlagNotifyAPVToApr
		,WCSecurity.idfFlagNotifyCCImport = #WCSecurityWork.idfFlagNotifyCCImport
		,WCSecurity.idfFlagNotifyEXPFromApr = #WCSecurityWork.idfFlagNotifyEXPFromApr
		,WCSecurity.idfFlagNotifyEXPFromRev = #WCSecurityWork.idfFlagNotifyEXPFromRev
		,WCSecurity.idfFlagNotifyEXPImport = #WCSecurityWork.idfFlagNotifyEXPImport
		,WCSecurity.idfFlagNotifyEXPNotApr = #WCSecurityWork.idfFlagNotifyEXPNotApr
		,WCSecurity.idfFlagNotifyEXPToApr = #WCSecurityWork.idfFlagNotifyEXPToApr
		,WCSecurity.idfFlagNotifyFromApr = #WCSecurityWork.idfFlagNotifyFromApr
		,WCSecurity.idfFlagNotifyFromAprFilter = #WCSecurityWork.idfFlagNotifyFromAprFilter
		,WCSecurity.idfFlagNotifyFromInv = #WCSecurityWork.idfFlagNotifyFromInv
		,WCSecurity.idfFlagNotifyFromRcv = #WCSecurityWork.idfFlagNotifyFromRcv
		,WCSecurity.idfFlagNotifyFromRev = #WCSecurityWork.idfFlagNotifyFromRev
		,WCSecurity.idfFlagNotifyFromRevInclPO = #WCSecurityWork.idfFlagNotifyFromRevInclPO
		,WCSecurity.idfFlagNotifyInvCaptureNeedAttn = #WCSecurityWork.idfFlagNotifyInvCaptureNeedAttn
		,WCSecurity.idfFlagNotifyInvNotRcv = #WCSecurityWork.idfFlagNotifyInvNotRcv
		,WCSecurity.idfFlagNotifyIVRdyToShip = #WCSecurityWork.idfFlagNotifyIVRdyToShip
		,WCSecurity.idfFlagNotifyNotApr = #WCSecurityWork.idfFlagNotifyNotApr
		,WCSecurity.idfFlagNotifyPAFromApr = #WCSecurityWork.idfFlagNotifyPAFromApr
		,WCSecurity.idfFlagNotifyPANotApr = #WCSecurityWork.idfFlagNotifyPANotApr
		,WCSecurity.idfFlagNotifyPAToApr = #WCSecurityWork.idfFlagNotifyPAToApr
		,WCSecurity.idfFlagNotifyPOFromApr = #WCSecurityWork.idfFlagNotifyPOFromApr
		,WCSecurity.idfFlagNotifyPOFromAprFilter = #WCSecurityWork.idfFlagNotifyPOFromAprFilter
		,WCSecurity.idfFlagNotifyPONotApr = #WCSecurityWork.idfFlagNotifyPONotApr
		,WCSecurity.idfFlagNotifyPOToApr = #WCSecurityWork.idfFlagNotifyPOToApr
		,WCSecurity.idfFlagNotifyRCVCancelled = #WCSecurityWork.idfFlagNotifyRCVCancelled
		,WCSecurity.idfFlagNotifyRCVFromApr = #WCSecurityWork.idfFlagNotifyRCVFromApr
		,WCSecurity.idfFlagNotifyRCVFromAprFilter = #WCSecurityWork.idfFlagNotifyRCVFromAprFilter
		,WCSecurity.idfFlagNotifyRCVNotApr = #WCSecurityWork.idfFlagNotifyRCVNotApr
		,WCSecurity.idfFlagNotifyRCVNotMatch = #WCSecurityWork.idfFlagNotifyRCVNotMatch
		,WCSecurity.idfFlagNotifyRCVReturnProcess = #WCSecurityWork.idfFlagNotifyRCVReturnProcess
		,WCSecurity.idfFlagNotifyRCVToApr = #WCSecurityWork.idfFlagNotifyRCVToApr
		,WCSecurity.idfFlagNotifyRQFromDelegate = #WCSecurityWork.idfFlagNotifyRQFromDelegate
		,WCSecurity.idfFlagNotifyRQNotApr = #WCSecurityWork.idfFlagNotifyRQNotApr
		,WCSecurity.idfFlagNotifyRQNotFullyRcv = #WCSecurityWork.idfFlagNotifyRQNotFullyRcv
		,WCSecurity.idfFlagNotifyRQPOTranError = #WCSecurityWork.idfFlagNotifyRQPOTranError
		,WCSecurity.idfFlagNotifyRQRevCancelled = #WCSecurityWork.idfFlagNotifyRQRevCancelled
		,WCSecurity.idfFlagNotifyRQToDelegate = #WCSecurityWork.idfFlagNotifyRQToDelegate
		,WCSecurity.idfFlagNotifyTEFromApr = #WCSecurityWork.idfFlagNotifyTEFromApr
		,WCSecurity.idfFlagNotifyTEFromRev = #WCSecurityWork.idfFlagNotifyTEFromRev
		,WCSecurity.idfFlagNotifyTENotApr = #WCSecurityWork.idfFlagNotifyTENotApr
		,WCSecurity.idfFlagNotifyTENotSub = #WCSecurityWork.idfFlagNotifyTENotSub
		,WCSecurity.idfFlagNotifyTEToApr = #WCSecurityWork.idfFlagNotifyTEToApr
		,WCSecurity.idfFlagNotifyToApr = #WCSecurityWork.idfFlagNotifyToApr
		,WCSecurity.idfFlagNotifyToRev = #WCSecurityWork.idfFlagNotifyToRev
		,WCSecurity.idfFlagShowAddr1 = #WCSecurityWork.idfFlagShowAddr1
		,WCSecurity.idfFlagShowAddr2 = #WCSecurityWork.idfFlagShowAddr2
		,WCSecurity.idfFlagShowAddr3 = #WCSecurityWork.idfFlagShowAddr3
		,WCSecurity.idfFlagShowCity = #WCSecurityWork.idfFlagShowCity
		,WCSecurity.idfFlagShowCountry = #WCSecurityWork.idfFlagShowCountry
		,WCSecurity.idfFlagShowEmail = #WCSecurityWork.idfFlagShowEmail
		,WCSecurity.idfFlagShowFax = #WCSecurityWork.idfFlagShowFax
		,WCSecurity.idfFlagShowHomePage = #WCSecurityWork.idfFlagShowHomePage
		,WCSecurity.idfFlagShowPager = #WCSecurityWork.idfFlagShowPager
		,WCSecurity.idfFlagShowPhone = #WCSecurityWork.idfFlagShowPhone
		,WCSecurity.idfFlagShowPhone2 = #WCSecurityWork.idfFlagShowPhone2
		,WCSecurity.idfFlagShowPhoneCar = #WCSecurityWork.idfFlagShowPhoneCar
		,WCSecurity.idfFlagShowPhoneHome = #WCSecurityWork.idfFlagShowPhoneHome
		,WCSecurity.idfFlagShowPhoneOffice = #WCSecurityWork.idfFlagShowPhoneOffice
		,WCSecurity.idfFlagShowState = #WCSecurityWork.idfFlagShowState
		,WCSecurity.idfFlagShowTimeZone = #WCSecurityWork.idfFlagShowTimeZone
		,WCSecurity.idfFlagShowZipCode = #WCSecurityWork.idfFlagShowZipCode
		,WCSecurity.idfFlagSVCUser = #WCSecurityWork.idfFlagSVCUser
		,WCSecurity.idfHireDate = #WCSecurityWork.idfHireDate
		,WCSecurity.idfHomePage = #WCSecurityWork.idfHomePage
		,WCSecurity.idfHoursTEMax = #WCSecurityWork.idfHoursTEMax
		,WCSecurity.idfHoursTEMin = #WCSecurityWork.idfHoursTEMin
		,WCSecurity.idfListUDF01Key = #WCSecurityWork.idfListUDF01Key
		,WCSecurity.idfNameFirst = #WCSecurityWork.idfNameFirst
		,WCSecurity.idfNameLast = #WCSecurityWork.idfNameLast
		,WCSecurity.idfNameMiddle = #WCSecurityWork.idfNameMiddle
		,WCSecurity.idfNotifyAPVCountApr = #WCSecurityWork.idfNotifyAPVCountApr
		,WCSecurity.idfNotifyCountApr = #WCSecurityWork.idfNotifyCountApr
		,WCSecurity.idfNotifyEXPCountApr = #WCSecurityWork.idfNotifyEXPCountApr
		,WCSecurity.idfNotifyPOCountApr = #WCSecurityWork.idfNotifyPOCountApr
		,WCSecurity.idfNotifyRCVCountApr = #WCSecurityWork.idfNotifyRCVCountApr
		,WCSecurity.idfNotifyRQCountRev = #WCSecurityWork.idfNotifyRQCountRev
		,WCSecurity.idfNotifyTECountApr = #WCSecurityWork.idfNotifyTECountApr
		,WCSecurity.idfPager = #WCSecurityWork.idfPager
		,WCSecurity.idfPALaborGroupKey = #WCSecurityWork.idfPALaborGroupKey
		,WCSecurity.idfPassword = #WCSecurityWork.idfPassword
		,WCSecurity.idfPasswordLen = #WCSecurityWork.idfPasswordLen
		,WCSecurity.idfPasswordSVC = #WCSecurityWork.idfPasswordSVC
		,WCSecurity.idfPhoneCar = #WCSecurityWork.idfPhoneCar
		,WCSecurity.idfPhoneExtOffice = #WCSecurityWork.idfPhoneExtOffice
		,WCSecurity.idfPhoneHome = #WCSecurityWork.idfPhoneHome
		,WCSecurity.idfPhoneOffice = #WCSecurityWork.idfPhoneOffice
		,WCSecurity.idfPTICompanyKey = #WCSecurityWork.idfPTICompanyKey
		,WCSecurity.idfRateBill = #WCSecurityWork.idfRateBill
		,WCSecurity.idfRateCost = #WCSecurityWork.idfRateCost
		,WCSecurity.idfRQPOTranErrorTimeToSend = #WCSecurityWork.idfRQPOTranErrorTimeToSend
		,WCSecurity.idfRQPOTranErrorTimeToSendLast = #WCSecurityWork.idfRQPOTranErrorTimeToSendLast
		,WCSecurity.idfSecurityID = #WCSecurityWork.idfSecurityID
		,WCSecurity.idfSecurityType = #WCSecurityWork.idfSecurityType
		,WCSecurity.idfSocialSec = #WCSecurityWork.idfSocialSec
		,WCSecurity.idfState = #WCSecurityWork.idfState
		,WCSecurity.idfTEEarningCodeKey = #WCSecurityWork.idfTEEarningCodeKey
		,WCSecurity.idfTimeZone = #WCSecurityWork.idfTimeZone
		,WCSecurity.idfWCDeptKey = #WCSecurityWork.idfWCDeptKey
		,WCSecurity.idfWCEmailDocDtlKeyAPVFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyAPVFromApr
		,WCSecurity.idfWCEmailDocDtlKeyAPVNotApr = #WCSecurityWork.idfWCEmailDocDtlKeyAPVNotApr
		,WCSecurity.idfWCEmailDocDtlKeyAPVToApr = #WCSecurityWork.idfWCEmailDocDtlKeyAPVToApr
		,WCSecurity.idfWCEmailDocDtlKeyCCImport = #WCSecurityWork.idfWCEmailDocDtlKeyCCImport
		,WCSecurity.idfWCEmailDocDtlKeyDelegatedRQCancelled = #WCSecurityWork.idfWCEmailDocDtlKeyDelegatedRQCancelled
		,WCSecurity.idfWCEmailDocDtlKeyEXPFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromApr
		,WCSecurity.idfWCEmailDocDtlKeyEXPFromRev = #WCSecurityWork.idfWCEmailDocDtlKeyEXPFromRev
		,WCSecurity.idfWCEmailDocDtlKeyEXPImport = #WCSecurityWork.idfWCEmailDocDtlKeyEXPImport
		,WCSecurity.idfWCEmailDocDtlKeyEXPNotApr = #WCSecurityWork.idfWCEmailDocDtlKeyEXPNotApr
		,WCSecurity.idfWCEmailDocDtlKeyEXPToApr = #WCSecurityWork.idfWCEmailDocDtlKeyEXPToApr
		,WCSecurity.idfWCEmailDocDtlKeyFrmAprFtr = #WCSecurityWork.idfWCEmailDocDtlKeyFrmAprFtr
		,WCSecurity.idfWCEmailDocDtlKeyFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyFromApr
		,WCSecurity.idfWCEmailDocDtlKeyFromInv = #WCSecurityWork.idfWCEmailDocDtlKeyFromInv
		,WCSecurity.idfWCEmailDocDtlKeyFromRcv = #WCSecurityWork.idfWCEmailDocDtlKeyFromRcv
		,WCSecurity.idfWCEmailDocDtlKeyFromRev = #WCSecurityWork.idfWCEmailDocDtlKeyFromRev
		,WCSecurity.idfWCEmailDocDtlKeyInvCaptureNeedAttn = #WCSecurityWork.idfWCEmailDocDtlKeyInvCaptureNeedAttn
		,WCSecurity.idfWCEmailDocDtlKeyInvNotRcv = #WCSecurityWork.idfWCEmailDocDtlKeyInvNotRcv
		,WCSecurity.idfWCEmailDocDtlKeyIVRdyToShip = #WCSecurityWork.idfWCEmailDocDtlKeyIVRdyToShip
		,WCSecurity.idfWCEmailDocDtlKeyNotApr = #WCSecurityWork.idfWCEmailDocDtlKeyNotApr
		,WCSecurity.idfWCEmailDocDtlKeyPAFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyPAFromApr
		,WCSecurity.idfWCEmailDocDtlKeyPANotApr = #WCSecurityWork.idfWCEmailDocDtlKeyPANotApr
		,WCSecurity.idfWCEmailDocDtlKeyPAToApr = #WCSecurityWork.idfWCEmailDocDtlKeyPAToApr
		,WCSecurity.idfWCEmailDocDtlKeyPOFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyPOFromApr
		,WCSecurity.idfWCEmailDocDtlKeyPOFromAprFilter = #WCSecurityWork.idfWCEmailDocDtlKeyPOFromAprFilter
		,WCSecurity.idfWCEmailDocDtlKeyPONotApr = #WCSecurityWork.idfWCEmailDocDtlKeyPONotApr
		,WCSecurity.idfWCEmailDocDtlKeyPOToApr = #WCSecurityWork.idfWCEmailDocDtlKeyPOToApr
		,WCSecurity.idfWCEmailDocDtlKeyRCVCancelled = #WCSecurityWork.idfWCEmailDocDtlKeyRCVCancelled
		,WCSecurity.idfWCEmailDocDtlKeyRCVFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromApr
		,WCSecurity.idfWCEmailDocDtlKeyRCVFromAprFilter = #WCSecurityWork.idfWCEmailDocDtlKeyRCVFromAprFilter
		,WCSecurity.idfWCEmailDocDtlKeyRCVNotApr = #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotApr
		,WCSecurity.idfWCEmailDocDtlKeyRCVNotMatch = #WCSecurityWork.idfWCEmailDocDtlKeyRCVNotMatch
		,WCSecurity.idfWCEmailDocDtlKeyRCVReturnProcess = #WCSecurityWork.idfWCEmailDocDtlKeyRCVReturnProcess
		,WCSecurity.idfWCEmailDocDtlKeyRCVToApr = #WCSecurityWork.idfWCEmailDocDtlKeyRCVToApr
		,WCSecurity.idfWCEmailDocDtlKeyRQDelagate = #WCSecurityWork.idfWCEmailDocDtlKeyRQDelagate
		,WCSecurity.idfWCEmailDocDtlKeyRQNotApr = #WCSecurityWork.idfWCEmailDocDtlKeyRQNotApr
		,WCSecurity.idfWCEmailDocDtlKeyRQNotFullyRcv = #WCSecurityWork.idfWCEmailDocDtlKeyRQNotFullyRcv
		,WCSecurity.idfWCEmailDocDtlKeyRQPOTranError = #WCSecurityWork.idfWCEmailDocDtlKeyRQPOTranError
		,WCSecurity.idfWCEmailDocDtlKeyRQRevCancelled = #WCSecurityWork.idfWCEmailDocDtlKeyRQRevCancelled
		,WCSecurity.idfWCEmailDocDtlKeyTEFromApr = #WCSecurityWork.idfWCEmailDocDtlKeyTEFromApr
		,WCSecurity.idfWCEmailDocDtlKeyTEFromRev = #WCSecurityWork.idfWCEmailDocDtlKeyTEFromRev
		,WCSecurity.idfWCEmailDocDtlKeyTENotApr = #WCSecurityWork.idfWCEmailDocDtlKeyTENotApr
		,WCSecurity.idfWCEmailDocDtlKeyTENotSub = #WCSecurityWork.idfWCEmailDocDtlKeyTENotSub
		,WCSecurity.idfWCEmailDocDtlKeyTEToApr = #WCSecurityWork.idfWCEmailDocDtlKeyTEToApr
		,WCSecurity.idfWCEmailDocDtlKeyToApr = #WCSecurityWork.idfWCEmailDocDtlKeyToApr
		,WCSecurity.idfWCEmailDocDtlKeyToRev = #WCSecurityWork.idfWCEmailDocDtlKeyToRev
		,WCSecurity.idfWCFilterHdrKeyFromAprFilter = #WCSecurityWork.idfWCFilterHdrKeyFromAprFilter
		,WCSecurity.idfWCFilterHdrKeyLoadRcv = #WCSecurityWork.idfWCFilterHdrKeyLoadRcv
		,WCSecurity.idfWCFilterHdrKeyLoadRev = #WCSecurityWork.idfWCFilterHdrKeyLoadRev
		,WCSecurity.idfWCFilterHdrKeyPOFromAprFilter = #WCSecurityWork.idfWCFilterHdrKeyPOFromAprFilter
		,WCSecurity.idfWCFilterHdrKeyRCVFromAprFilter = #WCSecurityWork.idfWCFilterHdrKeyRCVFromAprFilter
		,WCSecurity.idfWCICCompanyKeyVendor = #WCSecurityWork.idfWCICCompanyKeyVendor
		,WCSecurity.idfWCLanguageKey = #WCSecurityWork.idfWCLanguageKey
		,WCSecurity.idfWCPositionKey = #WCSecurityWork.idfWCPositionKey
		,WCSecurity.idfWCSecTypeKey = #WCSecurityWork.idfWCSecTypeKey
		,WCSecurity.idfWCSecurityKeyAprAltr = #WCSecurityWork.idfWCSecurityKeyAprAltr
		,WCSecurity.idfWCSecurityKeySupervisor = #WCSecurityWork.idfWCSecurityKeySupervisor
		,WCSecurity.idfWCUDFListDtlKey02 = #WCSecurityWork.idfWCUDFListDtlKey02
		,WCSecurity.idfWCUDFTemplateHdrKey = #WCSecurityWork.idfWCUDFTemplateHdrKey
		,WCSecurity.idfWCUDFTemplateKey = #WCSecurityWork.idfWCUDFTemplateKey
		,WCSecurity.idfWCUDFTemplateKeyApr = #WCSecurityWork.idfWCUDFTemplateKeyApr
		,WCSecurity.idfWCUDFTemplateKeyRcv = #WCSecurityWork.idfWCUDFTemplateKeyRcv
		,WCSecurity.idfWCUDFTemplateKeyRev = #WCSecurityWork.idfWCUDFTemplateKeyRev
		,WCSecurity.idfZipCode = #WCSecurityWork.idfZipCode
	FROM WCSecurity, #WCSecurityWork
	WHERE	WCSecurity.idfWCSecurityKey = #WCSecurityWork.idfWCSecurityKey
	AND	#WCSecurityWork.idfRowAction = 'UP'

	UPDATE WCSecuritySetting SET idfValue = 0 
	FROM WCSecuritySetting TF
	INNER JOIN #WCSecurityWork S ON TF.idfWCSecurityKey = S.idfWCSecurityKey AND TF.idfName = 'TwoFactorAuthenticationEnabled' AND S.vdfTwoFactorEnabled = 0
	AND S.idfRowAction = 'UP'

	DECLARE @nCPCount INT

		IF @nidfWCTableAuditHdrKey IS NOT NULL
		UPDATE WCTableAuditHdr SET idfOwnerSPID = 0 WHERE idfWCTableAuditHdrKey = @nidfWCTableAuditHdrKey

	DECLARE zcurspWCSecurityCopy INSENSITIVE CURSOR
	FOR SELECT
		 idfWCSecurityKey
		,vdfCopyFromKey
	FROM #WCSecurityWork
	WHERE #WCSecurityWork.idfRowAction = 'CP'

	OPEN zcurspWCSecurityCopy

	FETCH zcurspWCSecurityCopy INTO
		 @nNewidfWCSecurityKey
		,@nidfWCSecurityKey

	WHILE @@fetch_status <> -1
	BEGIN
		IF @@fetch_status <> -2
		BEGIN
	
			EXEC spWCSecurityCopy @xochErrSP OUTPUT, @xonErrNum OUTPUT, @xostrErrInfo OUTPUT, @nidfWCSecurityKey, @nNewidfWCSecurityKey,@xnRQMaxUsers,@xnEXPMaxUsers,@xnHCMaxUsers,@xnPAMaxUsers,@xnTEMaxUsers,@xnEMPLMaxUsers,'IMPORT'
		END -- @@fetch_status <> -2

		FETCH zcurspWCSecurityCopy INTO
			 @nNewidfWCSecurityKey
			,@nidfWCSecurityKey

	END --@@fetch_status <> -1
	CLOSE zcurspWCSecurityCopy
	DEALLOCATE zcurspWCSecurityCopy

	COMMIT TRANSACTION

	IF @nidfFlagCreateUser = 1 AND IS_SRVROLEMEMBER ('sysadmin') = 1 
	BEGIN
		DECLARE zWCSecurity CURSOR FOR SELECT
		 idfNewidfSecurityID
		,idfOldidfSecurityID
		,idfFlagActiveOld
		,idfFlagActiveNew
		,nLoginExists
		FROM @Security

		OPEN zWCSecurity

		FETCH zWCSecurity INTO
			 @stridfNewidfSecurityID
			,@stridfOldidfSecurityID
			,@nidfFlagActiveOld
			,@nidfFlagActiveNew
			,@nLoginExists
		WHILE @@fetch_status <> -1
		BEGIN
			IF @@fetch_status <> -2
			BEGIN

			IF @nLoginExists = 1 AND @xstridfEncodedPass <> '' AND @xstridfEncodedPass IS NOT NULL
				EXEC master..sp_password @new = @xstridfEncodedPass, @loginame = @stridfNewidfSecurityID
		
			-- Only add if user was switched from inactive to active.
			IF (ISNULL(@nidfFlagActiveOld,0) = 0 AND @nidfFlagActiveNew = 1) OR (@nLoginExists = 0 AND @nidfFlagActiveNew=1)
				EXEC spPTIFixSQLGrant   @xstrControlDB = 'DYNAMICS', @xnAddSQLUsersIfNecessary = 1, @xstrDefaultSQLPassword = @xstridfEncodedPass, @xstridfSecurityID = @stridfNewidfSecurityID, @xstrServerAuthType = @xstrServerAuthType

			END -- @@fetch_status <> -2
		FETCH zWCSecurity INTO
			 @stridfNewidfSecurityID
			,@stridfOldidfSecurityID
			,@nidfFlagActiveOld
			,@nidfFlagActiveNew
			,@nLoginExists
		END --@@fetch_status <> -1
		CLOSE zWCSecurity
		DEALLOCATE zWCSecurity
	END
	EXEC sp_executesql N'UPDATE #WCSecurity SET idfWCSecurityKey = T2.idfWCSecurityKey
	FROM #WCSecurity T1
	INNER JOIN #WCSecurityWork T2 ON T1.idfRowKey = T2.idfRowKey'
END

IF @xchAction = 'DT'
BEGIN
     DROP TABLE #WCSecurityWork
END

RETURN (0)
GO


