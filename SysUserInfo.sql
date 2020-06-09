/*Instructions and Notes

Open up SQL Server Management Studio and execute the script on the WorkPlace company database: spUserInfoQuery.sql

This query returns the following per user. 
LoginID = This is the WorkPlace login for the user.
UserName = WorkPlace user’s first and last name.
RoleID = These are the Roles assigned to the user in WorkPlace Security.
Approvers_PO = Equal to 1 means they approved for a PO based routing rule. Equal to 0 means they do not approved for a PO based routing rule. 
Approvers_Receive/Invoice = Equal to 1 means they approved for a Receive/Invoice based routing rule. Equal to 0 means they do not approved for a Receive/Invoice based routing rule.
Approvers_Requisition = Equal to 1 means they approved for a Requisition based routing rule. Equal to 0 means they do not approved for a Requisition based routing rule. 
Rules = This displays the specific criteria setup on the filter the user Approves for. 

Notes:
Query only looks at the standard WorkPlace Routing Rule engine. (Position, Project and Supervisor Approval not included.) 
Repeating results for each user can occur due to what is assigned to them. */


DECLARE
 @nidfWCSecurityKey			INT
,@nidfWCDeptKey 			INT
,@n__curWCRRGroupLineUp_idfWCSecurityKey	INT
,@n__curWCRRGroupLineUp_idfGroup		INT
,@n__curWCRRGroupLineUp_idfWCRRGroupLineUpKey	INT
,@n__curWCRRGroupLineUp_idfWCLineUpKey	INT
,@n__curWCRRGroupLineUp_idfPrecedence	INT
,@n__curWCRRGroupLineUp_idfFieldCount	INT
,@strcurWCRRGroupLineUp_idfShowAtTab	VARCHAR(30)
,@strcurWCRRGroupLineUp_idfDescription	VARCHAR(60)
,@strcurWCRRGroupLineUp_idfValue	VARCHAR(60)
,@strcurWCRRGroupLineUp_idfValueType	VARCHAR(1)
,@strcurWCRRGroupLineUp_idfValueList	VARCHAR(512)
,@n__curWCRRGroupLineUp_idfFlagRQ	INT
,@n__curWCRRGroupLineUp_idfFlagTS	INT
,@n__curWCRRGroupLineUp_idfFlagES	INT
,@n__curWCRRGroupLineUp_idfFlagPO	INT
,@n__curWCRRGroupLineUp_idfFlagRCV	INT
,@strcurWCRRGroupLineUp_idfTableName	VARCHAR(255)
,@strcurWCRRGroupLineUp_idfIDColumn	VARCHAR(255)
,@strcurWCRRGroupLineUp_idfKeyColumn	VARCHAR(255)
,@n__Last_idfWCSecurityKey		INT
,@n__Last_idfWCRRGroupLineUpKey		INT
,@n__Last_idfWCLineUpKey		INT
,@n__Last_idfPrecedence			INT
,@n__Last_idfFieldCount			INT
,@strLast_idfShowAtTab			VARCHAR(20)
,@strLast_idfDescription		VARCHAR(60)
,@strLast_idfValue			VARCHAR(60)	
,@strLast_idfValueType			VARCHAR(1)
,@n__Last_idfFlagRQ			INT
,@n__Last_idfFlagTS			INT
,@n__Last_idfFlagES			INT
,@n__Last_idfFlagPO			INT
,@n__Last_idfFlagRCV				INT
,@strRoutingRuleEnglish	   VARCHAR(8000)
,@strRoutingRuleEnglishRQ  VARCHAR(8000)
,@strRoutingRuleEnglishTS  VARCHAR(8000)  
,@strRoutingRuleEnglishES  VARCHAR(8000)	
,@strRoutingRuleEnglishRCV VARCHAR(8000)
,@strRoutingRuleEnglishPO  VARCHAR(8000)
,@nSplitCtr				   INT
,@nSplitWord			   VARCHAR(512)
,@strWCListHdr_idfListID   VARCHAR(20)
,@strSQL	   NVARCHAR(4000)
,@strWCListType_Value			VARCHAR(255)
,@nRuleSet				INT
,@strDateLabel VARCHAR(20)
,@strTimeLabel VARCHAR(20)
,@strPageLabel VARCHAR(10)
,@strOFLabel VARCHAR(10)
,@strUserLabel VARCHAR(15)
,@strDeptLabel VARCHAR(20)
,@strRoutRuleLabel VARCHAR(25)
,@strPrecedenceLabel VARCHAR(15)
,@strGrpIndLabel VARCHAR(20)
,@strRoutingLabel VARCHAR(15)
,@strAprListLabel VARCHAR(20)
,@nidfWCLanguageKey INT
,@strIsInList VARCHAR(20)
,@strIsNOTInList VARCHAR(20)
,@strIS VARCHAR(10)
,@strIndvidual VARCHAR(15)
,@strGroup	   VARCHAR(10)
,@strAND	   VARCHAR(10)
,@strNewLine   VARCHAR(20)
,@nCounterRQ   INT
,@nCounterES   INT
,@nCounterTS   INT
,@nCounterRCV  INT
,@nCounterPO   INT
,@strInternalAprDescription		VARCHAR(60)
,@strInternalAprGroup			VARCHAR(60)	
,@n__curWCRRGroupLineUp_idfFlagAPV VARCHAR(60)
,@n__curWCRRGroupLineUp_idfFlagPAPRJ VARCHAR(60)
,@nCounterAPV		INT
,@nCounterPAPRJ		INT
,@strRoutingRuleEnglishAPV  VARCHAR(8000)
,@strRoutingRuleEnglishPAPRJ  VARCHAR(8000)
,@n__Last_idfFlagAPV INT
,@n__Last_idfFlagPAPRJ INT


