---- check MCI chargings of the day
select cast(ChargeDateTime as date), count(*) from charging
where ChargeDateTime > '2018-06-15' and MciStatus = 0  and DATEPART(HOUR, ChargeDateTime) < 12
group by cast(ChargeDateTime as date)
order by 1 desc