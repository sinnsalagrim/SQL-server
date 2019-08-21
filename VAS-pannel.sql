select CAST(LastActivityDateTime as date), SubServiceId, COUNT(1) from CustomerSubscriptionHistory
where Agent = 1 and CAST(LastActivityDateTime as date) >= '2016-10-24'
group by CAST(LastActivityDateTime as date), SubServiceId
order by CAST(LastActivityDateTime as date)

select top 10 * from CustomerSubscriptionHistory