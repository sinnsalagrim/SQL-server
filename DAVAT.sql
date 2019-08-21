/* DAVAT - on Games DB */

/* -->games - number of remained people in DAVAT services ----------------------------------------------------------- */ 
select SubServiceId, count(1), sum(cast(isactive as int)) from GatewayV2..CustomerSubServiceSubscription c
where c.SubServiceId = 62 and  CAST(c.ActivatedDateTime as date) > '2016-09-05' and customerId in(select CustomerId from CustomerInvitation)
group by c.SubServiceId
order by SubServiceId
/* on subserviceId = 62,	67965 came from DAVAT,	28654 users remaind */
/* 2016-11-27 -- on subserviceId = 62,	165927 came from DAVAT,	62138 users remaind */

/* the one who invited others and are still active ---------------------------------------------------------------------*/
select InvitedCustomerId,count(1), sum(cast(b.isactive as int)) from CustomerInvitation  a
left join GatewayV2..CustomerSubServiceSubscription b
on a.CustomerId = b.customerId and b.subserviceId = 62 
where CAST(b.ActivatedDateTime as date) > '2016-09-04' 
group by InvitedCustomerId
order by 2 desc
/* represents how useful are the users who invite the others. eg the one who invited 2123	and 1040 remained,
 it means that it is sending invitation to friends and did not tell them to unsub
 the whole user behavior is the same. not a big difference, not a loveable customer */

/* number of users who used DAVAT(whether invited or inviting) and are still active ----------------------------------------------------------- */ 
select count(1) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation) and isDelivered = 1 and serviceId = 35
/* 119236 presents number of inviters(!) who are still active in Roya */

/*number of users came from DAVAT which are still active ----------------------------------------------------------------------- */
select count(distinct destination) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation where customerId in (select CustomerId from GatewayV2..customersubservicesubscription where serviceId = 35 and isActive =1))
and cast(insertdatetime as date) = '2016-09-05'
/* number of sent charges from us to users */

/* number of sent messages to users came from DAVAT that delivery = 1 ----------------------------------------------------------- */
select cast(insertdatetime as date), isdelivered, count(1) from GatewayV2..vw_outbounds 
where destination in(select CustomerId from CustomerInvitation where customerId in (select CustomerId from GatewayV2..customersubservicesubscription where serviceId = 35 and isActive =1))
and cast(insertdatetime as date) > = '2016-09-05' 
group by cast(insertdatetime as date), IsDelivered
order by 1
/* number of delivered sent charges from us to users. results: 9824/26527 = 37% delivery rate */
/* 2016-11-27 -- number of delivered sent charges from us to users. results: 323270/2672509 = 12% delivery rate */

/* Result ---------------------------------------------------------------------------------------------------------------------------
 we have around 28000 active services. till now we must pay 28000000 prize. it means each user costs 1000 toman
delivery rate is 37%, so we will gain 9tomans from user each day. if user stays 108 days in the service, user will compensate the price we paied
lenght of each user remembering in services is around 80 days. so we pay 80 toomans for each user */

select sum(dateDif)/count(1) from 
(select customerId, datediff(day , ActivatedDateTime , InActivedDateTime) as dateDif from GatewayV2..CustomerSubServiceSubscription A where subserviceId = 62 )
where datedif is not null


select top 10 * from CustomerInvitation

select datepart(week, '2016-12-04')