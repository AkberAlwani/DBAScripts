USE [msdb]
GO

/****** Object:  Job [SynchWorkplace_To_GP]    Script Date: 07/03/2018 17:33:51 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/03/2018 17:33:51 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'SynchWorkplace_To_GP', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'NT AUTHORITY\SYSTEM', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Sync_WTransaction_To_GPTransaction]    Script Date: 07/03/2018 17:33:51 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Sync_WTransaction_To_GPTransaction', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @SynchingFromApplicationName varchar(50)
DECLARE @SynchingFromModuleName varchar(50)
DECLARE @SynchingFromTransactionTypeName varchar(50)
DECLARE @SynchingToApplicationName varchar(50)
DECLARE @SynchingToModuleName varchar(50)
DECLARE @SynchingToTransactionTypeName varchar(50)
DECLARE @SynchingToParentID varchar(50)
DECLARE @SynchingFromParentID varchar(50)
DECLARE @SynchingToCompanyName varchar(100)
DECLARE @SynchingFromCompanyName varchar(100)
DECLARE @SynchingToHostData Varchar(MAX)
DECLARE @SynchingFromTransactionTypeID int

DECLARE @TOParentID Varchar(Max)
DECLARE @FromParentID Varchar(Max);

set @SynchingToApplicationName = ''Dynamics GP''
set @SynchingToCompanyName = ''Fabrikam, Inc.''
set @SynchingFromApplicationName = ''Paramount Workplace''
set @SynchingFromCompanyName = ''Fabrikam, Inc.''

DECLARE MODULE_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
Select Name from PaperSave.dbo.Module where HostApplication_ID = (Select ID from PaperSave.dbo.HostApplication where Name like ''Paramount Workplace'')
OPEN MODULE_CURSOR
FETCH NEXT FROM MODULE_CURSOR
INTO @SynchingFromModuleName
	WHILE @@FETCH_STATUS = 0
	BEGIN
			DECLARE Transaction_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
			Select Name,ID from PaperSave.dbo.TransactionType Where Module_ID IN (Select ID from PaperSave.dbo.Module where Name like @SynchingFromModuleName)
			OPEN Transaction_CURSOR
			FETCH NEXT FROM Transaction_CURSOR
			INTO @SynchingFromTransactionTypeName,@SynchingFromTransactionTypeID
			WHILE @@FETCH_STATUS = 0
			BEGIN
			---- Requisition Header
				IF (@SynchingFromTransactionTypeName = ''Requisition Header'')
				BEGIN
					set @SynchingToModuleName = ''Purchasing''
					Set @SynchingToTransactionTypeName = ''Purchase Order''
					-- IF Type in Workplace is Requisition then GP transaction type will be Purchase Order.
						DECLARE RQ_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						select RQDetail.edfPONumber as [TOParentID] ,HSTTable.ParentID as [FromParentID] from PaperSave.dbo.Document 
						Inner join TWO.dbo.WCAttach as RQDocument on RQDocument.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						Inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						Inner Join Two.dbo.RQDetail as RQDetail on CONVERT(varchar,RQDetail.idfRQHeaderKey) = HSTTable.ParentID 
						where HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and RQDetail.edfPONumber <> ''''
						and Content_ID is not null and RQDocument.idfExternalUDF02 = ''''
						OPEN RQ_CURSOR
						FETCH NEXT FROM RQ_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @VENDORID Varchar(MAX);
							DECLARE @VENDORNAME Varchar(MAX);
							DECLARE @PONUMBER Varchar(MAX);
							DECLARE @PARENTID Varchar(MAX);
							DECLARE RQHOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select ParentID,[PO Number],[Vendor ID],[Vendor Name] from (SELECT DISTINCT Convert(varchar,TWO.dbo.POP30100.PONUMBER) AS ParentID, Convert(varchar,TWO.dbo.POP30100.PONUMBER) AS [PO Number], TWO.dbo.PM00200.VENDORID AS [Vendor ID], TWO.dbo.PM00200.VENDNAME AS [Vendor Name] FROM TWO.dbo.POP30100 INNER JOIN TWO.dbo.PM00200 ON TWO.dbo.POP30100.VENDORID = TWO.dbo.PM00200.VENDORID UNION SELECT DISTINCT Convert(varchar,TWO.dbo.POP10100.PONUMBER) AS ParentID, Convert(varchar,TWO.dbo.POP10100.PONUMBER) AS [PO Number], PM00200_1.VENDORID AS [Vendor ID], PM00200_1.VENDNAME AS [Vendor Name] FROM TWO.dbo.POP10100 INNER JOIN TWO.dbo.PM00200 AS PM00200_1 ON TWO.dbo.POP10100.VENDORID = PM00200_1.VENDORID) as PurchaseOrder where [PO Number] like ''''+@TOParentID+''''
							OPEN RQHOSTDATAXML
							FETCH NEXT FROM RQHOSTDATAXML
							INTO @PARENTID ,@PONUMBER ,@VENDORID ,@VENDORNAME
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Purchase_Order><PO_Number><![CDATA[''+ @PONUMBER +'']]></PO_Number><Vendor_ID><![CDATA[''+ @VENDORID +'']]></Vendor_ID><Vendor_Name><![CDATA[''+ @VENDORNAME +'']]></Vendor_Name></Purchase_Order>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RQHOSTDATAXML
							INTO @PARENTID ,@PONUMBER ,@VENDORID ,@VENDORNAME
							END
							CLOSE RQHOSTDATAXML
							DEALLOCATE RQHOSTDATAXML
						FETCH NEXT FROM RQ_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RQ_CURSOR
						DEALLOCATE RQ_CURSOR
					-- IF Type in Workplace is Check Type then GP transaction type will be Receiving Transaction.
						DECLARE RQRECEIVE_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						Select RCVH.edfReceiptNumber, RQD.idfRQHeaderKey from TWO.dbo.WCAttach as W 
						inner join PAPERSAVE.dbo.Document on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						inner join TWO.dbo.RQHeader as RQH on CONVERT(varchar,RQH.idfRQHeaderKey) =  HSTTable.ParentID 
						inner join two.dbo.RQDetail as RQD on RQH.idfRQHeaderKey = RQD.idfRQHeaderKey
						inner join two.dbo.RCVDetail as RCVD on RQD.idfRCVDetailKey = RCVD.idfRCVDetailKey
						inner join TWO.dbo.RCVHeader as RCVH on RCVD.idfRCVHeaderKey = RCVH.idfRCVHeaderKey
						where RQH.idfRQTypeKey =3 and HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and RCVH.edfReceiptNumber<>'''' and Content_ID is not null and W.idfExternalUDF02 = ''''
						
						OPEN RQRECEIVE_CURSOR
						FETCH NEXT FROM RQRECEIVE_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							Set @SynchingToTransactionTypeName = ''Receivings Transaction'';
							DECLARE @RCVPOPNumber varchar(max);
							DECLARE @RCVRECEIPTDATE varchar(max);
							DECLARE @RCVVENDORID varchar(max);
							DECLARE @RCVVENDORNAME VARCHAR(MAX);
							DECLARE @RCVSUB_TOTAL varchar(max);
							DECLARE @RCVDUE_DATE varchar(max);
							
							DECLARE RECEVIE_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select [POP Reciept Number],[Receipt Date],[Vendor ID],[Vendor Name],[Sub Total],[Due Date] from (Select [POP Receipt Number] as ParentID ,''Origin'' = Case when [Posting Status] = ''Posted'' Then ''HIST'' ELSE ''OPEN'' END ,[POP Receipt Number] as [POP Reciept Number] ,  substring(convert(varchar,isnull([Receipt Date],''9999-01-01''),120),1,10) AS [Receipt Date],   TWO.dbo.ReceivingsTransactions.[Vendor Document Number] as [Document Number],  TWO.dbo.ReceivingsTransactions.[POP Type] as [Type],  [Vendor ID],[Vendor Name] ,   [Reference],  CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Sub Total] ,substring(convert(varchar,isnull([Due Date],''9999-01-01''),120),1,10) as [Due Date] from TWO.dbo.ReceivingsTransactions  WHERE [POP Type]<>''Invoice'') as ReceivingTransaction where [POP Reciept Number] like ''''+LTrim(Rtrim(@TOParentID))+''''
							OPEN RECEVIE_HOSTDATAXML
							FETCH NEXT FROM RECEVIE_HOSTDATAXML
							INTO @RCVPOPNumber ,@RCVRECEIPTDATE ,@RCVVENDORID ,@RCVVENDORNAME,@RCVSUB_TOTAL,@RCVDUE_DATE
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Receivings_Transaction><Origin></Origin><POP_Reciept_Number>''+@RCVPOPNumber +''</POP_Reciept_Number><Receipt_Date>''+@RCVRECEIPTDATE+''</Receipt_Date><Vendor_ID>''+@RCVVENDORID+''</Vendor_ID><Vendor_Name>''+@RCVVENDORNAME+''</Vendor_Name><Reference>Receivings Transaction Entry</Reference><Sub_Total>''+@RCVSUB_TOTAL+''</Sub_Total><Due_Date>''+@RCVDUE_DATE+''</Due_Date></Receivings_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RECEVIE_HOSTDATAXML
							INTO @RCVPOPNumber ,@RCVRECEIPTDATE ,@RCVVENDORID ,@RCVVENDORNAME,@RCVSUB_TOTAL,@RCVDUE_DATE
							END
							CLOSE RECEVIE_HOSTDATAXML
							DEALLOCATE RECEVIE_HOSTDATAXML
						FETCH NEXT FROM RQRECEIVE_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RQRECEIVE_CURSOR
						DEALLOCATE RQRECEIVE_CURSOR
					END		
		---- Requisition Line
					ELSE IF (@SynchingFromTransactionTypeName = ''Requisition Line'')
					BEGIN
						set @SynchingToModuleName = ''Purchasing''
						Set @SynchingToTransactionTypeName = ''Purchase Order''
					-- IF Type in Workplace is Requisition then GP transaction type will be Purchase Order.
						DECLARE RQLine_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						select RQDetail.edfPONumber as [TOParentID] ,HSTTable.ParentID as [FromParentID] from PaperSave.dbo.Document 
						Inner join TWO.dbo.WCAttach as RQDocument on RQDocument.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						Inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						Inner Join Two.dbo.RQDetail as RQDetail on CONVERT(varchar,RQDetail.idfRQDetailKey) = HSTTable.ParentID 
						where HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and RQDetail.edfPONumber <> ''''	and Content_ID is not null and RQDocument.idfExternalUDF02 = ''''
						OPEN RQLine_CURSOR
						FETCH NEXT FROM RQLine_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @RQLine_VENDORID Varchar(MAX);
							DECLARE @RQLine_VENDORNAME Varchar(MAX);
							DECLARE @RQLine_PONUMBER Varchar(MAX);
							DECLARE @RQLine_PARENTID Varchar(MAX);
							DECLARE RQLine_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select ParentID,[PO Number],[Vendor ID],[Vendor Name] from (SELECT DISTINCT Convert(varchar,TWO.dbo.POP30100.PONUMBER) AS ParentID, Convert(varchar,TWO.dbo.POP30100.PONUMBER) AS [PO Number], TWO.dbo.PM00200.VENDORID AS [Vendor ID], TWO.dbo.PM00200.VENDNAME AS [Vendor Name] FROM TWO.dbo.POP30100 INNER JOIN TWO.dbo.PM00200 ON TWO.dbo.POP30100.VENDORID = TWO.dbo.PM00200.VENDORID UNION SELECT DISTINCT Convert(varchar,TWO.dbo.POP10100.PONUMBER) AS ParentID, Convert(varchar,TWO.dbo.POP10100.PONUMBER) AS [PO Number], PM00200_1.VENDORID AS [Vendor ID], PM00200_1.VENDNAME AS [Vendor Name] FROM TWO.dbo.POP10100 INNER JOIN TWO.dbo.PM00200 AS PM00200_1 ON TWO.dbo.POP10100.VENDORID = PM00200_1.VENDORID) as PurchaseOrder where [PO Number] like ''''+@TOParentID+''''
							OPEN RQLine_HOSTDATAXML
							FETCH NEXT FROM RQLine_HOSTDATAXML
							INTO @RQLine_PARENTID ,@RQLine_PONUMBER ,@RQLine_VENDORID ,@RQLine_VENDORNAME
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Purchase_Order><PO_Number><![CDATA[''+ @RQLine_PONUMBER +'']]></PO_Number><Vendor_ID><![CDATA[''+ @RQLine_VENDORID +'']]></Vendor_ID><Vendor_Name><![CDATA[''+ @RQLine_VENDORNAME +'']]></Vendor_Name></Purchase_Order>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RQLine_HOSTDATAXML
							INTO @RQLine_PARENTID ,@RQLine_PONUMBER ,@RQLine_VENDORID ,@RQLine_VENDORNAME
							END
							CLOSE RQLine_HOSTDATAXML
							DEALLOCATE RQLine_HOSTDATAXML
						FETCH NEXT FROM RQLine_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RQLine_CURSOR
						DEALLOCATE RQLine_CURSOR
					-- IF Type in Workplace is Check Type then GP transaction type will be Receiving Transaction.
						DECLARE RQRECEIVELine_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						Select RCVH.edfReceiptNumber, RQD.idfRQDetailKey from TWO.dbo.WCAttach as W 
						inner join PAPERSAVE.dbo.Document on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						inner join two.dbo.RQDetail as RQD on CONVERT(varchar,RQD.idfRQDetailKey) =  HSTTable.ParentID
						inner join TWO.dbo.RQHeader as RQH on CONVERT(varchar,RQH.idfRQHeaderKey) =  RQD.idfRQHeaderKey 
						inner join two.dbo.RCVDetail as RCVD on RQD.idfRCVDetailKey = RCVD.idfRCVDetailKey
						inner join TWO.dbo.RCVHeader as RCVH on RCVD.idfRCVHeaderKey = RCVH.idfRCVHeaderKey
						where RQH.idfRQTypeKey =3 and HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and RCVH.edfReceiptNumber<>'''' and Content_ID is not null and W.idfExternalUDF02 = ''''
						
						OPEN RQRECEIVELine_CURSOR
						FETCH NEXT FROM RQRECEIVELine_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							Set @SynchingToTransactionTypeName = ''Receivings Transaction'';
							DECLARE @RCVLinePOPNumber varchar(max);
							DECLARE @RCVLineRECEIPTDATE varchar(max);
							DECLARE @RCVLineVENDORID varchar(max);
							DECLARE @RCVLineVENDORNAME VARCHAR(MAX);
							DECLARE @RCVLineSUB_TOTAL varchar(max);
							DECLARE @RCVLineDUE_DATE varchar(max);
							
							DECLARE RECEVIELine_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select [POP Reciept Number],[Receipt Date],[Vendor ID],[Vendor Name],[Sub Total],[Due Date] from (Select [POP Receipt Number] as ParentID ,''Origin'' = Case when [Posting Status] = ''Posted'' Then ''HIST'' ELSE ''OPEN'' END ,[POP Receipt Number] as [POP Reciept Number] ,  substring(convert(varchar,isnull([Receipt Date],''9999-01-01''),120),1,10) AS [Receipt Date],   TWO.dbo.ReceivingsTransactions.[Vendor Document Number] as [Document Number],  TWO.dbo.ReceivingsTransactions.[POP Type] as [Type],  [Vendor ID],[Vendor Name] ,   [Reference],  CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Sub Total] ,substring(convert(varchar,isnull([Due Date],''9999-01-01''),120),1,10) as [Due Date] from TWO.dbo.ReceivingsTransactions  WHERE [POP Type]<>''Invoice'') as ReceivingTransaction where [POP Reciept Number] like ''''+LTrim(Rtrim(@TOParentID))+''''
							OPEN RECEVIELine_HOSTDATAXML
							FETCH NEXT FROM RECEVIELine_HOSTDATAXML
							INTO @RCVLinePOPNumber ,@RCVLineRECEIPTDATE ,@RCVLineVENDORID ,@RCVLineVENDORNAME,@RCVLineSUB_TOTAL,@RCVLineDUE_DATE
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Receivings_Transaction><Origin></Origin><POP_Reciept_Number>''+@RCVLinePOPNumber +''</POP_Reciept_Number><Receipt_Date>''+@RCVLineRECEIPTDATE+''</Receipt_Date><Vendor_ID>''+@RCVLineVENDORID+''</Vendor_ID><Vendor_Name>''+@RCVLineVENDORNAME+''</Vendor_Name><Reference>Receivings Transaction Entry</Reference><Sub_Total>''+@RCVLineSUB_TOTAL+''</Sub_Total><Due_Date>''+@RCVLineDUE_DATE+''</Due_Date></Receivings_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RECEVIELine_HOSTDATAXML
							INTO @RCVLinePOPNumber ,@RCVLineRECEIPTDATE ,@RCVLineVENDORID ,@RCVLineVENDORNAME,@RCVLineSUB_TOTAL,@RCVLineDUE_DATE
							END
							CLOSE RECEVIELine_HOSTDATAXML
							DEALLOCATE RECEVIELine_HOSTDATAXML
						FETCH NEXT FROM RQRECEIVELine_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RQRECEIVELine_CURSOR
						DEALLOCATE RQRECEIVELine_CURSOR
					END
	-- Receiving Wizard (Workplace) To Receiving Transaction (GP).........
					ELSE IF (@SynchingFromTransactionTypeName = ''Receiving Wizard'')
					BEGIN
						set @SynchingToModuleName = ''Purchasing'';
						Set @SynchingToTransactionTypeName = ''Receivings Transaction'';
												
						DECLARE RCVW_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						select RCVH.edfReceiptNumber,RcvHdr.idfRCVAutoRcvHdrKey  from TWO.dbo.WCAttach as W 
						inner join PAPERSAVE.dbo.Document on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						inner join TWO.dbo.RCVAutoRcvHdr as RcvHdr on  CONVERT(varchar,RcvHdr.idfRCVAutoRcvHdrKey) =HSTTable.ParentID 
						inner join TWO.dbo.RCVAutoRcvDtl Rcvdtl on Rcvdtl.idfRCVAutoRcvHdrKey = RcvHdr.idfRCVAutoRcvHdrKey
						inner join TWO.dbo.RCVDetail RCVD on Rcvdtl.idfRCVDetailKey = RCVD.idfRCVDetailKey
						inner join TWO.dbo.RCVHeader RCVH on RCVH.idfRCVHeaderKey = RCVD.idfRCVHeaderKey
						where HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and Rcvdtl.idfFlagReceive = 1 and Content_ID is not null and W.idfExternalUDF02 = ''''
						OPEN RCVW_CURSOR
						FETCH NEXT FROM RCVW_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @RCVW_POPNumber varchar(max);
							DECLARE @RCVW_RECEIPTDATE varchar(max);
							DECLARE @RCVW_VENDORID varchar(max);
							DECLARE @RCVW_VENDORNAME VARCHAR(MAX);
							DECLARE @RCVW_SUB_TOTAL varchar(max);
							DECLARE @RCVW_DUE_DATE varchar(max);
							
							DECLARE RCVWHOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
								Select [POP Reciept Number],[Receipt Date],[Vendor ID],[Vendor Name],[Sub Total],[Due Date] from (Select [POP Receipt Number] as ParentID ,''Origin'' = Case when [Posting Status] = ''Posted'' Then ''HIST'' ELSE ''OPEN'' END ,[POP Receipt Number] as [POP Reciept Number] ,  substring(convert(varchar,isnull([Receipt Date],''9999-01-01''),120),1,10) AS [Receipt Date],   TWO.dbo.ReceivingsTransactions.[Vendor Document Number] as [Document Number],  TWO.dbo.ReceivingsTransactions.[POP Type] as [Type],  [Vendor ID],[Vendor Name] ,   [Reference],  CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Sub Total] ,substring(convert(varchar,isnull([Due Date],''9999-01-01''),120),1,10) as [Due Date] from TWO.dbo.ReceivingsTransactions  WHERE [POP Type]<>''Invoice'') as ReceivingTransaction where [POP Reciept Number] like ''''+LTrim(Rtrim(@TOParentID))+'''';
							OPEN RCVWHOSTDATAXML
							FETCH NEXT FROM RCVWHOSTDATAXML
							INTO @RCVW_POPNumber ,@RCVW_RECEIPTDATE ,@RCVW_VENDORID ,@RCVW_VENDORNAME,@RCVW_SUB_TOTAL,@RCVW_DUE_DATE
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Receivings_Transaction><Origin></Origin><POP_Reciept_Number>''+@RCVW_POPNumber +''</POP_Reciept_Number><Receipt_Date>''+@RCVW_RECEIPTDATE+''</Receipt_Date><Vendor_ID>''+@RCVW_VENDORID+''</Vendor_ID><Vendor_Name>''+@RCVW_VENDORNAME+''</Vendor_Name><Reference>Receivings Transaction Entry</Reference><Sub_Total>''+@RCVW_SUB_TOTAL+''</Sub_Total><Due_Date>''+@RCVW_DUE_DATE+''</Due_Date></Receivings_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RCVWHOSTDATAXML
							INTO @RCVW_POPNumber ,@RCVW_RECEIPTDATE ,@RCVW_VENDORID ,@RCVW_VENDORNAME,@RCVW_SUB_TOTAL,@RCVW_DUE_DATE
							END
							CLOSE RCVWHOSTDATAXML
							DEALLOCATE RCVWHOSTDATAXML
						FETCH NEXT FROM RCVW_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RCVW_CURSOR
						DEALLOCATE RCVW_CURSOR
					END
	-- Receive Match Invoice Header -----Receiving Transaction
					ELSE IF (@SynchingFromTransactionTypeName = ''Receive Match Invoice Header'')
					BEGIN
					-- If Transaction Type of Workplace is Shipment or ShipmentInvoice then entry is added in Receiving Transaction.
						set @SynchingToModuleName = ''Purchasing'';
						Set @SynchingToTransactionTypeName = ''Receivings Transaction'';
												
						DECLARE RCVMIH_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						
						Select RCVH.edfReceiptNumber,RCVH.idfRCVHeaderKey from TWO.dbo.WCAttach AS w 
						inner join PAPERSAVE.dbo.Document on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						inner join TWO.dbo.RCVHeader as RCVH on CONVERT(varchar,RCVH.idfRCVHeaderKey) = HSTTable.ParentID
						where RCVH.edfReceiptNumber <> '''' and RCVH.idfTransactionType<>2 and HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and Content_ID is not null and W.idfExternalUDF02 = ''''
						
						OPEN RCVMIH_CURSOR
						FETCH NEXT FROM RCVMIH_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @RCVMIH_POPNumber varchar(max);
							DECLARE @RCVMIH_RECEIPTDATE varchar(max);
							DECLARE @RCVMIH_VENDORID varchar(max);
							DECLARE @RCVMIH_VENDORNAME VARCHAR(MAX);
							DECLARE @RCVMIH_SUB_TOTAL varchar(max);
							DECLARE @RCVMIH_DUE_DATE varchar(max);
							
							DECLARE RCVMIHHOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
								Select [POP Reciept Number],[Receipt Date],[Vendor ID],[Vendor Name],[Sub Total],[Due Date] from (Select [POP Receipt Number] as ParentID ,''Origin'' = Case when [Posting Status] = ''Posted'' Then ''HIST'' ELSE ''OPEN'' END ,[POP Receipt Number] as [POP Reciept Number] ,  substring(convert(varchar,isnull([Receipt Date],''9999-01-01''),120),1,10) AS [Receipt Date],   TWO.dbo.ReceivingsTransactions.[Vendor Document Number] as [Document Number],  TWO.dbo.ReceivingsTransactions.[POP Type] as [Type],  [Vendor ID],[Vendor Name] ,   [Reference],  CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Sub Total] ,substring(convert(varchar,isnull([Due Date],''9999-01-01''),120),1,10) as [Due Date] from TWO.dbo.ReceivingsTransactions  WHERE [POP Type]<>''Invoice'') as ReceivingTransaction where [POP Reciept Number] like ''''+LTrim(Rtrim(@TOParentID))+'''';
							OPEN RCVMIHHOSTDATAXML
							FETCH NEXT FROM RCVMIHHOSTDATAXML
							INTO @RCVMIH_POPNumber ,@RCVMIH_RECEIPTDATE ,@RCVMIH_VENDORID ,@RCVMIH_VENDORNAME,@RCVMIH_SUB_TOTAL,@RCVMIH_DUE_DATE
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Receivings_Transaction><Origin></Origin><POP_Reciept_Number>''+@RCVMIH_POPNumber +''</POP_Reciept_Number><Receipt_Date>''+@RCVMIH_RECEIPTDATE+''</Receipt_Date><Vendor_ID>''+@RCVMIH_VENDORID+''</Vendor_ID><Vendor_Name>''+@RCVMIH_VENDORNAME+''</Vendor_Name><Reference>Receivings Transaction Entry</Reference><Sub_Total>''+@RCVMIH_SUB_TOTAL+''</Sub_Total><Due_Date>''+@RCVMIH_DUE_DATE+''</Due_Date></Receivings_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RCVMIHHOSTDATAXML
							INTO @RCVMIH_POPNumber ,@RCVMIH_RECEIPTDATE ,@RCVMIH_VENDORID ,@RCVMIH_VENDORNAME,@RCVMIH_SUB_TOTAL,@RCVMIH_DUE_DATE
							END
							CLOSE RCVMIHHOSTDATAXML
							DEALLOCATE RCVMIHHOSTDATAXML
						FETCH NEXT FROM RCVMIH_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RCVMIH_CURSOR
						DEALLOCATE RCVMIH_CURSOR
						-- If Transaction Type of Workplace is Invoice then entry is added in Enter\Match Invoice of GP Payable.
						set @SynchingToModuleName = ''Purchasing'';
						Set @SynchingToTransactionTypeName = ''Payables Transaction'';
												
						DECLARE RCVMIH_INV_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						
						Select RCVH.edfReceiptNumber,RCVH.idfRCVHeaderKey from Two.dbo.WCAttach AS w 
						inner join PAPERSAVE.dbo.Document on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						inner join Two.dbo.RCVHeader as RCVH on CONVERT(varchar,RCVH.idfRCVHeaderKey) = HSTTable.ParentID
						where RCVH.idfTransactionType=2 and HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and Content_ID is not null and W.idfExternalUDF02 = ''''
						
						OPEN RCVMIH_INV_CURSOR
						FETCH NEXT FROM RCVMIH_INV_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @RCVMIH_INV_VoucherNumber varchar(max);
							DECLARE @RCVMIH_INV_DocNumber varchar(max);
							DECLARE @RCVMIH_INV_Date varchar(max);
							DECLARE @RCVMIH_INV_VENDORID varchar(max);
							DECLARE @RCVMIH_INV_VENDORNAME VARCHAR(MAX);
							DECLARE @RCVMIH_INV_Amount varchar(max);
							DECLARE @RCVMIH_INV_DESC varchar(max);
							
							DECLARE RCVMIH_INV_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select [Voucher Number],[Document Number],[Date],[Vendor ID],[Vendor Name],[Amount],[Description] from (SELECT DISTINCT Convert(varchar,VCHRNMBR) AS ParentID,  Convert(varchar,VCHRNMBR) AS [Voucher Number],''HIST'' AS Origin,  DOCNUMBR AS [Document Number],   CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type], substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  PAYABLESTRANSACTIONHISTORY.VENDORID AS [Vendor ID], VENDOR.VENDNAME AS [Vendor Name],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount, TRXDSCRN AS [Description]   FROM TWO.dbo.PM30200 PAYABLESTRANSACTIONHISTORY INNER JOIN TWO.dbo.PM00200 VENDOR ON PAYABLESTRANSACTIONHISTORY.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6   AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS PARENTID, Convert(varchar,VCHRNMBR) AS [VOUCHER NUMBER], ''OPEN'' AS ORIGIN,  DOCNUMBR AS [DOCUMENT NUMBER],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [VENDOR], VENDOR.VENDNAME AS [VENDOR NAME],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS AMOUNT, TRXDSCRN AS [DESCRIPTION] FROM TWO.dbo.PM20000 OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS [ParentID],  Convert(varchar,VCHRNMBR) AS [Voucher Number], ''WORK'' AS Origin,  DOCNUMBR AS [Document Number],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [Vendor], VENDOR.VENDNAME AS [Vendor Name], CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount , TRXDSCRN AS [Description] FROM TWO.dbo.PM10000   OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID],  VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP10300   WHERE POPTYPE = 2 UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID], VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP30300   WHERE POPTYPE = 2 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry'') PayableTransaction where ParentID like ''''+LTrim(Rtrim(@TOParentID))+'''';
							OPEN RCVMIH_INV_HOSTDATAXML
							FETCH NEXT FROM RCVMIH_INV_HOSTDATAXML
							INTO @RCVMIH_INV_VoucherNumber ,@RCVMIH_INV_DocNumber ,@RCVMIH_INV_Date ,@RCVMIH_INV_VENDORID,@RCVMIH_INV_VENDORNAME,@RCVMIH_INV_Amount,@RCVMIH_INV_DESC
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Payables_Transaction><Voucher_Number><![CDATA[''+@RCVMIH_INV_VoucherNumber+'']]></Voucher_Number><Origin></Origin><Document_Number><![CDATA[''+@RCVMIH_INV_DocNumber+'']]></Document_Number><Payables_Type></Payables_Type><Date><![CDATA[''+@RCVMIH_INV_Date+'']]></Date><Vendor_ID><![CDATA[''+@RCVMIH_INV_VENDORID+'']]></Vendor_ID><Vendor_Name><![CDATA[''+@RCVMIH_INV_VENDORNAME+'']]></Vendor_Name><Amount><![CDATA[''+@RCVMIH_INV_VENDORNAME+'']]></Amount><Description><![CDATA[''+@RCVMIH_INV_DESC+'']]></Description></Payables_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM RCVMIH_INV_HOSTDATAXML
							INTO @RCVMIH_INV_VoucherNumber ,@RCVMIH_INV_DocNumber ,@RCVMIH_INV_Date ,@RCVMIH_INV_VENDORID,@RCVMIH_INV_VENDORNAME,@RCVMIH_INV_Amount,@RCVMIH_INV_DESC
							END
							CLOSE RCVMIH_INV_HOSTDATAXML
							DEALLOCATE RCVMIH_INV_HOSTDATAXML
						FETCH NEXT FROM RCVMIH_INV_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE RCVMIH_INV_CURSOR
						DEALLOCATE RCVMIH_INV_CURSOR
					END
	--  Expense Sheet Header --- TO --- Payables Transaction
					ELSE IF (@SynchingFromTransactionTypeName = ''Expense Sheet Header'')
					BEGIN
						set @SynchingToModuleName = ''Purchasing'';
						Set @SynchingToTransactionTypeName = ''Payables Transaction'';
												
						DECLARE EXPH_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						Select ExpDetail.edfDocNo,HSTTable.ParentID from TWO.dbo.WCAttach as W
						Inner join PaperSave.dbo.Document  on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						Inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						Inner join TWO.dbo.EXPExpenseSheetHdrHist ExpHeader on CONVERT(varchar,ExpHeader.idfEXPExpenseSheetHdrHistKey) =  HSTTable.ParentID  
						Inner join TWO.dbo.EXPExpenseSheetDtlHist as ExpDetail on ExpHeader.idfEXPExpenseSheetHdrHistKey = ExpDetail.idfEXPExpenseSheetHdrHistKey 
						where HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and Content_ID is not null and W.idfExternalUDF02 = '''' and ExpDetail.edfDocNo <> ''''
						OPEN EXPH_CURSOR
						FETCH NEXT FROM EXPH_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @EXPH_VoucherNumber varchar(max);
							DECLARE @EXPH_DocNumber varchar(max);
							DECLARE @EXPH_Date varchar(max);
							DECLARE @EXPH_VENDORID varchar(max);
							DECLARE @EXPH_VENDORNAME VARCHAR(MAX);
							DECLARE @EXPH_Amount varchar(max);
							DECLARE @EXPH_DESC varchar(max);
							DECLARE EXPH_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select [Voucher Number],[Document Number],[Date],[Vendor ID],[Vendor Name],[Amount],[Description] from (SELECT DISTINCT Convert(varchar,VCHRNMBR) AS ParentID,  Convert(varchar,VCHRNMBR) AS [Voucher Number],''HIST'' AS Origin,  DOCNUMBR AS [Document Number],   CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type], substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  PAYABLESTRANSACTIONHISTORY.VENDORID AS [Vendor ID], VENDOR.VENDNAME AS [Vendor Name],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount, TRXDSCRN AS [Description]   FROM TWO.dbo.PM30200 PAYABLESTRANSACTIONHISTORY INNER JOIN TWO.dbo.PM00200 VENDOR ON PAYABLESTRANSACTIONHISTORY.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6   AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS PARENTID, Convert(varchar,VCHRNMBR) AS [VOUCHER NUMBER], ''OPEN'' AS ORIGIN,  DOCNUMBR AS [DOCUMENT NUMBER],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [VENDOR], VENDOR.VENDNAME AS [VENDOR NAME],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS AMOUNT, TRXDSCRN AS [DESCRIPTION] FROM TWO.dbo.PM20000 OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS [ParentID],  Convert(varchar,VCHRNMBR) AS [Voucher Number], ''WORK'' AS Origin,  DOCNUMBR AS [Document Number],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [Vendor], VENDOR.VENDNAME AS [Vendor Name], CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount , TRXDSCRN AS [Description] FROM TWO.dbo.PM10000   OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID],  VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP10300   WHERE POPTYPE = 2 UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID], VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP30300   WHERE POPTYPE = 2 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry'') PayableTransaction where ParentID = ''''+@TOParentID+'''';
							OPEN EXPH_HOSTDATAXML
							FETCH NEXT FROM EXPH_HOSTDATAXML
							INTO @EXPH_VoucherNumber ,@EXPH_DocNumber ,@EXPH_Date ,@EXPH_VENDORID,@EXPH_VENDORNAME,@EXPH_Amount,@EXPH_DESC
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Payables_Transaction><Voucher_Number><![CDATA[''+@EXPH_VoucherNumber+'']]></Voucher_Number><Origin></Origin><Document_Number><![CDATA[''+@EXPH_DocNumber+'']]></Document_Number><Payables_Type></Payables_Type><Date><![CDATA[''+@EXPH_Date+'']]></Date><Vendor_ID><![CDATA[''+@EXPH_VENDORID+'']]></Vendor_ID><Vendor_Name><![CDATA[''+@EXPH_VENDORNAME+'']]></Vendor_Name><Amount><![CDATA[''+@EXPH_VENDORNAME+'']]></Amount><Description><![CDATA[''+@EXPH_DESC+'']]></Description></Payables_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM EXPH_HOSTDATAXML
							INTO @EXPH_VoucherNumber ,@EXPH_DocNumber ,@EXPH_Date ,@EXPH_VENDORID,@EXPH_VENDORNAME,@EXPH_Amount,@EXPH_DESC
							END
							CLOSE EXPH_HOSTDATAXML
							DEALLOCATE EXPH_HOSTDATAXML
						FETCH NEXT FROM EXPH_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE EXPH_CURSOR
						DEALLOCATE EXPH_CURSOR
					END
--  Expense Sheet Detail --- TO --- Payables Transaction
					ELSE IF (@SynchingFromTransactionTypeName = ''Expense Sheet Detail'')
					BEGIN
						set @SynchingToModuleName = ''Purchasing'';
						Set @SynchingToTransactionTypeName = ''Payables Transaction'';
												
						DECLARE EXPDetail_CURSOR CURSOR FAST_FORWARD READ_ONLY FOR
						Select Distinct ExpDetail.edfDocNo,ExpDetail.idfExpExpenseSheetdtlHistKey from TWO.dbo.WCAttach as W
						Inner join PaperSave.dbo.Document  on W.idfExternalUDF01 = Convert(varchar,PaperSave.dbo.document.ID) 
						Inner join PaperSave.dbo.HostApplicationLocalData  as HSTTable 
						on HSTTable.ID = PaperSave.dbo.Document.HostApplicationLocalData_ID
						Inner join TWO.dbo.EXPExpenseSheetDtlHist as ExpDetail on Convert(varchar,ExpDetail.idfEXPExpenseSheetDtlHistKey) = HSTTable.ParentID 
						where HSTTable.TransactionType_ID = @SynchingFromTransactionTypeID and Content_ID is not null and W.idfExternalUDF02 = '''' and ExpDetail.edfDocNo <> ''''
						OPEN EXPDetail_CURSOR
						FETCH NEXT FROM EXPDetail_CURSOR
						INTO @TOParentID,@FromParentID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							DECLARE @EXPDetail_VoucherNumber varchar(max);
							DECLARE @EXPDetail_DocNumber varchar(max);
							DECLARE @EXPDetail_Date varchar(max);
							DECLARE @EXPDetail_VENDORID varchar(max);
							DECLARE @EXPDetail_VENDORNAME VARCHAR(MAX);
							DECLARE @EXPDetail_Amount varchar(max);
							DECLARE @EXPDetail_DESC varchar(max);
							
							DECLARE EXPDetail_HOSTDATAXML CURSOR FAST_FORWARD READ_ONLY FOR	
							Select [Voucher Number],[Document Number],[Date],[Vendor ID],[Vendor Name],[Amount],[Description] from (SELECT DISTINCT Convert(varchar,VCHRNMBR) AS ParentID,  Convert(varchar,VCHRNMBR) AS [Voucher Number],''HIST'' AS Origin,  DOCNUMBR AS [Document Number],   CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100) WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type], substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  PAYABLESTRANSACTIONHISTORY.VENDORID AS [Vendor ID], VENDOR.VENDNAME AS [Vendor Name],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount, TRXDSCRN AS [Description]   FROM TWO.dbo.PM30200 PAYABLESTRANSACTIONHISTORY INNER JOIN TWO.dbo.PM00200 VENDOR ON PAYABLESTRANSACTIONHISTORY.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6   AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS PARENTID, Convert(varchar,VCHRNMBR) AS [VOUCHER NUMBER], ''OPEN'' AS ORIGIN,  DOCNUMBR AS [DOCUMENT NUMBER],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [VENDOR], VENDOR.VENDNAME AS [VENDOR NAME],  CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS AMOUNT, TRXDSCRN AS [DESCRIPTION] FROM TWO.dbo.PM20000 OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,VCHRNMBR) AS [ParentID],  Convert(varchar,VCHRNMBR) AS [Voucher Number], ''WORK'' AS Origin,  DOCNUMBR AS [Document Number],  CASE    WHEN DOCTYPE = 1 THEN (SELECT PMTRXABR_1 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 2 THEN (SELECT PMTRXABR_2 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 3 THEN (SELECT PMTRXABR_3 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 4 THEN (SELECT PMTRXABR_4 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 5 THEN (SELECT PMTRXABR_5 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 6 THEN (SELECT PMTRXABR_6 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 7 THEN (SELECT PMTRXABR_7 FROM TWO.dbo.PM40100)   WHEN DOCTYPE = 8 THEN (SELECT PMTRXABR_8 FROM TWO.dbo.PM40100)  END AS [Payables Type],  substring(convert(varchar,isnull(DOCDATE,''9999-01-01''),120),1,10) AS Date,  OPENPAYABLESTRANSACTION.VENDORID AS [Vendor], VENDOR.VENDNAME AS [Vendor Name], CAST(isnull(DOCAMNT,0) as decimal(22,2)) AS Amount , TRXDSCRN AS [Description] FROM TWO.dbo.PM10000   OPENPAYABLESTRANSACTION INNER JOIN TWO.dbo.PM00200 VENDOR ON OPENPAYABLESTRANSACTION.VENDORID = VENDOR.VENDORID   WHERE [DOCTYPE]<>6 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry''  UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID],  VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP10300   WHERE POPTYPE = 2 UNION SELECT DISTINCT Convert(varchar,POPRCTNM) AS ParentID, Convert(varchar,POPRCTNM) AS [VOUCHER NUMBER],'''' AS Origin, VNDDOCNM AS [DOCUMENT NUMBER],  ''INV'' AS [Payables Type],substring(convert(varchar,isnull(receiptdate,''9999-01-01''),120),1,10) AS [Date],VENDORID AS [Vendor ID], VENDNAME AS [Vendor Name],CAST(isnull(SUBTOTAL,0) as decimal(22,2)) AS [Amount], '''' AS [Description]FROM TWO.dbo.POP30300   WHERE POPTYPE = 2 AND BCHSOURC <> ''Rcvg Trx Ivc'' and BCHSOURC <> ''Rcvg Trx Entry'') PayableTransaction where ParentID like ''''+LTrim(Rtrim(@TOParentID))+'''';
							OPEN EXPDetail_HOSTDATAXML
							FETCH NEXT FROM EXPDetail_HOSTDATAXML
							INTO @EXPDetail_VoucherNumber ,@EXPDetail_DocNumber ,@EXPDetail_Date ,@EXPDetail_VENDORID,@EXPDetail_VENDORNAME,@EXPDetail_Amount,@EXPDetail_DESC
							WHILE @@FETCH_STATUS = 0
							BEGIN
								set @SynchingToHostData=''<?xml version="1.0" encoding="utf-8"?><Payables_Transaction><Voucher_Number><![CDATA[''+@EXPDetail_VoucherNumber+'']]></Voucher_Number><Origin></Origin><Document_Number><![CDATA[''+@EXPDetail_DocNumber+'']]></Document_Number><Payables_Type></Payables_Type><Date><![CDATA[''+@EXPDetail_Date+'']]></Date><Vendor_ID><![CDATA[''+@EXPDetail_VENDORID+'']]></Vendor_ID><Vendor_Name><![CDATA[''+@EXPDetail_VENDORNAME+'']]></Vendor_Name><Amount><![CDATA[''+@EXPDetail_VENDORNAME+'']]></Amount><Description><![CDATA[''+@EXPDetail_DESC+'']]></Description></Payables_Transaction>'';
								BEGIN TRY
								EXECUTE [PaperSave].[dbo].[SynchDocumentsOfMatchingDocTypesForTwoParentIDs_v5] 
								@SynchingFromApplicationName
								,@SynchingFromModuleName
								,@SynchingFromTransactionTypeName
								,@SynchingToApplicationName
								,@SynchingToModuleName
								,@SynchingToTransactionTypeName
								,@TOParentID
								,@FromParentID
								,@SynchingToCompanyName
								,@SynchingFromCompanyName
								,@SynchingToHostData
								END TRY
								BEGIN Catch
									Print ERROR_MESSAGE();
								END Catch
							FETCH NEXT FROM EXPDetail_HOSTDATAXML
							INTO @EXPDetail_VoucherNumber ,@EXPDetail_DocNumber ,@EXPDetail_Date ,@EXPDetail_VENDORID,@EXPDetail_VENDORNAME,@EXPDetail_Amount,@EXPDetail_DESC
							END
							CLOSE EXPDetail_HOSTDATAXML
							DEALLOCATE EXPDetail_HOSTDATAXML
						FETCH NEXT FROM EXPDetail_CURSOR
						INTO @TOParentID,@FromParentID
						END
						CLOSE EXPDetail_CURSOR
						DEALLOCATE EXPDetail_CURSOR
					END
			FETCH NEXT FROM Transaction_CURSOR
			INTO @SynchingFromTransactionTypeName,@SynchingFromTransactionTypeID
			END
			CLOSE Transaction_CURSOR
			DEALLOCATE Transaction_CURSOR
			FETCH NEXT FROM MODULE_CURSOR
			INTO @SynchingFromModuleName
	END
CLOSE MODULE_CURSOR
DEALLOCATE MODULE_CURSOR', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'New', 
		@enabled=0, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20120725, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'd3aad169-677e-45a8-a757-1b656ca78923'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


