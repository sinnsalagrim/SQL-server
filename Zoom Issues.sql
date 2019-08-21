--- App = 0, landing = 1, Sabacell = 2, table -> core
select agent, count(*) from SubscriptionHistory
group by Agent

--- table -> core
select Agent, count(*) from SubscriptionHistory
where IsActive = 0 and InsertDateTime > '2018-05-30'
group by Agent

/*
charging = first charging
renewal = renewals
retry renewal = retries on renewal
retry subscribe = retry the first charging 
*/
--- users are unsubscribed with a short distance with unsufficient balance/charge failure
select DATEDIFF(SECOND, R.InsertDateTime, S.InsertDateTime), count(*) from SubscriptionHistory S
left join [Transaction] T On S.Msisdn = T.Msisdn and S.AppId = T.AppId and cast(S.InsertDateTime as date) = cast(T.InsertDateTime as date)
left join TransactionResult R on T.Id = R.TransactionId
where S.IsActive = 0 and S.Agent = 0 and S.AppId = 2 and R.ResponseCode = '3601'
group by DATEDIFF(SECOND, R.InsertDateTime, S.InsertDateTime)
Order by 1


--- table -> core
--- does not sending status update to zoom makes a difference in unsubscription rate?
select cast(todate as date), count(*) from SubscriptionHistory
where PlanId = 6 and UnSubscriptionChannel = 200 --and todate >'2018-05-30' and cast(ToDate as time) between '10:45:55.0466667' and '14:45:55.0466667'
group by cast(todate as date)
order by 1 desc

--- table -> MTNPayment
--- does not sending status update to zoom makes a difference in unsubscription rate?
select datepart(hour,todate), count(*) from SubscriptionHistory
where PlanId = 6  and UnSubscriptionChannel = 200 and cast(ToDate as date) = '2018-07-04'
--and todate >'2018-05-30' and cast(ToDate as time) between '10:45:55.0466667' and '14:45:55.0466667'
group by datepart(hour,todate)
order by 1 desc


select * from SubscriptionHistory
where Msisdn = '989371908067'
order by todate desc

select cast(todate as date), UnSubscriptionChannel, count(*) from SubscriptionHistory
where PlanId = 6 and cast(ToDate as date) > '2018-07-03'
--and todate >'2018-05-30' and cast(ToDate as time) between '10:45:55.0466667' and '14:45:55.0466667'
group by cast(todate as date), UnSubscriptionChannel
order by 1 desc
