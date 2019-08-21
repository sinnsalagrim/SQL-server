USE [MciPaymnet]
GO

INSERT INTO [dbo].[Service]
           ([Name]
           ,[ServiceId]
           ,[ServiceKey]
           ,[ShortCode]
           ,[MTChargeCode]
           ,[SubChargeCode]
           ,[UnSubChargeCode]
           ,[IsActive])
     SELECT
           'CAPPDASTANGRAM'
           ,'9605'
           ,'bd5aa876c3b14a09a822b45aa181f30e'
           ,'9830844132'
           ,'APPRENCAPPDAST5000'
           ,'APPSUBCAPPDASTANGR'
           ,'APPUSUBCAPPDASTANG'
           ,1  
		   from service
		   where id = 18
Go

