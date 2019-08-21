select cIp, count(*) from iislogs
where csUriStem = '/user'
group by cIp
order by 2 desc

select top 10 LEFT(csReferer, CHARINDEX ('/', csReferer)) from iislogs
select top 10 * from iislogs

--- which links are using HE
select left(csReferer, 30), count(*) from iislogs
where csUriStem = '/user' and [date] > '2018-02-20'
group by left(csReferer, 30)
order by 1 desc

select count(*) from iislogs