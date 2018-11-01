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

