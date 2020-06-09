-- Paramount Technologies, Inc. $Version: WorkPlace_08.01.00 $  - $Revision: 43 $ $Modtime: 11/02/05 10:58a $
ALTER PROCEDURE spFNAConvertCur
@xochErrSP		CHAR(32)      	= ''	OUTPUT,
@xonErrNum		INT          	= 0	OUTPUT,
@xostrErrInfo		VARCHAR(255) 	= ''	OUTPUT,
@xstrConvertCurrency	VARCHAR(255)	= '',		
@xnFromorToFunctional	INT		= 0,	-- 1) Going to Functional from @xstrConvertCurrency 2) Going from Functional to @xstrConvertCurrency 3) To Operational from xstrConvertCurrency
@xnFromAmount		NUMERIC(19,5)	= 0,
@xonToAmount		NUMERIC(19,5)	= 0	OUTPUT,
@xonXchRate		NUMERIC(19,7)	= NULL	OUTPUT,
@xostrRateTypeID	VARCHAR(255)	= ''	OUTPUT,
@xostrRateTable		VARCHAR(255)	= ''	OUTPUT,
@xonExpr		INT		= NULL	OUTPUT,
@xostrDate		VARCHAR(15)	= ''	OUTPUT,
@xostrTime		VARCHAR(15)	= ''	OUTPUT,
@xodtDateTime		DATETIME		= NULL,	
@xodtXchRateDate	DATETIME		= NULL,
@xnForceDefaultRateType INT			= 1,
@xnForceGivenRate		INT			= 0
AS
DECLARE
 @strFunctionalCur	VARCHAR(255)
 
,@nDefaultFind		INT
,@nLimitSearch		INT
,@nDayLimit			INT


SELECT	@xonToAmount	= NULL
		,@xonExpr		= NULL
		,@xostrDate		= NULL
		,@xostrTime		= NULL

IF (@xnForceGivenRate = 0)
	SELECT	@xonXchRate	= NULL

IF @xodtXchRateDate IS NULL
	SET @xodtXchRateDate = getdate()

	
-- Get Functional Currency
SELECT 	 @xostrRateTypeID = CASE WHEN @xnForceDefaultRateType = 1 OR ISNULL(@xostrRateTypeID,'') = '' THEN DEFPURTP ELSE @xostrRateTypeID END
	,@strFunctionalCur	= MC40000.FUNLCURR 
FROM MC40000 (NOLOCK)
	INNER JOIN DYNAMICS..MC40200 MC40200 (NOLOCK) ON MC40000.FUNLCURR = MC40200.CURNCYID

	

-- Default values if empty to the functional currency.
IF (@xstrConvertCurrency = '' OR @xstrConvertCurrency IS NULL)
	SELECT @xstrConvertCurrency = @strFunctionalCur

