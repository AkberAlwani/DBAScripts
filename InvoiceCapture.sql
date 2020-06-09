select * from dbo.RQHeader
select * from dbo.RQDetail
select * from dbo.RQDetailTax
select * from dbo.RQRevDtlRQHeader

delete from dbo.APInvoiceCaptureHdr
delete from dbo.APInvoiceCaptureDtl
delete from dbo.APInvoiceCaptureQueue
delete from dbo.APInvoiceCaptureQueueHist
select * from dbo.APInvoiceCaptureVendorMatch

begin tran
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5=''
exec TWO..spRQRevLoad @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfWCSecurityKey='1',@xonidfRQRevHdrKey=@p5 output,@xstrLD_vdfSortOrder='',@xstrLD_vdfReqType='3',@xstrLD_RequisitionName='',@xstrLD_vdfLoadType='Standard',@xnLoadSizeLimit='999999',@xstrLD_idfSecurityID_From='sa',@xstrLD_idfSecurityID_To='sa'
select @p1, @p2, @p3, @p5
ROLLBACK tran 

declare @p3 nvarchar(4000)
set @p3=''
exec spGLAccountDeptJoinBuilder @xstrvdfDeptID='',@xstrvdfDeptIDMASS='',@xstrSQLJoin01=@p3 output
select @p3
select * from #GLAccountMaskList 


SELECT DISTINCT TOP 25 
	DOCID AS DOCID
FROM SOP40200(NOLOCK)
WHERE SOPTYPE = 3
AND WORKFLOWENABLED = 1
ORDER BY 1 SET NO_BROWSETABLE OFF;

exec dbo.spCATCatalogInit

select * from GL00105 where ACTNUMST='xx'