------- VOD requested report 

--- How many of sers who came on day x are still active on day y
--------------- zoom
select CAST(FromDate as date), DATEDIFF(day, FromDate, isnull(todate, getdate())), count(*)
from Subscriptionhistory
where PlanId = 6
group by CAST(FromDate as date), DATEDIFF(day, FromDate, isnull(todate, getdate()))

-------------- kanape
--- calculate the unsubscripted users on each day after subscription
select CAST(ActivateDateTime as date), DATEDIFF(day, ActivateDateTime, isnull(InActiveDateTime, getdate())), count(*)
from Subscription
where AppId = 1119 AND ActivateDateTime > '2018-12-22'
group by CAST(ActivateDateTime as date), DATEDIFF(day, ActivateDateTime, isnull(InActiveDateTime, getdate()))
order by 3 DESC


--- calculate how many of the users who came on week x are charged on yth week after subscription
select  DATEPART(WEEK, s.fromDate) activatedWeek, DATEDIFF(WEEK, s.fromDate, c.ChargeDateTime) xthWeek, count(DISTINCT c.TransactionId) transactionNumber FROM
(
SELECT D.Msisdn msisdn, D.appIds appId, MIN(D.fromDate) fromDate, D.toDate toDate FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate FROM
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1 AND AppId = 1119) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0 AND AppId = 1119) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate 
) s

LEFT JOIN 

charging c
ON s.msisdn = c.msisdn AND s.appid = c.appid AND s.fromDate < c.chargedatetime AND C.ChargeDateTime < S.toDate
where s.fromDate > '2018-12-22' AND c.MciStatus = 0
--- DATEPART(YEAR, s.fromDate), DATEPART(MONTH, s.fromDate),
group BY  DATEPART(WEEK, s.fromDate), DATEDIFF(WEEK, s.fromDate, c.ChargeDateTime)


--- Seddigh
DECLARE @AppId INT
SET @AppId = 1119

SELECT DATEDIFF(DAY, S.fromDate, C.ChargeDateTime), COUNT(DISTINCT C.TransactionId) from
(SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1 AND AppId = @AppId) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0 AND AppId = @AppId) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate) S
LEFT JOIN dbo.Charging C 
ON S.Msisdn = C.Msisdn AND S.appIds = C.AppId AND C.ChargeDateTime < S.toDate AND C.ChargeDateTime > S.fromDate
--WHERE C.MciStatus = 0
GROUP BY DATEDIFF(DAY, S.fromDate, C.ChargeDateTime)

----- end of kanape








--- How many of the users who came on day x are charged on day y

select cast(sh.fromdate as date), DATEDIFF(day, FromDate, isnull(todate, getdate())), count(1) from Subscriptionhistory sh
left join
TransactionArchive ta
on ta.msisdn = sh.msisdn
where ta.planid = 6 and sh.PlanId = 6 --- and Result = 1
group by cast(sh.fromdate as date), DATEDIFF(day, FromDate, isnull(todate, getdate()))



select DATEPART(week, cs.activateddatetime) , DATEPART(week, o.InsertDateTime), count(1) from customerinvitation CI
left join
Gatewayv2..CustomerSubServiceSubscription CS
on ci.CustomerId = cs.CustomerId and cs.SubServiceId = 62

left join

GatewayV2..OutboundLog O
on ci.CustomerId =  o.Destination and o.ServiceId = 35 and o.IsDelivered = 1
where cs.activateddatetime > '2016-09-04'
group by DATEPART(week, cs.activateddatetime) , DATEPART(week, o.InsertDateTime)
