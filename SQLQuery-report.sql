/*daily report */
select * from MTNINewDailyReport('2017-06-29')
order by 1, 2 

select * from subservice

/* internal Report */
select * from InternalSDPReport('2016-09-04', 83)
order by 1
/*update*/
update SubService
set keywords = 1
where Id = 159

/* weekly report */
select count(1) from CustomerSubServiceSubscription
where CAST(ActivatedDateTime as date) between '2016-12-01' and '2017-04-01' 

select count(1) from CustomerSubServiceSubscription
where CAST(InActivedDateTime as date) between '2016-12-01' and '2017-04-01'

select ServiceId, count(*) from vw_outbounds
where isdelivered = 1 and CAST(sentdatetime as date) between '2017-02-27' and '2017-03-05' 
group by ServiceId
order by 1 asc
/* End of weekly report */

-- bulk response
select  CAST(ActivatedDateTime as date), SubServiceId, count(1) from CustomerSubServiceSubscription
where CAST(ActivatedDateTime as date) > =  '2017-01-01'
group by  CAST(ActivatedDateTime as date), SubServiceId 
order by 1 , 2 desc

select CAST(b.activateddatetime as date), count(1), sum(cast(b.isactive as int)) from CustomerInvitation  a
left join GatewayV2..CustomerSubServiceSubscription b
on a.CustomerId = b.customerId and b.subserviceId = 62 
where CAST(b.activateddatetime as date) >'2016-12-05'
group by CAST(b.activateddatetime as date)
order by 1 desc
-- end of bulk response


select cast(ActivatedDateTime as date), SubServiceId, count(1) from CustomerSubServiceSubscription
where CAST(ActivatedDateTime as date) > = '2016-09-15'
group by cast(ActivatedDateTime as date), SubServiceId
order by 1, 2 

select * from SubService                                               

select InsertDateTime, ServiceId, Message from Inbound
where CAST(InsertDateTime as date) > = '2016-08-29'
and ServiceId = 35
and Message LIKE '%3%'
order by 1 desc

/*report on kanape - campaign */
select InsertDateTime, COUNT(1) from Inbound
where Message Like '%101%' and InsertDateTime>= '2016-09-13 18:00:00' and AppId = 1119
group by InsertDateTime, COUNT(1)
order by 1 desc

/* total subscription on each service */
select i.SubServiceId, j.ServiceId, COUNT(1) from [CustomerSubServiceSubscription] i
inner join [SubService] j
on i.SubServiceId = j.Id
where i.IsActive = 1 
group by i.SubServiceId, j.ServiceId
order by 3 desc

select InsertDateTime, Message from Inbound
where Message like '%DAVAT%'
/*and   InsertDateTime between '2016-09-22' and '2016-09-24' */
and ServiceId = 35
order by 1 desc

/* -->games - number of remained people in DAVAT services */
select SubServiceId, count(1), sum(cast(isactive as int)) from GatewayV2..CustomerSubServiceSubscription c
where customerId in(select CustomerId from CustomerInvitation)
group by c.SubServiceId
order by SubServiceId
/* on subserviceId = 62,	67965 came from DAVAT,	28654 users remaind */

/* the one who invited others and are still active */
select InvitedCustomerId,count(1), sum(cast(b.isactive as int)) from CustomerInvitation  a
left join GatewayV2..CustomerSubServiceSubscription b
on a.CustomerId = b.customerId and b.subserviceId = 62
group by InvitedCustomerId
order by 2 desc

/* number of users who used DAVAT(whether invited or inviting) and are still active */ 
select count(1) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation) and isDelivered = 1 and serviceId = 35

/*number of users came from DVAT which are still active */
select count(distinct destination) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation where customerId in (select CustomerId from GatewayV2..customersubservicesubscription where serviceId = 35 and isActive =1))
and cast(insertdatetime as date) = '2016-10-16'
/* number of sent messages to users came from DAVAT that delivery = 1 */
select count(1) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation where customerId in (select CustomerId from GatewayV2..customersubservicesubscription where serviceId = 35 and isActive =1))
and cast(insertdatetime as date) = '2016-10-16' and IsDelivered = 1

select sum(dateDif)/count(1) from customerinvitation B right join
(select CustomerId, datediff(day , ActivatedDateTime , InActivedDateTime) as dateDif from GatewayV2..CustomerSubServiceSubscription 
where subserviceId = 62 ) A
on a.customerid = b.customerid



select * from subservice


select CAST(c.ActivatedDateTime as date), count(1), sum(cast(isactive as int)) from GatewayV2..CustomerSubServiceSubscription c
where c.SubServiceId = 62 and  CAST(c.ActivatedDateTime as date) > = '2016-09-05' and customerId in(select CustomerId from CustomerInvitation)
group by CAST(c.ActivatedDateTime as date)
order by 1

select AcDate, count(1) from 
(select * from GatewayV2..vw_outbounds) as Y
left join
(select CAST(b.ActivatedDateTime as date) as AcDate, InvitedCustomerId from CustomerInvitation  a
left join GatewayV2..CustomerSubServiceSubscription b
on a.CustomerId = b.customerId and b.subserviceId = 62 ) as F

on F.InvitedCustomerId = Y.destination
where AcDate > '2016-09-04'
group by AcDate

select top 10 * from vw_outbounds 
where CAST(InsertDateTime as  date) > = '2016-09-26'
order by insertdatetime desc

-- on what retry round, on each serviceId user is charged
select CAST(InsertDateTime as  date), destination, serviceId, type, count(1) from vw_outbounds 
where CAST(InsertDateTime as  date) = '2016-11-26'
group by CAST(InsertDateTime as  date), destination, serviceId, type
order by 1 desc


-- check to see in which delivery round user is charged. 
-- which retry round to select. which retry round has a better delivery rate
select A.D, A.C, A.ServiceId, count(1) from
(select Destination, Cast(InsertDateTime as date) D, ServiceId, count(1) C from OutboundLog
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
where cs.activateddatetime > '2016-12-04'
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

select count(distinct customerID) from CustomerInvitation
select count(distinct InvitedCustomerId) from CustomerInvitation

select  CustomerId, count(*) from CustomerInvitation
group by CustomerId
having count(*) > 1