/* charged more than one time in an hour on info2cell */
SELECT Msisdn, CAST(t.InsertDateTime as date), DATEPART(hour, t.InsertDateTime), count(1) FROM TransactionResult tr
right JOIN [Transaction] t ON tr.TransactionId=t.Id
WHERE t.AppId = 1118 and t.InsertDateTime > '2016-10-14'
group by CAST(t.InsertDateTime as date), DATEPART(hour, t.InsertDateTime), Msisdn
having COUNT(1) > 1

