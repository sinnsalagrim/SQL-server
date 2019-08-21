USE [SabaGames]
GO

INSERT INTO [dbo].[Game]
           ([Title]
           ,[DirectLink]
           ,[Embed]
           ,[Level]
           ,[Thumbnail]
           ,[Rate]
           ,[TitleEn]
           ,[CategoryId]
           ,[IsActive]
           ,[Type]
           ,[DownloadCount]
           ,[Order])
     SELECT 
            N'دو در یک'
           ,'/Games/2in1coolgames.apk'
           ,[Embed]
           ,10
           ,'2in1coolgames.jpg'
           ,[Rate]
           ,'2in1coolgames'
           ,[CategoryId]
           ,1
           ,1
           ,0
           ,0
		   from Game
		   where id = 1379
GO


select * from game

