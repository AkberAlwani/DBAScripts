--Replace LIVE with the LIVE databasename - TEST with the TEST database name
--Users in TEST but not in LIVE  
SELECT S1.idfSecurityID FROM TEST..WCSecurity S1
LEFT OUTER JOIN LIVE..WCSecurity S2 ON S1.idfSecurityID = S2.idfSecurityID
WHERE S2.idfWCSecurityKey IS NULL and S1.idfFlagActive=1

 --Users in LIVE but not in TEST
SELECT S1.idfSecurityID FROM LIVE..WCSecurity S1
LEFT OUTER JOIN TEST..WCSecurity S2 ON S1.idfSecurityID = S2.idfSecurityID
WHERE S2.idfWCSecurityKey IS NULL and S1.idfFlagActive=1