-- bulk reports
select cast(ActivatedDateTime as date) , count(1)  from CustomerSubServiceSubscription
where cast(ActivatedDateTime as date) between '2016-10-01' and '2016-10-25' and subserviceid = 143
group by cast(ActivatedDateTime as date) 
order by 1 desc

--using DAVAT
select  count(1), sum(cast(isactive as int)) from GatewayV2..CustomerSubServiceSubscription c
where c.SubServiceId = 62 and  CAST(c.ActivatedDateTime as date) between '2016-09-22' and '2016-11-20' and customerId in(select CustomerId from CustomerInvitation)
group by CAST(c.ActivatedDateTime as date)
order by 1 desc

--income from DAVAT
select cast(insertdatetime as date), count(distinct destination) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation
where customerId in (select CustomerId from GatewayV2..customersubservicesubscription where serviceId = 35))
and cast(insertdatetime as date) > '2016-11-25'
group by cast(insertdatetime as date)
order by 1 asc