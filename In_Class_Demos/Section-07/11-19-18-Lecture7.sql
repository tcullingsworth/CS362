/*************************************************************************************************
* Author:	Biz Nigatu
*
* Description:	This script is created to teach students Structure Query Language for Data Management.
*
* Notes: Lecture 7: JOIN (Detail)
**************************************************************************************************
* Change History
**************************************************************************************************
* Date:			Author:			Description:
* ----------    ---------- 		--------------------------------------------------
* 09/07/2018	BNigatu			initial version created
*************************************************************************************************
* Usage:
*************************************************************************************************
Execute each batch of the script sequentially
*************************************************************************************************/

-- JOINs
--		- JOIN / INNER JOIN - joins on primary key
--		- Sometimes we do not want to JOIN on a primary key
--		- For example if we want to see countries with or without rivers:
--			Use LEFT JOIN:  FROM Country LEFT JOIN River
--			will display all countries even though a country might not have a river
--			in this case the countries without rivers will show NULL where river would be
--		- Can use an OUTER JOIN

USE [trevor.cullingsworth];
go
/*==============================================================================================
 * 1) INNER JOIN or simply JOIN
 *==============================================================================================*/
-- Inner join is a join that displays only the rows that have a match in both joined tables. 
SELECT c.Name as Country_Name, 
	   d.Desert as Desert_Name
FROM Country c
JOIN geo_Desert d ON c.code = d.Country; -- This is the same as using
									     -- INNER JOIN Desert d ON c.code = d.Country


/*==============================================================================================
 * 2) LEFT OUTER JOIN or simply LEFT JOIN
 *==============================================================================================*/
-- Left outer join All rows from the first-named table (the "left" table, which 
-- appears leftmost in the JOIN clause) are included. 
SELECT c.Name as Country_Name, 
	   d.Desert as Desert_Name
FROM Country c
LEFT OUTER JOIN geo_Desert d 
	ON c.Code = d.Country;


/*==============================================================================================
 * 3) RIGHT OUTER JOIN or simply RIGHT JOIN
 *==============================================================================================*/
-- Right outer join All rows in the second-named table (the "right" table, which 
-- appears rightmost in the JOIN clause) are included. 
SELECT d.Desert as Desert_Name,
	   c.Name as Country_Name
FROM geo_Desert d
RIGHT OUTER JOIN Country c
		ON c.Code = d.Country;


/*==============================================================================================
 * 4) FULL OUTER JOIN
 *==============================================================================================*/
-- Full outer join All rows in all joined tables are included, whether they are matched or not. 
SELECT (SELECT Name FROM Country WHERE Code = ISNULL(geo_Desert.Country, geo_Mountain.Country)) AS Country, 
       geo_Desert.Desert, 
       geo_Mountain.Mountain
FROM geo_Mountain 
FULL OUTER JOIN geo_Desert 
            ON geo_Desert.Country 
             = geo_Mountain.Country;


/*==============================================================================================
 * 5) CROSS JOIN
 *==============================================================================================*/
-- Cross join is a join whose result set includes one row for each possible pairing of 
-- rows from the two tables. This join simply provides a cartesian product of the data sets.

SELECT *
FROM Desert CROSS JOIN Mountain;  -- Desert X Mountain

--		Table A		Table B
--		  1		      3
--		  2			  4
-- Will provide the following results:
--		1,3
--		1,4
--		2,3
--		2,4

/*==============================================================================================
 * 6) Using Subqueries in FROM clause
 *==============================================================================================*/
-- Display all countries with their tallest mountain if they have one.
SELECT c.Name as Country_Name, 
	   m.Highest_Elevation
FROM Country c
LEFT JOIN  (SELECT Country, MAX(Mountain.Elevation) AS Highest_Elevation
			FROM geo_Mountain join Mountain on Mountain.Name = geo_Mountain.Mountain
			GROUP BY Country) AS m ON c.Code = m.Country; -- AS m provides a name to your Subquery


/*==============================================================================================
 * 7) Joining tables using a WHERE clause
 *==============================================================================================*/
--There is no reason for you to join this way for new queries that you are writing.
--However, there are two reasons why you should know this method.
-- 1) You might get a chance to work on a SQL script that was created 
--	  long time ago and you don't get confuse by this.
-- 2) To avoid any accidental joins or converting any of the OUTER JOINS to 
--	  INNER JOIN unintentionally.

-- Example 1
SELECT c.Name as Country_Name, 
	   d.Desert as Desert_Name
FROM  Country c, geo_Desert d -- Stopping here makes this a cross join - need to use the WHERE clause
WHERE  c.code  =  d.Country ; -- This is the same as INNER JOIN Country and Desert

-- Example 2
SELECT c.Name as Country_Name, 
	   m.Mountain as Mountain_Name
FROM Country c
LEFT JOIN geo_Mountain m ON c.Code = m.Country 
WHERE m.Mountain LIKE 'A%'; -- Even if the two tables are joined with OUTER JOIN, because
						     -- of the where clause the join is converted to INNER JOIN

-- Example 2 another implementation
SELECT c.Name as Country_Name, 
	   m.Mountain as Mountain_Name
FROM Country c
LEFT JOIN geo_Mountain m ON c.Code = m.Country AND m.Mountain LIKE 'A%'; 
-- by adding the criteria of 'A%' as part of the LEFT JOIN it will list all countries
-- regardles if they have a mountain starting with A or not but in the case of countries 
-- with no 'A' mountain the query displays NULL

SELECT c.Name as Country_Name, 
	   m.Mountain as Mountain_Name
FROM Country c
LEFT JOIN geo_Mountain m ON c.Code = m.Country AND m.Mountain LIKE 'A%';


