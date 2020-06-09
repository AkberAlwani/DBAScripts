USE TWO
GO
SET IDENTITY_INSERT [dbo].[TX00101] ON

GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'All GST Sales Details          ', CAST(0.00000 AS NUMERIC(19, 5)), 1)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'All GST Purchases Details      ', CAST(0.00000 AS NUMERIC(19, 5)), 2)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTADJ       ', N'GST Excl. Adjustment           ', CAST(0.00000 AS NUMERIC(19, 5)), 3)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTFS        ', N'GST Excl. Free Supply          ', CAST(0.00000 AS NUMERIC(19, 5)), 4)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPCUST   ', N'GST Excl. Import Customs       ', CAST(0.00000 AS NUMERIC(19, 5)), 5)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPSUP    ', N'GST Excl. Import Supplier      ', CAST(0.00000 AS NUMERIC(19, 5)), 6)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTIT        ', N'GST Excl. Input Taxed          ', CAST(0.00000 AS NUMERIC(19, 5)), 7)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTNITD      ', N'GST Excl. Non Tax Deductible   ', CAST(0.00000 AS NUMERIC(19, 5)), 8)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTTS        ', N'GST Excl. Taxable Supply       ', CAST(0.00000 AS NUMERIC(19, 5)), 9)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'P-GSTTSCAP     ', N'GST Exc.Taxable Supply-Capital ', CAST(0.00000 AS NUMERIC(19, 5)), 10)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTADJ      ', N'GST Incl. Adjustment           ', CAST(0.00000 AS NUMERIC(19, 5)), 11)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTFS       ', N'GST Incl. Free Supply          ', CAST(0.00000 AS NUMERIC(19, 5)), 12)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTIT       ', N'GST Incl. Input Taxed Supply   ', CAST(0.00000 AS NUMERIC(19, 5)), 13)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTNITD     ', N'GST Incl. - NITD               ', CAST(0.00000 AS NUMERIC(19, 5)), 14)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTTS       ', N'GST Incl. Taxable Supply       ', CAST(0.00000 AS NUMERIC(19, 5)), 15)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'PI-GSTTSCAP    ', N'GST Inc.Taxable Supply-Capital ', CAST(0.00000 AS NUMERIC(19, 5)), 16)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'S-GSTADJ       ', N'GST Excl. Adjustment           ', CAST(0.00000 AS NUMERIC(19, 5)), 17)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'S-GSTEX        ', N'GST Excl. Exports              ', CAST(0.00000 AS NUMERIC(19, 5)), 18)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'S-GSTFS        ', N'GST Excl. Free Supply          ', CAST(0.00000 AS NUMERIC(19, 5)), 19)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'S-GSTIT        ', N'GST Excl. Input Taxed Supply   ', CAST(0.00000 AS NUMERIC(19, 5)), 20)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'S-GSTTS        ', N'GST Excl. Taxable Supply       ', CAST(0.00000 AS NUMERIC(19, 5)), 21)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'SI-GSTADJ      ', N'GST Incl. Adjustment           ', CAST(0.00000 AS NUMERIC(19, 5)), 22)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'SI-GSTEX       ', N'GST Incl. Exports              ', CAST(0.00000 AS NUMERIC(19, 5)), 23)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'SI-GSTFS       ', N'GST Incl. Free Supply          ', CAST(0.00000 AS NUMERIC(19, 5)), 24)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'SI-GSTIT       ', N'GST Incl. Input Taxed Supply   ', CAST(0.00000 AS NUMERIC(19, 5)), 25)
GO
INSERT [dbo].[TX00101] ([TAXSCHID], [TXSCHDSC], [NOTEINDX], [DEX_ROW_ID])
	VALUES (N'SI-GSTTS       ', N'GST Incl. Taxable Supply       ', CAST(0.00000 AS NUMERIC(19, 5)), 26)
GO
SET IDENTITY_INSERT [dbo].[TX00101] OFF
GO
SET IDENTITY_INSERT [dbo].[TX00102] ON

GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTADJ       ', N'P-GSTADJ       ', 3, 0, 0, 1)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTADJ       ', 3, 0, 0, 2)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTFS        ', N'P-GSTFS        ', 3, 0, 0, 3)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTFS        ', 3, 0, 0, 4)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPCUST   ', N'P-GSTIMPCUST   ', 2, 0, 0, 5)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTIMPCUST   ', 2, 0, 0, 6)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPSUP    ', N'P-GSTIMPSUP    ', 3, 0, 0, 7)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTIMPSUP    ', 3, 0, 0, 8)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTIT        ', N'P-GSTIT        ', 3, 0, 0, 9)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTIT        ', 3, 0, 0, 10)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTNITD      ', N'P-GSTNITD      ', 3, 0, 0, 11)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTNITD      ', 3, 0, 0, 12)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTTS        ', N'P-GSTTS        ', 3, 0, 0, 13)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTTS        ', 3, 0, 0, 14)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'P-GSTTSCAP     ', N'P-GSTTSCAP     ', 3, 0, 0, 15)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'P-GSTTSCAP     ', 3, 0, 0, 16)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTADJ      ', N'PI-GSTADJ      ', 1, 0, 0, 17)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTADJ      ', 1, 0, 0, 18)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTFS       ', N'PI-GSTFS       ', 1, 0, 0, 19)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTFS       ', 1, 0, 0, 20)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTIT       ', N'PI-GSTIT       ', 1, 0, 0, 21)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTIT       ', 1, 0, 0, 22)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTNITD     ', N'PI-GSTNITD     ', 1, 0, 0, 23)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTNITD     ', 1, 0, 0, 24)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTTS       ', N'PI-GSTTS       ', 1, 0, 0, 25)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTTS       ', 1, 0, 0, 26)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'PI-GSTTSCAP    ', N'PI-GSTTSCAP    ', 1, 0, 0, 27)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-PURCHASES  ', N'PI-GSTTSCAP    ', 1, 0, 0, 28)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'S-GSTADJ       ', N'S-GSTADJ       ', 3, 0, 0, 29)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'S-GSTADJ       ', 3, 0, 0, 30)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'S-GSTEX        ', N'S-GSTEX        ', 3, 0, 0, 31)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'S-GSTEX        ', 3, 0, 0, 32)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'S-GSTFS        ', N'S-GSTFS        ', 3, 0, 0, 33)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'S-GSTFS        ', 3, 0, 0, 34)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'S-GSTIT        ', N'S-GSTIT        ', 3, 0, 0, 35)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'S-GSTIT        ', 3, 0, 0, 36)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'S-GSTTS        ', N'S-GSTTS        ', 3, 0, 0, 37)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'S-GSTTS        ', 3, 0, 0, 38)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'SI-GSTADJ      ', N'SI-GSTADJ      ', 1, 0, 0, 39)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'SI-GSTADJ      ', 1, 0, 0, 40)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'SI-GSTEX       ', N'SI-GSTEX       ', 1, 0, 0, 41)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'SI-GSTEX       ', 1, 0, 0, 42)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'SI-GSTFS       ', N'SI-GSTFS       ', 1, 0, 0, 43)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'SI-GSTFS       ', 1, 0, 0, 44)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'SI-GSTIT       ', N'SI-GSTIT       ', 1, 0, 0, 45)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'SI-GSTIT       ', 1, 0, 0, 46)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'SI-GSTTS       ', N'SI-GSTTS       ', 1, 0, 0, 47)
GO
INSERT [dbo].[TX00102] ([TAXSCHID], [TAXDTLID], [TXDTLBSE], [TDTAXTAX], [Auto_Calculate], [DEX_ROW_ID])
	VALUES (N'ALL-SALES      ', N'SI-GSTTS       ', 1, 0, 0, 48)
