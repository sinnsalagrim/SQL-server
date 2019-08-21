

WITH query
AS ( SELECT CAST(se.CreateAt AS DATE) [Date],
			sp.PlanProviderCode PlanProviderCode,
			se.EventTypeId EventTypeId	
	FROM dbo.SessionEvents se
		LEFT JOIN (SELECT s.Id Id, p.PlanProviderCode PlanProviderCode FROM dbo.Sessions s
					LEFT JOIN pages p 
					ON s.PageId = p.Id) sp
					ON sp.Id = se.SessionId
			WHERE se.CreateAt > '2019-06-09'
)
SELECT [Date], PlanProviderCode, [1],[101],[102],[103],[104],[105],[106],[107],[108],[109],[110]
FROM   query
PIVOT(COUNT(EventTypeId) FOR EventTypeId IN ([1],[101],[102],[103],[104],[105],[106],[107],[108],[109],[110])) AS pa;

<!--subscription and views on landings per hour per day-->  
WITH query
AS ( SELECT CAST(se.CreateAt AS DATE) [Date],
		DATEPART(HOUR, se.CreateAt) [Hour],
		sp.PlanProviderCode PlanProviderCode,
		EventTypeId 
	FROM dbo.SessionEvents se
	LEFT JOIN (SELECT s.Id Id, p.PlanProviderCode PlanProviderCode FROM dbo.Sessions s
					LEFT JOIN pages p 
					ON s.PageId = p.Id) sp
					ON sp.Id = se.SessionId
	WHERE se.CreateAt > '2019-06-09'
)
	SELECT [Date], PlanProviderCode, [Hour], [101],[108]
		FROM   query
	PIVOT(COUNT(EventTypeId) FOR EventTypeId IN ([101],[108])) AS p;



