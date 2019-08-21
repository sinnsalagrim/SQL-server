select top 10 * from OutboundLog
select top 10 * from CustomerSubServiceSubscription

/* mean days for who they left */
select SUM( CAST(InActivedDateTime as float) - CAST(ActivatedDateTime as float))/1519814  from CustomerSubServiceSubscription
	where CAST(ActivatedDateTime as float) < CAST(InActivedDateTime as float)

/* mean days for who they left each service */
select SubServiceId, COUNT(1), SUM( CAST(InActivedDateTime as float) - CAST(ActivatedDateTime as float))/COUNT(1) from CustomerSubServiceSubscription
	where CAST(ActivatedDateTime as float) < CAST(InActivedDateTime as float)
	group by SubServiceId
	order by 3 desc

/* length for membership in services */
select right(CustomerId, 14), SubServiceId,  CAST(InActivedDateTime as float) - CAST(ActivatedDateTime as float)  from CustomerSubServiceSubscription
	where CAST(ActivatedDateTim
	e as float) < CAST(InActivedDateTime as float)
	order by 2 desc

/* customer's memberence time in each service*/
select right(CustomerId, 14), SubServiceId, CAST(GETDATE() as float) - CAST(ActivatedDateTime as float) from CustomerSubServiceSubscription
	where CAST(GETDATE() as float) - CAST(ActivedDateTime as float) > 0
	order by 3 desc

/* mean days for who they are still in each service */
select SUM( CAST(GETDATE() as float) - CAST(ActivatedDateTime as float))/1244459 from CustomerSubServiceSubscription
	/*where (CAST(ActivatedDateTime as float) > CAST(InActivedDateTime as float) and InActivedDateTime is not null) or InActivedDateTime is NULL
	where InActivedDateTime is null*/
	where IsActive = 1

/* customers who are still in each service */
select right(CustomerId, 14), SubServiceId, DATEDIFF(day, CAST(ActivatedDateTime as float), CAST(GETDATE() as float)) from CustomerSubServiceSubscription
	where IsActive = 1 
	order by 2 desc

/* customers who are still in each service */
select SubServiceId, COUNT(1), SUM(DATEDIFF(day, CAST(ActivatedDateTime as float), CAST(GETDATE() as float)))/COUNT(1) from CustomerSubServiceSubscription
	where IsActive = 1 
	group by SubServiceId
	order by 2 desc

/* which (high vas) customer in wich service */
	select CustomerId, SubServiceId from CustomerSubServiceSubscription
		where IsActive = 1
		order by 2 desc