/***************************************************************************************************************
* Author     :	Trevor Cullingsworth
* Email      :	trevor.cullingsworth@my.denver.coloradotech.edu
* Course     :  CS362 - Structured Query Language for Data Management
* Description:	Lab 4 SQL query exercise assignment
* Date       :	Due 12/07/18
*				
* Notes:
*	From CIA FactBook database please write 5 queries that will answer the following questions. 
*	Make sure your query is properly commented and it is executable before submitting.
*
*	1) Download the class Roster as CSV and create a new table to import the CSV to a new table Roster?
*	2) Update sales to the same Sales agent to USASales table if the same agent has sales on both USA and Canada?
*	   -- Configure the Excercise database first to answer this question.
* 	   -- hint FROM, and JOIN are allowed in DELETE AND UPDATE queries.
*	3) After completing Question 2, Delete all sales from SalesCanada if the sales agent in CanadaSales has any sales in USASales?
*	4) Insert a new sales agent ('20','YourName','YourLastName','123 Some Address','100','CASH') to USASales?
*	5) We can be able to undo deleted records in SQL Server. (Ture/False)?
*
***************************************************************************************************************/

USE [trevor.cullingsworth];
go

IF OBJECT_ID('Roster') IS NULL
CREATE TABLE Roster(
	FirstName VARCHAR(50),
	LastName  VARCHAR(50),
	EMail VARCHAR(50)
	);
GO

SELECT * FROM Roster;

BULK INSERT [trevor.cullingsworth].dbo.Roster 
   FROM 'c:\Users\trevor.cullingsworth\github\Query Scripts\Lab 4\CS362_Cullingsworth_SQL_Query_Exercise_Lab4_class_roster.csv' -- this needs to be a full path where you have your Students.csv file
   WITH   
      (  
         FIELDTERMINATOR =',',  
         ROWTERMINATOR ='\n'
      );  

Msg 4834, Level 16, State 4, Line 7
You do not have permission to use the bulk load statement.

-- Check what's in the table
SELECT * FROM Roster;


-- --------------------------------------------------------------------------------------

-- Question 2:
--*	2) Update sales to the same Sales agent to USASales table if the same agent has sales on both USA and Canada?
--*	   -- Configure the Excercise database first to answer this question.
--*    -- hint FROM, and JOIN are allowed in DELETE AND UPDATE queries.

SELECT *
FROM dbo.USASales;

SELECT *
FROM dbo.CanadaSales;



