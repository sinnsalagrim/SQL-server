CREATE TABLE SyncSub
(ID INT,
FakeId VARCHAR(40),
ServiceId VARCHAR(40))

BULK
INSERT SyncSub
FROM 'C:\Users\mohammadi\SiminDoc\Irancell\MTNI_48440\980110003479.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
