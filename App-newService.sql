USE [MciPaymnet]
GO

INSERT INTO [dbo].[App]
           ([Id]
           ,[PartnerName]
           ,[Name]
           ,[IsActive]
           ,[UnsubKeywords]
           ,[ServiceId]
           ,[SubscribeKeywords]
           ,[DownloadLink]
           ,[PortalLink]
           ,[SubscriptionFee]
           ,[Duration]
           ,[Type]
           ,[UnsubscribeUrl]
           ,[WelcomeMessage]
           ,[UnsubscribeMessage]
           ,[AlreadySubscribeMessage]
           ,[AlreadyUnsubscribeMessage]
           ,[ReminderMessage]
           ,[SubscribePermision]
           ,[SubscribeUrl]
           ,[ChargingUrl]
           ,[DefaultPlanId])
     Select 
            1140
           ,'Navaar'
           ,'DastanGram'
           ,1
           ,[UnsubKeywords]
           ,27
           ,[SubscribeKeywords]
           ,[DownloadLink]
           ,'https://www.navaar.ir'
           ,[SubscriptionFee]
           ,[Duration]
           ,[Type]
           ,'https://www.navaar.ir/api/vas/mci/unsubscribe'
           ,N'مشترک گرامی، شما با موفقیت در سرویس #name عضو شدید. هزینه ی سرویس #duration #fee تومان می باشد. شما می توانید از طریق #portal به سرویس دسترسی داشته باشید. در صورت تمایل به غیر فعالسازی عبارت #unsubkey را به #shortcode ارسال فرمایید.
پشتیبانی صباسل: 02188686941'
           ,[UnsubscribeMessage]
           ,[AlreadySubscribeMessage]
           ,[AlreadyUnsubscribeMessage]
           ,[ReminderMessage]
           ,1
           ,'https://www.navaar.ir/api/vas/mci/subscribe'
           ,'https://www.navaar.ir/api/vas/mci/chargingreport'
           ,[DefaultPlanId]
		   from App
		   where id = 1129
GO
