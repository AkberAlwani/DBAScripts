Company/System Tables
      74 Votes

Commonly Used Tables – Company databases:
CO00101 – Document Attachment Master
CO00102 – Document Attachment Reference
SY00500 – Batch Master
SY00600 – Location/Address Master
SY01100 – Company Posting Account Master
SY01200 – Internet Addresses
SY01401 – User Defaults
SY02200 – Posting Journal Destinations
SY02300 – Posting Settings
SY03000 – Shipping Methods Master
SY03100 – Credit Card Master
SY03300 – Payment Terms Master
SY03900 – Record Notes Master
SY04200 – Comment Master
SY40100 – Period Setup
SY40101 – Period Header
TX00101 – Tax Schedule Header Master (header)
TX00102 – Tax Schedule Master (detail)
TX00201 – Tax Detail Master
TX30000 – Tax History

Commonly Used Tables – System (DYNAMICS) database:
ACTIVITY – User Activity
SY003001 – Account Definition Header
SY00302 – Account Definition Detail
SY00800 – Batch Activity
SY00801 – Resource Activity
SY01400 – Users Master
SY01402 – System User Defaults
SY01403 – User Tasks (Reminders)
SY01404 – Customer Reminders Setup
SY01500 – Company Master
SY01990 – Shortcut Bar Master (Navigation Pane Shortcuts)
SY60100 – User Access

Security Tables in GP 10.0 and higher – System (DYNAMICS) database:
SY09000 – Task master
SY09100 – Role master
SY09200 – Alternate or modified form and report ID master
SY10500 – Role assignment master
SY10550 – DEFAULTUSER task ID assignment master
SY10600 – Tasks assignments master
SY10700 – Operations assignments master
SY10750 – DEFAULTUSER task assignment
SY10800 – Alternate or modified form and report ID assignment master

Email Tables (in GP 2010 and higher)
SY04900 – Email Options
SY04901 – Email Messages
SY04902 – Email Series Setup
SY04903 – Email Series Documents
SY04904 – Email Card Setup
SY04905 – Email Card Documents
SY04910 – Email Details
SY04911 – Email Temp
SY04912 – Email Attachment Temp
SY04915 – Email History

Document Attach Tables
CO40100 – Document Attachment Setup
CO00101 – Document Attachment Master
CO00102 – Document Attachment Reference
CO00103 – Document Attachment Properties
CO00104 – Document Attachment Status
CO00105 – Document Attachment E-mail

Official list of BCHSTTUS (Batch Status) in SY00500:
0 – Available
1 – Marked to Post
2 – Available / Delete
3 – Marked / Receive
4 – Marked
5 – Marked / Print
6 – Marked / Update
7 – Posting Interrupted
8 – Journal Printing Interrupted
9 – Table Updates Interrupted
10 – Recurring Batch Error – Edit Required
11 – Single Use Error – Edit Required
15 – Computer Check Posting Error
110 – Checks Printing (this is the status you will see for a computer check batch after the checks are printed)
130 – Remittance Processing

Francisco’s list of BCHSTTUS (Batch Status) in SY00500:
[This is a much more comprehensive list posted by Francisco Hillyer in a GP Newsgroup – provided courtesy of e-mail by Robert Cavill – thanks Robert and Francisco!] 
0 – Available
1 – Batch Posting
2 – Batch Being Deleted
3 – Batch Receiving Transactions
4 – Batch Done Posting
5 – Being Printed
6 – Being Updated
7 – Interrupted While Posting
8 – Interrupted While Printing
9 – Interrupted While Updating
10 – Recurring Batch Errors / Transactions Did Not Post
11 – Single Batch Error / Transactions Did Not Post
15 – Error While Posting Computer Checks
20 – Interrupted While Processing Computer Checks
25 – Interrupted While Printing Computer Checks Align
30 – Interrupted While Printing Computer Checks
35 – Interrupted While Printing Computer Checks Align Before Reprint Computer Checks
40 – Interrupted While Voiding Checks
45 – Interrupted While Reprinting Checks
50 – Interrupted While Processing Remittance Report
55 – Interrupted While Processing Remittance Report Align
60 – Interrupted While Printing Remittance Report
100 – Processing Computer Checks
105 – Check Align Being Printed Before Print Checks
110 – Printing Computer Checks
115 – Check Align Being Printed Before Reprint Checks
120 – Voiding Computer Checks
125 – Reprint Computer Checks
130 – Remittance Report
135 – Printing Remittance Align Form
140 – Printing Remittance Form

Series (in most tables):
1 – All
2 – Financial
3 – Sales
4 – Purchasing
5 – Inventory
6 – Payroll
7 – Project
10 – 3rd Party

Series in TX30000 table:
1 – SOP
2 – Invoicing
3 – Sales (RM)
4 – Purchasing (PM)
5 – General Ledger
12 – POP

BACHFREQ (Batch Frequency):
1 – Single Use
2 – Weekly
3 – Biweekly
4 – Semimonthly
5 – Monthly
6 – Bimonthly
7 – Quarterly
8 – Miscellaneous

MODULE1 in Email Tables:
9 – Receivables Management
11 – Sales Order Processing
12 – Purchase Order Processing
19 – Payables Management

EmailDocumentID in Email Tables:
Module 9 – Receivables Management
1 – Invoice
3 – Debit Memo
4 – Finance Charge
5 – Service/Repair
6 – Warranty
7 – Credit Memo
8 – Return
10 – Customer Statement

Module 11 – Sales Order Processing
1 – Quote
2 – Order
3 – Invoice
4 – Return
6 – Fulfillment Order

Module 12 – Purchase Order Processing
1 – Purchase Order

Module 19 – Payables Management
6 – Remittance

EmailDocumentFormat in Email Tables:
1 – DOCX
2 – HTML
3 – PDF
4 – XPS