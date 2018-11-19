-- 4)	Display the most widely spoken language in the continent Europe?
 	    -- hint refer to Encompasses table

		select --C.Name as CountryName,			  
			   top(1)
			   l.Name as LanguageName,
			   sum(l.Percentage *   C.Population ) as NumerOfSpeakers
		from dbo.Encompasses e
		join dbo.Country c on e.Country = c.Code and e.Continent='Europe'
		join dbo.[Language] l on l.Country = c.Code
		group by l.Name
		order by NumerOfSpeakers desc


-- For this question start with the smallest portion:
--	Find all of the European countries first
--	then find language spoken in each country
--  do the calculation with percentage 
--  and sum up the population from the calculation


SELECT C.[Name],
	   E.[Continent]
FROM dbo.encompasses E
JOIN dbo.Country C ON E.[Country] = C.[Code]
WHERE E.[Continent] = 'Europe'
ORDER BY C.[Name] ASC;



SELECT DISTINCT C.[Name] AS 'Country Name',
	   L1.[Lake] AS 'Lake Name',
	   SUM(L2.[Area]) AS 'Lake Area'
FROM dbo.geo_Lake L1
JOIN dbo.Country C ON C.[Code] = L1.[Country]
JOIN dbo.Lake L2 ON L2.[Name] = L1.[Lake]
GROUP BY C.[Name],
	     'Lake Name'
ORDER BY 'Lake Area' DESC;

