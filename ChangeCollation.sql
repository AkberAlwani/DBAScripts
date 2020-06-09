USE master;
GO
 
-- Set to single-user mode
ALTER DATABASE TWO
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
  
-- change collation
ALTER DATABASE TWO
COLLATE SQL_Latin1_General_CP1_CI_AS;  
GO  
 
-- Set to multi-user mode
ALTER DATABASE TWO
SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO  
 
--Verify the collation setting.  
SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'TWO';  
GO