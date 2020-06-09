
/****************************************************/
/* Created by: SQL Server 2017 Profiler          */
/* Date: 02/27/2019  12:23:20 AM         */
/****************************************************/
 
-- Create a Queue
DECLARE 
    @traceidnum INT,
    @on BIT,
    @file_path NVARCHAR(50),
    @maxsize bigint;

    SET @on = 1;
    SET @maxsize =5;
    SET @file_path = 'c:\trace';
-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

--exec @rc = sp_trace_create @TraceID output, 0, N'd:\BDO',@maxfilesize
exec sp_trace_create  @traceid = @traceidnum OUTPUT, @options = 2, @tracefile = @file_path, @maxfilesize = @maxsize, @stoptime=null, @filecount =0;
--if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
exec sp_trace_setevent @traceidnum, 33, 1, @on
exec sp_trace_setevent @traceidnum, 33, 9, @on
exec sp_trace_setevent @traceidnum, 33, 3, @on
exec sp_trace_setevent @traceidnum, 33, 11, @on
exec sp_trace_setevent @traceidnum, 33, 4, @on
exec sp_trace_setevent @traceidnum, 33, 6, @on
exec sp_trace_setevent @traceidnum, 33, 7, @on
exec sp_trace_setevent @traceidnum, 33, 8, @on
exec sp_trace_setevent @traceidnum, 33, 10, @on
exec sp_trace_setevent @traceidnum, 33, 12, @on
exec sp_trace_setevent @traceidnum, 33, 14, @on
exec sp_trace_setevent @traceidnum, 33, 20, @on
exec sp_trace_setevent @traceidnum, 33, 26, @on
exec sp_trace_setevent @traceidnum, 33, 30, @on
exec sp_trace_setevent @traceidnum, 33, 31, @on
exec sp_trace_setevent @traceidnum, 33, 35, @on
exec sp_trace_setevent @traceidnum, 33, 41, @on
exec sp_trace_setevent @traceidnum, 33, 49, @on
exec sp_trace_setevent @traceidnum, 33, 50, @on
exec sp_trace_setevent @traceidnum, 33, 51, @on
exec sp_trace_setevent @traceidnum, 33, 60, @on
exec sp_trace_setevent @traceidnum, 33, 64, @on
exec sp_trace_setevent @traceidnum, 33, 66, @on
exec sp_trace_setevent @traceidnum, 162, 1, @on
exec sp_trace_setevent @traceidnum, 162, 9, @on
exec sp_trace_setevent @traceidnum, 162, 3, @on
exec sp_trace_setevent @traceidnum, 162, 11, @on
exec sp_trace_setevent @traceidnum, 162, 4, @on
exec sp_trace_setevent @traceidnum, 162, 6, @on
exec sp_trace_setevent @traceidnum, 162, 7, @on
exec sp_trace_setevent @traceidnum, 162, 8, @on
exec sp_trace_setevent @traceidnum, 162, 10, @on
exec sp_trace_setevent @traceidnum, 162, 12, @on
exec sp_trace_setevent @traceidnum, 162, 14, @on
exec sp_trace_setevent @traceidnum, 162, 20, @on
exec sp_trace_setevent @traceidnum, 162, 26, @on
exec sp_trace_setevent @traceidnum, 162, 30, @on
exec sp_trace_setevent @traceidnum, 162, 31, @on
exec sp_trace_setevent @traceidnum, 162, 35, @on
exec sp_trace_setevent @traceidnum, 162, 41, @on
exec sp_trace_setevent @traceidnum, 162, 49, @on
exec sp_trace_setevent @traceidnum, 162, 50, @on
exec sp_trace_setevent @traceidnum, 162, 51, @on
exec sp_trace_setevent @traceidnum, 162, 60, @on
exec sp_trace_setevent @traceidnum, 162, 64, @on
exec sp_trace_setevent @traceidnum, 162, 66, @on
exec sp_trace_setevent @traceidnum, 148, 1, @on
exec sp_trace_setevent @traceidnum, 148, 41, @on
exec sp_trace_setevent @traceidnum, 148, 4, @on
exec sp_trace_setevent @traceidnum, 148, 12, @on
exec sp_trace_setevent @traceidnum, 148, 11, @on
exec sp_trace_setevent @traceidnum, 148, 51, @on
exec sp_trace_setevent @traceidnum, 148, 14, @on
exec sp_trace_setevent @traceidnum, 148, 26, @on
exec sp_trace_setevent @traceidnum, 148, 60, @on
exec sp_trace_setevent @traceidnum, 148, 64, @on
exec sp_trace_setevent @traceidnum, 10, 1, @on
exec sp_trace_setevent @traceidnum, 10, 9, @on
exec sp_trace_setevent @traceidnum, 10, 2, @on
exec sp_trace_setevent @traceidnum, 10, 66, @on
exec sp_trace_setevent @traceidnum, 10, 10, @on
exec sp_trace_setevent @traceidnum, 10, 3, @on
exec sp_trace_setevent @traceidnum, 10, 4, @on
exec sp_trace_setevent @traceidnum, 10, 6, @on
exec sp_trace_setevent @traceidnum, 10, 7, @on
exec sp_trace_setevent @traceidnum, 10, 8, @on
exec sp_trace_setevent @traceidnum, 10, 11, @on
exec sp_trace_setevent @traceidnum, 10, 12, @on
exec sp_trace_setevent @traceidnum, 10, 13, @on
exec sp_trace_setevent @traceidnum, 10, 14, @on
exec sp_trace_setevent @traceidnum, 10, 15, @on
exec sp_trace_setevent @traceidnum, 10, 16, @on
exec sp_trace_setevent @traceidnum, 10, 17, @on
exec sp_trace_setevent @traceidnum, 10, 18, @on
exec sp_trace_setevent @traceidnum, 10, 25, @on
exec sp_trace_setevent @traceidnum, 10, 26, @on
exec sp_trace_setevent @traceidnum, 10, 31, @on
exec sp_trace_setevent @traceidnum, 10, 34, @on
exec sp_trace_setevent @traceidnum, 10, 35, @on
exec sp_trace_setevent @traceidnum, 10, 41, @on
exec sp_trace_setevent @traceidnum, 10, 48, @on
exec sp_trace_setevent @traceidnum, 10, 49, @on
exec sp_trace_setevent @traceidnum, 10, 50, @on
exec sp_trace_setevent @traceidnum, 10, 51, @on
exec sp_trace_setevent @traceidnum, 10, 60, @on
exec sp_trace_setevent @traceidnum, 10, 64, @on
exec sp_trace_setevent @traceidnum, 11, 1, @on
exec sp_trace_setevent @traceidnum, 11, 9, @on
exec sp_trace_setevent @traceidnum, 11, 2, @on
exec sp_trace_setevent @traceidnum, 11, 66, @on
exec sp_trace_setevent @traceidnum, 11, 10, @on
exec sp_trace_setevent @traceidnum, 11, 3, @on
exec sp_trace_setevent @traceidnum, 11, 4, @on
exec sp_trace_setevent @traceidnum, 11, 6, @on
exec sp_trace_setevent @traceidnum, 11, 7, @on
exec sp_trace_setevent @traceidnum, 11, 8, @on
exec sp_trace_setevent @traceidnum, 11, 11, @on
exec sp_trace_setevent @traceidnum, 11, 12, @on
exec sp_trace_setevent @traceidnum, 11, 14, @on
exec sp_trace_setevent @traceidnum, 11, 25, @on
exec sp_trace_setevent @traceidnum, 11, 26, @on
exec sp_trace_setevent @traceidnum, 11, 34, @on
exec sp_trace_setevent @traceidnum, 11, 35, @on
exec sp_trace_setevent @traceidnum, 11, 41, @on
exec sp_trace_setevent @traceidnum, 11, 49, @on
exec sp_trace_setevent @traceidnum, 11, 50, @on
exec sp_trace_setevent @traceidnum, 11, 51, @on
exec sp_trace_setevent @traceidnum, 11, 60, @on
exec sp_trace_setevent @traceidnum, 11, 64, @on
exec sp_trace_setevent @traceidnum, 43, 1, @on
exec sp_trace_setevent @traceidnum, 43, 9, @on
exec sp_trace_setevent @traceidnum, 43, 2, @on
exec sp_trace_setevent @traceidnum, 43, 66, @on
exec sp_trace_setevent @traceidnum, 43, 3, @on
exec sp_trace_setevent @traceidnum, 43, 4, @on
exec sp_trace_setevent @traceidnum, 43, 5, @on
exec sp_trace_setevent @traceidnum, 43, 6, @on
exec sp_trace_setevent @traceidnum, 43, 7, @on
exec sp_trace_setevent @traceidnum, 43, 8, @on
exec sp_trace_setevent @traceidnum, 43, 10, @on
exec sp_trace_setevent @traceidnum, 43, 11, @on
exec sp_trace_setevent @traceidnum, 43, 12, @on
exec sp_trace_setevent @traceidnum, 43, 13, @on
exec sp_trace_setevent @traceidnum, 43, 14, @on
exec sp_trace_setevent @traceidnum, 43, 15, @on
exec sp_trace_setevent @traceidnum, 43, 22, @on
exec sp_trace_setevent @traceidnum, 43, 26, @on
exec sp_trace_setevent @traceidnum, 43, 28, @on
exec sp_trace_setevent @traceidnum, 43, 29, @on
exec sp_trace_setevent @traceidnum, 43, 34, @on
exec sp_trace_setevent @traceidnum, 43, 35, @on
exec sp_trace_setevent @traceidnum, 43, 41, @on
exec sp_trace_setevent @traceidnum, 43, 48, @on
exec sp_trace_setevent @traceidnum, 43, 49, @on
exec sp_trace_setevent @traceidnum, 43, 50, @on
exec sp_trace_setevent @traceidnum, 43, 51, @on
exec sp_trace_setevent @traceidnum, 43, 60, @on
exec sp_trace_setevent @traceidnum, 43, 62, @on
exec sp_trace_setevent @traceidnum, 43, 64, @on
exec sp_trace_setevent @traceidnum, 42, 1, @on
exec sp_trace_setevent @traceidnum, 42, 9, @on
exec sp_trace_setevent @traceidnum, 42, 2, @on
exec sp_trace_setevent @traceidnum, 42, 66, @on
exec sp_trace_setevent @traceidnum, 42, 3, @on
exec sp_trace_setevent @traceidnum, 42, 4, @on
exec sp_trace_setevent @traceidnum, 42, 5, @on
exec sp_trace_setevent @traceidnum, 42, 6, @on
exec sp_trace_setevent @traceidnum, 42, 7, @on
exec sp_trace_setevent @traceidnum, 42, 8, @on
exec sp_trace_setevent @traceidnum, 42, 10, @on
exec sp_trace_setevent @traceidnum, 42, 11, @on
exec sp_trace_setevent @traceidnum, 42, 12, @on
exec sp_trace_setevent @traceidnum, 42, 14, @on
exec sp_trace_setevent @traceidnum, 42, 22, @on
exec sp_trace_setevent @traceidnum, 42, 26, @on
exec sp_trace_setevent @traceidnum, 42, 28, @on
exec sp_trace_setevent @traceidnum, 42, 29, @on
exec sp_trace_setevent @traceidnum, 42, 34, @on
exec sp_trace_setevent @traceidnum, 42, 35, @on
exec sp_trace_setevent @traceidnum, 42, 41, @on
exec sp_trace_setevent @traceidnum, 42, 49, @on
exec sp_trace_setevent @traceidnum, 42, 50, @on
exec sp_trace_setevent @traceidnum, 42, 51, @on
exec sp_trace_setevent @traceidnum, 42, 60, @on
exec sp_trace_setevent @traceidnum, 42, 62, @on
exec sp_trace_setevent @traceidnum, 42, 64, @on
exec sp_trace_setevent @traceidnum, 45, 1, @on
exec sp_trace_setevent @traceidnum, 45, 9, @on
exec sp_trace_setevent @traceidnum, 45, 3, @on
exec sp_trace_setevent @traceidnum, 45, 4, @on
exec sp_trace_setevent @traceidnum, 45, 5, @on
exec sp_trace_setevent @traceidnum, 45, 6, @on
exec sp_trace_setevent @traceidnum, 45, 7, @on
exec sp_trace_setevent @traceidnum, 45, 8, @on
exec sp_trace_setevent @traceidnum, 45, 10, @on
exec sp_trace_setevent @traceidnum, 45, 11, @on
exec sp_trace_setevent @traceidnum, 45, 12, @on
exec sp_trace_setevent @traceidnum, 45, 13, @on
exec sp_trace_setevent @traceidnum, 45, 14, @on
exec sp_trace_setevent @traceidnum, 45, 15, @on
exec sp_trace_setevent @traceidnum, 45, 16, @on
exec sp_trace_setevent @traceidnum, 45, 17, @on
exec sp_trace_setevent @traceidnum, 45, 18, @on
exec sp_trace_setevent @traceidnum, 45, 22, @on
exec sp_trace_setevent @traceidnum, 45, 25, @on
exec sp_trace_setevent @traceidnum, 45, 26, @on
exec sp_trace_setevent @traceidnum, 45, 28, @on
exec sp_trace_setevent @traceidnum, 45, 29, @on
exec sp_trace_setevent @traceidnum, 45, 34, @on
exec sp_trace_setevent @traceidnum, 45, 35, @on
exec sp_trace_setevent @traceidnum, 45, 41, @on
exec sp_trace_setevent @traceidnum, 45, 48, @on
exec sp_trace_setevent @traceidnum, 45, 49, @on
exec sp_trace_setevent @traceidnum, 45, 50, @on
exec sp_trace_setevent @traceidnum, 45, 51, @on
exec sp_trace_setevent @traceidnum, 45, 55, @on
exec sp_trace_setevent @traceidnum, 45, 60, @on
exec sp_trace_setevent @traceidnum, 45, 61, @on
exec sp_trace_setevent @traceidnum, 45, 62, @on
exec sp_trace_setevent @traceidnum, 45, 64, @on
exec sp_trace_setevent @traceidnum, 45, 66, @on
exec sp_trace_setevent @traceidnum, 44, 1, @on
exec sp_trace_setevent @traceidnum, 44, 9, @on
exec sp_trace_setevent @traceidnum, 44, 3, @on
exec sp_trace_setevent @traceidnum, 44, 4, @on
exec sp_trace_setevent @traceidnum, 44, 5, @on
exec sp_trace_setevent @traceidnum, 44, 6, @on
exec sp_trace_setevent @traceidnum, 44, 7, @on
exec sp_trace_setevent @traceidnum, 44, 8, @on
exec sp_trace_setevent @traceidnum, 44, 10, @on
exec sp_trace_setevent @traceidnum, 44, 11, @on
exec sp_trace_setevent @traceidnum, 44, 12, @on
exec sp_trace_setevent @traceidnum, 44, 14, @on
exec sp_trace_setevent @traceidnum, 44, 22, @on
exec sp_trace_setevent @traceidnum, 44, 26, @on
exec sp_trace_setevent @traceidnum, 44, 28, @on
exec sp_trace_setevent @traceidnum, 44, 29, @on
exec sp_trace_setevent @traceidnum, 44, 30, @on
exec sp_trace_setevent @traceidnum, 44, 34, @on
exec sp_trace_setevent @traceidnum, 44, 35, @on
exec sp_trace_setevent @traceidnum, 44, 41, @on
exec sp_trace_setevent @traceidnum, 44, 49, @on
exec sp_trace_setevent @traceidnum, 44, 50, @on
exec sp_trace_setevent @traceidnum, 44, 51, @on
exec sp_trace_setevent @traceidnum, 44, 55, @on
exec sp_trace_setevent @traceidnum, 44, 60, @on
exec sp_trace_setevent @traceidnum, 44, 61, @on
exec sp_trace_setevent @traceidnum, 44, 62, @on
exec sp_trace_setevent @traceidnum, 44, 64, @on
exec sp_trace_setevent @traceidnum, 44, 66, @on
exec sp_trace_setevent @traceidnum, 12, 1, @on
exec sp_trace_setevent @traceidnum, 12, 9, @on
exec sp_trace_setevent @traceidnum, 12, 3, @on
exec sp_trace_setevent @traceidnum, 12, 11, @on
exec sp_trace_setevent @traceidnum, 12, 4, @on
exec sp_trace_setevent @traceidnum, 12, 6, @on
exec sp_trace_setevent @traceidnum, 12, 7, @on
exec sp_trace_setevent @traceidnum, 12, 8, @on
exec sp_trace_setevent @traceidnum, 12, 10, @on
exec sp_trace_setevent @traceidnum, 12, 12, @on
exec sp_trace_setevent @traceidnum, 12, 13, @on
exec sp_trace_setevent @traceidnum, 12, 14, @on
exec sp_trace_setevent @traceidnum, 12, 15, @on
exec sp_trace_setevent @traceidnum, 12, 16, @on
exec sp_trace_setevent @traceidnum, 12, 17, @on
exec sp_trace_setevent @traceidnum, 12, 18, @on
exec sp_trace_setevent @traceidnum, 12, 26, @on
exec sp_trace_setevent @traceidnum, 12, 31, @on
exec sp_trace_setevent @traceidnum, 12, 35, @on
exec sp_trace_setevent @traceidnum, 12, 41, @on
exec sp_trace_setevent @traceidnum, 12, 48, @on
exec sp_trace_setevent @traceidnum, 12, 49, @on
exec sp_trace_setevent @traceidnum, 12, 50, @on
exec sp_trace_setevent @traceidnum, 12, 51, @on
exec sp_trace_setevent @traceidnum, 12, 60, @on
exec sp_trace_setevent @traceidnum, 12, 64, @on
exec sp_trace_setevent @traceidnum, 12, 66, @on
exec sp_trace_setevent @traceidnum, 13, 1, @on
exec sp_trace_setevent @traceidnum, 13, 9, @on
exec sp_trace_setevent @traceidnum, 13, 3, @on
exec sp_trace_setevent @traceidnum, 13, 11, @on
exec sp_trace_setevent @traceidnum, 13, 4, @on
exec sp_trace_setevent @traceidnum, 13, 6, @on
exec sp_trace_setevent @traceidnum, 13, 7, @on
exec sp_trace_setevent @traceidnum, 13, 8, @on
exec sp_trace_setevent @traceidnum, 13, 10, @on
exec sp_trace_setevent @traceidnum, 13, 12, @on
exec sp_trace_setevent @traceidnum, 13, 14, @on
exec sp_trace_setevent @traceidnum, 13, 26, @on
exec sp_trace_setevent @traceidnum, 13, 35, @on
exec sp_trace_setevent @traceidnum, 13, 41, @on
exec sp_trace_setevent @traceidnum, 13, 49, @on
exec sp_trace_setevent @traceidnum, 13, 50, @on
exec sp_trace_setevent @traceidnum, 13, 51, @on
exec sp_trace_setevent @traceidnum, 13, 60, @on
exec sp_trace_setevent @traceidnum, 13, 64, @on
exec sp_trace_setevent @traceidnum, 13, 66, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @traceidnum, 10, 0, 6, N'WorkPlace:User1'
exec sp_trace_setfilter @traceidnum, 10, 0, 7, N'SQL Server Profiler - 1cdb8343-399f-444e-90f0-98703b3f780d'
-- Set the trace status to start
exec sp_trace_setstatus @traceidnum, 1

-- display trace id for future references
--select TraceID=@traceidnum
goto finish

error: 
--select ErrorCode=@rc

finish: 
go