/*==============================================================================================
 * 8) Using CROSS APPLY/ OUTER APPLY to make a join
 *==============================================================================================*/
-- Using CROSS APPLY
-- You can execute functions and sub selects in an optimized way

SELECT c.[Name],c.[Population], p.projected_population
FROM Country AS c
CROSS APPLY ( SELECT POWER(c.[Population] , 2)  AS projected_population ) AS p;

-- Example: for each country, select a religion that has the most followers 
-- Without using subselect/subqueries.

SELECT DISTINCT 
	   R1.Country
      ,R1.[Name] AS Religion    
	  ,R2.[Max_Percentage]
FROM dbo.Religion R1
CROSS APPLY (SELECT MAX([Percentage]) AS [Max_Percentage] -- this sub select is used to as a filter
			 FROM dbo.Religion
			 WHERE Country = R1.Country
			 GROUP BY Country
			 HAVING MAX([Percentage]) = R1.[Percentage]) AS R2
ORDER BY  Country ASC, [Max_Percentage] DESC;


/*==============================================================================================
 * 9) Set operationS in SQL: UNION, INTERSECT and EXCEPT
 *==============================================================================================*/
CREATE DATABASE FourthDatabase;
go

USE FourthDatabase;
go
 --create sample tables
 CREATE TABLE TABLE1(
	NUMBER INT
 );

 CREATE TABLE TABLE2(
	NUMBER INT
 );
 GO

 INSERT INTO TABLE1 VALUES(1),(2),(3),(4);
 INSERT INTO TABLE2 VALUES(2),(4),(5),(6),(7),(8);
 GO

/*
 To be union compatible:
   - The number and the order of the columns must be the same in all queries.
   - The data types must be compatible.
*/

 -- UNION gives a union of the two sets (A U B): 1,2,3,4,5,6,7,8
 SELECT NUMBER
 FROM TABLE1
 UNION      -- This combines the result of the top and bottom SELECT queries.
 SELECT NUMBER
 FROM TABLE2;


-- INTERSECT gives the intersection of common to both sets (A n B): 2 and 4 
 SELECT NUMBER
 FROM TABLE1
 INTERSECT      -- This gives the intestection of both the top and bottom SELECT queries.
 SELECT NUMBER
 FROM TABLE2;

 -- EXCEPT gives values from in the left that are not in the right sets (A \ B): 1 and 3
 SELECT NUMBER
 FROM TABLE1
 EXCEPT      -- This gives rows that are at the top SELECT but not in bottom SELECT queries.
 SELECT NUMBER
 FROM TABLE2;


/*==============================================================================================
 * 10) Casting or Converting data types
 *==============================================================================================*/
USE CIA_FACTBOOK_DB;
go

-- Let us combine contry name, its capital and total area for display purpose.
-- This query will give an error since area is a float and can not be concatinated with other string.
-- converting happens at run time - does not alter the table

SELECT [Name] +' - '+ Capital +' - '+ Area 
FROM Country;


-- Using CAST
SELECT [Name] +' - '+ Capital +' - '+ CAST(Area AS VARCHAR(50)) AS [UsingCast]
FROM Country;

-- Using CONVERT
SELECT [Name] +' - '+ Capital +' - '+ CONVERT(VARCHAR(50), Area) AS [UsingConvert]
FROM Country;

/*
 * Here are some examples
 */

-- Dates
SELECT GETDATE() AS [CurrentTimeStamp],
       CAST(GETDATE() AS DATE) AS [CastToOnlyDate],
	   CONVERT(DATE, GETDATE()) AS [ConvertToOnlyDate],
	   CONVERT(VARCHAR(10), GETDATE(), 112) [ConvertAlsoSupportFormating-YYYYMMDD]

-- the date format 112 is set in SQL to YYYYMMDD
-- 111 format YYYY/MM/DD etc.  - can google all of the formats

-- Text to INT
SELECT '1' AS [This is Text 1],
	   CAST('1' AS INT) AS [CAST to number 1],
	   CONVERT(INT, '1') AS [CONVERT to number 1]

-- Text to Binary
SELECT 'SQL' AS [This is Text SQL],
	   CAST('SQL' AS VARBINARY(50)) AS [CAST to varbinary],
	   CONVERT(VARBINARY(50), 'SQL') AS [CONVERT to varbinary]


 /*==============================================================================================
 * Exercise Questions
 *==============================================================================================*/

/*
  1) Find all cities that exist in the continent of Africa?
  2) You are an analyst for Census Bureau and asked to find US cities _that are losing their population year after year, 
     for example, Akron Ohio?
      -- hint use Citypops tables and make sure the cities are in the USA.
  3) You are working as a database consultant to one of the major political party in the next national election.
	 Your party asked you to provide the top 3, most populated cities in the Swing States to run TV ads?
	   -- hint Use City table. Find the Swing States from https://en.wikipedia.org/wiki/Swing_state
  4) You are working for FEMA, and due to its relations to hurricane you are requested to find rivers that have 
	 "estuary elevation" more than 100 feet in the USA?
	   -- hint Make sure the estuary is in the USA.
  5) Create a report that has the name of State and all water body sorted by State and Water body in ascending order?
	   -- hint vertically combine [State, Lake] and [State, River]
*/

-- Question 1
SELECT C1.Name AS CityName,
       C2.Name AS CountryName,
	   E.Continent AS ContinentName
FROM dbo.City C1
JOIN dbo.Country C2 ON C1.Country = C2.Code
JOIN dbo.encompasses E ON C2.Code = E.Country AND
E.Continent = 'Africa' AND
E.Percentage = 100;