SELECT @nidfWCLanguageKey = idfWCLanguageKey FROM WCSecurity WITH (NOLOCK)

SELECT   @strNewLine  = char(10)
		,@nCounterRQ  = 0
		,@nCounterES  = 0
		,@nCounterTS  = 0
		,@nCounterRCV = 0
		,@nCounterPO  = 0
		,@nCounterAPV  = 0
		,@nCounterPAPRJ  = 0


SELECT	 @strIsInList = '::12527::'
		,@strIsNOTInList = '::12528::'
		,@strIS = '::12529::'
		,@strIndvidual = '::11519::'
		,@strGroup = '::12161:::'
		,@strAND = '::12530::'
		,@strInternalAprDescription = '::13018:: / ::15431::'
		,@strInternalAprGroup = '::15432::'
		,@nidfWCLanguageKey = 1

EXEC spWCLanguageDecode @strIsInList OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strIsNOTInList OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strIS OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strIndvidual OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strGroup OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strAND OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strInternalAprDescription OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strInternalAprGroup OUTPUT,@nidfWCLanguageKey

CREATE TABLE #WCSecDept (idfWCSecurityKey INT, idfWCDeptKey INT)
CREATE TABLE #WCSecurity (idfWCSecurityKey INT)
CREATE TABLE #tmpWCRRGroupLineUp 
(
	 idfGroup		INT
	,idfWCRRGroupLineUpKey	INT
	,idfWCLineUpKey		INT
	,idfWCSecurityKey	INT
	,idfWCRoleKey		INT
	,idfFieldCount		INT
	,idfPrecedence		INT
	,idfFlagRQ		INT
	,idfFlagTS		INT
	,idfFlagES		INT
	,idfFlagPO		INT
	,idfFlagRCV		INT
	,idfFlagAPV		INT
	,idfFlagPAPRJ	INT
)
CREATE TABLE #spWCRPTRoutingRuleByUser
(
	 idfPrimaryKey		INT IDENTITY(0,1)
	,idfSecurityID		VARCHAR(255)
	,idfDescription		VARCHAR(60)
	,idfLineUpID		VARCHAR(20)
	,idfLineUpDesc		VARCHAR(60)
	,idfGroupRRDesc		VARCHAR(70)
	,idfRoutingRule		TEXT
	,idfPrecedence		INT
)

-- Get a list of all departments the user can select.
INSERT INTO #WCSecDept
SELECT idfWCSecurityKey,idfCodeKey
FROM WCSecurity S (NOLOCK)
	INNER JOIN WCUDFTemplateDtl U (NOLOCK)	ON S.idfWCUDFTemplateKey = U.idfWCUDFTemplateHdrKey AND U.idfWCUDFTemplateFieldKey = 1
	INNER JOIN WCListDtl L (NOLOCK) 	ON U.idfRestrictByValue = L.idfWCListHdrKey AND U.idfRestrictByValueType = 'L'
WHERE (@nidfWCDeptKey IS NULL OR @nidfWCDeptKey = idfCodeKey) AND
	(@nidfWCSecurityKey IS NULL OR @nidfWCSecurityKey = S.idfWCSecurityKey)

INSERT INTO #WCSecDept
SELECT idfWCSecurityKey,idfRestrictByValue
FROM WCSecurity S (NOLOCK)
	INNER JOIN WCUDFTemplateDtl U (NOLOCK)	ON S.idfWCUDFTemplateKey = U.idfWCUDFTemplateHdrKey 
WHERE U.idfWCUDFTemplateFieldKey = 1 AND 
	idfRestrictByValueType = 'K' AND
	(@nidfWCDeptKey IS NULL OR @nidfWCDeptKey = idfRestrictByValue) AND
	(@nidfWCSecurityKey IS NULL OR @nidfWCSecurityKey = S.idfWCSecurityKey)

