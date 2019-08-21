--- check if there is a big unsubscription
SELECT CAST(InActiveDateTime AS DATE) , COUNT(*) FROM dbo.Subscription
WHERE InActiveDateTime > '2019-05-01' AND CAST(InActiveDateTime AS DATE) != CAST(ActivateDateTime AS DATE) 
GROUP BY CAST(InActiveDateTime AS DATE) 
ORDER BY 1 DESC

--- how many new users added
SELECT CAST(ActivateDateTime AS DATE), COUNT(*) FROM dbo.Subscription
WHERE ActivateDateTime > '2019-05-01'
GROUP BY  CAST(ActivateDateTime AS DATE)

--- check the income 
SELECT CAST(ChargeDateTime AS DATE),  COUNT(DISTINCT TransactionId) FROM dbo.Charging
WHERE ChargeDateTime > '2019-05-20' AND MciStatus = 0
GROUP BY CAST(ChargeDateTime AS DATE)

--------- percentage of charged subscribed users
--- number of Active users on each day
SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate 
INTO #cleanSub FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate

SELECT c.cdate, cs.appIds, cs.Msisdn FROM   
(SELECT DISTINCT CAST(ActivateDateTime AS DATE) cdate FROM dbo.Subscription) c
LEFT join
#cleanSub cs
ON cs.fromDate < c.cdate AND ISNULL(cs.toDate, GETDATE()) > c.cdate
GROUP BY c.cdate, cs.appIds, cs.Msisdn

---- chargings per hour on each day
SELECT  CAST(chargedatetime AS DATE), DATEPART(HOUR, ChargeDateTime) AS zeit, COUNT(DISTINCT TransactionId) FROM dbo.Charging
WHERE CAST(ChargeDateTime AS DATE) = '2019-05-30'
GROUP BY   CAST(chargedatetime AS DATE),DATEPART(HOUR, ChargeDateTime)




