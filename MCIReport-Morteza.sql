--Main Report
------------------------------------------------
--Price
WITH query
AS ( SELECT   CAST(ChargeDateTime AS DATE) d ,
              AppId ,
              Price charge
     FROM     Charging
     WHERE    ChargeDateTime > '2018-10-15' and MciStatus=0
     
     
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(SUM(charge) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p;


--------------------------
--Total users
go
WITH query
AS ( SELECT   cast(getdate() as date) as d,
              AppId ,
              Msisdn 
     FROM     Subscription
   	 
     
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(count(msisdn) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p
order by d;


------------------------
--Active users
go
WITH query
AS ( SELECT   cast(getdate() as date) as d,
              AppId ,
              Msisdn 
     FROM     Subscription where Status=1
   	 
     
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(count(msisdn) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p
order by d;

--------------------------
--New SUB
WITH query
AS ( SELECT   CAST(ActivateDateTime AS DATE) d ,
              AppId ,
              Msisdn cnt
     FROM     Subscription
     WHERE    ActivateDateTime > '2018-10-15'	
     
     
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(count(cnt) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p
order by d;

---------------------------
--Unsub
WITH query
AS ( SELECT   CAST(InActiveDateTime AS DATE) d ,
              AppId ,
              Msisdn cnt
     FROM     Subscription
     WHERE    InActiveDateTime > '2018-10-15'
  
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(count(cnt) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p
order by d;

----------------------------
--Unsub today
WITH query
AS ( SELECT   CAST(InActiveDateTime AS DATE) d ,
              AppId ,
              Msisdn cnt
     FROM     Subscription
     WHERE    InActiveDateTime > '2018-10-15' and Cast(InActiveDateTime AS Date) = Cast(ActivateDateTime AS Date)
	
   )
SELECT d, [1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140]
FROM   query
PIVOT(count(cnt) FOR AppId IN ([1111],[1115],[1116],[1118],[1119],[1123],[1121],[1122],[1124],[1125],[1126],[1127],[1128],[1133],[1132],[1134],[1135],[23],[1129],[1138],[1140])) AS p
order by d;