IF @xstrConvertCurrency <> @strFunctionalCur
BEGIN
	IF (@xnForceGivenRate = 0)
		SELECT @xonXchRate = NULL
	
	
	SELECT @xostrRateTable = EXGTBLID  
	FROM MC40301 (NOLOCK) 
	WHERE CURNCYID = @xstrConvertCurrency AND RATETPID = @xostrRateTypeID

	-- RTCLCMTD (Rate Calculation Method): 0=Multiply; 1=Didvide
	-- TRXDTDEF (Trasaction Rate Default): 0=Exact Date; 1=Previous Date; 2=Next Date
	-- DATELMTS (Search for Unexpired Rates): 0=Unlimited; 1=Limited
	SELECT 	 @xonExpr = RTCLCMTD
			,@nDefaultFind = TRXDTDEF
			,@nLimitSearch = DATELMTS
			,@nDayLimit = PRVDSLMT 
	FROM DYNAMICS..MC40300 (NOLOCK)
	WHERE EXGTBLID = @xostrRateTable
	insert into test_exchange (fld1) values  ('I am here 1')
	update test_exchange set fld2=@xostrRateTable where fld1='I am here 1 '
	IF (@xnForceGivenRate = 0)
		SELECT 	 @xonXchRate = XCHGRATE
				,@xostrDate = CONVERT(VARCHAR(10),EXCHDATE,112)
				,@xostrTime = CONVERT(VARCHAR(12),TIME1,114) 
		FROM DYNAMICS..MC00100 (NOLOCK)
		WHERE EXGTBLID = @xostrRateTable AND EXCHDATE = CONVERT(VARCHAR(10),@xodtXchRateDate,112)
		ORDER BY TIME1 DESC
	ELSE
		SELECT 	 @xostrDate = CONVERT(VARCHAR(10),@xodtXchRateDate,112)
				,@xostrTime = CONVERT(VARCHAR(12),@xodtXchRateDate,114) 
	insert into test_exchange (fld1) values  ('I am here 2 ' + ISNULL(@xostrDate,'Date : Rate'))
	IF @xonXchRate IS NULL
	BEGIN
	    insert into test_exchange (fld1) values  ('I am here 3')
		IF @nDefaultFind = 1 	
		BEGIN
		    insert into test_exchange (fld1) values  ('I am here 3a')
			SELECT TOP 1 @xonXchRate = XCHGRATE, @xostrDate = CONVERT(VARCHAR(10),EXCHDATE,112), @xostrTime = CONVERT(VARCHAR(12),TIME1,114)  FROM DYNAMICS..MC00100 (NOLOCK)
			WHERE EXGTBLID = @xostrRateTable AND EXCHDATE < CONVERT(VARCHAR(10),@xodtXchRateDate,112)  AND (EXPNDATE='1900-01-01' OR EXPNDATE >= CONVERT(VARCHAR(10),@xodtXchRateDate,112))
				AND ((@nLimitSearch=0) OR (@nLimitSearch = 1 AND EXCHDATE >= CONVERT(VARCHAR(10),DATEADD(day,-@nDayLimit,@xodtXchRateDate),112))) 
			ORDER BY EXCHDATE DESC, TIME1 DESC
			
			IF @xonXchRate IS NULL
			BEGIN
				insert into test_exchange (fld1) values  ('I am here 4')
				SELECT TOP 1 @xonXchRate = XCHGRATE, @xostrDate = CONVERT(VARCHAR(10),EXCHDATE,112), @xostrTime = CONVERT(VARCHAR(12),TIME1,114) FROM DYNAMICS..MC00100 (NOLOCK)
				WHERE EXGTBLID = @xostrRateTable AND EXCHDATE > CONVERT(VARCHAR(10),@xodtXchRateDate,112)  AND (EXPNDATE='1900-01-01' OR EXPNDATE >= CONVERT(VARCHAR(10),@xodtXchRateDate,112))
					AND ((@nLimitSearch=0) OR (@nLimitSearch = 1 AND EXCHDATE <= CONVERT(VARCHAR(10),DATEADD(day,@nDayLimit,@xodtXchRateDate),112)))
				ORDER BY EXCHDATE ASC, TIME1 ASC
			END
		END
		
		IF @nDefaultFind = 2
		BEGIN
		insert into test_exchange (fld1) values  ('I am here 5')
			SELECT TOP 1 @xonXchRate = XCHGRATE, @xostrDate = CONVERT(VARCHAR(10),EXCHDATE,112), @xostrTime = CONVERT(VARCHAR(12),TIME1,114)  FROM DYNAMICS..MC00100 (NOLOCK)
			WHERE EXGTBLID = @xostrRateTable AND EXCHDATE > CONVERT(VARCHAR(10),@xodtXchRateDate,112)  AND (EXPNDATE='1900-01-01' OR EXPNDATE >= CONVERT(VARCHAR(10),@xodtXchRateDate,112))
				AND ((@nLimitSearch=0) OR (@nLimitSearch = 1 AND EXCHDATE <= CONVERT(VARCHAR(10),DATEADD(day,@nDayLimit,@xodtXchRateDate),112)))
			ORDER BY EXCHDATE ASC, TIME1 ASC
			
			IF @xonXchRate IS NULL
			BEGIN
				SELECT TOP 1 @xonXchRate = XCHGRATE, @xostrDate = CONVERT(VARCHAR(10),EXCHDATE,112), @xostrTime = CONVERT(VARCHAR(12),TIME1,114)  FROM DYNAMICS..MC00100 (NOLOCK)
				WHERE EXGTBLID = @xostrRateTable AND EXCHDATE < CONVERT(VARCHAR(10),@xodtXchRateDate,112)  AND (EXPNDATE='1900-01-01' OR EXPNDATE >= CONVERT(VARCHAR(10),@xodtXchRateDate,112))
					AND ((@nLimitSearch=0) OR (@nLimitSearch = 1 AND EXCHDATE >= CONVERT(VARCHAR(10),DATEADD(day,-@nDayLimit,@xodtXchRateDate),112))) 
				ORDER BY EXCHDATE DESC, TIME1 DESC
			END
		END
	END

	IF @xonXchRate IS NULL
		SELECT @xonXchRate = 0
		insert into test_exchange (fld1) values  ('I am here 6')
	-- If going FROM functional then do the inverse.
IF (@xnFromorToFunctional = 2)
	BEGIN
	insert into test_exchange (fld1) values  ('I am here 7')
		IF (@xonExpr = 0 AND @xonXchRate != 0)
			SELECT @xonToAmount = @xnFromAmount / @xonXchRate
	
		IF @xonExpr = 1
			SELECT @xonToAmount = @xnFromAmount * @xonXchRate
	END
	ELSE 
	BEGIN
	insert into test_exchange (fld1) values  ('I am here 8')
		IF @xonExpr = 0
			SELECT @xonToAmount = @xonXchRate * @xnFromAmount
	
		IF (@xonExpr = 1 AND @xonXchRate != 0)
			SELECT @xonToAmount = @xnFromAmount / @xonXchRate
	END



	--Return is no amount is passed in.
	IF (ISNULL(@xnFromAmount,0) = 0)
	BEGIN
		insert into test_exchange (fld1) values  ('I am here 9')
		SELECT @xonToAmount = 0, @xonXchRate = 1
		RETURN
	END	

	IF ISNULL(@xonToAmount,0) = 0
	BEGIN
		SELECT @xonErrNum = '101', @xonToAmount = @xnFromAmount, @xostrDate = '',@xostrTime	= '', @xostrErrInfo = 'No conversion rate found'
	END
END
ELSE
BEGIN
	SELECT @xonToAmount 	= @xnFromAmount
	

		,@xonXchRate 		= 1
		,@xostrRateTypeID	= ''

		,@xonExpr		= 0
		,@xostrRateTable	= ''
		,@xostrDate		= ''
		,@xostrTime		= ''
END
RETURN

