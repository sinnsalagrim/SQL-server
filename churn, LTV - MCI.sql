--- number of unsubscribe today
select cast(ActivateDateTime as date), appid, count(*) from Subscription
where cast(ActivateDateTime as date) = cast(InActiveDateTime as date)
group by cast(ActivateDateTime as date) , AppId

--- number of new users
select cast(ActivateDateTime as date), AppId, count(*) from Subscription
--where ActivateDateTime > '2017-06-01'
group by cast(ActivateDateTime as date), AppId

------------------- make a pairwise clean table
--- make a table on RAM 
-- you need to run the whole code together
SET ANSI_WARNINGS OFF
GO

Declare @t table (Msisdn VARCHAR(50) ,Appid INT,  SubDate DATETIME, UnsubDate DATETIME )

INSERT INTO @t(Msisdn,Appid, SubDate, UnsubDate)

select D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate  FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate FROM
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate

SELECT TOP 10 * FROM @t

--------- make a temp table in sql server and then delete it when you are done with it 
SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate 
INTO #cleanSub FROM
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate

--- adding status column
ALTER TABLE #cleanSub
ADD [Status] INT
UPDATE #cleanSub
SET [Status] = CASE WHEN toDate IS NOT NULL THEN 0 ELSE 1 END

-- delete the table
DROP TABLE #cleanSub;
SELECT TOP 10 * FROM #cleanSub


--- parwise table code
select D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate

--- life time final query 
select DATEDIFF(DAY, c.fromDate, GETDATE()), C.AppIds, count(*) from
(
select D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
Group By D.Msisdn, D.appIds, D.toDate
) C
where Isnull(DATEDIFF(DAY, c.fromdate, c.toDate), 2) >= 1
group by  DATEDIFF(DAY, fromdate, GETDATE()), c.appIds
order by 1 asc

--- still subscribed
select DATEDIFF(DAY, c.fromDate, GETDATE()), C.AppIds, count(*) from
(
select D.Msisdn, D.appIds, MIN(D.fromDate) fromDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
where D.toDate is null
Group By D.Msisdn, D.appIds
) C
group by  DATEDIFF(DAY, fromdate, GETDATE()), c.appIds
order by 1 asc

---- still subscribed 
select DATEDIFF(DAY, activatedatetime, GETDATE()), AppId, count(*) from subscription
where Status = 1 --and datediff(DAY, activatedatetime, GETDATE()) > 1
group by DATEDIFF(DAY, activatedatetime, GETDATE()), AppId


--------------------------------------------------------LTV kanape
---LTV kanape
--- HE is disabled from 2018-02-24
--- Total new users
select DATEDIFF(DAY, c.fromDate, GETDATE()), c.appIds, count(*) from 
(
select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B     
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
where  a.InsertDateTime > '2018-02-24' 
group by A.msisdn, A.AppId, A.InsertDateTime
) C
where DATEDIFF(HOUR, c.fromdate, ISNULL(c.toDate, getdate())) > 24
 --- or (DATEDIFF(HOUR, c.fromDate,getdate())>24 and c.toDate IS NULL)
group by  DATEDIFF(DAY, fromdate, GETDATE()),c.appIds
order by 1 asc

---LTV kanape 
--- Active users
select DATEDIFF(DAY, c.fromDate, GETDATE()), c.appIds, count(*) from 
(
select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B     
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
where  a.InsertDateTime > '2018-02-24'
group by A.msisdn, A.AppId, A.InsertDateTime
) C
where (DATEDIFF(HOUR, c.fromdate, ISNULL(c.toDate, getdate())) > 24)
and (c.todate IS NULL or c.fromDate > c.toDate)
 --- or (DATEDIFF(HOUR, c.fromDate,getdate())>24 and c.toDate IS NULL)
group by  DATEDIFF(DAY, fromdate, GETDATE()), c.appIds
order by 1 asc

-- success rate calculation - 
select cast(chargedatetime as date), appid, count(DISTINCT TransactionId) successCount from Charging
where MciStatus = 0 and ChargeDateTime > '2019-04-13'
group by  cast(chargedatetime as date), appid


--- churn rate calculation
select CAST(activatedatetime as date), appid, count(*) from Subscription
where ActivateDateTime > '2019-04-12'
	AND cast(activatedatetime as date) = cast(InActiveDateTime as date) 
group by CAST(activatedatetime as date), AppId
	HAVING count(*) > 50
-------------------------------------------------------------------------------------------------- end of LTV kanape