SELECT ROUND(8,0),ROUND(8,1),ROUND(8,0-1)
SELECT
	ROUND(CEILING(@QTY_Require / @ORDERMULTIPLE) * @ORDERMULTIPLE, @DecPlaceQtys - 1)   -- This Return 10 Qty

SELECT CEILING(8 / 1.0000) 
select ROUND(CEILING(8/ 1.0000) * 1.0000, 0- 1)
SELECT DECPLQTY,* FROm IV00101 WHERE ITEMNMBR='401'


SELECT * from IV00103 WHERE ITEMNMBR='401'
SELECT * from IV00106 WHERE ITEMNMBR='401'
select ORDERMULTIPLE,IV00103.MINORQTY,* from IV00103 where IV00103.ITEMNMBR='401'
SELECT
	@VNDITNUM = VNDITNUM
   ,@VNDITDSC = VNDITDSC
   ,@PLANNINGLEADTIME = PLANNINGLEADTIME
   ,@ORDERMULTIPLE = ORDERMULTIPLE
   ,@FREEONBOARD = FREEONBOARD
   ,@PRCHSUOM = PRCHSUOM
   ,@MINORQTY = MINORQTY
   ,@MAXORDQTY = MAXORDQTY
   ,@ECORDQTY = ECORDQTY
FROM IV00103(nolock)
WHERE ITEMNMBR = @stridfItemID
AND VENDORID = @strVendorOnReqID  

-- Step 1
select @QTYBSUOM = QTYBSUOM, @UMPUROPT = UMPUROPT from IV00106 (nolock) where ITEMNMBR = @fcITEMNMBR and UOFM = @PRCHSUOM

SELECT	@DecPlaceQtys = 0
if (@UMPUROPT = 2)  begin
SELECT @DecPlaceQtys = 0 END
ELSE 
BEGIN 
SELECT @DecPlaceQtys = @fcDECPLQTY - 1
END  

 SELECT * from IV00106 WHERE ITEMNMBR='401'
SELECT ROUND(CEILING(@QTY_Require / @ORDERMULTIPLE) * @ORDERMULTIPLE, @DecPlaceQtys- 1)   -- This Return 10 Qty

Declare @QTYBSUOM numeric(19,5),  @UMPUROPT smallint,  @DecPlaceQtys smallint,  @QTYToOrderInPurchUofM numeric(19,5),@QTY_Modified numeric(19,5)
SELECT @QTY_Modified=0,
@QTYToOrderInPurchUofM =0
select @QTY_MODIFIED=ROUND(CEILING(8 / 1.0000) * 1.0000, 0- 1)
SELECT @QTYBSUOM = QTYBSUOM from IV00106 (nolock) where ITEMNMBR = '401' and UOFM = 'Box'

SELECT
	(ROUND((10/ 10), 0) * 10) 	,ROUND((4/ 10) + (.5 / POWER(10, 0)), 0, 0),
	CASE
		WHEN ((ROUND((0 / 10), 0) * 10) >= 0) THEN ROUND((0 / 10), 0)
		ELSE ROUND((0 / 10) + (.5 / POWER(10, 0)), 0, 0)
	END


SELECT 
	CASE
		WHEN ((ROUND((@QTY_Modified / @QTYBSUOM), @DecPlaceQtys) * @QTYBSUOM) >= @QTY_Modified) THEN ROUND((@QTY_Modified / @QTYBSUOM), @DecPlaceQtys)
		ELSE ROUND((@QTY_Modified / @QTYBSUOM) + (.5 / POWER(10, @DecPlaceQtys)), @DecPlaceQtys, 0)
	END

SELECT QTY_Required =
	CASE
		WHEN QTYAVAIL < ORDRPNTQTY THEN CASE
				WHEN ReplenishmentLevel IN (1, 3) THEN ORDRPNTQTY - QTYAVAIL
				ELSE CASE
						WHEN (ORDRUPTOLVL = 0 OR
							ORDRUPTOLVL < ORDRPNTQTY) THEN ORDRPNTQTY - QTYAVAIL
						ELSE ORDRUPTOLVL - QTYAVAIL
					END
			END
		ELSE 0
	END
