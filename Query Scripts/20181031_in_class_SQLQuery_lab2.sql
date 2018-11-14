/***************************************************************************************************************
* Author     :	Trevor Cullingsworth
* Email      :	trevor.cullingsworth@my.denver.coloradotech.edu
* Course     :  CS362 - Structured Query Language for Data Management
* Description:	Lab 2 SQL query exercise assignment
* Date       :	Due 11/2/18
*				
* Notes:
*	From CIA FactBook database please write 5 queries that will answer the following questions. 
*	Make sure your query is properly commented and it is executable before submitting.
*
*	1)  Select a country that has the smallest GDP in the world?
*	2)  Find the population growth rate for each city?
*	    -- hint refer to Citypops table and https://pages.uoregon.edu/rgp/PPPM613/class8a.htm for population growth rate
*	3)  Display the most widely spoken language for each country, using a subquery?
*	4)  Display the most widely spoken language in the continent Europe?
 	    -- hint refer to Encompasses table
*	5)  Display all top 5 Countries that have the largest area of Lakes combined?
*
***************************************************************************************************************/

USE [trevor.cullingsworth];
go

-- 1)	Select a country that has the smallest GDP in the world?
SELECT TOP 1 C.Name
       ,MIN(GDP) AS "Minimum GDP"
FROM dbo.Economy E
JOIN dbo.Country AS C ON C.[Code] = E.[Country]
WHERE GDP IS NOT NULL
GROUP BY C.Name
ORDER BY "Minimum GDP" ASC;

-- 2)   Find the population growth rate for each city?
		-- hint refer to Citypops table and https://pages.uoregon.edu/rgp/PPPM613/class8a.htm for population growth rate
		-- Eisenstadt 58369
		-- Extra credit
SELECT City
       ,Year
       ,Population
FROM dbo.Citypops
GROUP BY City;


SELECT City
       ,SUM(Population)
FROM dbo.Citypops
WHERE City = 'Eisenstadt'
GROUP BY City;



-- 3)	Display the most widely spoken language for each country, using a subquery?

SELECT C.[Name] AS 'Country Name',
	   L1.[Name] AS 'Language Name',
	   L1.[Percentage] AS 'Language Percentage'
FROM dbo.LANGUAGE L1
JOIN dbo.Country C ON C.Code = L1.Country
WHERE L1.[Percentage] IN (SELECT MAX(L2.[Percentage]) AS [Percentage]
						  FROM dbo.LANGUAGE L2
						  WHERE L1.[Country] = L2.[Country]
						  GROUP BY L2.[Country])
ORDER BY C.[Name] ASC,
	     L1.[Percentage] DESC;



-- 4)	Display the most widely spoken language in the continent Europe?
 	    -- hint refer to Encompasses table
SELECT L1.[Name] AS 'Language Name',
	   L1.[Percentage] AS 'Language Percentage',
	   E.[Continent]
FROM dbo.LANGUAGE L1
JOIN dbo.encompasses E ON E.Country = L1.Country
JOIN dbo.Country C ON C.Code = L1.Country
WHERE L1.[Percentage] IN (SELECT MAX(L2.[Percentage]) AS [Percentage]
						  FROM dbo.LANGUAGE L2
						  WHERE L1.[Country] = L2.[Country]
						  GROUP BY L2.[Country])
AND E.[Continent] = 'Europe'
ORDER BY L1.[Percentage] DESC,
		 L1.[Name] ASC;



SELECT L1.[Name] AS 'Language Name',
	   C.[Population] AS 'Total Population'
FROM dbo.Country C
JOIN dbo.encompasses E ON E.Country = C.Code
JOIN dbo.LANGUAGE L1 ON L1.Country = C.Code
WHERE E.[Continent] = 'Europe'
AND L1.[Percentage] IN (SELECT MAX(L2.[Percentage]) AS [Percentage]
						FROM dbo.LANGUAGE L2
						WHERE L1.[Country] = L2.[Country]
						GROUP BY L2.[Country])
ORDER BY L1.[Name] ASC,
	     'Total Population' DESC;



SELECT L1.[Name], MAX(L.[Percentage]) AS [Percentage]
FROM dbo.LANGUAGE L
JOIN dbo.Country C ON C.Code = L.Country
GROUP BY L.[Country]


SELECT C.[Name] AS 'Country Name',
	   E.[Continent] AS 'Continent',
	   C.[Population] AS 'Total Population',
	   L1.[Name] AS 'Language Name',
	   L1.[Percentage] AS 'Language Percentage'




SELECT L1.[Name] AS 'Language Name',
	   (SELECT SUM(C2.[Population]) AS [Population]
	    FROM dbo.Country C2
		JOIN dbo.LANGUAGE L3 ON L3.Country = C2.Code
		WHERE L1.Country = L3.Country
		GROUP BY L3.Country) 
	    AS 'Total Population'
FROM dbo.Country C1
JOIN dbo.encompasses E ON E.Country = C1.Code
JOIN dbo.LANGUAGE L1 ON L1.Country = C1.Code
WHERE E.[Continent] = 'Europe'
AND L1.[Percentage] IN (SELECT MAX(L2.[Percentage]) AS [Percentage]
						FROM dbo.LANGUAGE L2
						WHERE L1.[Country] = L2.[Country]
						GROUP BY L2.[Country])
ORDER BY L1.[Name] ASC,
	     'Total Population' DESC;
		 




SELECT [Name] AS 'Country Name',
	   [Population] AS 'Total Population',
	   [Province] AS 'Province'
FROM dbo.Country
ORDER BY [Province] ASC;









WHERE L1.[Percentage] IN (SELECT MAX(L2.[Percentage]) AS [Percentage]
						  FROM dbo.LANGUAGE L2
						  WHERE L1.[Country] = L2.[Country]
						  GROUP BY L2.[Country])
AND E.[Continent] = 'Europe'
ORDER BY L1.[Percentage] DESC,
		 L1.[Name] ASC;


