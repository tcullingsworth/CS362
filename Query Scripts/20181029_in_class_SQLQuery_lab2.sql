USE [trevor.cullingsworth];
go

SELECT C.[Name]
       ,MIN (GDP)
FROM dbo.Economy AS E
JOIN dbo.Country AS C ON C.[Code] = E.[Country];