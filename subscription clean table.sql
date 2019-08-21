--- putting active users in a table 
Declare @t table (Msisdn varchar(50) ,appid int )
insert into @t (Msisdn,appid)
Select h.Msisdn,AppId From SubscriptionHistory H join 
(select max(id)as id2,Msisdn as id  from SubscriptionHistory
where  InsertDateTime > '2019-01-01' and isactive = 1 and appid = 1111
group by Msisdn) q on q.id2 = h.id  
DELETE FROM @t
FROM            @t as t  INNER JOIN
                         Subscription  ON Subscription.AppId = t.AppId AND Subscription.Msisdn = t.Msisdn

where Subscription.Status = 2
--where Status = 1 and appid = 1111 and ActivateDateTime > '2019-01-01' )


--Select * From  Subscription
--where Msisdn = '989917234068'

--select top 10 * from SubscriptionHistory
