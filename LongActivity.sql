USE [master]
GO
/****** Object:  StoredProcedure [dbo].[usp_GPLoggedUsers_overtimed]    Script Date: 2013-04-04 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
--Author:           < Beat BUCHER >
--Create date: 2009-09-08 / 10:22 
--Description:      The script validates which user account is logged in Dynamics GP
--                  since more then 750 min (12,5 hrs) and sent the report by e-mail
--=============================================
CREATE PROCEDURE [dbo].[usp_GPLoggedUsers_overtimed]
AS
BEGIN
       --SET NOCOUNT ON added to prevent extra result sets from
       --interfering with SELECT statements.
       SET NOCOUNT ON;
IF EXISTS
(
select datediff(mi,logindat+logintim, getdate()) as DURATION, 
       convert(datetime, convert(varchar(15), GetDate(), 114), 114) - LOGINTIM as DURATION,
USERID,
CMPNYNAM,
LOGINDAT,
LOGINTIM
from DYNAMICS.dbo.ACTIVITY
where datediff(mi,logindat+logintim, getdate()) > 750
)
BEGIN
DECLARE @SQL varchar(8000)
              SET @SQL = 'select datediff(mi,logindat+logintim, getdate()) as DURATION, USERID,
CMPNYNAM,
LOGINDAT,
LOGINTIM
from DYNAMICS.dbo.ACTIVITY where datediff(mi,logindat+logintim,getdate()) > 750'
               --print @SQL
               EXEC msdb.dbo.sp_send_dbmail @recipients = 'aali@paramountworkplace.com',
@subject = 'Users Logged in beyond limit',
@body = 'Attached is a list of users that have been logged in beyond the limit',                 @query = @SQL,
@attach_query_result_as_file = 'TRUE',
@query_result_width = 250
      END
END
GO