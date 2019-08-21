------------------------------------------------ success charging calculation based on MCI total chargings
DECLARE @AppId INT
SET @AppId = 1141

SELECT DATEDIFF(DAY, S.fromDate, C.ChargeDateTime) xthDay, s.appids, COUNT(DISTINCT C.TransactionId) chargingCount from
(SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1 AND InsertDateTime < '2019-01-02') A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0 ) B

on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate) S
LEFT JOIN dbo.Charging C 
ON S.Msisdn = C.Msisdn AND S.appIds = C.AppId AND C.ChargeDateTime < S.toDate AND C.ChargeDateTime > S.fromDate
WHERE C.MciStatus = 0
GROUP BY  DATEDIFF(DAY, S.fromDate, C.ChargeDateTime), S.appids

-------------------------------------------------- calculating active users on each date
SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate 
INTO #cleanSub FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate

SELECT c.cdate, cs.appIds, COUNT(*) FROM   
(SELECT DISTINCT CAST(ActivateDateTime AS DATE) cdate FROM dbo.Subscription) c
LEFT join
#cleanSub cs
ON cs.fromDate < c.cdate AND ISNULL(cs.toDate, GETDATE()) > c.cdate
GROUP BY c.cdate, cs.appIds

------------------------ delete the temp table
DROP TABLE #cleanSub;
SELECT TOP 10 * FROM #cleanSub


----------------------------------------- success charging calculation based on Active user's count
--- wie vielen users are subscribed on day xth from subscription - compare it with total charging sent on day xth of subscription
SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate 
INTO #cleanSub FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate


SELECT DATEDIFF(DAY, cs.fromDate, c.cdate), cs.appIds, COUNT(*) FROM
(SELECT DISTINCT CAST(insertDateTime AS DATE) cdate FROM dbo.Subscriptionhistory) c
LEFT join
#cleanSub cs
ON cs.fromDate < c.cdate AND ISNULL(cs.toDate, GETDATE()) > c.cdate
GROUP BY DATEDIFF(DAY, cs.fromDate, c.cdate), cs.appIds



------ active users on each day with finals 

DECLARE @AppId INT
SET @AppId = 1119

SELECT c.cdate, cs.appIds, COUNT(*) FROM   
(SELECT DISTINCT CAST(ActivateDateTime AS DATE) cdate FROM dbo.Subscription) c
LEFT join
(SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
       (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = @AppId) A
               left join
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = @AppId) B
               on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
           group by A.msisdn, A.AppId, A.InsertDateTime) D
       Group By D.Msisdn, D.appIds, D.toDate) cs
ON cs.fromDate < c.cdate AND ISNULL(cs.toDate, GETDATE()) > c.cdate
GROUP BY c.cdate, cs.appIds



