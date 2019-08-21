-- on what retry round, on each serviceId user is charged
select CAST(InsertDateTime as  date), destination, serviceId, type, count(1) from vw_outbounds 
where CAST(InsertDateTime as  date) = '2016-11-26'
group by CAST(InsertDateTime as  date), destination, serviceId, type
order by 1 desc

-- check to see in which delivery round user is charged. 
-- which retry round to select. which retry round has a better delivery rate
select A.D, A.C, A.ServiceId, count(1) from
(select Destination, Cast(InsertDateTime as time) D, ServiceId, count(1) C from OutboundLog
where Insertdatetime > '2016-12-21' and Type > 0
Group By Destination, Cast(InsertDateTime as date), ServiceId
Having MAX(cast(IsDelivered as tinyint)) = 1) A
Group By A.D, A.C, A.ServiceId

-- if user is inserted in subscriptionTable more than 3 times, so autocharge is sent more than what it must be
select Destination, count(1) C from OutboundLog
where Cast(InsertDateTime as date) = '2016-12-24' and Type > 0 and ServiceId = 35
Group By Destination
Having count(1) > 3
Order by count(1) desc

-- What is the income for users using DAVAT in Roya service 
-- how many times a user is charged after he/she subscribed using DAVAT
select DATEPART(week, cs.activateddatetime) , DATEPART(week, o.InsertDateTime), count(1) from customerinvitation CI
left join
Gatewayv2..CustomerSubServiceSubscription CS
on ci.CustomerId = cs.CustomerId and cs.SubServiceId = 62

left join

GatewayV2..OutboundLog O
on ci.CustomerId =  o.Destination and o.ServiceId = 35 and o.IsDelivered = 1
where cs.activateddatetime > '2016-09-04'
group by DATEPART(week, cs.activateddatetime) , DATEPART(week, o.InsertDateTime)

-- How many sybscription using DAVAT - weekly
select DATEPART(week, cs.activateddatetime) , count(1) from customerinvitation CI
left join
Gatewayv2..CustomerSubServiceSubscription CS
on ci.CustomerId = cs.CustomerId and cs.SubServiceId = 62
where cs.activateddatetime > '2016-09-04'
group by DATEPART(week, cs.activateddatetime) 

-- check to see if user is inserted in subscriptionTable more than one time
select * from (
select customerid, count(1) as count1 from gatewayv2..customersubservicesubscription
where CAST(activateddatetime as date) > '2016-09-04' and SubServiceId = 62
group by CustomerId
Having count(1) > 1) A where a.CustomerId in (select InvitedCustomerId from customerinvitation)

-- each user invited how many users
select customerId, count(1) from CustomerInvitation
where CustomerId in (select CustomerId from GatewayV2..CustomerSubServiceSubscription where subserviceid = 62 and ActivatedDateTime > '2016-09-04')
group by customerid
order by 2 desc

--180087
select count(distinct customerID) from CustomerInvitation
where CustomerId in  ( select CustomerId from GatewayV2..customersubservicesubscription where CAST(activateddatetime as date) between '2016-09-05' and '2016-12-05' and SubServiceId = 62)
--15779
select count(distinct InvitedCustomerId) from CustomerInvitation

--- in how many days how many invited users left the service
select datediff(day, cs.ActivatedDateTime, cs.InActivedDateTime), count(1) from CustomerInvitation ci
left join
 GatewayV2..CustomerSubServiceSubscription cs
 on cs.customerid = ci.customerid
 where cs.subserviceid = 62 and cs.ActivatedDateTime between '2016-09-04' and '2016-12-05'
group by datediff(day, cs.ActivatedDateTime, cs.InActivedDateTime)
order by 2 desc
