declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p7 varchar(255)
set @p7='0'
exec TWO..spEXPApprovalAction @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xstrCodeApr='APPROVED',@xstrTableLinkName='EXPAprHdr',@xnTableLinkKey='1',@xoNoteRQ=@p7 output
select @p1, @p2, @p3, @p7

declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec TWO..spEXPAprPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfEXPAprHdrKey='196'
select @p1, @p2, @p3

declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5=''
exec TWO..spEXPBatchProcess @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfWCSecurityKey='2',@xonidfEXPRevHdrKey=@p5 output,@xstridfBatchID=''
select @p1, @p2, @p3, @p5


declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5=''
exec YTWO..spEXPBatchProcess @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfWCSecurityKey='2',@xonidfEXPRevHdrKey=@p5 output,@xstrLD_idfSecurityID_From='User1',@xstrLD_idfSecurityID_To='User1',@xstridfBatchID=''
select @p1, @p2, @p3, @p5

-- RQ Rev
begin tran
declare @P1 int
set @p1 =NULL
declare @P2 int
set @p1 =NULL
declare @p3 varchar(255)
set @p3=NULL
exec spRQREvPost @xochERRsp=@p1 OUTPUT,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output, @xnidfRQRevHdrKey='2'
select @p1,@p2,@p3
rollback tran

-- RQ Aprovel Load
begin tran
declare @p3 int
set @p3=NULL
declare @p4 int
set @p4=NULL
declare @p5 int
set @p5=NULL
declare @p6 int
set @p6=NULL
declare @p7 int
set @p7=NULL
exec dbo.spRQRevLoad @xnidfWCSecurityKey=2,@xnGetRecordCountsOnly=1,@xonRecordsPendingApproval=@p3 output,@xonRecordsPendingApprovalCR=@p4 output,@xonRecordsPendingRFQApproval=@p5 output,@xonRecordsInBatch=@p6 output,@xonRecordsInBatchCR=@p7 output
select @p3, @p4, @p5, @p6, @p7
rollback tran

EXEC spRQRPTPurchaseOrder @xstridfSecurityIDCurrent = 'sa' 						 ,@xnidfCaption = 1
EXEC spRQRPTPurchaseOrder 'STD', 'P00720044', 6,@xstridfSecurityIDCurrent = 'sa',@xnidfDateFormat='101', @xnidfData = 1
EXEC spRQPORelease '',0,'','PO2111           ','STD'


declare @p1 varchar(32)
set @p1=''
declare @p2 int
set @p2=0
declare @p3 varchar(255)
set @p3=''
exec dbo.spRQRevDtlRQHeader @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xchAction='CM',@xnValidationType='3',@xchUDFParam1='',@xstrCaller='SUBMIT'
select @p1, @p2, @p3

declare @p3 int
set @p3=NULL
declare @p4 int
set @p4=NULL
declare @p5 int
set @p5=NULL
declare @p6 int
set @p6=NULL
declare @p7 int
set @p7=NULL
exec dbo.spRQRevLoad @xnidfWCSecurityKey=34,@xnGetRecordCountsOnly=1,@xonRecordsPendingApproval=@p3 output,@xonRecordsPendingApprovalCR=@p4 output,@xonRecordsPendingRFQApproval=@p5 output,@xonRecordsInBatch=@p6 output,@xonRecordsInBatchCR=@p7 output
select @p3, @p4, @p5, @p6, @p7


--WPE
begin tran
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec YTWO..spRQRevPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRQRevHdrKey='14'
select @p1, @p2, @p3
rollback tran


declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec WPELive..spRCVAprPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRCVAprHdrKey='509'
select @p1, @p2, @p3


declare @p6 varchar(8000)
set @p6=NULL
declare @p7 varchar(8000)
set @p7=NULL
exec ZTWO.dbo.spRQAprLoad @xnidfWCSecurityKey=2,@xnidfPTICompanyKey=19,@xstrLD_vdfRQType=-1,@xnGetRecordCountsOnly=1,@xnGetRecordHeadersOnly=0,@xostrRecordsPendingApproval=@p6 output,@xostrRecordsPendingApprovalCR=@p7 output
select @p6, @p7


declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5='-1'
exec WPCompany_EPICOR..spRCVHeaderPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xidfRCVHeaderKey='4',@xonWCValHdrKey=@p5 output,@xnEAICPriority='100'
select @p1, @p2, @p3, @p5


-- Security Report
EXEC spWCRPTSecurity 1, 0, 0, 0,0, '', @xstridfSecurityIDCurrent =  'User2',@xnidfDateFormat='101',@xnidfData = 1

declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5=''
exec WPLIVE..spRQAprPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRQAprHdrKey='247304',@xstrPostMessage=@p5 output
select @p1, @p2, @p3, @p5

WPE
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec WPELIVE..spRQRevPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRQRevHdrKey='4821'
select @p1, @p2, @p3