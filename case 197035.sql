begin tran
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
declare @p5 varchar(255)
set @p5='-1'
exec WPCompany_EPICOR..spRCVHeaderPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xidfRCVHeaderKey='6',@xonWCValHdrKey=@p5 output,@xnEAICPriority='100'
select @p1, @p2, @p3, @p5

rollback tran 

--select * from PODetailDistributionHist


