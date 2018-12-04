/***************************************************************************************************************
* Author     :	Trevor Cullingsworth
* Email      :	trevor.cullingsworth@my.denver.coloradotech.edu
* Course     :  CS362 - Structured Query Language for Data Management
* Description:	Lab 3 SQL query exercise assignment
* Date       :	Due 11/30/18
*				
* Notes:
*	From CIA FactBook database please write 5 queries that will answer the following questions. 
*	Make sure your query is properly commented and it is executable before submitting.
*
*	1) Find all cities that exist in the continent of Africa?
*	2) You are an analyst for Census Bureau and asked to find US cities _that are losing their population year after year, 
*      for example, Akron Ohio?
*      -- hint use Citypops tables and make sure the cities are in the USA.
*	3) You are working as a database consultant to one of the major political party in the next national election.
*	   Your party asked you to provide the top 3, most populated cities in the Swing States to run TV ads?
*	   -- hint Use City table. Find the Swing States from https://en.wikipedia.org/wiki/Swing_state
*	4) You are working for FEMA, and due to its relations to hurricane you are requested to find rivers that have 
*	   "estuary elevation" more than 100 feet in the USA?
*	   -- hint Make sure the estuary is in the USA.
*	5) Create a report that has the name of State and all water body sorted by State and Water body in ascending order?
*	   -- hint vertically combine [State, Lake] and [State, River]
*
***************************************************************************************************************/

USE [trevor.cullingsworth];
go

-- 1)	Find all cities that exist in the continent of Africa?
--			Query does the following:
--				- Selects city name from the city table
--				- Joins the country table to get the country name
--				- Joins the encompasses table and using this encompasses table
--				  query looks for the cities that are 100% in the continent Africa
--
SELECT C1.Name AS CityName,
       C2.Name AS CountryName,
	   E.Continent AS ContinentName
FROM dbo.City C1
JOIN dbo.Country C2 ON C1.Country = C2.Code
JOIN dbo.encompasses E ON C2.Code = E.Country AND
E.Continent = 'Africa' AND
E.Percentage = 100;



-- 2)	You are an analyst for Census Bureau and asked to find US cities _that are losing their population year after year, 
--	    for example, Akron Ohio?
--      -- hint use Citypops tables and make sure the cities are in the USA.
--		Query provided in class
--		As far as I understand the query:
--			Query does the following:
--				- Creates a common table expression to get number of years of population data per USA city
--				- Using this temporary table the query gets the population data from the next 
--				  data point (one more row than current loaded data point) - in the query the current
--				  loaded data point is A.[Population] and next data point is B.[Population]
--			      The comparison is checking if current data point A.[Population] is greater than
--			      next data point B.[Population] then the population decreased from data point A to 
--			      data point B
--				- For the results each city is listed with its data points and the population from those
--				  data points
--
;WITH CTE AS (
	SELECT *, row_number() OVER(PARTITION BY City, Province ORDER BY [Year]) AS row_num
	FROM Citypops
	WHERE Country = 'USA'
)
SELECT A.City,
	   A.Province,
	   C.[Year], 
	   C.Population
FROM CTE as A
JOIN dbo.Citypops C ON C.City = A.City 
LEFT JOIN CTE AS B ON A.City = B.City AND
					  A.Province = B.Province AND 
					  A.row_num+1 = B.row_num AND
					  A.[Population] > B.[Population]
GROUP BY A.City,
         A.Province,
		 C.[Year],
		 C.Population
HAVING MAX(A.row_num)-1 = COUNT(B.row_num);



-- 3)	You are working as a database consultant to one of the major political party in the next national election.
--	    Your party asked you to provide the top 3, most populated cities in the Swing States to run TV ads?
--	    -- hint Use City table. Find the Swing States from https://en.wikipedia.org/wiki/Swing_state
--			Query does the following:
--				- Query will only use the following states since we only need "swing states":
--					Colorado
--					Florida
--					Iowa
--					Michigan
--					Minnesota
--					Ohio
--					Nevada
--					New Hampshire
--					North Carolina
--					Pennsylvania
--					Virginia
--					Wisconsin
--				- Creates a common table expression to get a list of cities for each state and 
--				  the population of those cities in descending order (most populous to least)
--				- The query filters the cities to only look for cities in the USA and only from 
--				  the swing states
--				- The results of the query will further be filtered to only list the top 3 (if available) 
--				  most populous cities per state		
--
;WITH CTE AS (
	SELECT *, row_number() OVER(PARTITION BY Province ORDER BY Population DESC) AS row_num
	FROM dbo.City
	WHERE Country = 'USA' AND
	      Province IN ('Colorado',
		           'Florida',
				   'Iowa',
				   'Michigan',
				   'Minnesota',
				   'Ohio',
				   'Nevada',
				   'New Hampshire',
				   'North Carolina',
				   'Pennsylvania',
				   'Virginia',
				   'Wisconsin')
)
SELECT Province AS State,
	   Name AS City,
       Population
FROM CTE
WHERE row_num < 4
ORDER BY Province ASC;



-- 4)  You are working for FEMA, and due to its relations to hurricane you are requested to find rivers that have 
--	   "estuary elevation" more than 100 feet in the USA?
--	   -- hint Make sure the estuary is in the USA.
--			Query does the following:
--				- Gets the estuary elevation information from the dbo.River table
--				- Joins the dbo.geo_River table in order to get the country/state information for the rivers
--				- Filters results by looking for all non-NULL rivers and estuary elevations and 
--				  only rivers in USA with an elevation > 100
--
SELECT R2.Province AS "State",
       R1.River,
	   R1.Name,
	   R1.EstuaryElevation
FROM dbo.River R1
JOIN dbo.geo_River R2 ON R2.River = R1.River
WHERE R1.River IS NOT NULL AND
      R1.EstuaryElevation IS NOT NULL AND
	  R2.Country = 'USA' AND
	  R1.EstuaryElevation > 100
ORDER BY R2.Province ASC;



-- 5)	Create a report that has the name of State and all water body sorted by State and Water body in ascending order?
--	    -- hint vertically combine [State, Lake] and [State, River]
--			Query does the following:
--				- Selects the state and lake name (only USA) from geo_Lake table
--				- Combines/union this info with:
--				- Selects the state and river name (only USA) from the geo_River table
--				- Sorts the results by State (Province)
--
SELECT Province AS "State",
	   Lake
FROM dbo.geo_Lake
WHERE Country = 'USA'
UNION
SELECT Province AS "State",
	   River
FROM dbo.geo_River
WHERE Country = 'USA'
ORDER BY Province ASC;
