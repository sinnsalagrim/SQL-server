USE [SabaGames]
GO

INSERT INTO [dbo].[GameDetail]
           ([GameId]
           ,[Description]
           ,[Images])
     SELECT 
            1381
           ,N'<p>
دو بازی سرگرم کننده و فوق العاده را در یک بسته دریافت کنید. نقاط رنگارنگ را در بازی به هم وصل کنید و مراقب باشید به بلوک های در حال سقوط برخورد نکنید.دو فضای جذاب</p>
'
           ,'["2in1coolgames_Screenshots_01.jpg","2in1coolgames_Screenshots_02.jpg","2in1coolgames_Screenshots_03.jpg","2in1coolgames_Screenshots_04.jpg","2in1coolgames_Screenshots_05.jpg","2in1coolgames_Screenshots_06.jpg","2in1coolgames_Screenshots_07.jpg"]'
		   from GameDetail
		   where id = 10
GO


