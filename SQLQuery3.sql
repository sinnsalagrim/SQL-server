select top 10 * from OutboundLog
select top 10 * from CustomerSubServiceSubscription

select Destination, COUNT(1), SUM(Cast(IsDelivered as float)) from OutboundLog
	Group By Destination
	Having SUM(Cast(IsDelivered as float)) /COUNT(1) > 0.1  and SUM(Cast(IsDelivered as int)) > 1000
	order by 3 desc

	select top 10 *  from CustomerSubServiceSubscription

	select CAST(ActivatedDateTime as date), COUNT(1), SubServiceId from CustomerSubServiceSubscription
	group by CAST(ActivatedDateTime as date), SubServiceId
	order by 1 desc
		
select count(1) from CustomerSubServiceSubscription