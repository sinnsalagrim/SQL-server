---------------------------------------------------------------------------------------MCI
---------------------------------------------------------------------
---sales
declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   CAST(TransactionDateTime AS DATE) Date ,
              p.Name ServiceName,
              tr.Amount amount
     FROM      [Transactionarchive] tr
	 left join [Plan] p
	 on p.id = tr.PlanId
     WHERE    tr.TransactionDateTime > Cast(''2018-10-15'' AS Date)  AND tr.Result=1
   )
SELECT Date '

set @query2 = N'FROM   query
PIVOT(SUM(amount) FOR ServiceName IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select [Name] from [plan]

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
              p.Name ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join [plan] p
	 on p.id = s.planid
	 )
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select [name] from [Plan]

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
              p.name ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join [plan] p
	 on p.id = s.planid
	 where s.status = 1)
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select name from [Plan]

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
AS ( SELECT   cast(s.Fromdate as date) Date ,
              p.name ServiceName,
              s.Msisdn MSISDN
     FROM     dbo.SubscriptionHistory s
	 left join [plan] p
	 on p.id = s.planid
	 where s.fromdate > ''2018-10-15'')
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select name from [Plan]

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
AS ( SELECT   cast(s.ModifiedDateTime as date) Date ,
              p.name ServiceName,
              s.Msisdn MSISDN
     FROM     Subscription s
	 left join [plan] p
	 on p.id = s.planid
	 where s.ModifiedDateTime > ''2018-10-15'' and status = 2)
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select name from [Plan]

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
AS ( SELECT   cast(s.todate as date) Date ,
              p.name ServiceName,
              s.Msisdn MSISDN
     FROM     Subscriptionhistory s
	 left join [plan] p
	 on p.id = s.planid
	 where s.todate > ''2018-10-15'' and Cast(s.todate AS Date) = Cast(s.fromdate AS Date))
SELECT Date '

set @query2 = N'FROM   query
PIVOT(count(msisdn) FOR Servicename IN ('

declare @name nvarchar(50)
declare servicename_crs cursor
for select name from [plan]

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


