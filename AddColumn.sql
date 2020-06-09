EXEC dbo.spPTIAddColumn 'EXPExpenseSheetDtl', 'idfRateHome' ,'numeric(19,5)', 'DEFAULT 0',0,1

EXEC dbo.spPTIAddColumn 'RCVDetail', 'edfTaxScheduleSource' ,'numeric(19,5)', 'DEFAULT 0',0,1
EXEC dbo.spPTIAddColumn 'RCVDetail', 'edfTaxScheduleItem' ,'numeric(19,5)', 'DEFAULT 0',0,1
EXEC dbo.spPTIAddColumn 'RCVDetail', 'edfTaxSchedulePurch' ,'numeric(19,5)', 'DEFAULT 0',0,1