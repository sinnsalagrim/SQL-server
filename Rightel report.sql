select top 10 * from subscription
select top 10 * from SubscriptionHistory
select top 10 * from payment
select * from app

------ repetative user will be included
------ #subscription per day
select cast(FromDate as date), a.Name, count(*) from SubscriptionHistory s
left join [app] a
on s.AppId = a.Id
where Msisdn Not in (989223763286, 989200400445, 989219604661) 
group by  cast(FromDate as date), a.Name

----- # unsubscription
select cast(todate as date), a.Name, count(*) from SubscriptionHistory s
left join [app] a
on s.AppId = a.Id
where Msisdn Not in (989223763286, 989200400445, 989219604661) and FromDate<ToDate and todate is not NULL
group by  cast(ToDate as date), a.Name

----- # unsub today
select cast(todate as date), a.Name, count(*) from SubscriptionHistory s
left join [app] a
on s.AppId = a.Id
where Msisdn Not in (989223763286, 989200400445, 989219604661) and cast(fromdate as date) = cast(todate as date) 
group by  cast(ToDate as date), a.Name

---- # payment
select cast(paymentdatetime as date), a.Name, sum(amount) from payment s
left join [app] a
on s.AppId = a.Id
where s.status = 1 
group by cast(paymentdatetime as date), a.Name

----- # active users
select a.Name, count(*) from   Subscription s
left JOIN [app] a
on s.AppId = a.Id
where s.Status = 1 and s.Msisdn Not in (989223763286, 989200400445, 989219604661)
group by a.Name

----- # total users
select a.Name, count(*) from  Subscription s
left join [app] a
on s.AppId = a.Id
where s.Msisdn Not in (989223763286, 989200400445, 989219604661)
group by a.Name 



select  * from Subscription
where Msisdn = '989219604661' and appid = 2
select * from SubscriptionHistory
where Msisdn = '989219604661' and appid = 2
order by FromDate desc



-----


