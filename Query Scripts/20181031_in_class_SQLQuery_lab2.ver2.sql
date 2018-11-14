
USE [trevor.cullingsworth];
go

SELECT Name,
	   SUM(Area) AS Total_Area
FROM dbo.Lake
GROUP BY NAME;

SELECT Name,
	   Area
FROM dbo.Lake
ORDER BY NAME;

SELECT C.[Name] AS 'Country Name',
       L1.[Name] AS 'Lake Name',
	   SUM(ISNULL(L1.[Area],0)) AS 'Total Area'
FROM dbo.Lake L1
JOIN dbo.geo_Lake L2 ON L2.Lake = L1.[Name]
JOIN dbo.Country C ON C.Code = L2.Country

GROUP BY C.[Name], L1.[Name]
ORDER BY Total_Area DESC;



-- We can use subquery using "IN" operator we have seen the previous section
-- To get a result of the aggregate function as a filter 
-- Example: for each country, select a religion that has the most followers 

SELECT C.Name
      ,R1.[Name] AS Religion    
	  ,R1.[Percentage]
FROM dbo.Religion AS R1
JOIN dbo.Country AS C ON C.Code = R1.Country
WHERE R1.[Percentage] IN (SELECT MAX(R2.[Percentage]) AS [Percentage] -- this sub select is used to as a filter
					      FROM dbo.Religion AS R2
					      WHERE R1.Country = R2.Country
					      GROUP BY R2.Country)
ORDER BY  C.Name ASC, 
		  R1.[Percentage] DESC;



GROUP BY Country,[NAME]   
ORDER BY Country ASC, Language_Percentage DESC;


SELECT Province
      ,SUM(ISNULL([Population],0)) as total_population
	  ,AVG(ISNULL([Population],0)) as average_population
FROM dbo.City
GROUP BY Province