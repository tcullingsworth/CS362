/***************************************************************************************************************
* Author     :	Trevor Cullingsworth
* Email      :	trevor.cullingsworth@my.denver.coloradotech.edu
* Course     :  CS362 - Structured Query Language for Data Management
* Description:	Week 03- Reading and Participation
* Date       :	10-22-2018
*				
* Notes:
*	1)  Select all cities in state of 'New York'?
*	2)  Find countries that have some part of their region on different continents?
*		-- hint refer to Encompasses table
*	3)  Display an Airport in 'USA' that has an elevation of 313?
*	4)  Select Islands that has an Elevation between 3000 and 4000 feet?
*	5)  Display all top 5 Lakes in the world that has the largest Area? 
*		(Use subquery to make this a bit difficult. Hint, don't use TOP function)
***************************************************************************************************************/

USE [trevor.cullingsworth];
go

SELECT 'Select all cities in state of "New York"?' AS 'Query Title';
-- 1) Select all cities in state of 'New York'?
--		I added a title to query results
SELECT *
FROM dbo.City
WHERE Province = 'New York';

SELECT 'Find countries that have some part of their region on different continents?' AS 'Query Title';