FROM 
(SELECT
	a.ITEMNMBR
   ,a.MasterLocationCode
   ,a.LOCNCODE
   ,a.RCRDTYPE
   ,0 QTY_Required
   ,a.QTYONHND +
	a.QTYONORD - (CASE
		WHEN a.IncludeAllocations = 1 THEN a.ATYALLOC
		ELSE 0
	END) - (CASE
		WHEN a.IncludeRequisitions = 1 THEN a.QTYRQSTN
		ELSE 0
	END) - (CASE
		WHEN a.IncludeBackorders = 1 THEN a.QTYBKORD
		ELSE 0
	END) + ISNULL((SELECT
			(SUM(ISNULL(ROUND(p.QTYORDER *
			CASE
				WHEN p.UMQTYINB > 0 THEN p.UMQTYINB
				ELSE 1
			END, p.DECPLQTY - 1), 0)) - SUM(ISNULL(ROUND(p.QTYCANCE *
			CASE
				WHEN p.UMQTYINB > 0 THEN p.UMQTYINB
				ELSE 1
			END, p.DECPLQTY - 1), 0)))
		FROM POP10110 p (NOLOCK)
		WHERE (p.ITEMNMBR = a.ITEMNMBR
		AND p.LOCNCODE = a.LOCNCODE
		AND p.POLNESTA = 1
		AND p.POTYPE IN (1, 3)
		AND p.LineNumber <> 0))
	, 0) QTYAVAIL
   ,a.QTYONHND
   ,a.QTYONORD
   ,ISNULL((SELECT
			(SUM(ISNULL(ROUND(p.QTYORDER *
			CASE
				WHEN p.UMQTYINB > 0 THEN p.UMQTYINB
				ELSE 1
			END, p.DECPLQTY - 1), 0)) - SUM(ISNULL(ROUND(p.QTYCANCE *
			CASE
				WHEN p.UMQTYINB > 0 THEN p.UMQTYINB
				ELSE 1
			END, p.DECPLQTY - 1), 0)))
		FROM POP10110 p (NOLOCK)
		WHERE (p.ITEMNMBR = a.ITEMNMBR
		AND p.LOCNCODE = a.LOCNCODE
		AND p.POLNESTA = 1
		AND p.POTYPE IN (1, 3)
		AND p.LineNumber <> 0))
	, 0) QTYONORDERNEWPO
   ,CASE
		WHEN a.IncludeAllocations = 1 THEN a.ATYALLOC
		ELSE 0
	END ATYALLOC
   ,CASE
		WHEN a.IncludeBackorders = 1 THEN a.QTYBKORD
		ELSE 0
	END QTYBKORD
   ,CASE
		WHEN a.IncludeRequisitions = 1 THEN a.QTYRQSTN
		ELSE 0
	END QTYRQSTN
   ,a.QTYONHND + a.QTYONORD QTY_Total_Supplies
   ,CASE
		WHEN a.IncludeAllocations = 1 THEN a.ATYALLOC
		ELSE 0
	END +
	CASE
		WHEN a.IncludeBackorders = 1 THEN a.QTYBKORD
		ELSE 0
	END +
	CASE
		WHEN a.IncludeRequisitions = 1 THEN a.QTYRQSTN
		ELSE 0
	END QTY_Total_Requirements
   ,a.ReplenishmentLevel
   ,a.ORDRPNTQTY
   ,a.ORDRUPTOLVL
FROM IV00102 a (NOLOCK)
	,IV00101 b (NOLOCK)
WHERE 
a.LOCNCODE <> ''
AND (b.ITEMNMBR = a.ITEMNMBR
AND b.ITEMTYPE = 1
AND b.INACTIVE = 0)
AND a.ITEMNMBR = '401'
AND a.ITEMNMBR = '401'
AND a.INACTIVE = 0) t



begin tran
declare @p1 varchar(32)
set @p1=''
declare @p2 int
set @p2=0
declare @p3 varchar(255)
set @p3=''
declare @p4 varchar(255)
set @p4=''
declare @p5 varchar(255)
set @p5=''
exec dbo.spIVReplenishment @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xstrReqsCreated=@p4 output,@xstrValHdrKeys=@p5 output,@xnidfWCSecurityKey=2,@xstrvdfItemFrom =N'401',@xstrvdfItemTo=N'401',@xstrvdfSiteFrom=N'01-N',@xstrvdfSiteTo=N'01-N',@xstrvdfVendorFrom=N'',@xstrvdfVendorTo=N'',@xstrvdfItemClassFrom=N'',@xstrvdfItemClassTo=N'',@xstrvdfBuyerFrom='               ',@xstrvdfBuyerTo='               ',@xdvdfDateRequired=N'',@xnIncludeWOVendor=0,@xnSubmitOnCreate=0,@xnBreakByVendor=0,@xnBreakBySite=0,@xnPlanningTime=1,@xstrShipTo=N'',@xstrBillTo=N'',@xstrDeptID='',@xstrFacilityID=default
select @p1, @p2, @p3, @p4, @p5
rollback tran

