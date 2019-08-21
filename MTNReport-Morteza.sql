--Main Report
------------------------------------------------
--Price
WITH query
AS ( SELECT   CAST(TransactionDateTime AS DATE) d ,
              Planid,
              amount 
     FROM      [dbo].[Transaction]
     WHERE    TransactionDateTime > Cast('2018-10-15' AS Date)  AND Result=1
         
   )
SELECT d, [3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(SUM(amount) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p;

--------------------------
--Total users
go
WITH query
AS ( SELECT   cast(getdate() as date) as d,
              PlanId ,
              Msisdn 
     FROM     Subscription
   	 
     
   )
SELECT  [3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(count(msisdn) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p
order by d;

------------------------
--Active users
go
WITH query
AS ( SELECT   cast(getdate() as date) as d,
              PlanId ,
              Msisdn 
     FROM     Subscription where status=1
   	 
     
   )
SELECT  [3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(count(msisdn) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p
order by d;


--------------------------
--New SUB
WITH query
AS ( SELECT   CAST(FromDate AS DATE) d ,
              PlanId ,
              Msisdn cnt
     FROM     dbo.SubscriptionHistory
     WHERE    FromDate > '2018-10-15' 
     
     
   )
SELECT  d,[3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(count(cnt) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p
order by d;

---------------------------
--Unsub
WITH query
AS ( SELECT   CAST(ModifiedDateTime AS DATE) d ,
              PlanId ,
              Msisdn cnt
     FROM     Subscription
     WHERE    ModifiedDateTime > '2018-10-15' and status=2
     
     
   )
SELECT d, [3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(count(cnt) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p
order by d;

----------------------------
--Unsub today
WITH query
AS ( SELECT   CAST(todate AS DATE) d ,
              PlanId ,
              Msisdn 
     FROM     SubscriptionHistory
     WHERE    todate > '2018-10-15' and CAST(FromDate AS date)=CAST(ToDate AS date)
	
   )
SELECT d, [3],[5],[6],[8],[10],[13]
FROM   query
PIVOT(count(msisdn) FOR PlanId IN ([3],[5],[6],[8],[10],[13])) AS p
order by d;

