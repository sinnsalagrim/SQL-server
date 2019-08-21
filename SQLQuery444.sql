---
Update H1 set H1.[Order] = H2.[Ranking] from headerEnrichmentLog H1 inner join 
(select *, RANK() OVER (Order By IPdec) as [Ranking] from headerEnrichmentLog) H2
On H1.Id = H2.Id
---
Update headerEnrichmentLog set IsEnriched = cast(Msisdn as bit)
---
select a.IPdec, a.isenriched, b.IPdec, b.IPdec - a.IPdec from headerEnrichmentLog a
left join headerEnrichmentLog b
on a.[order] = b.[order]-1
where (a.IPdec != b.IPdec or b.IPdec is null) and Isnull(b.IPdec - a.IPdec, 257) > 256
Order By 1
---
select IPdec, COUNT(distinct IsEnriched), count(1) from headerEnrichmentLog
Group By IPdec
Having COUNT(distinct IsEnriched) > 1
Order By 1
---
select (IPdec / 16384) * 16384, (IPdec / 16384) * 16384 + 16383, COUNT(distinct IsEnriched), count(1) 
from headerEnrichmentLog
Group By IPdec / 16384
Having COUNT(distinct IsEnriched) > 1
Order By 1

--- all the MCI IPs and how many / 8% failure
select count(*) from headerEnrichmentLog where 
IPdec = 97779712 or ipdec = 97583104 or ipdec = 97714176 or ipdec = 520257536 or ipdec = 2548695040
or ipdec = 629211136 or ipdec = 775094272 or ipdec = 1446445056 or ipdec = 1543176192 or ipdec = 2760540160
or ipdec = 3104153344 or ipdec = 3169124352 or (IPdec between 3104152832 and 3104178175)
or (ipdec between 3104152832 and 3104178175) or (IPdec between 90832960 and 90898431) 
or (IPdec between 97517638 and 97583103) or (IPdec between 97648670 and 97714175) or (IPdec between 1506017536 and 1506082815)
or (IPdec between 1506148608 and 1506213887) or (IPdec between 1506214144 and 1506279423)
or (IPdec between 2548760592 and 2548826111) or (IPdec between 3104152640 and 3104152831)

--- percentage of failure requests on header enrichment / 51% for now
select  sum(cast(IsEnriched as float))/count(*) from headerEnrichmentLog