 -- Get  
-- Paramount Technologies, Inc. $Version: WorkPlace_08.01.00 $  - $Revision: 24 $ $Modtime: 5/10/05 4:58p $  
CREATE PROCEDURE spFNAGetNextNoteID  
 @xnCompanyID int,  
 @xiNewKey numeric(19,5) output,  
 @xnNumbertoReserve int = 1  
AS  
BEGIN TRANSACTION  
 -- Increment key in table which will hold the lock for the transaction.  
 UPDATE DYNAMICS.dbo.SY01500 WITH (UPDLOCK)  
  SET @xiNewKey = NOTEINDX  
   , NOTEINDX = NOTEINDX + @xnNumbertoReserve  
  WHERE CMPANYID = @xnCompanyID  
COMMIT TRANSACTION  
RETURN


select NOTEINDX,* from TWO..PM10000
--update PM10000 set NOTEINDX=0


declare @O_mNoteIndex numeric(19,5),@O_iErrorState int
exec DYNAMICS..smGetNextNoteIndex -1,1,@O_mNoteIndex OUTPUT,@O_iErrorState  OUTPUT
select @O_mNoteIndex,@O_iErrorState
select NOTEINDX,* from DYNAMICS.dbo.SY01500 

 create procedure dbo.smGetNextNoteIndex         
    @I_sCompanyID           smallint        = NULL,  
	@I_iSQLSessionID                int             = NULL,  
	@O_mNoteIndex           numeric(19,5)= NULL  output,  
	@O_iErrorState          int             = NULL  output as  
	declare @tTransaction tinyint  
	select @O_mNoteIndex = 0.0,  @O_iErrorState = 0  
	if ( (@I_sCompanyID is NULL) or  (@I_iSQLSessionID is NULL) ) 
      begin  
	     select  @O_iErrorState = 20231  
		   return 
	   end  
	if @@trancount = 0 
	   begin  
	     select @tTransaction = 1  
         begin transaction 
	   end   
       update   SY01500 set   @O_mNoteIndex = NOTEINDX,  NOTEINDX = NOTEINDX + 1.0 
	   where   CMPANYID = @I_sCompanyID  
	   if (@@rowcount <> 1) 
	   begin  
		    select @O_iErrorState = 20081  
		    if @tTransaction = 1  
	     rollback transaction  
		       return 
	     end  
		 if (@O_mNoteIndex < 1)  
		   select @O_mNoteIndex = 1.0  
		   if @tTransaction = 1  
		commit transaction  
		return 
