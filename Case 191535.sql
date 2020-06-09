begin tran
--update GLAccount  set idfEAICLink='BRAND13187'  where idfGLAccountKey=11714
--update GLAccount  set idfEAICLink='BRAND13186',idfDescription='Digital-Display-Brand USA-Affinit-Partner- -Canada '  where idfGLAccountKey=7978
select  * from GLAccount where idfGLID in ('6313-65-623-725-00000-CA','6313-66-622-720-00000-CA') --13035BRAND,9297BRAND
select * from GLACcount where idfEAICLink like '%13186%' or  idfEAICLink  like '%13187%'
rollback tran

select * from BRAND..GL00105 where ACTNUMST in ('6313-65-623-725-00000-CA','6313-66-622-720-00000-CA') --13186,13187
select * from GLAccount where idfGLID in ('6313-65-623-725-00000-CA','6313-66-622-720-00000-CA') --13035BRAND,9297BRAND

select * from GLACcount where idfEAICLink like '%13186%' or  idfEAICLink  like '%13187%'
select * from BRAND..GL00100 where ACTINDX in (13186,13187)

select * from BRAND..GL00105 where ACTINDX in (13186,13187)

select * from BRAND..GL00100 where ACTINDX in (13035,9297,70)

select * from GLJournalDtl where idfGLAccountKey in (7978,11714) --44551(7978) 2nd 44552(11714)
--UPDATE GLJournalDtl SET idfGLAccountKey=7978 WHERE idfGLJournalDtlKey=44551
--UPDATE GLJournalDtl SET idfGLAccountKey=11714 WHERE idfGLJournalDtlKey=44552

--UPDATE PAPhaseActivity SET idfGLACase 191535ccountKeyExpense=7978 WHERE idfPAPhaseActivityKey=5117
--UPDATE PAPhaseActivity SET idfGLAccountKeyExpense=11714 WHERE idfPAPhaseActivityKey=5116

select * from PAPhaseActivity where idfGLAccountKeyExpense in (7978,11714) --5117(7978),, 5116(11714)
select * from POAprDtlDistribution where idfGLAccountKey in (7978,11714) 

update WPEAICLog set idfAction='UPDATE' where idfTableName='GL00100' and idfPKNewValue01 in ('13186','13187')