declare @query nvarchar(2048)
declare @query2 nvarchar(1024)

set @query = N'WITH query
AS ( SELECT   CAST(ChargeDateTime AS DATE) d ,
              a.latinname ServiceName,
              Price charge
     FROM     Charging c
	 left join App a
	 on a.id = c.AppId
     WHERE    c.ChargeDateTime > ''2018-10-15'' and c.MciStatus=0)
SELECT d '

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


