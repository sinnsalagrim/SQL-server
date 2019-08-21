--- unsub today channel
select PlanId, UnSubscriptionChannel, count(*) from SubscriptionHistory
where cast(FromDate as date) = cast(todate as date)  and ToDate > '2018-05-29'
group by PlanId, UnSubscriptionChannel

--unsub channels general
select PlanId, UnSubscriptionChannel, count(*) from SubscriptionHistory
where ToDate > '2018-07-20'
group by PlanId, UnSubscriptionChannel

--- MTN SLA on our side - 4 times charging limitation
--- 3442 and 3335 in error description are the codes for more than 4 times charging
--- start time : 5 first retry: 9 intervals: 6h
select msisdn, count(*) from TransactionArchive
where FaultDesc like '%3442.' and TransactionDateTime > '2018-07-18'
group by  Msisdn
order by 2 desc

--- double in subscription table that causes double charge
select Msisdn, PlanId, count(*) from subscription 
group by Msisdn, PlanId
HAVING count(*) > 1
order by 1, 3 desc

---Churning from MTN
/*
3334: reached the daily try request
3335: reached the daily charging request
3312: user is not exist or unsubscribed
*/
select msisdn, planid, count(*) from TransactionArchive
where FaultDesc like '%3312.' and TransactionDateTime > '2019-01-01'
group by  Msisdn, PlanId

--- MTN response 
select * from Subscription
where Msisdn = '989352000483'

--- My account
--- august 2018, 82200 toman tasvie kardam 
select sum(Amount) from [TransactionArchive]
where Msisdn = '989359053957'  and result = 1--and planid = 8


--- double charging check 
select cast(transactiondatetime as date),planid,  Msisdn, count(*) from TransactionArchive
where TransactionDateTime > '2019-04-01' and Result = 1
group by cast(transactiondatetime as date),planid,  Msisdn
having count(*) > 1
order by 1 desc

--- No user with 989411 prefix must be in your list
select * from Subscription
where Msisdn like '989411%' and ModifiedDateTime > '2018-06-27'





select top 1000 * from Subscription where FailureReason is not null Msisdn = '989356250712'
select * from SubscriptionHistory where Msisdn = '989392657493' order by ToDate desc

select planid, count(distinct msisdn) from transactionarchive
where  cast(TransactionDateTime as date) = '2018-07-23' -- and Msisdn = '989356250712'
group by planid



select max(ChargeDateTime) from charging






