SELECT idfWCRRGroupLineUpKey, idfWCLineUpKey, idfPrecedence, idfFieldCount, TMP.idfShowAtTab, TMP.idfDescription,T.idfValue,T.idfValueType,TMP.idfValueList
	,G.idfFlagRQ
	,G.idfFlagTS
	,G.idfFlagES
	,G.idfFlagPO
	,G.idfFlagRCV
	,L.idfTableName
	,L.idfIDColumn
	,L.idfKeyColumn
FROM WCRRGroupLineUp G
	LEFT OUTER JOIN WCRRTemplateDtl T   WITH (NOLOCK) 	ON idfTableLinkName = 'WCRRGroupLineUp' AND G.idfWCRRGroupLineUpKey = T.idfTableLinkKey
	LEFT OUTER JOIN WCRRTemplate	TMP WITH (NOLOCK) 	ON T.idfWCRRTemplateKey = TMP.idfWCRRTemplateKey
	LEFT OUTER JOIN WCListType		L   WITH (NOLOCK)	ON TMP.idfWCListTypeKey = L.idfWCListTypeKey
GROUP BY idfWCRRGroupLineUpKey, idfWCLineUpKey, idfPrecedence, idfFieldCount, TMP.idfShowAtTab, TMP.idfDescription,T.idfValue,T.idfValueType,TMP.idfValueList
	,G.idfFlagRQ
	,G.idfFlagTS
	,G.idfFlagES
	,G.idfFlagPO
	,G.idfFlagRCV
	,L.idfTableName
	,L.idfIDColumn
	,L.idfKeyColumn
--ORDER BY idfWCRRGroupLineUpKey ASC, idfPrecedence ASC,idfFieldCount DESC, TMP.idfShowAtTab,TMP.idfDescription

--Routing Rule Line Users and Precedance
DELETE FROM WCRRSecurity

SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey 
	INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCRRGroupSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
	INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
--WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
UNION ALL
SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	INNER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCRRGroupSec.idfWCRoleKey 		= WCSecRole.idfWCRoleKey
	INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
--WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
ORDER BY WCRRGroupLineUp.idfPrecedence ASC,WCRRGroupLineUp.idfFieldCount DESC


--Routing By Users/Roles
SELECT DISTINCT idfWCRRGroupLineUpKey,idfPrecedence	 
			,CASE WHEN SR.idfRoleID IS NULL THEN RTRIM(ST.idfNameLast)+','+RTRIM(ST.idfNameFirst) +' ('+RTRIM(ST.idfSecurityID)+')' ELSE SR.idfDescription +' ('+RTRIM(SR.idfRoleID)+')' END AS UserRoleID
FROM (SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCSecurity.idfWCSecurityKey, NULL idfWCRoleKey,idfPrecedence
       FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey 
	   INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCRRGroupSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
	   INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
       --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
      UNION ALL
      SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
      FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	    INNER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCRRGroupSec.idfWCRoleKey 		= WCSecRole.idfWCRoleKey
	    INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey ) G
      --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID) 
	LEFT OUTER JOIN dbo.WCRole			SR WITH (NOLOCK) ON SR.idfWCRoleKey		= G.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		ST WITH (NOLOCK) ON ST.idfWCSecurityKey = G.idfWCSecurityKey
ORDER BY idfWCRRGroupLineUpKey, idfPrecedence

--Routing Alternate
SELECT DISTINCT  idfWCRRGroupLineUpKey,
			CASE WHEN S.idfFlagAltrActive = 1 THEN 
					CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END 
			ELSE
				    CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END  
			END	 AS AlternateID
			,CASE WHEN SR.idfRoleID IS NULL THEN RTRIM(ST.idfNameLast)+','+RTRIM(ST.idfNameFirst) +' ('+RTRIM(ST.idfSecurityID)+')' ELSE SR.idfDescription +' ('+RTRIM(SR.idfRoleID)+')' END AS UserRoleID
			,idfPrecedence
