/*Select * From APVoucher

SELECT * FROM APVoucherJournal

SELECT * FROM GLJournalDtl

SELECT * FROM APVoucher
LEFT OUTER JOIN APVoucherJournal ON APVoucherJournal.idfAPVoucherKey = APVoucher.idfAPVoucherKey
WHERE APVoucherJournal.idfAPVoucherJournalKey IS NULL
*/


--BEGIN TRAN
DECLARE @HeaderKey INT
DECLARE @Keys TABLE (Keys INT,idfAPVoucherKey INT)
INSERT INTO @Keys (Keys,idfAPVoucherKey)
SELECT REPLACE(idfDocument01,'EXPHDR:',''),APVoucher.idfAPVoucherKey  FROM APVoucher
LEFT OUTER JOIN APVoucherJournal ON APVoucherJournal.idfAPVoucherKey = APVoucher.idfAPVoucherKey
WHERE APVoucherJournal.idfAPVoucherJournalKey IS NULL


DECLARE curInsJournal INSENSITIVE CURSOR FOR
			SELECT DISTINCT Keys
			FROM @Keys

			OPEN curInsJournal

			FETCH NEXT FROM curInsJournal INTO @HeaderKey
			WHILE (@@fetch_status <> -1) BEGIN
				IF (@@fetch_status <> -2) BEGIN	
			
                    -- CDB 6/20/16: For now until we have the need to post GL Journal seperate from the AP Voucher we will mark these GL Journals as Posted.
                    --              This supports backwards compatability. 
					EXEC dbo.spEXPExpenseSheetHdrCreateGLJournalHist
						 ''
						,0
						,''
						,@HeaderKey
                        ,1		
						/*
					IF (ISNULL(@xonErrNum,0) > 0)
					BEGIN
						BREAK
					END
					*/
				END
				FETCH NEXT FROM curInsJournal INTO @HeaderKey
			END
			CLOSE curInsJournal
			DEALLOCATE curInsJournal

			--SELECT * FROM GLJournalHdr WHERE idfGLJournalHdrkey > 22323
			/*SELECT * FROM GLJournalDtl WHERE idfGLJournalHdrkey > 22323*/
			
			INSERT INTO dbo.APVoucherJournal (idfAPVoucherKey,idfGLJournalDtlKey)
			SELECT DTL.idfAPVoucherKey, D.idfGLJournalDtlKey
			FROM dbo.GLJournalHdr H WITH (NOLOCK) 
				INNER JOIN dbo.GLJournalDtl D WITH (NOLOCK) ON H.idfGLJournalHdrKey = D.idfGLJournalHdrKey
				INNER JOIN APVoucher DTL ON DTL.idfDocument01 = 'EXPHDR:'+D.idfDocument01
				WHERE H.idfTableLinkName = 'EXPExpenseSheetHdrHist'
				
				SELECT * FROM APVoucherJournal WHERE idfAPVoucherJournalKey > 201579
				



INSERT INTO [dbo].[WCEAICQueue]
				([idfDescription]
				,[idfLinkTableKey]
				,[idfLinkTableName]
				,[idfParam01]
				,[idfParam02]
				,[idfParam03]
				,[idfParamText01]
				,[idfProcessAttempts]
				,[idfProcessedLast]
				,[idfProcessErrorLast]
				,[idfType]
				,[idfDateCreated]
				,[idfDateModified])
	SELECT 
				'::EAICQUEUE-PROC-AP::'									-- <idfDescription, varchar(128),>
				,TMP.idfAPVoucherKey										-- <idfLinkTableKey, int,>
				,'APVoucher'											-- <idfLinkTableName, varchar(128),>
				,APVoucher.idfVoucherNumber										-- <idfParam01, varchar(128),>
				,'EXPHDR:'+CONVERT(VARCHAR(10),Keys) -- <idfParam02, varchar(128),>
				,'EXPREV:' + CONVERT(VARCHAR(10),EXPRevDtl.idfEXPRevHdrKey)	-- <idfParam03, varchar(128),>
				,''														-- <idfParamText01, text,>
				,0														-- <idfProcessAttempts, int,>
				,NULL													-- <idfProcessedLast, datetime,>
				,''														-- <idfProcessErrorLast, text,>
				,'::EAICQUEUE-AP::'										-- <idfType, varchar(60),>
				,GETDATE()												-- <idfDateCreated, datetime,>
				,GETDATE()												-- <idfDateModified, datetime,>
	FROM @Keys  TMP
	INNER JOIN APVoucher ON APVoucher.idfAPVoucherKey = TMP.idfAPVoucherKey
	INNER JOIN EXPExpenseSheetDtlHist ON EXPExpenseSheetDtlHist.idfEXPExpenseSheetHdrHistKey = TMP.Keys
	INNER JOIN EXPRevDtl ON EXPRevDtl.idfEXPExpenseSheetDtlKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey

SELECT * FROM WCEAICQueue

--ROLLBACK TRAN

