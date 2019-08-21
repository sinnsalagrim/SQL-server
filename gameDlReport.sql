--- game's download count
select g.Title gameName, DATEPART(MONTH, d.insertdatetime), count(*) as downloadCnt from Game g
left join DownloadHistory d
on g.id = d.gameid
where InsertDateTime > '2018-01-01'
group by g.Title, DATEPART(MONTH, d.insertdatetime)


select * from [Transaction] where planid = 5

select PlanId, Msisdn, [Status] from Subscription
where PlanId = 5
and Status = 1

select * from Game