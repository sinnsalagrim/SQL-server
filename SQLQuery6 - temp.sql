select * from charging
where appid = 1136 and chargedatetime > '2018-02-13'

select * from subscription
where appid = 1132 and status = 1


select appid, cast(chargedatetime as date), count(distinct msisdn) from charging
where msisdn not in (select distinct msisdn from subscription where status = 1 and appid = 1119) and chargedatetime > '2018-02-12'
group by appid, cast(chargedatetime as date)

select distinct msisdn from charging
where msisdn not in (select distinct msisdn from subscription where status = 1) and chargedatetime > '2018-02-12'


select top 10 * from Charging

select * from pushotp
where Msisdn = '989101969502' and InsertDateTime > '2018-02-12'
where ActionType = 1 and appid = 1132 and InsertDateTime > '2018-02-12'


select distinct msisdn from charging
where msisdn not in (select distinct msisdn from subscription where status = 1 and appid = 1119) and chargedatetime > '2018-02-13' and appid = 1119