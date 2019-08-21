
--- user income from different channels
--- how much money is gained through users from different user acquisition channels
select A.SC, a.SI, COUNT(DISTINCT C.TransactionId) from
(select ServiceId SI, Msisdn M, SourceId SC, MIN(SubDate) SD from HamidData
Group By ServiceId, Msisdn, SourceId) A
left join 
(select distinct TransactionId, AppId, Msisdn, ChargeDateTime from Charging WHERE MciStatus = 0 AND ChargeDateTime > '2019-06-01') C
On A.SI = C.AppId and A.M = C.Msisdn and A.SD < C.ChargeDateTime
Group By A.SC, a.SI

--- money gained, if user have stayed in the service days*service daily price
select A.SC, a.si, SUM(DATEDIFF(day, A.SD, getdate())) from
(select ServiceId SI, Msisdn M, SourceId SC, MIN(SubDate) SD from HamidData
Group By ServiceId, Msisdn, SourceId) A
Group By A.SC, a.si

--- duplicate user acquisition in different channels
--- duplicate users
SELECT Msisdn, SourceId, ServiceId, COUNT(*) FROM dbo.HamidData
--WHERE ServiceId = 1142
GROUP BY Msisdn, SourceId,ServiceId
HAVING COUNT(*) > 1

--- total new users from channels
SELECT SourceId, ServiceId, COUNT(*) FROM dbo.HamidData
--WHERE ServiceId = 1142
GROUP BY SourceId, ServiceId


---- how much money payed a user to us in its life
SELECT hd.SourceId,hd.ServiceId, hd.SubDate,hd.Msisdn, COUNT(DISTINCT income) FROM dbo.HamidData hd
LEFT JOIN (SELECT Msisdn, AppId, ChargeDateTime, TransactionId income FROM dbo.Charging WHERE MciStatus = 0) c
ON hd.Msisdn = c.Msisdn AND hd.ServiceId = c.AppId AND hd.SubDate < c.ChargeDateTime
GROUP BY hd.SourceId,hd.ServiceId, hd.SubDate, hd.Msisdn

--- check if there is duplicate
SELECT SourceId, ServiceId, Msisdn, SubDate, COUNT(*) FROM dbo.HamidData
GROUP BY SourceId, ServiceId, Msisdn, SubDate
HAVING COUNT(*) > 1

---- test query to get data
select * from 
(
select A.msisdn msisdn, A.AppId appIds, A.insertdatetime fromDate, min(b.InsertDateTime) toDate from
(select  msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 1) A
left join
(select msisdn, appid, insertdatetime from SubscriptionHistory where isactive = 0) B     
on A.Msisdn = b.Msisdn and a.AppId = b.AppId and A.insertdatetime < B.insertdatetime
group by A.msisdn, A.AppId, A.InsertDateTime
) as S
left join
(

	SELECT DISTINCT CAST(ChargeDateTime AS DATE) Date ,
				  transactionid as Transactionid,
				  appid appid,
				  Isnull(Price, 0) charge  
		 FROM     Charging c
		 WHERE    ChargeDateTime > '2019-01-01' and MciStatus=0  
) as C
on c.date between s.fromdate and s.todate and s.appids= c.appid



SELECT COUNT(DISTINCT TransactionId) FROM dbo.Charging
WHERE Msisdn IN (SELECT Msisdn FROM dbo.HamidData WHERE SourceId = 141 AND CAST(SubDate AS DATE) = '2019-03-09')


SELECT COUNT(DISTINCT TransactionId) FROM dbo.Charging
WHERE Msisdn = '989120621722' AND ChargeDateTime > '2019-03-09' AND MciStatus  = 0 

SELECT CAST(subdate AS DATE), COUNT(*) FROM hamiddata
WHERE SourceId = 141
GROUP BY CAST(subdate AS DATE)

SELECT TOP 10 * FROM dbo.HamidData



SELECT DISTINCT hd.SourceId,hd.ServiceId, hd.SubDate,hd.Msisdn, c.ChargeDateTime,  c.income FROM dbo.HamidData hd
LEFT JOIN (SELECT Msisdn, AppId, ChargeDateTime, TransactionId income FROM dbo.Charging WHERE MciStatus = 0) c
ON hd.Msisdn = c.Msisdn AND hd.ServiceId = c.AppId AND hd.subdate BETWEEN '2019-03-08' AND '2019-03-31' AND hd.SubDate < c.ChargeDateTime

   
   
DELETE FROM dbo.HamidData
WHERE ServiceId = 1142      

SELECT * FROM dbo.HamidData                                                