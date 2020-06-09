DECLARE
@xnLD_RQHeaderKey INT
,@xnLD_WCSecurityKey INT
,@xstrLD_PONumber INT
,@xstrLD_POLine INT
,@xstrLD_Vendor INT
,@xstrLD_Item INT
,@xstrLD_VendorItem int
,@xstrLD_Location int
,@xstrLD_Currency int
,@xstrLD_vdfProjMgr int
,@xstrLD_vdfJobNo int

 ,@nidfWCSecurityKey		INT
,@nRowsLoaded			INT
,@nidfPTICompanyKey		INT
,@nidfRCVAutoRcvDtlKey		INT
,@nidfLine			INT
,@strPONUMBER			CHAR(17)
,@nORD				INT
,@strITEMNMBR			CHAR(31)
,@strITEMDESC			CHAR(101)
,@strVENDORID			CHAR(15)
,@strVNDITNUM			CHAR(31)
,@strVNDITDSC			CHAR(101)
,@nQTYORDER			NUMERIC(19,5)
,@nQTYSHPPD			NUMERIC(19,5)
,@nQTYREJ			NUMERIC(19,5)
,@nQTYCANCE			NUMERIC(19,5)
,@strLOCNCODE			CHAR(11)
,@strUOFM			CHAR(9)
,@strCURNCYID			CHAR(15)
,@nEXTDCOST			NUMERIC(19,5)
,@nUNITCOST			NUMERIC(19,5)
,@nORUNTCST			NUMERIC(19,5)
,@nOREXTCST			NUMERIC(19,5)
,@nINVINDX			INT
,@nUPPVIDX			INT
,@nedfPALineItemSeq  		INT
,@stredfPAProjectL1  		CHAR(15)
,@stredfPAProjectL2  		CHAR(17)
,@stredfPAProjectL3 		CHAR(27)
,@nidfFlagManualDist		INT
,@stridfSecurityID		VARCHAR(255)
,@stredfTranType        	CHAR(3)
,@nidfRQHeaderKey 		INT
,@nPreCount            		INT
,@nPostCount            	INT
,@nidfWCFilterHdrKey    	INT
,@nAmtExtended			NUMERIC(19,5)
,@nAmtExtendedHome		NUMERIC(19,5)
,@nXchRate			NUMERIC(19,5)
,@nXchRateType 			VARCHAR(255)
,@strXchRateTable		VARCHAR(255)
,@nXchExpression 		INT
,@strXchDate 			VARCHAR(15)
,@strXchTime 			VARCHAR(15)
,@nedfWSProductIndicator 	INT
,@nRecordsLoaded		INT
,@nWCDistribution_edfAmtExtended	NUMERIC(19,5)
,@nHDR_idfRQTypeKey		INT
,@strShipTo				VARCHAR(60)
,@strBillTo				VARCHAR(60)
,@strHDR_FacilityID		VARCHAR(67)
,@idfQtyPrec			INT 
,@nGRPIsStandardPO		INT
,@nedfPrice				NUMERIC(19,5)
,@xItemCurrPer			INT
,@nidfRateHome			NUMERIC(19,5)
,@nRCVLOADRATEFROMPO	INT
,@nRCVUSEDATEANDRATEFORRCV	INT
,@nForceGivenRate		INT
,@xodtXchRateDate		DATETIME
,@nedfGLDist			INT
,@dtudfDateField01                      datetime      
,@dtudfDateField02                      datetime      
,@dtudfDateField03                      datetime      
,@dtudfDateField04                      datetime      
,@dtudfDateField05                      datetime      
,@strudfLargeTextField01                 varchar(255)  
,@strudfLargeTextField02                 varchar(255)  
,@strudfLargeTextField03                 varchar(255)  
,@nudfNumericField01                   numeric(19,5) 
,@nudfNumericField02                   numeric(19,5) 
,@nudfNumericField03                   numeric(19,5) 
,@nudfNumericField04                   numeric(19,5) 
,@nudfNumericField05                   numeric(19,5) 
,@nudfNumericField06                   numeric(19,5) 
,@nudfNumericField07                   numeric(19,5) 
,@nudfNumericField08                   numeric(19,5) 
,@nudfNumericField09                   numeric(19,5) 
,@nudfNumericField10                   numeric(19,5) 
,@strudfTextField01                      varchar(60)   
,@strudfTextField02                      varchar(60)   
,@strudfTextField03                      varchar(60)   
,@strudfTextField04     varchar(60)   
,@strudfTextField05                      varchar(60)   
,@strudfTextField06                      varchar(60)   
,@strudfTextField07                      varchar(60)   
,@strudfTextField08                      varchar(60)   
,@strudfTextField09                      varchar(60)   
,@strudfTextField10                      varchar(60) 
SELECT POP10110.PONUMBER, POP10110.ORD
	,SUM(ISNULL(POP10500.QTYSHPPD,0)) - SUM(ISNULL(POP10500.QTYINVRESERVE,0))+MAX(ISNULL(RA.idfQtyShipped,0))+MAX(ISNULL(RD.idfQtyShipped,0)) AS 'QTYSHPPD'
	,SUM(ISNULL(POP10500.QTYREJ,0))+MAX(ISNULL(RA.idfQtyRejected,0))+MAX(ISNULL(RD.idfQtyRejected,0)) AS 'QTYREJ'
	,MIN(ISNULL(POP10110.QTYCANCE,0)) AS 'QTYCANCE'
	,'STD'
    FROM POP10100 (NOLOCK)
    	INNER JOIN POP10110 (NOLOCK)		ON POP10100.PONUMBER = POP10110.PONUMBER --AND (POP10110.ITMTRKOP = 0 OR POP10110.ITMTRKOP = 1) -- Only do non Serial/Lot for now.
	   	LEFT OUTER JOIN POP10500 (NOLOCK)	ON POP10110.PONUMBER = POP10500.PONUMBER AND POP10110.ORD = POP10500.POLNENUM
		LEFT OUTER JOIN RQDetail D (NOLOCK) ON POP10110.PONUMBER = D.edfPONumber AND POP10110.ORD = D.edfPOLine AND D.idfRQSessionKey = 170
		LEFT OUTER JOIN RQHeader H (NOLOCK) ON D.idfRQHeaderKey = H.idfRQHeaderKey
    	LEFT JOIN WCSecurity S	(NOLOCK)	ON H.idfWCSecurityKey = S.idfWCSecurityKey
		LEFT OUTER JOIN (SELECT SUM(idfQtyShipped) AS idfQtyShipped, SUM(idfQtyRejected) AS idfQtyRejected,edfPONumber,edfPOLine FROM RCVAutoRcvDtl (NOLOCK) INNER JOIN RCVAutoRcvHdr (NOLOCK) ON  RCVAutoRcvDtl.idfRCVAutoRcvHdrKey = RCVAutoRcvHdr.idfRCVAutoRcvHdrKey 
		WHERE  idfFlagProcessed=0 GROUP BY edfPONumber,edfPOLine) RA ON  POP10110.PONUMBER = RA.edfPONumber AND POP10110.ORD = RA.edfPOLine 
		LEFT OUTER JOIN (SELECT SUM(idfQtyShipped) AS idfQtyShipped, SUM(idfQtyRejected) AS idfQtyRejected,edfPONumber,edfPOLine FROM RCVDetail (NOLOCK) INNER JOIN RCVHeader (NOLOCK) ON RCVDetail.idfRCVHeaderKey=RCVHeader.idfRCVHeaderKey  WHERE  idfFlagPosted=0
  GROUP BY edfPONumber,edfPOLine) RD ON  POP10110.PONUMBER = RD.edfPONumber AND POP10110.ORD = RD.edfPOLine	
		LEFT OUTER JOIN dbo.JC00102 WITH (NOLOCK) ON JC00102.WS_Job_Number = D.edfPAProjectL2
    WHERE 	POP10100.POTYPE = 1 
    	AND POP10100.POSTATUS < 4 -- Make sure not Fully Received, Closed or Canceled.
    	AND POP10110.POLNESTA < 4 -- Make sure not Fully Received, Closed or Canceled.
    	AND (H.idfRQHeaderKey IS NULL OR H.idfRQHeaderKey = ISNULL(@xnLD_RQHeaderKey	,H.idfRQHeaderKey))
    	AND (H.idfWCSecurityKey IS NULL OR H.idfWCSecurityKey = ISNULL(@xnLD_WCSecurityKey,H.idfWCSecurityKey))
    	AND (POP10110.PONUMBER			= ISNULL(@xstrLD_PONumber	,POP10110.PONUMBER	))
    	AND (POP10110.ORD				= ISNULL(@xstrLD_POLine		,POP10110.ORD		))
    	AND (POP10110.VENDORID			= ISNULL(@xstrLD_Vendor		,POP10110.VENDORID	))
    	AND (POP10110.ITEMNMBR			= ISNULL(@xstrLD_Item		,POP10110.ITEMNMBR	))
    	AND (POP10110.VNDITNUM			= ISNULL(@xstrLD_VendorItem	,POP10110.VNDITNUM	))
    	AND (POP10110.LOCNCODE			= ISNULL(@xstrLD_Location	,POP10110.LOCNCODE	))
    	AND (POP10110.CURNCYID			= ISNULL(@xstrLD_Currency	,POP10110.CURNCYID	))
		AND (JC00102.WS_Manager_ID IS NULL OR JC00102.WS_Manager_ID	= ISNULL(@xstrLD_vdfProjMgr,JC00102.WS_Manager_ID))
		AND (D.edfPAProjectL2 IS NULL OR D.edfPAProjectL2 = ISNULL(@xstrLD_vdfJobNo,D.edfPAProjectL2))
    GROUP BY POP10110.PONUMBER,POP10110.ORD
    HAVING MAX(POP10110.QTYORDER) > (SUM(ISNULL(POP10500.QTYSHPPD,0))-SUM(ISNULL(POP10500.QTYINVRESERVE,0))+MAX(ISNULL(RA.idfQtyShipped,0))+MAX(ISNULL(RD.idfQtyShipped,0)) - SUM(ISNULL(POP10500.QTYREJ,0))-MAX(ISNULL(RA.idfQtyRejected,0))-MAX(ISNULL(RD.idfQtyRejected,0)) + MIN(ISNULL(POP10110.QTYCANCE,0)))