GO
SET IDENTITY_INSERT [dbo].[TX00102] OFF
GO
SET IDENTITY_INSERT [dbo].[TX00201] ON

GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTADJ       ', N'GST Excl. Adjustment           ', 2, 39, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00200000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 1)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTFS        ', N'GST Excl. Free Supply          ', 2, 39, N'           ', 3, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00050000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 2)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPCUST   ', N'GST Excl. Import Customs       ', 2, 39, N'           ', 2, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 3)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPSUP    ', N'GST Excl. Import Supplier      ', 2, 39, N'           ', 3, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00110000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 4)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTIT        ', N'GST Excl. Input Taxed          ', 2, 39, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 2, 0x00030000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 5)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTNITD      ', N'GST Excl. Non Tax Deductible   ', 2, 39, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 2, 0x00090000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 6)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTTS        ', N'GST Excl. Taxable Supply       ', 2, 39, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00110000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 7)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'P-GSTTSCAP     ', N'GST Exc.Taxable Supply-Capital ', 2, 39, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x80100000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 8)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTADJ      ', N'GST Incl. Adjustment           ', 2, 39, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00200000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 9)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTFS       ', N'GST Incl. Free Supply          ', 2, 39, N'           ', 1, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00050000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 10)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTIT       ', N'GST Incl. Input Taxed Supply   ', 2, 39, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 2, 0x00030000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 11)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTNITD     ', N'GST Incl. - NITD               ', 2, 39, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 2, 0x00090000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 12)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTTS       ', N'GST Incl. Taxable Supply       ', 2, 39, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x00110000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 13)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'PI-GSTTSCAP    ', N'GST Inc.Taxable Supply-Capital ', 2, 39, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x80100000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 14)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'S-GSTADJ       ', N'GST Excl. Adjustment           ', 1, 38, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x20000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 15)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'S-GSTEX        ', N'GST Excl. Exports              ', 1, 38, N'           ', 3, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x03000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 16)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'S-GSTFS        ', N'GST Excl. Free Supply          ', 1, 38, N'           ', 3, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x05000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 17)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'S-GSTIT        ', N'GST Excl. Input Taxed Supply   ', 1, 38, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x09000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 18)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'S-GSTTS        ', N'GST Excl. Taxable Supply       ', 1, 38, N'           ', 3, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x11000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 19)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'SI-GSTADJ      ', N'GST Incl. Adjustment           ', 1, 38, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x20000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 20)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'SI-GSTEX       ', N'GST Incl. Exports              ', 1, 38, N'           ', 1, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x03000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 21)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'SI-GSTFS       ', N'GST Incl. Free Supply          ', 1, 38, N'           ', 1, CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x05000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 22)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'SI-GSTIT       ', N'GST Incl. Input Taxed Supply   ', 1, 38, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x09000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 23)
GO
INSERT [dbo].[TX00201] ([TAXDTLID], [TXDTLDSC], [TXDTLTYP], [ACTINDX], [TXIDNMBR], [TXDTLBSE], [TXDTLPCT], [TXDTLAMT], [TDTLRNDG], [TXDBODTL], [TDTABMIN], [TDTABMAX], [TDTAXMIN], [TDTAXMAX], [TDRNGTYP], [TXDTQUAL], [TDTAXTAX], [TXDTLPDC], [TXDTLPCH], [TXDXDISC], [CMNYTXID], [NOTEINDX], [NAME], [CNTCPRSN], [ADDRESS1], [ADDRESS2], [ADDRESS3], [CITY], [STATE], [ZIPCODE], [COUNTRY], [PHONE1], [PHONE2], [PHONE3], [FAX], [TXUSRDF1], [TXUSRDF2], [VATREGTX], [TaxInvReqd], [TaxPostToAcct], [TaxBoxes], [IGNRGRSSAMNT], [TDTABPCT], [DEX_ROW_ID])
	VALUES (N'SI-GSTTS       ', N'GST Incl. Taxable Supply       ', 1, 38, N'           ', 1, CAST(15.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 2, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 0, 0, 1, N' ', 0, N'               ', CAST(0.00000 AS NUMERIC(19, 5)), N'                               ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                                             ', N'                                   ', N'                             ', N'           ', N'                                                             ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', N'                     ', 0, 0, 1, 0x11000000, 0, CAST(0.00000 AS NUMERIC(19, 5)), 24)
GO
SET IDENTITY_INSERT [dbo].[TX00201] OFF
GO
SET IDENTITY_INSERT [dbo].[TX00202] ON

GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTADJ       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 1)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTFS        ', CAST(119140.97000 AS NUMERIC(19, 5)), CAST(9371.51000 AS NUMERIC(19, 5)), CAST(118940.70000 AS NUMERIC(19, 5)), CAST(9371.51000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 2)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPCUST   ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 3)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTIMPSUP    ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 4)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTIT        ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 5)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTNITD      ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 6)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTTS        ', CAST(1386837.15000 AS NUMERIC(19, 5)), CAST(9278.51000 AS NUMERIC(19, 5)), CAST(1386837.15000 AS NUMERIC(19, 5)), CAST(9278.51000 AS NUMERIC(19, 5)), CAST(208024.04000 AS NUMERIC(19, 5)), CAST(1159.81000 AS NUMERIC(19, 5)), 1, 1, 7)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'P-GSTTSCAP     ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 8)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTADJ      ', CAST(-1728.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(-1728.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(-259.20000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 9)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTFS       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 10)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTIT       ', CAST(183353.14000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(183353.14000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(27502.98000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 11)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTNITD     ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 12)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTTS       ', CAST(76616987.39000 AS NUMERIC(19, 5)), CAST(1391672.32000 AS NUMERIC(19, 5)), CAST(76616987.39000 AS NUMERIC(19, 5)), CAST(1391672.32000 AS NUMERIC(19, 5)), CAST(11447275.05000 AS NUMERIC(19, 5)), CAST(204567.69000 AS NUMERIC(19, 5)), 1, 1, 13)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'PI-GSTTSCAP    ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 14)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'S-GSTADJ       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 15)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'S-GSTEX        ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 16)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'S-GSTFS        ', CAST(54091.35000 AS NUMERIC(19, 5)), CAST(422.50000 AS NUMERIC(19, 5)), CAST(54091.35000 AS NUMERIC(19, 5)), CAST(422.50000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 17)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'S-GSTIT        ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 18)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'S-GSTTS        ', CAST(109055793.52000 AS NUMERIC(19, 5)), CAST(2461814.71000 AS NUMERIC(19, 5)), CAST(109055793.52000 AS NUMERIC(19, 5)), CAST(2461814.71000 AS NUMERIC(19, 5)), CAST(16357998.30000 AS NUMERIC(19, 5)), CAST(358531.95000 AS NUMERIC(19, 5)), 1, 1, 19)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'SI-GSTADJ      ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 20)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'SI-GSTEX       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 21)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'SI-GSTFS       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 22)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'SI-GSTIT       ', CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), CAST(0.00000 AS NUMERIC(19, 5)), 1, 1, 23)
GO
INSERT [dbo].[TX00202] ([TAXDTLID], [TDTSYTD], [TDSLLYTD], [TXDTSYTD], [TDTSLYTD], [TXDSTYTD], [TDSTLYTD], [KPCALHST], [KPERHIST], [DEX_ROW_ID])
	VALUES (N'SI-GSTTS       ', CAST(-360689.37000 AS NUMERIC(19, 5)), CAST(930.57000 AS NUMERIC(19, 5)), CAST(-360689.37000 AS NUMERIC(19, 5)), CAST(930.57000 AS NUMERIC(19, 5)), CAST(-54354.49000 AS NUMERIC(19, 5)), CAST(137.89000 AS NUMERIC(19, 5)), 1, 1, 24)
GO
SET IDENTITY_INSERT [dbo].[TX00202] OFF
GO
