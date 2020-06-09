select * from IV00101 where itemnmbr like '%BP%'
select * from IV00106 where itemnmbr like '%BP%' 
update IV00101 set PRICMTHD=4,DECPLCUR= 3,VCTNMTHD=4 where itemnmbr like '%BP%'

begin tran
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec TWO..spRQHeaderSubmit @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRQHeaderKey=3,@xstrCurrentUser='sa'
select @p1, @p2, @p3
rollback tran

