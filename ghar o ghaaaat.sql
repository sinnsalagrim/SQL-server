Declare @t table (Msisdn VARCHAR(50) ,Appid INT, [Status] INT, SubDate DATETIME, UnsubDate DATETIME )

insert into @t (Msisdn,Appid, Status, SubDate, UnsubDate)
Select h.Msisdn,H.AppId,H.IsActive, H.InsertDateTime, NULL From SubscriptionHistory H join 
(select max(id)as id2,Msisdn as id  from SubscriptionHistory
where  InsertDateTime > '2019-01-01' and isactive = 1 and appid = 1111
group by Msisdn) q on q.id2 = h.id  

DELETE FROM @t
FROM            @t as t  INNER JOIN
                         Subscription  ON Subscription.AppId = t.AppId AND Subscription.Msisdn = t.Msisdn
where Subscription.Status = 2


INSERT INTO @t(Msisdn,Appid, Status, SubDate, UnsubDate)

SELECT B.Msisdn, b.AppIds, MIN(B.InsertDateTime) , B.D from
(select A.Msisdn, a.AppId AppIds, A.InsertDateTime, MIN(D.InsertDateTime) D from SubscriptionHistory  A
left join SubscriptionHistory D
On A.Msisdn = D.Msisdn and A.AppId = D.AppId and A.IsActive = 1 and D.IsActive = 0 and A.InsertDateTime < D.InsertDateTime
where  A.InsertDateTime > '2019-01-01'
Group By A.Msisdn, a.AppId, A.InsertDateTime) B
Group By B.Msisdn, b.AppIds, B.D


SELECT COUNT(*) FROM @t
SELECT TOP 10 * FROM @t



SELECT COUNT(*) FROM dbo.SubscriptionHistory WHERE IsActive = 1 AND AppId = 1111 AND InsertDateTime > '2019-01-01'


SELECT h.SourceId, h.ServiceId, h.Msisdn, sh.A subscriptionDate, sh.unsubDate unsubscriptionDate  FROM
dbo.HamidData h
LEFT join
(
SELECT B.Msisdn, B.appids appids, MIN(B.InsertDateTime) A, B.D unsubDate from
(select A.Msisdn, a.AppId appids, A.InsertDateTime, MIN(D.InsertDateTime) D from SubscriptionHistory A
left join SubscriptionHistory D
On A.Msisdn = D.Msisdn and A.AppId = D.AppId and A.IsActive = 1 and D.IsActive = 0 and A.InsertDateTime < D.InsertDateTime
where A.InsertDateTime > '2019-01-01'
Group By A.Msisdn,  a.AppId, A.InsertDateTime) B
Group By B.Msisdn,B.appids, B.D
) sh
ON STUFF(CONVERT(CHAR(13), sh.A , 120), 11, 1, ':')= STUFF(CONVERT(CHAR(13), h.SubDate , 120), 11, 1, ':') AND h.ServiceId = sh.appids AND h.Msisdn = sh.msisdn

SELECT TOP 10 *  FROM dbo.HamidData





SELECT * FROM
(
SELECT h.ServiceId, h.SourceId, H.Msisdn, s.Status, h.SubDate, s.InActiveDateTime FROM dbo.HamidData H
LEFT JOIN
dbo.Subscription S
ON h.Msisdn = s.Msisdn AND CAST(h.SubDate AS DATE) = CAST(s.ActivateDateTime AS DATE)
) AS Subs
LEFT JOIN
(
SELECT DISTINCT CAST(ChargeDateTime AS DATE) Date ,
				  transactionid as Transactionid,
				  appid appid,
				  Isnull(Price, 0) charge  
		 FROM     Charging c
		 WHERE    ChargeDateTime > '2019-01-01' and MciStatus=0  
) as C
on c.date between s.fromdate and s.todate and s.appids= c.appid
) AS ch



SELECT h.ServiceId, h.SourceId, H.Msisdn, s.Status, h.SubDate, s.InActiveDateTime FROM dbo.HamidData H
LEFT JOIN
(dbo.Subscription 
WHERE CAST(ActivateDateTime AS DATE) != CAST(InActiveDateTime AS DATE) ) AS S
ON h.Msisdn = s.Msisdn AND CAST(h.SubDate AS DATE) = CAST(s.ActivateDateTime AS DATE)
