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
--			Query does the following:
--				- Selects from the Economy table the GDP records and uses
--				  MIN keyword to get minimum GDP
--				- Uses Top 1 to get the country with the lowest GDP
--				- JOINs the Country table so that report will list the country 
--				  name instead of the country code
--
SELECT TOP 1 C.Name
       ,MIN(GDP) AS "Minimum GDP"
FROM dbo.Economy E
JOIN dbo.Country AS C ON C.[Code] = E.[Country]
WHERE GDP IS NOT NULL
GROUP BY C.Name
ORDER BY "Minimum GDP" ASC;



-- 2)   Find the population growth rate for each city?
		-- hint refer to Citypops table and https://pages.uoregon.edu/rgp/PPPM613/class8a.htm for population growth rate
		-- EXTRA CREDIT
--
--		Query does the following:
--			- Since not all of the cities have the same interval of years (some cities have 4 year interval 
--            between data points, some have 10 years) the query attempts to calculate the
--            growth rate of each city dynamically by using the last 2 year data points of the city
--			- The query only looks at cities that >2 year points
--			- For each city with >2 year points query will retrieve the data from the latest year point
--		      and previous year point
--			- By doing this it doesn't matter if the previous year point is 4 years ago or 10 years ago
--		      the calculation takes the difference in years between the 2 points
--			- In the SELECT statement it is clunky but it works from what I see - for each part of the 
--			  calculation (latest year, latest population, previous year, previous population) I am 
--			  using a subquery to extract the exact information I need using:
--					OFFSET 0 ROWS / FETCH NEXT 1 ROW ONLY to get the first item in list (for latest year info)
--					OFFSET 1 ROWS / FETCH NEXT 1 ROW ONLY to get the second item in the list (for previous year info)
--
--			- This query can probably be simplified but banged my head forever against the wall trying to 
--			  simplify it without success
--
SELECT DISTINCT CP1.City,
	   
	   (SELECT CP2.Year
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 0 ROWS
		FETCH NEXT 1 ROW ONLY) AS 'Latest Year',
	   
	   (SELECT CP2.Population
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 0 ROWS
		FETCH NEXT 1 ROW ONLY) AS 'Latest Population',
	   
	   (SELECT CP2.Year
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY) AS 'Previous Year',
	   
	   (SELECT CP2.Population
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY) AS 'Previous Population',

		-- Growth Rate Calculation:
		--	(((Present Year Population - Previous Year Population) / (Previous Year Population)) * 100)
		--  ------------------------------------------------------------------------------------------- (divided by)
		--                               (Present Year - Past Year)

		-- Breakdown of equation:
		--	(Present Year Population - Previous Year Population)
		--		Selecting the Present Year Population for city
	   ((((SELECT CP2.Population
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 0 ROWS
		FETCH NEXT 1 ROW ONLY) -
		
		--		MINUS
		--		Selecting the Previous Year Population for city
		(SELECT CP2.Population
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY)) /
		
		-- / (Previous Year Population)
		-- DIVIDED BY
		--		Selecting the Previous Year Population for city
		-- and multiply by 100
		(SELECT CP2.Population
	    FROM dbo.Citypops CP2
		WHERE CP2.City = CP1.City AND
		      CP2.Population > 0
		ORDER BY CP2.Year DESC
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY)) * 100) /
		
		-- / (Present Year - Past Year) Year difference of data being used
		-- DIVIDED BY
		-- NULLIF is used to avoid divide by zero error
		--		Selecting Latest Year
		(NULLIF(((SELECT CP2.Year
	     FROM dbo.Citypops CP2
		 WHERE CP2.City = CP1.City AND
		       CP2.Population > 0
		 ORDER BY CP2.Year DESC
		 OFFSET 0 ROWS
		 FETCH NEXT 1 ROW ONLY) -

		--		MINUS
		--		Selecting Previous Year
		 (SELECT CP2.Year
	      FROM dbo.Citypops CP2
		  WHERE CP2.City = CP1.City AND
		        CP2.Population > 0
		  ORDER BY CP2.Year DESC
		  OFFSET 1 ROWS
		  FETCH NEXT 1 ROW ONLY)),0)) AS 'City Growth Rate %'

FROM dbo.Citypops CP1
GROUP BY CP1.City
HAVING COUNT(CP1.Year) > 2
ORDER BY CP1.City ASC;



-- 3)	Display the most widely spoken language for each country, using a subquery?
--			Query does the following:
--				- Retrieves the language and percentage that that language is 
--				  spoken in each country
--				- Uses a subquery to find the language that is spoken the most using
--				  the MAX keyword in each country
--				- Report is sorted by country and then by the language
--				- JOINs the Country table so that report will list the country 
--				  name instead of the country code
--
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
--			As discussed in class:
--			Query does the following:
--				- JOINs the Country table so that report will list the country 
--				  name instead of the country code
--				- The JOIN statement also only pulls countries that are in Europe
--				- JOINs the Language table based on country code to get the languages
--				  spoken in the countries
--				- For each language the population of people who speak that language 
--				  is calculated by multiplying the percentage of people who speak 
--				  the language with the population of each country where language is
--				  spoken
--				- These population numbers are added together with the keyword SUM to
--				  get total population of people who speak each language
--				- Finally, since we only want to most widely spoken language we
--				  ORDER BY the total population for each spoken language in 
--				  descendinhg order and using TOP 1 we just list the first one (most widely spoken)
--				
SELECT TOP 1 L.[Name] AS 'Language Name',
		     SUM(L.[Percentage] * C.[Population]) AS 'Population that speaks Language'
FROM dbo.encompasses E
JOIN dbo.Country C ON E.[Country] = C.[Code] AND E.[Continent] = 'Europe'
JOIN dbo.Language L ON L.[Country] = C.[Code]
GROUP BY L.[Name]
ORDER BY 'Population that speaks Language' DESC;



-- 5)	Display all top 5 Countries that have the largest area of Lakes combined?
--			Query does the following:
--				- Retrieves the lakes for each country from the geo_Lake table
--				- JOINs Lake table to geo_lake table based on lake name so that
--				  we can retrieve the area for each lake
--				- The area for all of the lakes in each country is totaled using 
--				  the SUM keyword
--				- Report is ordered by total lake area per country in descending order 
--				  and uses TOP 5 to get the top 5 countries with the largest lake area
--				- JOINs the Country table so that report will list the country 
--				  name instead of the country code
--
SELECT TOP 5 C.[Name] AS 'Country Name',
	   SUM(L2.[Area]) AS 'Total Lake Area'
FROM dbo.geo_Lake L1
JOIN dbo.Country C ON C.[Code] = L1.[Country]
JOIN dbo.Lake L2 ON L2.[Name] = L1.[Lake]
GROUP BY C.[Name]
ORDER BY 'Total Lake Area' DESC;