FROM (SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCSecurity.idfWCSecurityKey, NULL idfWCRoleKey,idfPrecedence
       FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey 
	   INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCRRGroupSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
	   INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
       --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
      UNION ALL
      SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
      FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	    INNER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCRRGroupSec.idfWCRoleKey 		= WCSecRole.idfWCRoleKey
	    INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey ) G
      --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID)  G
	LEFT OUTER JOIN dbo.WCLineUp		L  WITH (NOLOCK) ON L.idfWCLineUpKey	= G.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSec		S  WITH (NOLOCK) ON S.idfWCLineUpKey	= L.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSecAltr A  WITH (NOLOCK) ON S.idfWCLineUpSecKey	= A.idfWCLineUpSecKey
	LEFT OUTER JOIN dbo.WCRole			SR WITH (NOLOCK) ON SR.idfWCRoleKey		= S.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		ST WITH (NOLOCK) ON ST.idfWCSecurityKey = S.idfWCSecurityKey
	LEFT OUTER JOIN dbo.WCRole			R  WITH (NOLOCK) ON R.idfWCRoleKey		= A.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		T  WITH (NOLOCK) ON T.idfWCSecurityKey  = A.idfWCSecurityKey

--AltUsers
SELECT  main.UserRoleID + main.AlternateID UserROle,main.idfWCRRGroupLineUpKey,main.idfPrecedence
			FROM 
				(
					SELECT DISTINCT A2.UserRoleID,A2.idfWCRRGroupLineUpKey,A2.idfPrecedence
					,	(
							SELECT CASE WHEN A1.AlternateID IS NOT NULL THEN CHAR(10)+char(9)+char(9)+char(9)+char(9)+char(9)+char(9)+char(9)+char(9)+A1.AlternateID ELSE '' END  AS [text()]
							FROM (SELECT DISTINCT  idfWCRRGroupLineUpKey,
			CASE WHEN S.idfFlagAltrActive = 1 THEN 
					CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END 
			ELSE
				    CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END  
			END	 AS AlternateID
			,CASE WHEN SR.idfRoleID IS NULL THEN RTRIM(ST.idfNameLast)+','+RTRIM(ST.idfNameFirst) +' ('+RTRIM(ST.idfSecurityID)+')' ELSE SR.idfDescription +' ('+RTRIM(SR.idfRoleID)+')' END AS UserRoleID
			,idfPrecedence
FROM (SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCSecurity.idfWCSecurityKey, NULL idfWCRoleKey,idfPrecedence
       FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey 
	   INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCRRGroupSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
	   INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
       --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
      UNION ALL
      SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
      FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	    INNER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCRRGroupSec.idfWCRoleKey 		= WCSecRole.idfWCRoleKey
	    INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey ) G
      --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID)  G
	LEFT OUTER JOIN dbo.WCLineUp		L  WITH (NOLOCK) ON L.idfWCLineUpKey	= G.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSec		S  WITH (NOLOCK) ON S.idfWCLineUpKey	= L.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSecAltr A  WITH (NOLOCK) ON S.idfWCLineUpSecKey	= A.idfWCLineUpSecKey
	LEFT OUTER JOIN dbo.WCRole			SR WITH (NOLOCK) ON SR.idfWCRoleKey		= S.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		ST WITH (NOLOCK) ON ST.idfWCSecurityKey = S.idfWCSecurityKey
	LEFT OUTER JOIN dbo.WCRole			R  WITH (NOLOCK) ON R.idfWCRoleKey		= A.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		T  WITH (NOLOCK) ON T.idfWCSecurityKey  = A.idfWCSecurityKey) A1
							Where A1.UserRoleID = A2.UserRoleID AND A1.idfWCRRGroupLineUpKey = A2.idfWCRRGroupLineUpKey AND A1.idfPrecedence = A2.idfPrecedence
							ORDER BY A1.UserRoleID
							For XML PATH ('')
						) AlternateID
				FROM (SELECT DISTINCT  idfWCRRGroupLineUpKey,
			CASE WHEN S.idfFlagAltrActive = 1 THEN 
					CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END 
			ELSE
				    CASE WHEN R.idfRoleID IS NULL THEN RTRIM(T.idfNameLast)+','+RTRIM(T.idfNameFirst) +' ('+RTRIM(T.idfSecurityID)+')' ELSE R.idfDescription +' ('+RTRIM(R.idfRoleID)+')' END  
			END	 AS AlternateID
			,CASE WHEN SR.idfRoleID IS NULL THEN RTRIM(ST.idfNameLast)+','+RTRIM(ST.idfNameFirst) +' ('+RTRIM(ST.idfSecurityID)+')' ELSE SR.idfDescription +' ('+RTRIM(SR.idfRoleID)+')' END AS UserRoleID
			,idfPrecedence
FROM (SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCSecurity.idfWCSecurityKey, NULL idfWCRoleKey,idfPrecedence
       FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey 
	   INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON WCRRGroupSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
	   INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey
       --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID
      UNION ALL
      SELECT WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey,NULL,WCSecRole.idfWCRoleKey,idfPrecedence
      FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	   INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	    INNER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCRRGroupSec.idfWCRoleKey 		= WCSecRole.idfWCRoleKey
	    INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey 		= WCRRGroupLineUp.idfWCRRGroupKey ) G
      --WHERE LEN(ISNULL(@xstridfGroupID,'')) = 0 OR WCRRGroup.idfDescription = @xstridfGroupID)  G
	LEFT OUTER JOIN dbo.WCLineUp		L  WITH (NOLOCK) ON L.idfWCLineUpKey	= G.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSec		S  WITH (NOLOCK) ON S.idfWCLineUpKey	= L.idfWCLineUpKey
	LEFT OUTER JOIN dbo.WCLineUpSecAltr A  WITH (NOLOCK) ON S.idfWCLineUpSecKey	= A.idfWCLineUpSecKey
	LEFT OUTER JOIN dbo.WCRole			SR WITH (NOLOCK) ON SR.idfWCRoleKey		= S.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		ST WITH (NOLOCK) ON ST.idfWCSecurityKey = S.idfWCSecurityKey
	LEFT OUTER JOIN dbo.WCRole			R  WITH (NOLOCK) ON R.idfWCRoleKey		= A.idfWCRoleKey
	LEFT OUTER JOIN dbo.WCSecurity		T  WITH (NOLOCK) ON T.idfWCSecurityKey  = A.idfWCSecurityKey) A2
			) main


