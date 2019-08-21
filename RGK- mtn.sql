select top 10 * from TransactionArchive

select top 10 * from subscriptionhistory
where msisdn = '989354785503' and enterrequestid = '00003892775890'

select * from TransactionArchive
where msisdn = '989034252863' and planid = 5 and referekey = '38788882-78f1-5177-7434-25017fffffff'

select faultcode, faultdesc, count(*) from TransactionArchive
where planid = 5 and transactiondatetime > '2018-02-05' 
group by FaultCode, faultdesc

select cast(transactiondatetime as date), count(*) from TransactionArchive
where PlanId = 5  and TransactionDateTime > '2017-12-01'
group by cast(transactiondatetime as date)
order by 1 desc


