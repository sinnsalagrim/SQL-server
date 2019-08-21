select top 10 * from iislogs

/* SELECT top 10 
 SUBSTRING(csReferer, LEN(SUBSTRING(csReferer, 0, LEN(csReferer) - CHARINDEX ('://', csReferer))) + 1, LEN(csReferer) - LEN(SUBSTRING(csReferer, 0, LEN(csReferer) - CHARINDEX ('://', csReferer))) - LEN(SUBSTRING(csReferer, CHARINDEX ('.', csReferer), LEN(csReferer)))) from iislogs
LEFT(right(csReferer, CHARINDEX(':', csReferer)), CHARINDEX('.', right(csReferer, CHARINDEX(':', csReferer)))) from iislogs
 SUBSTRING(csReferer, LEN(LEFT(csReferer, CHARINDEX (':', csReferer))) + 1, LEN(csReferer) - LEN(LEFT(csReferer, CHARINDEX (':', csReferer))) - LEN(RIGHT(csReferer, LEN(csReferer) - CHARINDEX ('.', csReferer))) - 1) from iislogs
where csUriStem = '/user'
*/

-- who is misusing our HE
select B.A, count(*) from
(select top 1000000 substring(csReferer,  P1.Pos + 1, P4.Pos - 1) A
from iislogs
  cross apply (select (charindex(':', csReferer))) as P1(Pos)
 -- cross apply (select (charindex('.', csReferer, P1.Pos+1))) as P2(Pos)
--  cross apply (select (charindex('.', csReferer, P2.Pos+1))) as P3(Pos)
  cross apply (select (charindex('/', csReferer, P1.Pos+3))) as P4(Pos)
  where csUriStem = '/user') B
  group by B.A

 select csReferer, count(1) from iislogs
 where csUriStem = '/user'
 Group By csReferer
 Order by 2 desc
 -- end

 select top 1 csReferer, COUNT(1) from iislogs
 where LEFT(csReferer, 18) = 'http://79.175.154.' and csUriStem = '/user'
 group by csReferer

SELECT  
    cs(csUserAgent) As UserAgent,  
    COUNT(*) as Hits  
FROM iislogs  
GROUP BY csUserAgent  
ORDER BY Hits DESC

select cast(Cast('07:25:39' AS varchar) as time)

-- extracting browser from user agent
select * from iislogs
case strcnt(cs(User-Agent), 'Firefox') when 1 THEN 'Firefox' 
else case strcnt(cs(User-Agent), 'MSIE+6') when 1 THEN 'IE 6'
else case strcnt(cs(User-Agent), 'MSIE+7') when 1 THEN 'IE 7'
else case strcnt(cs(User-Agent), 'Chrome') when 1 THEN 'Chrome'
else case strcnt(cs(User-Agent), 'MSIE ') when 1 THEN 'IE'
else case strcnt(cs(User-Agent), 'Safari ') when 1 THEN 'Safari'
else case strcnt(cs(User-Agent), 'Opera ') when 1 THEN 'Opera' ELSE 'Unknown'
End End End End End End End as Browser

-- change IP to int
update headerenrichmentlog set IPdec = (CONVERT(bigint, PARSENAME(logIP,1)) +

CONVERT(bigint, PARSENAME(logIP,2)) * 256 +

CONVERT(bigint, PARSENAME(logIP,3)) * 65536 +

CONVERT(bigint, PARSENAME(logIP,4)) * 16777216)
where IPdec is null
--4047258

update iislogs set I = (CONVERT(bigint, PARSENAME(sIP,1)) +

CONVERT(bigint, PARSENAME(sIP,2)) * 256 +

CONVERT(bigint, PARSENAME(sIP,3)) * 65536 +

CONVERT(bigint, PARSENAME(sIP,4)) * 16777216)

---- count distinct subnets in an IP column
SELECT
    SUBSTRING(logip, 1, LEN(logip) - CHARINDEX('.',REVERSE(logip))),
    COUNT(*)
FROM
    headerenrichmentlog
GROUP BY
    SUBSTRING(logip, 1, LEN(logip) - CHARINDEX('.',REVERSE(logip)))
	order by 2 desc
---
--- ip and msisdn join
select a.[date], cast(a.[time] as time) as time, a.cip, a.csreferer, b.Msisdn from iislogs A
left join headerEnrichmentLog b
on a.cip = b.logip and datediff(second, cast(a.[time] as time), cast(b.logtime as time)) < 1
where CAST(b.logDate as date) = '2017-03-12' and a.csReferer like '%sabacell.bazicloob.mobi%' and a.csUriStem = '/user'
---

select top 10 * from headerenrichmentlog
where ipdec like '9811090798110907'

