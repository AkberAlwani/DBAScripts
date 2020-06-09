--Insert Purchase Order Outstanding Report to all Roles
declare @lastKey int,@roleKey int
SELECT @lastKey=max(idfWCSecurityAccessKey)+1 from WCSecurityAccess 

DECLARE curRole CURSOR for
select idfWCRoleKey from WCRole
WHERE idfWCRoleKey not in (Select IdfWCRoleKey from 
   WCSecurityAccess where idfWCRptHdrKey=73)

OPEN curRole 
FETCH curRole  INTO @RoleKey
WHILE @@FETCH_STATUS<>-1
BEGIN
   Print @RoleKey
   INSERT INTO WCSecurityAccess (idfWCSecurityAccessKey,idfFlagAllow,idfFlagDeny,idfType,idfWCChartKey,idfWCRoleKey,idfWCRptHdrKey,idfWCSecurityAccessTemplateKey)
   VALUES (@lastKey,1,0,'REPORT',0,@rolekey,73,0)
   set @lastkey=@lastkey+1
   FETCH curRole INTO @RoleKey
END
CLOSE curRole
DEALLOCATE curRole




--- Deny Acceess to Reseve PO
UPDATE WCSecurityAccess set idfFlagAllow=0, idfFlagDeny=1 where idfWCSecurityAccessTemplateKey=46