SELECT RD.idfRQHeaderKey ReqNumber,ISNULL(p.idfWCRRGroupLineUpKey,0) AS RoutingRule,ISNULL(g.idfWCLineUpKey,0) AS idfWCLineUpKey,rr.idfDescription RoutingRule,WCLU.vdfDisplay Approval,
WCLU.idfDescription AppDescription
FROM TWO.dbo.WCAprPath p WITH (NOLOCK)
LEFT OUTER JOIN WCRRGroupLineUp g WITH (NOLOCK) ON p.idfWCRRGroupLineUpKey = g.idfWCRRGroupLineUpKey
INNER JOIN WCRRGroup RR (NOLOCK) ON g.idfWCRRGroupKey=rr.idfWCRRGroupKey
LEFT OUTER JOIN WCSecurity S WITH (NOLOCK) ON p.idfWCSecurityKey = S.idfWCSecurityKey

LEFT OUTER JOIN (SELECT vdfDisplay	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN WCSecurity.idfNameLast + ', ' + WCSecurity.idfNameFirst ELSE WCRole.idfRoleID END,''),
								    vdfDisplayDesc	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN '' ELSE WCRole.idfDescription END,''),
								    WCLineUp.idfDescription,WCLineUp.idfLineUpID,ISNULL(WCLineUpSec.idfSequence,-1) idfSequence,idfFlagParallelApr,WCLineUpSec.idfWCLineUpSecKey,WCLineUp.idfWCLineUpKey
								    FROM WCLineUp (NOLOCK)
							    LEFT OUTER JOIN TWO..WCLineUpSec  WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
							    LEFT OUTER JOIN TWO..WCRole       WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
							    LEFT OUTER JOIN TWO..WCSecurity   WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey) AS WCLU ON WCLU.idfWCLineUpKey = g.idfWCLineUpKey
LEFT OUTER JOIN RQDetail RD (NOLOCK) on idfLinkTableKey =idfRQDetailKey
WHERE idfLinkTableKey = 812 AND idfLinkTableName = 'RQDetail' 
ORDER BY WCLU.idfSequence 

							    SELECT vdfDisplay	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN WCSecurity.idfNameLast + ', ' + WCSecurity.idfNameFirst ELSE WCRole.idfRoleID END,''),
								    vdfDisplayDesc	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN '' ELSE WCRole.idfDescription END,''),
								    WCLineUp.idfDescription,WCLineUp.idfLineUpID,ISNULL(WCLineUpSec.idfSequence,-1) idfSequence,idfFlagParallelApr,WCLineUpSec.idfWCLineUpSecKey
								    FROM TWO..WCLineUp (NOLOCK)
							    LEFT OUTER JOIN TWO..WCLineUpSec  WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
							    LEFT OUTER JOIN TWO..WCRole       WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
							    LEFT OUTER JOIN TWO..WCSecurity   WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey
							    --WHERE WCLineUp.idfWCLineUpKey = 71919
							    