INSERT INTO #WCSecDept 
SELECT idfWCSecurityKey, idfWCDeptKey FROM WCSecurity (NOLOCK) 
WHERE idfWCSecurityKey NOT IN (SELECT idfWCSecurityKey FROM #WCSecDept)	AND 
	(@nidfWCDeptKey IS NULL OR @nidfWCDeptKey = idfWCDeptKey) AND
	(@nidfWCSecurityKey IS NULL OR @nidfWCSecurityKey = idfWCSecurityKey)

-- Get a consolodated list of users.
INSERT INTO #WCSecurity SELECT idfWCSecurityKey FROM #WCSecDept GROUP BY idfWCSecurityKey

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Load in all rules that apply to the list of users.
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- Get Individual Routing Rules by User
INSERT INTO #tmpWCRRGroupLineUp
SELECT 	 0,WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCRRSecurity.idfWCSecurityKey, NULL, WCRRGroupLineUp.idfFieldCount,idfPrecedence
	,WCRRGroupLineUp.idfFlagRQ
	,WCRRGroupLineUp.idfFlagTS
	,WCRRGroupLineUp.idfFlagES
	,WCRRGroupLineUp.idfFlagPO
	,WCRRGroupLineUp.idfFlagRCV
	,WCRRGroupLineUp.idfFlagAPV
	,0
	FROM WCRRGroupLineUp (NOLOCK)
		INNER JOIN WCRRSecurity (NOLOCK) 	ON WCRRSecurity.idfWCRRSecurityKey 	= WCRRGroupLineUp.idfWCRRSecurityKey
		INNER JOIN #WCSecurity 			ON WCRRSecurity.idfWCSecurityKey 	= #WCSecurity.idfWCSecurityKey
ORDER BY WCRRGroupLineUp.idfPrecedence ASC,WCRRGroupLineUp.idfFieldCount DESC

-- Get Routing Rules by User.
INSERT INTO #tmpWCRRGroupLineUp
SELECT 1,WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey, WCRRGroupSec.idfWCSecurityKey, NULL, WCRRGroupLineUp.idfFieldCount,idfPrecedence
	,WCRRGroupLineUp.idfFlagRQ
	,WCRRGroupLineUp.idfFlagTS
	,WCRRGroupLineUp.idfFlagES
	,WCRRGroupLineUp.idfFlagPO
	,WCRRGroupLineUp.idfFlagRCV
	,WCRRGroupLineUp.idfFlagAPV
	,0
FROM WCRRGroupLineUp (NOLOCK)
	INNER JOIN WCRRGroupSec (NOLOCK)	ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey
	INNER JOIN #WCSecurity 			ON WCRRGroupSec.idfWCSecurityKey= #WCSecurity.idfWCSecurityKey
ORDER BY WCRRGroupLineUp.idfPrecedence ASC,WCRRGroupLineUp.idfFieldCount DESC

-- Get Routing Rules by Role.
INSERT INTO #tmpWCRRGroupLineUp
SELECT 1,WCRRGroupLineUp.idfWCRRGroupLineUpKey, WCRRGroupLineUp.idfWCLineUpKey
	,WCSecRole.idfWCSecurityKey
	,WCSecRole.idfWCRoleKey
	,WCRRGroupLineUp.idfFieldCount,idfPrecedence
	,WCRRGroupLineUp.idfFlagRQ
	,WCRRGroupLineUp.idfFlagTS
	,WCRRGroupLineUp.idfFlagES
	,WCRRGroupLineUp.idfFlagPO
	,WCRRGroupLineUp.idfFlagRCV
	,WCRRGroupLineUp.idfFlagAPV
	,0
FROM WCRRGroupLineUp (NOLOCK)
	INNER JOIN WCRRGroupSec (NOLOCK) 	ON WCRRGroupSec.idfWCRRGroupKey	= WCRRGroupLineUp.idfWCRRGroupKey
	INNER JOIN WCSecRole	(NOLOCK) 	ON WCRRGroupSec.idfWCRoleKey 	= WCSecRole.idfWCRoleKey
	INNER JOIN #WCSecurity 			ON WCSecRole.idfWCSecurityKey	= #WCSecurity.idfWCSecurityKey

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- LOOP THROUGH ALL USERS ROUTING RULES
-- ------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE curWCRRGroupLineUp INSENSITIVE CURSOR FOR
SELECT DISTINCT idfWCSecurityKey, idfGroup, idfWCRRGroupLineUpKey, idfWCLineUpKey, idfPrecedence, idfFieldCount, TMP.idfShowAtTab, TMP.idfDescription,T.idfValue,T.idfValueType,TMP.idfValueList
	,G.idfFlagRQ
	,G.idfFlagTS
	,G.idfFlagES
	,G.idfFlagPO
	,G.idfFlagRCV
	,G.idfFlagAPV
	,G.idfFlagPAPRJ
	,L.idfTableName
	,L.idfIDColumn
	,L.idfKeyColumn
FROM #tmpWCRRGroupLineUp G
	LEFT OUTER JOIN WCRRTemplateDtl T (NOLOCK) 	ON idfTableLinkName = 'WCRRGroupLineUp' AND G.idfWCRRGroupLineUpKey = T.idfTableLinkKey
	LEFT OUTER JOIN WCRRTemplate	TMP (NOLOCK) 	ON T.idfWCRRTemplateKey = TMP.idfWCRRTemplateKey
	LEFT OUTER JOIN WCListType L (NOLOCK)		ON TMP.idfWCListTypeKey = L.idfWCListTypeKey
ORDER BY idfWCSecurityKey, idfGroup, idfWCRRGroupLineUpKey ASC, idfPrecedence ASC,idfFieldCount DESC, TMP.idfShowAtTab,TMP.idfDescription

OPEN curWCRRGroupLineUp

FETCH NEXT FROM curWCRRGroupLineUp INTO 
	 @n__curWCRRGroupLineUp_idfWCSecurityKey
	,@n__curWCRRGroupLineUp_idfGroup
	,@n__curWCRRGroupLineUp_idfWCRRGroupLineUpKey
	,@n__curWCRRGroupLineUp_idfWCLineUpKey
	,@n__curWCRRGroupLineUp_idfPrecedence
	,@n__curWCRRGroupLineUp_idfFieldCount
	,@strcurWCRRGroupLineUp_idfShowAtTab
	,@strcurWCRRGroupLineUp_idfDescription
	,@strcurWCRRGroupLineUp_idfValue
	,@strcurWCRRGroupLineUp_idfValueType
	,@strcurWCRRGroupLineUp_idfValueList
	,@n__curWCRRGroupLineUp_idfFlagRQ
	,@n__curWCRRGroupLineUp_idfFlagTS
	,@n__curWCRRGroupLineUp_idfFlagES
	,@n__curWCRRGroupLineUp_idfFlagPO
	,@n__curWCRRGroupLineUp_idfFlagRCV
	,@n__curWCRRGroupLineUp_idfFlagAPV
	,@n__curWCRRGroupLineUp_idfFlagPAPRJ
	,@strcurWCRRGroupLineUp_idfTableName
	,@strcurWCRRGroupLineUp_idfIDColumn
	,@strcurWCRRGroupLineUp_idfKeyColumn

SELECT @strRoutingRuleEnglish = ''

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN				 
		SELECT 	@n__Last_idfWCRRGroupLineUpKey	= @n__curWCRRGroupLineUp_idfWCRRGroupLineUpKey
			,@n__Last_idfWCLineUpKey	= @n__curWCRRGroupLineUp_idfWCLineUpKey
			,@n__Last_idfWCSecurityKey	= @n__curWCRRGroupLineUp_idfWCSecurityKey 
			,@n__Last_idfPrecedence = @n__curWCRRGroupLineUp_idfPrecedence
			,@n__Last_idfFlagRQ		= @n__curWCRRGroupLineUp_idfFlagRQ
			,@n__Last_idfFlagTS		= @n__curWCRRGroupLineUp_idfFlagTS
			,@n__Last_idfFlagES		= @n__curWCRRGroupLineUp_idfFlagES
			,@n__Last_idfFlagPO			= @n__curWCRRGroupLineUp_idfFlagPO
			,@n__Last_idfFlagRCV		= @n__curWCRRGroupLineUp_idfFlagRCV
			,@n__Last_idfFlagAPV		= @n__curWCRRGroupLineUp_idfFlagAPV
			,@n__Last_idfFlagPAPRJ		= @n__curWCRRGroupLineUp_idfFlagPAPRJ

		-- Decode filter and add to filter description.
		SELECT @nRuleSet = 0
		
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::RQNAME::' 
			SELECT @nCounterRQ  = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::11353::' 
			SELECT @nCounterTS  = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::11354::' 
			SELECT @nCounterES  = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::RCVNAME::' 
			SELECT @nCounterRCV = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::12459::' 
			SELECT @nCounterPO  = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::15218::' 
			SELECT @nCounterAPV  = 1
		IF @strcurWCRRGroupLineUp_idfShowAtTab = '::PAProject::' 
			SELECT @nCounterPAPRJ  = 1
	

		IF (@strcurWCRRGroupLineUp_idfShowAtTab = '::11470::' OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::RQNAME::' 	AND @n__curWCRRGroupLineUp_idfFlagRQ = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::11353::' 		AND @n__curWCRRGroupLineUp_idfFlagTS = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::11354::' 	AND @n__curWCRRGroupLineUp_idfFlagES = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::RCVNAME::' 	AND @n__curWCRRGroupLineUp_idfFlagRCV = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::12459::' 	AND @n__curWCRRGroupLineUp_idfFlagPO = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::15218::' 	AND @n__curWCRRGroupLineUp_idfFlagAPV = '1') OR
			(@strcurWCRRGroupLineUp_idfShowAtTab = '::PAProject::' 	AND @n__curWCRRGroupLineUp_idfFlagPAPRJ = '1'))
			
		BEGIN
			SELECT @nRuleSet = 1
			-- If the module is not General then add to caption.
			IF (@strcurWCRRGroupLineUp_idfShowAtTab <> '::11470::')
			BEGIN
				EXEC spWCLanguageDecode @strcurWCRRGroupLineUp_idfShowAtTab OUTPUT,@nidfWCLanguageKey
				SELECT	 @strRoutingRuleEnglish = @strRoutingRuleEnglish + @strcurWCRRGroupLineUp_idfShowAtTab + ' '
			END
			
			IF (@strcurWCRRGroupLineUp_idfValueType <> 'B') BEGIN

				IF (@strcurWCRRGroupLineUp_idfDescription = '::RQPriority::')
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + idfLblPriority FROM WCSystem (NOLOCK)
				ELSE BEGIN
					EXEC spWCLanguageDecode @strcurWCRRGroupLineUp_idfDescription OUTPUT,@nidfWCLanguageKey
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + @strcurWCRRGroupLineUp_idfDescription
				END

				IF (RIGHT(@strcurWCRRGroupLineUp_idfDescription,4) <> 'Than')
					IF (@strcurWCRRGroupLineUp_idfValueType = 'L')
						SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + ' '+@strIsInList+' '
					ELSE IF (@strcurWCRRGroupLineUp_idfValueType = 'N')
						SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + ' '+@strIsNOTInList+' '
					ELSE
						SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + ' '+@strIS+' '
				ELSE
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + ' '

				-- ---------------------------------------------------------------------------------------------------------
				-- If idfValueType is 'L' (list) or 'N' (not in list) then find list name.
				-- ---------------------------------------------------------------------------------------------------------
				IF (@strcurWCRRGroupLineUp_idfValueType = 'N' OR @strcurWCRRGroupLineUp_idfValueType = 'L') BEGIN

					SELECT @strWCListHdr_idfListID	= ''
	
					SELECT @strSQL = N'SELECT @xoidfListID=LTRIM(RTRIM(idfListID)) FROM WCListHdr (NOLOCK) WHERE idfWCListHdrKey = '+@strcurWCRRGroupLineUp_idfValue

					EXEC sp_executesql @strSQL
						,N'@xoidfListID VARCHAR(20) OUTPUT'
						,@strWCListHdr_idfListID OUTPUT

					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + '''' + @strWCListHdr_idfListID + ''''
				END
				ELSE IF (@strcurWCRRGroupLineUp_idfValueType = 'K' AND @strcurWCRRGroupLineUp_idfTableName IS NOT NULL) BEGIN

					SELECT @strWCListType_Value = ''

					SELECT @strSQL = N'SELECT @xoValue=RTRIM(LTRIM(CONVERT(VARCHAR(255),'+@strcurWCRRGroupLineUp_idfTableName+'.'+@strcurWCRRGroupLineUp_idfIDColumn+'))) '+
						' FROM '+@strcurWCRRGroupLineUp_idfTableName + ' WHERE ' +@strcurWCRRGroupLineUp_idfTableName+'.'+@strcurWCRRGroupLineUp_idfKeyColumn+
						' = @xoInput'

					EXEC sp_executesql @strSQL
						,N'@xoValue VARCHAR(255) OUTPUT,@xoInput VARCHAR(255)'
						,@strWCListType_Value OUTPUT
						,@strcurWCRRGroupLineUp_idfValue

					if @strcurWCRRGroupLineUp_idfTableName = 'RQType'
						EXEC spWCLanguageDecode @strWCListType_Value OUTPUT,@nidfWCLanguageKey

					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + '''' + @strWCListType_Value + ''''
				END
				ELSE BEGIN
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + '''' + @strcurWCRRGroupLineUp_idfValue + ''''
				END
			END 
			ELSE BEGIN
				SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + @strIS + ' '

				IF (@strcurWCRRGroupLineUp_idfDescription='::RQPriority::') BEGIN
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + idfLblPriority FROM WCSystem (NOLOCK)
				END
				ELSE BEGIN
					EXEC spWCLanguageDecode @strcurWCRRGroupLineUp_idfDescription OUTPUT,@nidfWCLanguageKey
					SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + @strcurWCRRGroupLineUp_idfDescription
				END

			END
		END
	END
	FETCH NEXT FROM curWCRRGroupLineUp INTO 
		 @n__curWCRRGroupLineUp_idfWCSecurityKey
		,@n__curWCRRGroupLineUp_idfGroup
		,@n__curWCRRGroupLineUp_idfWCRRGroupLineUpKey
		,@n__curWCRRGroupLineUp_idfWCLineUpKey
		,@n__curWCRRGroupLineUp_idfPrecedence
		,@n__curWCRRGroupLineUp_idfFieldCount
		,@strcurWCRRGroupLineUp_idfShowAtTab
		,@strcurWCRRGroupLineUp_idfDescription
		,@strcurWCRRGroupLineUp_idfValue
		,@strcurWCRRGroupLineUp_idfValueType
		,@strcurWCRRGroupLineUp_idfValueList
		,@n__curWCRRGroupLineUp_idfFlagRQ
		,@n__curWCRRGroupLineUp_idfFlagTS
		,@n__curWCRRGroupLineUp_idfFlagES
		,@n__curWCRRGroupLineUp_idfFlagPO
		,@n__curWCRRGroupLineUp_idfFlagRCV
		,@n__curWCRRGroupLineUp_idfFlagAPV
		,@n__curWCRRGroupLineUp_idfFlagPAPRJ
		,@strcurWCRRGroupLineUp_idfTableName
		,@strcurWCRRGroupLineUp_idfIDColumn
		,@strcurWCRRGroupLineUp_idfKeyColumn

	-- If any of the following changes then record filter:
	-- 1) User/idfWCSecurityKey changes 
	-- 2) Filter/idfWCRRGroupLineUpKey changes.
	-- 3) @@fetch_status is = -1 
	IF (@@fetch_status = -1 OR (@n__curWCRRGroupLineUp_idfWCSecurityKey <> @n__Last_idfWCSecurityKey OR @n__curWCRRGroupLineUp_idfWCRRGroupLineUpKey <> @n__Last_idfWCRRGroupLineUpKey)) BEGIN
		IF (@n__Last_idfFlagRQ = '1' AND @nCounterRQ = 0) BEGIN
			SELECT @strRoutingRuleEnglishRQ = '::13366::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishRQ OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishRQ ELSE @strRoutingRuleEnglishRQ END
		END
		IF (@n__Last_idfFlagTS = '1' AND @nCounterTS = 0) BEGIN
			SELECT @strRoutingRuleEnglishTS = '::13367::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishTS OUTPUT,@nidfWCLanguageKey
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishTS ELSE @strRoutingRuleEnglishTS END
		END
		IF (@n__curWCRRGroupLineUp_idfFlagES = '1' AND @nCounterES = 0) BEGIN
			SELECT @strRoutingRuleEnglishES = '::13368::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishES OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishES ELSE @strRoutingRuleEnglishES END
		END
		IF (@n__Last_idfFlagRCV = '1' AND @nCounterRCV = 0) BEGIN
			SELECT @strRoutingRuleEnglishRCV = '::14173::'	
			EXEC spWCLanguageDecode @strRoutingRuleEnglishRCV OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishRCV ELSE @strRoutingRuleEnglishRCV END
		END
		IF (@n__Last_idfFlagPO = '1' AND @nCounterPO = 0) BEGIN
			SELECT @strRoutingRuleEnglishPO = '::14174::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishPO OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishPO ELSE @strRoutingRuleEnglishPO END
		END
		IF (@n__Last_idfFlagAPV = '1' AND @nCounterAPV = 0) BEGIN
			SELECT @strRoutingRuleEnglishAPV = '::15219::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishAPV OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishAPV ELSE @strRoutingRuleEnglishAPV END
		END
		IF (@n__Last_idfFlagPAPRJ = '1' AND @nCounterPAPRJ = 0) BEGIN
			SELECT @strRoutingRuleEnglishPAPRJ = '::16811::'
			EXEC spWCLanguageDecode @strRoutingRuleEnglishPAPRJ OUTPUT,@nidfWCLanguageKey 
			SELECT @strRoutingRuleEnglish = CASE WHEN LEN(@strRoutingRuleEnglish) > 0 THEN @strRoutingRuleEnglish + ' ' + @strAND + @strNewLine + @strRoutingRuleEnglishPAPRJ ELSE @strRoutingRuleEnglishPAPRJ END
		END
		
		SELECT @nCounterRQ  = 0
		SELECT @nCounterTS  = 0 
		SELECT @nCounterES  = 0
		SELECT @nCounterRCV = 0
		SELECT @nCounterPO  = 0
		SELECT @nCounterAPV  = 0
		SELECT @nCounterPAPRJ  = 0

		INSERT INTO #spWCRPTRoutingRuleByUser
		(
			 idfSecurityID		
			,idfDescription		
			,idfLineUpID		
			,idfLineUpDesc		
			,idfGroupRRDesc		
			,idfRoutingRule		
			,idfPrecedence
		)
		SELECT 
			 S.idfSecurityID
			,S.idfDescription
			,L.idfLineUpID
			,CASE WHEN L.idfFlagInternal = 1 THEN @strInternalAprDescription ELSE L.idfDescription END
			,CASE WHEN G.idfDescription IS NULL THEN @strIndvidual ELSE CASE WHEN G.idfFlagInternal = 1 THEN G.idfDescription ELSE G.idfDescription END END
			,@strRoutingRuleEnglish
			,@n__Last_idfPrecedence			
		FROM WCSecurity S (NOLOCK)
			LEFT OUTER JOIN WCLineUp L (NOLOCK) ON L.idfWCLineUpKey = @n__Last_idfWCLineUpKey
			LEFT OUTER JOIN WCRRGroupLineUp GL (NOLOCK) ON GL.idfWCRRGroupLineUpKey = @n__Last_idfWCRRGroupLineUpKey
			LEFT OUTER JOIN WCRRGroup G (NOLOCK) ON GL.idfWCRRGroupKey = G.idfWCRRGroupKey
		WHERE S.idfWCSecurityKey = @n__Last_idfWCSecurityKey

		SELECT @strRoutingRuleEnglish = ''
	END 
	ELSE IF (@nRuleSet = 1)
		SELECT @strRoutingRuleEnglish = @strRoutingRuleEnglish + ' '+@strAND+CHAR(13)+CHAR(10)
