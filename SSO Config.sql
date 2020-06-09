--SO WCSecurity Changes

--1. Create Backup Of WCSecurity Table Just In Case
--SELECT * INTO WCSecurityBak FROM WCSECURITY

--2. Query WCSecurity For Duplicate EMail Addresses - If Duplicates Then Client Will Have To Fix First In WorkPlace!
--SELECT idfEmail FROM WCSecurity GROUP BY idfEmail HAVING COUNT(*) > 1

--3. Query WCSecurity - Note idfSecurityID of SQL users to not change that may exist as logins i.e. WPShared, WPLanguageUser, sa, Etc... 
--SELECT idfSecurityID, idfEmail, * from WCSecurity

--4. Update WCSecurity Where NOT IN  is list of users not to change
UPDATE WCSecurity SET idfSecurityID = idfEmail WHERE idfFlagActive='1' AND idfSecurityID NOT IN ('##','##','##') AND idfEMail <> '' and idfEmail<>idfSecurityID 

--5. Resync PTIMaster PTISecurity
DELETE PTIMaster..PTISecurity
--EXEC spWCSecurityAccessEffectiveSync  
--EXEC spPTIFixDB

--Well one more thing - need to create a SQL WPAgent user and in WorkPlace Service Account and change the WorkPlace Agent to SQL/APP authentication with this new user