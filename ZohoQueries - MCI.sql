---------------------------------------------------------------------------------------MCI
---------------------------------------------------------------------
---sales
declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   CAST(ChargeDateTime AS DATE) Date ,
              a.latinname ServiceName,
              Price charge
     FROM     Charging c
	 left join App a
	 on a.id = c.AppId
     WHERE    c.ChargeDateTime > ''2018-10-15'' and c.MciStatus=0)
SELECT Date '

set @query2 = N'FROM   query
PIVOT(SUM(charge) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)

--select @query

--------------------------------------------------------------------------------
---Total users

declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   cast(getdate() as date) Date ,
              a.latinname ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join App a
	 on a.id = s.AppId
	 )
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)

-------------------------------------------------------------------------
---Active users

declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   cast(getdate() as date) Date ,
              a.latinname ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join App a
	 on a.id = s.AppId
	 where status = 1)
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)
-------------------------------------------------------------------------- 
--- New Sub

declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   cast(ActivateDateTime as date) Date ,
              a.latinname ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join App a
	 on a.id = s.AppId
	 where ActivateDateTime > ''2018-10-15'')
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)
-----------------------------------------------------------------
--- unsub

declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   cast(InActiveDateTime as date) Date ,
              a.latinname ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join App a
	 on a.id = s.AppId
	 where InActiveDateTime > ''2018-10-15'')
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)
------------------------------------------------------------------------
--- unsub today

declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   cast(InActiveDateTime as date) Date ,
              a.latinname ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join App a
	 on a.id = s.AppId
	 where InActiveDateTime > ''2018-10-15'' and Cast(InActiveDateTime AS Date) = Cast(ActivateDateTime AS Date))
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select latinname from app

Open servicename_crs
fetch next from servicename_crs into @name
while @@FETCH_STATUS = 0
begin 
set @query = CONCAT( @query , N', ' , @name )
set @query2 = CONCAT(@query2, @name, N', ')
fetch next from servicename_crs into @name
end

close servicename_crs
deallocate servicename_crs


set @query2 = left(@query2, LEN(@query2) - 1)


set @query =CONCAT(@query, ' ', @query2 , N')) AS p;')

execute( @query)

--- Sample
WITH query
	 AS ( SELECT   CAST(ChargeDateTime AS DATE) DATE,
			a.latinname ServiceName,
			Price charge
		FROM Charging c    
	 left join App a
	 on a.id = c.AppId       
	 WHERE c.ChargeDateTime > '2018-10-15' and c.MciStatus=0) 
	 SELECT DATE , Xbuzzi, BaziCloob, SunnyGames, Majazak, Skillderby, Kanape, FunClips, BestGames, Igames, Phosphor, Phos, Gahvare, TestApp, AppSpace, DailyGames, CinemaMagazine, AlphabetsOfBeauty, Gamiplex, Regim, Playbox, EfunGames, GameFactory, Mobitwist, MrBazi, Sportsie, Dastangram
	 FROM   query
	 PIVOT(SUM(charge) FOR Servicename IN (Xbuzzi, BaziCloob, SunnyGames, Majazak, Skillderby, Kanape, FunClips, BestGames, Igames, Phosphor, Phos, Gahvare, TestApp, AppSpace, DailyGames, CinemaMagazine, AlphabetsOfBeauty, Gamiplex, Regim, Playbox, EfunGames, GameFactory, Mobitwist, MrBazi, Sportsie, Dastangram)) AS p;