END

SELECT DISTINCT
 CONVERT(VARCHAR(256),LoginID)						AS 'LoginID'
,CONVERT(VARCHAR(60),UserName)						AS 'UserName'
,CONVERT(VARCHAR(20),RoleID)						AS 'RoleID'
,CONVERT(VARCHAR(1),Approves_PO)					AS 'Approves_PO'
,CONVERT(VARCHAR(1),[Approves_Receive/Invoice])		AS 'Approves_Receive/Invoice'  
,CONVERT(VARCHAR(1),Approves_Requisition)			AS 'Approves_Requisition'
,CONVERT(VARCHAR(2000),Rules)						AS 'Rules'
FROM 
(
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,ISNULL(WCRole.idfRoleID,'')				 AS 'RoleID'
	,ISNULL(WCRRGroupLineUp.idfFlagPO,0)		 AS 'Approves_PO'
	,ISNULL(WCRRGroupLineUp.idfFlagRCV,0)		 AS 'Approves_Receive/Invoice'
	,ISNULL(WCRRGroupLineUp.idfFlagRQ,0)		 AS 'Approves_Requisition'
	,ISNULL(TMP.idfRoutingRule,'ALL')			 AS 'Rules'
FROM #spWCRPTRoutingRuleByUser TMP
INNER JOIN dbo.WCLineUp			WITH (NOLOCK) ON WCLineUp.idfLineUpID = TMP.idfLineUpID 
INNER JOIN dbo.WCLineUpSec		WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
INNER JOIN dbo.WCRRGroup		WITH (NOLOCK) ON WCRRGroup.idfDescription = TMP.idfGroupRRDesc
INNER JOIN dbo.WCRRGroupLineUp	WITH (NOLOCK) ON WCRRGroupLineUp.idfWCRRGroupKey = WCRRGroup.idfWCRRGroupKey
INNER JOIN dbo.WCSecurity		WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey 
LEFT OUTER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCSecRole.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
LEFT OUTER JOIN dbo.WCRole		WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCSecRole.idfWCRoleKey 
UNION ALL
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,ISNULL(WCRole.idfRoleID,'')				 AS 'RoleID'
	,ISNULL(WCRRGroupLineUp.idfFlagPO,0)		 AS 'Approves_PO'
	,ISNULL(WCRRGroupLineUp.idfFlagRCV,0)		 AS 'Approves_Receive/Invoice'
	,ISNULL(WCRRGroupLineUp.idfFlagRQ,0)		 AS 'Approves_Requisition'
	,ISNULL(TMP.idfRoutingRule,'ALL')			 AS 'Rules'
FROM #spWCRPTRoutingRuleByUser TMP
INNER JOIN dbo.WCLineUp			WITH (NOLOCK) ON WCLineUp.idfLineUpID = TMP.idfLineUpID 
INNER JOIN dbo.WCLineUpSec		WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
INNER JOIN dbo.WCRRGroup		WITH (NOLOCK) ON WCRRGroup.idfDescription = TMP.idfGroupRRDesc
INNER JOIN dbo.WCRRGroupLineUp	WITH (NOLOCK) ON WCRRGroupLineUp.idfWCRRGroupKey = WCRRGroup.idfWCRRGroupKey
INNER JOIN dbo.WCRole			WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
INNER JOIN dbo.WCSecRole		WITH (NOLOCK) ON WCSecRole.idfWCRoleKey = WCRole.idfWCRoleKey
INNER JOIN dbo.WCSecurity		WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCSecRole.idfWCSecurityKey 
UNION ALL
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,''											 AS 'RoleID'
	,ISNULL(WCRRGroupLineUp.idfFlagPO,0)		 AS 'Approves_PO'
	,ISNULL(WCRRGroupLineUp.idfFlagRCV,0)		 AS 'Approves_Receive/Invoice'
	,ISNULL(WCRRGroupLineUp.idfFlagRQ,0)		 AS 'Approves_Requisition'
	,ISNULL(TMP.idfRoutingRule,'ALL')			 AS 'Rules'
FROM #spWCRPTRoutingRuleByUser TMP
INNER JOIN dbo.WCLineUp			WITH (NOLOCK) ON WCLineUp.idfLineUpID = TMP.idfLineUpID 
INNER JOIN dbo.WCLineUpSec		WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
INNER JOIN dbo.WCSecurity		WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey 
INNER JOIN dbo.WCRRSecurity		WITH (NOLOCK) ON WCRRSecurity.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
INNER JOIN dbo.WCRRGroupLineUp	WITH (NOLOCK) ON WCRRGroupLineUp.idfWCRRSecurityKey = WCRRSecurity.idfWCRRSecurityKey
LEFT OUTER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCSecRole.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
LEFT OUTER JOIN dbo.WCRole		WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCSecRole.idfWCRoleKey 
WHERE TMP.idfGroupRRDesc = 'Individual'
UNION ALL
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,ISNULL(WCRole.idfRoleID,'')				 AS 'RoleID'
	,ISNULL(WCRRGroupLineUp.idfFlagPO,0)		 AS 'Approves_PO'
	,ISNULL(WCRRGroupLineUp.idfFlagRCV,0)		 AS 'Approves_Receive/Invoice'
	,ISNULL(WCRRGroupLineUp.idfFlagRQ,0)		 AS 'Approves_Requisition'
	,ISNULL(TMP.idfRoutingRule,'ALL')			 AS 'Rules'
FROM #spWCRPTRoutingRuleByUser TMP
INNER JOIN dbo.WCLineUp			WITH (NOLOCK) ON WCLineUp.idfLineUpID = TMP.idfLineUpID 
INNER JOIN dbo.WCLineUpSec		WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
INNER JOIN dbo.WCRole			WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
INNER JOIN dbo.WCSecRole		WITH (NOLOCK) ON WCSecRole.idfWCRoleKey = WCRole.idfWCRoleKey
INNER JOIN dbo.WCSecurity		WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCSecRole.idfWCSecurityKey 
INNER JOIN dbo.WCRRSecurity		WITH (NOLOCK) ON WCRRSecurity.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
INNER JOIN dbo.WCRRGroupLineUp	WITH (NOLOCK) ON WCRRGroupLineUp.idfWCRRSecurityKey = WCRRSecurity.idfWCRRSecurityKey
WHERE TMP.idfGroupRRDesc = 'Individual'
UNION ALL
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,ISNULL(WCRole.idfRoleID,'')				 AS 'RoleID'
	,0											 AS 'Approves_PO'
	,0											 AS 'Approves_Receive/Invoice'
	,0											 AS 'Approves_Requisition'
	,'NONE'										 AS 'Rules'
FROM dbo.WCSecurity				WITH (NOLOCK) 
INNER JOIN dbo.WCSecRole		WITH (NOLOCK) ON WCSecRole.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
INNER JOIN dbo.WCRole			WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCSecRole.idfWCRoleKey
LEFT OUTER JOIN dbo.WCLineUpSec WITH (NOLOCK) ON WCLineUpSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey OR WCLineUpSec.idfWCRoleKey = WCSecRole.idfWCRoleKey
LEFT OUTER JOIN dbo.WCLineUp	WITH (NOLOCK) ON WCLineUp.idfWCLineUpKey = WCLineUpSec.idfWCLineUpKey  
LEFT OUTER JOIN #spWCRPTRoutingRuleByUser TMP ON TMP.idfLineUpID = WCLineUp.idfLineUpID 
WHERE TMP.idfLineUpID IS NULL
UNION ALL
SELECT 
	 WCSecurity.idfSecurityID					 AS 'LoginID'
	,WCSecurity.idfDescription					 AS 'UserName'
	,''											 AS 'RoleID'
	,0											 AS 'Approves_PO'
	,0											 AS 'Approves_Receive/Invoice'
	,0											 AS 'Approves_Requisition'
	,'NONE'										 AS 'Rules'
FROM dbo.WCSecurity WITH (NOLOCK) 
LEFT OUTER JOIN dbo.WCSecRole	WITH (NOLOCK) ON WCSecRole.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
LEFT OUTER JOIN dbo.WCLineUpSec WITH (NOLOCK) ON WCLineUpSec.idfWCSecurityKey = WCSecurity.idfWCSecurityKey
LEFT OUTER JOIN dbo.WCLineUp	WITH (NOLOCK) ON WCLineUp.idfWCLineUpKey = WCLineUpSec.idfWCLineUpKey  
LEFT OUTER JOIN #spWCRPTRoutingRuleByUser TMP ON TMP.idfLineUpID = WCLineUp.idfLineUpID 
WHERE TMP.idfLineUpID IS NULL
) TMP

CLOSE curWCRRGroupLineUp
DEALLOCATE curWCRRGroupLineUp

DROP TABLE #WCSecDept
DROP TABLE #WCSecurity
DROP TABLE #tmpWCRRGroupLineUp
DROP TABLE #spWCRPTRoutingRuleByUser
