--1
select * from WCRRGroup R
inner join WCRRGroupLineUp RL on R.idfWCRRGroupKey=RL.idfWCRRGroupKey
inner join WCLineUp WC on RL.idfWCLineUpKey=WC.idfWCLineUpKey
where r.idfFlagInternal=1

--2
Select idfRQHeaderKey,* from RQDetail where idfWCLineUpKey=<<WCLINEUPKEY>> and idfRQSessionKey<>170


--3
Select idfWCLineUpKey,idfRCVHeaderKey,* from RCVDetail where idfWCLineUpKey=<<WCLINEUPKEY>>-- from first results

--4
Delete from WCRRGroupLineUp where idfWCRRGroupLineUpKey=<<WCRRGROUPLINEUPKEY>> -- from first results
Delete from WCRRGroup where idfWCRRGroupKey=<<WCRRGROUPKEY>>-- from first results
Delete from WCLineUp where idfWCLineUpKey=<<WCLINEUPKEY>>-- from first results