--2. Run qeury 2 next. De-Activate All Users except the ones specified. Replace loginname1, loginname2 etc. with the user's login that you do NOT want to deactivate
SET ROWCOUNT 1
WHILE 1=1 BEGIN
UPDATE WCSecurity SET idfFlagActive = 0 WHERE idfSecurityID NOT IN ('sa') 
AND idfFlagActive= 1
IF @@ROWCOUNT=0
BREAK
END
SET ROWCOUNT 0


-- Activate Users

SET ROWCOUNT 1
WHILE 1=1 BEGIN
UPDATE WCSecurity 
SET idfFlagActive = '1' FROM WCSecurity WITH (NOLOCK)
WHERE WCSecurity.idfFlagActive <> 1 and idfWCSecurityKey in ('xxx','xxx') -- Security ID of user(s)
IF @@ROWCOUNT=0
BREAK
END
SET ROWCOUNT 0