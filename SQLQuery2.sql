select top 10 * from OutboundLog
select top 10 * from CustomerSubServiceSubscription

select right(Destination, 14), count(1), ServiceId, IsDelivered from OutboundLog
	where SentDateTime > '2016-03-05' 
	group by right(Destination, 14),  ServiceId, IsDelivered

select right(Destination, 14), COUNT(1), SUM(Cast(IsDelivered as int)) from OutboundLog
	where SentDateTime > '2016-03-05' 
	Group By right(Destination, 14) order by 3

	select right(Destination, 14, COUNT(1), SUM(Cast(IsDelivered as int)) from OutboundLog
Group By right(Destination, 14)
Having SUM(Cast(IsDelivered as int)) > 100
order by 3 desc