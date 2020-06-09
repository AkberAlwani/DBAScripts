USE [PLIP]
GO

/****** Object:  StoredProcedure [dbo].[BI_spDailyReqV2]    Script Date: 5/29/2018 2:14:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BI_spDailyReqV2]
	-- Add the parameters for the stored procedure here
@FromDate datetime,
@ToDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
-- Get Status 
DECLARE PurchaseReq INSENSITIVE CURSOR FOR

select 
   RQHeader.idfRQNumber, RQHeader.idfRQHeaderKey, RQDetail.idfRQDetailKey, WCDept.idfDeptID, WCDept.idfDescription, RQPriority.idfPriorityID, RQPriority.idfDescription AS Classification, 
   RQSession.idfRQSessionKey, RQSession.idfDescription AS RQSessionDesc, RQDetail.edfAmtExtended, RQDetail.edfAmtHomeExtended, RQDetail.edfPrice, RQDetail.edfCurrency, RQDetail.idfDateRequired, 
   RQDetail.idfDateCreated, RQDetail.edfItem, RQDetail.edfItemDesc, RQDetail.idfQty, RQDetail.edfPONumber, RQDetail.edfVendor, WCSecurity_1.idfDescription AS Approver, RQAprHdr.idfRQAprHdrKey, 
   RQRevHdr.idfRQRevHdrKey, WCSecurity.idfDescription AS Reviewer, RQHeader.idfDescription AS PRNameTitle
from
	   RQHeader JOIN RQDetail ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
	JOIN RQRevDtl ON RQDetail.idfSessionLinkKey = RQRevDtl.idfRQRevDtlKey
	JOIN RQRevHdr ON RQRevDtl.idfRQRevHdrKey = RQRevHdr.idfRQRevHdrKey
	JOIN WCSecurity ON RQRevHdr.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
	JOIN WCDept ON RQDetail.idfWCDeptKey = WCDept.idfWCDeptKey
	JOIN RQSession ON RQDetail.idfRQSessionKey = RQSession.idfRQSessionKey
	JOIN RQPriority ON RQDetail.idfRQPriorityKey = RQPriority.idfRQPriorityKey
	LEFT JOIN RQAprDtl ON RQDetail.idfSessionLinkKey = RQAprDtl.idfRQAprDtlKey
	LEFT JOIN RQAprHdr ON RQAprDtl.idfRQAprHdrKey = RQAprHdr.idfRQAprHdrKey
	LEFT JOIN WCSecurity AS WCSecurity_1 ON RQAprHdr.idfWCSecurityKey = WCSecurity_1.idfWCSecurityKey
DECLARE
@ReqNumber varchar(60),
@ReqHeaderKey INT,
@ReqDetailKey INT,
@DepartmentID char(20) ,
@DepartmentDesc varchar(60),
@ClassificationID char(20),
@ClassificationDesc varchar(60),
@SessionKey INT,
@SessionDesc varchar(60),
@CostForeign numeric(19,5),
@CostLocal numeric(19,5),
@UnitCost numeric(19,5),
@Currency char(15),
@RequiredDate datetime,
@CreatedDate datetime,
@Item char(31),
@ItemDesc char(101),
@Qty numeric(19,5),
@PONumber char(17),
@Vendor char(15),
@Approver varchar(60),
@ApprovalSession int,
@ReviewSession int,
@Reviewer varchar(60),
@PRNameTitle varchar(60)

Open PurchaseReq

FETCH NEXT FROM PurchaseReq INTO @ReqNumber, @ReqHeaderKey, @ReqDetailKey, @DepartmentID, @DepartmentDesc, @ClassificationID, @ClassificationDesc, @SessionKey,
								 @SessionDesc, @CostForeign, @CostLocal, @UnitCost, @Currency, @RequiredDate, @CreatedDate, @Item, @ItemDesc, @Qty, @PONumber, @Vendor, 
								 @Approver, @ApprovalSession, @ReviewSession, @Reviewer,@PRNameTitle

CREATE TABLE #TempDaily (ReqDetailKey int, SessionID int, SessionDesc varchar(255))
WHILE (@@fetch_status <> -1)
BEGIN
	EXEC spWCLanguageDecode @SessionDesc OUTPUT

	INSERT INTO #TempDaily VALUES (@ReqDetailKey, @SessionKey, @SessionDesc)
	
	FETCH NEXT FROM PurchaseReq INTO @ReqNumber, @ReqHeaderKey, @ReqDetailKey, @DepartmentID, @DepartmentDesc, @ClassificationID, @ClassificationDesc, @SessionKey,
									 @SessionDesc, @CostForeign, @CostLocal, @UnitCost, @Currency, @RequiredDate, @CreatedDate, @Item, @ItemDesc, @Qty, @PONumber, @Vendor,
									 @Approver, @ApprovalSession, @ReviewSession, @Reviewer,@PRNameTitle
END
CLOSE PurchaseReq
DEALLOCATE PurchaseReq

--Get Approval Date
DECLARE Approve INSENSITIVE CURSOR FOR
SELECT  idfRQDetailKey,max(idfDateModified) as ApprovalDate
FROM [PLIP].[dbo].[RQAprDtl]
WHERE idfCodeApr = 'APPROVED'
GROUP BY idfRQDetailKey

DECLARE
@ReqDetailAppKey INT,
@ApprDate Datetime
  
Open Approve

FETCH NEXT FROM Approve INTO @ReqDetailAppKey, @ApprDate

CREATE TABLE #TempAppr (ReqDetailKey int, ApprDate datetime)
WHILE (@@fetch_status <> -1)
BEGIN

	INSERT INTO #TempAppr VALUES (@ReqDetailAppKey, @ApprDate)
	
	FETCH NEXT FROM Approve INTO @ReqDetailAppKey, @ApprDate
END
CLOSE Approve
DEALLOCATE Approve

--Get PODate
DECLARE PO INSENSITIVE CURSOR FOR
SELECT     idfRQDetailKey, max(idfDateModified) AS PODate
FROM         PLIP.dbo.RQRevDtl
WHERE     (idfCodeRev = 'ORDER')
GROUP BY idfRQDetailKey

DECLARE
@ReqDetailPOKey INT,
@PODate Datetime
  
Open PO

FETCH NEXT FROM PO INTO @ReqDetailPOKey, @PODate

CREATE TABLE #TempPO (ReqDetailKey int, PODate datetime)
WHILE (@@fetch_status <> -1)
BEGIN

	INSERT INTO #TempPO VALUES (@ReqDetailPOKey, @PODate)
	
	FETCH NEXT FROM PO INTO @ReqDetailPOKey, @PODate
END
CLOSE PO
DEALLOCATE PO
--IF null dates given

IF (@FromDate is Null) BEGIN SELECT @FromDate = GETDATE() END 
IF (@ToDate is Null)  BEGIN SELECT @ToDate = GETDATE() END 

--Dataset Query
SELECT DISTINCT 
	RQHeader.idfRQNumber AS RequisitionNumber, RQHeader.idfRQHeaderKey AS RequisitionNo, RQDetail.idfRQDetailKey AS RequisitionLine, [#TempAppr].ApprDate AS ApprovalDate, 
	WCDept.idfDeptID AS DepartmentID, WCDept.idfDescription AS Department, RQPriority.idfPriorityID AS ClassificationID, RQPriority.idfDescription AS Classification, RQSession.idfRQSessionKey AS StatusID, 
	[#TempDaily].SessionDesc AS Status, RQDetail.edfAmtExtended AS ForeignCost, RQDetail.edfAmtHomeExtended AS LocalCost, RQDetail.edfPrice AS UnitCost, RQDetail.edfCurrency AS Currency, 
	RQDetail.idfDateRequired AS DateRequired, RQDetail.idfDateCreated AS DateCreated, RQDetail.edfItem AS ItemNumber, RQDetail.edfItemDesc AS ItemDescription, RQDetail.idfQty AS Quantity, 
	RQDetail.edfPONumber AS PONumber, RQDetail.edfVendor AS Vendor, [#TempPO].PODate, WCSecurity_1.idfDescription AS Approver, RQAprHdr.idfRQAprHdrKey AS ApprovalSession, 
	RQRevHdr.idfRQRevHdrKey AS ReviewSession, WCSecurity.idfDescription AS Reviewer, RQHeader.idfDescription AS PRNameTitle
FROM           
		RQHeader JOIN RQDetail ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
	JOIN RQRevDtl ON RQDetail.idfSessionLinkKey = RQRevDtl.idfRQRevDtlKey
	JOIN RQRevHdr ON RQRevDtl.idfRQRevHdrKey = RQRevHdr.idfRQRevHdrKey
	JOIN WCSecurity ON RQRevHdr.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
	JOIN WCDept ON RQDetail.idfWCDeptKey = WCDept.idfWCDeptKey
	JOIN RQSession ON RQDetail.idfRQSessionKey = RQSession.idfRQSessionKey
	JOIN RQPriority ON RQDetail.idfRQPriorityKey = RQPriority.idfRQPriorityKey
	LEFT JOIN RQAprDtl ON RQDetail.idfSessionLinkKey = RQAprDtl.idfRQAprDtlKey
	LEFT JOIN RQAprHdr ON RQAprDtl.idfRQAprHdrKey = RQAprHdr.idfRQAprHdrKey
	LEFT JOIN WCSecurity AS WCSecurity_1 ON RQAprHdr.idfWCSecurityKey = WCSecurity_1.idfWCSecurityKey
	LEFT JOIN [#TempPO] ON [#TempPO].ReqDetailKey = RQDetail.idfRQDetailKey
	LEFT JOIN [#TempDaily] ON RQDetail.idfRQDetailKey = [#TempDaily].ReqDetailKey 
    LEFT JOIN [#TempAppr] ON [#TempAppr].ReqDetailKey = RQDetail.idfRQDetailKey   
WHERE     ([#TempAppr].ApprDate >= @FromDate) AND ([#TempAppr].ApprDate <= @ToDate)
DROP TABLE #TempDaily,#TempAppr,#TempPO
END
GO


