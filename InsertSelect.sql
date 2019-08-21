USE [MtnPaymnet]
GO

INSERT INTO [dbo].[Service]
           ([Id]
           ,[Name]
           ,[ServiceId]
           ,[ServiceKey]
           ,[ShortCode]
           ,[MTChargeCode]
           ,[SubChargeCode]
           ,[UnSubChareCode]
           ,[IsActive]
           ,[FromDate]
           ,[ToDate]
           ,[Password]
           ,[BundleId]
           ,[TimeStamp]
           ,[ProductId]
           ,[PartnerId]
           ,[ServiceType]
           ,[PageNo])
     select 
            4
           ,'Zoom'
           ,'98012000012191'
           ,[ServiceKey]
           ,[ShortCode]
           ,[MTChargeCode]
           ,[SubChargeCode]
           ,[UnSubChareCode]
           ,[IsActive]
           ,Getdate()
           ,[ToDate]
           ,[Password]
           ,[BundleId]
           ,[TimeStamp]
           ,[ProductId]
           ,[PartnerId]
           ,[ServiceType]
           ,[PageNo]
		   from Service
		   where id= 3
GO

select * from app


