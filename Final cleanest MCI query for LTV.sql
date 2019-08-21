------------------------------------------------------ creating allSubHistory
/*
--- last update ---> 24 june
Insert Into AllSubHistory
select C2.Msisdn, 1142, 1, C2.ChargeDateTime from Charging C1
full join Charging C2
On C1.AppId = C2.AppId and C1.Msisdn = C2.Msisdn and DATEDIFF(day, C1.ChargeDateTime, C2.ChargeDateTime) between 1 and 3
where C1.Id is null and C2.ChargeDateTime > '2018-02-01' and C2.ChargeDateTime < '2019-06-13' and C2.AppId = 1142

Insert Into AllSubHistory
select C1.Msisdn, 1142, 0, C1.ChargeDateTime from Charging C1
full join Charging C2
On C1.AppId = C2.AppId and C1.Msisdn = C2.Msisdn and DATEDIFF(day, C1.ChargeDateTime, C2.ChargeDateTime) between 1 and 3
where C2.Id is null and C1.ChargeDateTime > '2018-02-01' and C1.ChargeDateTime < '2019-06-13' and C1.AppId = 1142

Insert into AllSubHistory select Msisdn, AppId, IsActive, InsertDateTime from SubscriptionHistory where AppId = 1142 and InsertDateTime < '2018-02-01'

Insert into AllSubHistory select Msisdn, AppId, IsActive, InsertDateTime from SubscriptionHistory where AppId = 1142 and InsertDateTime > '2019-06-01'

Insert Into AllSubHistory
    select S.Msisdn, 1142, 0, '2018-02-01' from
        (SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
                    (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
                        (select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1 AND AppId = 1142) A
                            left join
                        (select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0 AND AppId = 1142) B
                            on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
                        group by A.msisdn, A.AppId, A.InsertDateTime) D
                    Group By D.Msisdn, D.appIds, D.toDate) S
            left join (Select * from Charging where ChargeDateTime between '2018-02-01' and '2018-02-04') C
                on C.Msisdn=S.Msisdn and C.AppId = S.appIds
            where S.fromDate < '2018-02-01' and (S.toDate > '2018-02-01' or S.toDate is null) and C.Id is null

*/


----------------------------------------- chargings
--- Wednesday 17 April, 28 farvardin - MCI had SOME changes -> makes a lap on the chart
DECLARE @AppId INT
SET @AppId = 1119

---- total charging
select DATEDIFF(day, S.fromDate, SH.DT) AS day, count(*) AS TotalCount FROM
(select distinct cast(InsertDateTime as date) DT from SubscriptionHistory) SH
left join
(SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
                    (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = @AppId) A
                            left join
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = @AppId) B
                            on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
                        group by A.msisdn, A.AppId, A.InsertDateTime) D
                    Group By D.Msisdn, D.appIds, D.toDate) S
            On S.fromDate < SH.DT and ISNULL(S.toDate, getdate()) > SH.DT
			WHERE sh.DT > '2018-02-01'
    Group By DATEDIFF(day, S.fromDate, SH.DT)
	--, DATEPART(MONTH, S.fromDate) AS [Month], DATEPART(YEAR, S.fromDate) AS [Year]


--- success count charging

SELECT DATEDIFF(DAY, S.fromDate, C.ChargeDateTime) AS [Day], COUNT(DISTINCT C.TransactionId) AS SuccessCount from
   (SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
       (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = @AppId) A
               left join
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = @AppId) B
               on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
           group by A.msisdn, A.AppId, A.InsertDateTime) D
       Group By D.Msisdn, D.appIds, D.toDate) S
       LEFT JOIN dbo.Charging C
       ON S.Msisdn = C.Msisdn AND S.appIds = C.AppId AND C.ChargeDateTime <= ISNULL(S.toDate, getdate()) AND C.ChargeDateTime >= S.fromDate
       WHERE C.ChargeDateTime > '2018-02-01' and C.MciStatus = 0
   GROUP BY DATEDIFF(DAY, S.fromDate, C.ChargeDateTime)
   ---, DATEPART(MONTH, S.fromDate)  AS [Month], DATEPART(YEAR, S.fromDate) AS [Year]

--------------------------------------------- subscription
--- life time final query 
SELECT DATEDIFF(DAY, c.fromDate, GETDATE()) Day, C.AppIds, count(*) totalSub FROM
(
   SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
                    (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = 1119) A
                            left join
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = 1119) B
                            on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
                        group by A.msisdn, A.AppId, A.InsertDateTime) D
                    Group By D.Msisdn, D.appIds, D.toDate ) C
where Isnull(DATEDIFF(DAY, c.fromdate, c.toDate), 2) >= 1
group by  DATEDIFF(DAY, fromdate, GETDATE()), c.appIds
order by 1 ASC

--- still subscribed
select DATEDIFF(DAY, c.fromDate, GETDATE()) day, C.AppIds, count(*) activeSub from
(
select D.Msisdn, D.appIds, MIN(D.fromDate) fromDate from
(select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from

(select  msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND Appid = 1119) A
left join
(select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND appid = 1119) B
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime) D
where D.toDate is null
Group By D.Msisdn, D.appIds
) C
group by  DATEDIFF(DAY, fromdate, GETDATE()), c.appIds
order by 1 ASC

------------------------- Model evaluation
--- success charging count real and model
--- Model
SELECT CAST(S.fromDate AS date), COUNT(DISTINCT S.Msisdn) from
(SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
                    (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = 1119) A
                            left join
                        (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = 1119) B
                            on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
                        group by A.msisdn, A.AppId, A.InsertDateTime) D

                    Group By D.Msisdn, D.appIds, D.toDate) S
					WHERE DATEDIFF(DAY, S.fromdate, S.todate) > 1 OR S.todate IS NULL --- dont forget to cut the instant
                    GROUP BY CAST(S.fromDate AS date)
--- Real
SELECT CAST(ChargeDateTime AS DATE), COUNT(DISTINCT TransactionId) FROM dbo.Charging
WHERE AppId = 1119 AND MciStatus = 0 
GROUP BY CAST(ChargeDateTime AS DATE)

--- total chargings count real and model
DECLARE @AppId INT
SET @AppId = 1119

SELECT CAST(C.ChargeDateTime AS date) AS [Date], COUNT(DISTINCT C.TransactionId) AS SuccessCount from
   (SELECT D.Msisdn, D.appIds, MIN(D.fromDate) fromDate, D.toDate from
       (select A.msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 1 AND AppId = @AppId) A
               left join
           (select msisdn, appid, insertdatetime from AllSubHistory where isactive = 0 AND AppId = @AppId) B
               on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime <= B.insertdatetime
           group by A.msisdn, A.AppId, A.InsertDateTime) D
       Group By D.Msisdn, D.appIds, D.toDate) S
       LEFT JOIN dbo.Charging C
       ON S.Msisdn = C.Msisdn AND S.appIds = C.AppId AND C.ChargeDateTime <= ISNULL(S.toDate, getdate()) AND C.ChargeDateTime >= S.fromDate
     ---  WHERE C.ChargeDateTime > '2018-02-01' and C.MciStatus = 0
   GROUP BY CAST(C.ChargeDateTime AS date)




SELECT * FROM dbo.AllSubHistory
WHERE InsertDateTime > '2019-06-12'


SELECT * FROM dbo.SubscriptionHistory WHERE appid = 1141 AND IsActive = 0 

TRUNCATE TABLE dbo.AllSubHistory

SELECT * FROM dbo.AllSubHistory
WHERE appid = 1141


SELECT TOP 10 * FROM dbo.AllSubHistory
