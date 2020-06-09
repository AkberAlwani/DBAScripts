begin tran
select 'BF HDR' status,*  from EXPExpenseSheetHdrHist where idfEXPExpenseSheetHdrHistKey=666
select 'BF DTL' status,* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=666
select 'BF TAX' status,* from EXPExpenseSheetDtlTaxHist et
inner join EXPExpenseSheetDtlHist ed on et.idfEXPExpenseSheetDtlHistKey=ed.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=666
select 'BF SPLIT' status,* from EXPExpenseSheetDtlSplitHist es
inner join EXPExpenseSheetDtlHist ed on es.idfEXPExpenseSheetDtlHistKey=ed.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=666

update EXPExpenseSheetDtl set idfEXPSessionKey=170 where idfEXPExpenseSheetHdrKey=666
select 'AF HDR' status,*  from EXPExpenseSheetHdrHist where idfEXPExpenseSheetHdrHistKey=666
select 'AF DTL' status,* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=666
select 'AF TAX' status,* from EXPExpenseSheetDtlTaxHist et
inner join EXPExpenseSheetDtlHist ed on et.idfEXPExpenseSheetDtlHistKey=ed.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=666
select 'AF SPLIT' status,* from EXPExpenseSheetDtlSplitHist es
inner join EXPExpenseSheetDtlHist ed on es.idfEXPExpenseSheetDtlHistKey=ed.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=666
commit tran
