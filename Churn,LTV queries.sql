
------------------------------------- LTV
--- moving to CG from 2018-11-27
--- Total new users
select DATEDIFF(DAY, fromDate, getdate()) su, planid, count(*) totalsubcount from subscriptionhistory
where FromDate > '2018-4-10' and DATEDIFF(HOUR, fromdate, ISNULL(toDate, getdate())) > 24
group by  DATEDIFF(DAY, fromDate, getdate()), planid
--- Active users
select DATEDIFF(DAY, fromDate, ISNULL(toDate, getdate())), planid, count(*) from subscriptionhistory
where FromDate > '2018-4-10' and DATEDIFF(HOUR, fromdate, ISNULL(toDate, getdate())) > 24 and (ToDate IS NULL or FromDate > ToDate)
group by  DATEDIFF(DAY, fromDate, ISNULL(toDate, getdate())), planid

--- successul charge rate calculation
select cast(transactiondatetime as date), planid, count(distinct Msisdn) from TransactionArchive
where TransactionDateTime > '2018-10-10' -- and Result = 1 
group by cast(transactiondatetime as date), PlanId

--- instant churn rate, what percentage of new users unsubscribed in the first day
----instant churn
--- user's churn issue is resolved on 1st of july
select cast(fromdate as date), PlanId, count(*) unsubToday from SubscriptionHistory
where fromdate > '2018-10-10' and cast(fromdate as date) = cast(todate as date)
group by cast(fromdate as date), PlanId
--- new sub today 
select cast(fromdate as date), PlanId, count(*) newSubs from SubscriptionHistory
where fromdate > '2018-10-10'
group by cast(fromdate as date), PlanId
having count(*) > 90



select count(*) from SubscriptionHistory a
right join Subscription b
on a.msisdn = b.Msisdn and a.planid = b.planid
where a.id is null
--where a.ToDate is null and b.status != 1

select Msisdn from SubscriptionHistory
where todate is null
group by Msisdn, PlanId
having count(*) >1
--order by 2,3 

select EnterRequestId, count(1) from SubscriptionHistory
where Msisdn in (
select Msisdn from SubscriptionHistory
where todate is null
group by Msisdn, PlanId
having count(*) >1)
Group By EnterRequestId
Order By 2

select distinct Msisdn, planid from SubscriptionHistory


select * from SubscriptionChannel

select  cast(transactiondatetime as date), msisdn, count(*) from TransactionArchive
where PlanId = 5
 group by cast(transactiondatetime as date), Msisdn
 having count(*) > 1
 order by 1,3
