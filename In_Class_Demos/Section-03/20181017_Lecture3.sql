/*************************************************************************************************
* Author     :	Trevor Cullingsworth
* Email      :	trevor.cullingsworth@my.denver.coloradotech.edu
* Date       :  10-17-2018
* Course     :  CS362 - Structured Query Language for Data Management
* Description:  WK03-Reading and Participation
* Notes:
*	We will work on the following questions and we will add some more if we have time:
*		Q1) Display Lakes that are present in a country that do not have any rivers. 
*		-- hint use geo_Lake and geo_River tables
*
*		Q2) Display cities from English speaking countries that has to top 5 population size
*		-- hint use City and Language tables, you may use TOP function
*
*		Q3) Display cities in USA that exists in two or more stats. 
*		-- hint use City table
*
*		Q4) Display the top 5 Islands in the world that has the largest Area size
*		-- hint use Island table and make sure to exclude Islands that has NULL area size. 
*		-- Do not use TOP function for this question.
*
*		Q5) You are working on the next G8-20 summit and tasked to find countries, whose economy is 
*		    between 8th - 20th largest economy in the world.
*		-- hint use dbo.Economy Table and a subquery
*
*************************************************************************************************/

USE [trevor.cullingsworth];
go

-- Q1) Display Lakes that are present in a country that do not have any rivers.
-- Using "NOT IN" from Subquery
-- Subquery selects countries in dbo.geo_River table and the NOT IN will list all
-- of the lakes and their countries that are not listed in subquery results 
-- Therefore the reqults of this query displays lakes and their countires that do not 
-- have any rivers.
SELECT Lake, Country
FROM dbo.geo_Lake
WHERE Country NOT IN (SELECT Country
					  FROM dbo.geo_River);

-- Q2) Display cities from English speaking countries that has to top 5 population size
SELECT TOP 5 [Name], [Country], Population
FROM dbo.City
WHERE Country IN (SELECT Country
			      FROM dbo.[LANGUAGE]
				  WHERE [Name] = 'English')
ORDER BY Population DESC;

-- Q3) Display cities in USA that exists in two or more stats.
SELECT *
FROM dbo.City
WHERE Country = 'USA' AND
	  Name IN (SELECT Name
	             FROM City AS c1
				 WHERE c1.Name = City.Name AND
				 c1.Province <> City.Province AND
				 c1.Country = 'USA')
ORDER BY City.Name;

SELECT *
FROM dbo.City
WHERE Country = 'USA' AND
      (SELECT COUNT(*) AS Cnt
	   FROM City AS c1
	   WHERE c1.Name = City.Name AND
	   c1.Country = 'USA') > 1
ORDER BY City.Name;

-- Q4) Display the top 5 Islands in the world that has the largest Area size
-- hint use Island table and make sure to exclude Islands that has NULL area size. 
-- Do not use TOP function for this question.
SELECT *
FROM dbo.Island
WHERE Area IS NOT NULL
ORDER BY Area DESC;

SELECT Name, Islands, Area, Elevation
FROM dbo.Island
WHERE 5 > (SELECT COUNT(Name) AS cnt
       FROM dbo.Island AS I
	   WHERE Island.Area < I.Area AND
	   I.Area IS NOT NULL) AND
Island.Area IS NOT NULL
ORDER BY Island.Area DESC;


SELECT Name, Islands, Area, Elevation
FROM dbo.Island
WHERE 5 > (SELECT COUNT(Name) AS cnt
       FROM dbo.Island AS I
	   WHERE Island.Area < I.Area AND
	   I.Area IS NOT NULL) AND
Island.Area IS NOT NULL
ORDER BY Island.Area DESC;


SELECT Name, Islands, Area, Elevation
FROM dbo.Island
WHERE (SELECT COUNT(Name) AS cnt
       FROM dbo.Island AS I
	   WHERE Island.Area < I.Area AND
	   I.Area IS NOT NULL) BETWEEN 5 AND 20 AND
Island.Area IS NOT NULL
ORDER BY Island.Area DESC;

-- Q5) You are working on the next G8-20 summit and tasked to find countries, whose economy is 
--	   between 8th - 20th largest economy in the world.
--     hint use dbo.Economy Table and a subquery
SELECT Country, GDP
FROM dbo.Economy
WHERE (SELECT COUNT(GDP) AS cnt
       FROM dbo.Economy AS E
	   WHERE Economy.GDP < E.GDP AND
	   E.GDP IS NOT NULL) BETWEEN 7 AND 19 AND
Economy.GDP IS NOT NULL
ORDER BY Economy.GDP DESC;

