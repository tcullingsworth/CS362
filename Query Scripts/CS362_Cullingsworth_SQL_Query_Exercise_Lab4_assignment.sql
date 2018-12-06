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
*	5) We can be able to undo deleted records in SQL Server. (True/False)?
*
***************************************************************************************************************/

USE [trevor.cullingsworth];
GO

-- 1)	Download the class Roster as CSV and create a new table to import the CSV to a new table Roster?
--			Query does the following:
IF OBJECT_ID('Roster') IS NULL
CREATE TABLE Roster(
	FirstName VARCHAR(50),
	LastName  VARCHAR(50),
	EMail VARCHAR(50)
	);
GO

SELECT * FROM Roster;

/***************************************************************************************************************
*	When working with SQL Server at home the following BULK INSERT command will be used since there is not
*	a permission issue with the command
***************************************************************************************************************/

/*
BULK INSERT [trevor.cullingsworth].dbo.Roster 
   FROM 'c:\Users\trevor.cullingsworth\github\Query Scripts\Lab 4\CS362_Cullingsworth_SQL_Query_Exercise_Lab4_class_roster.csv' -- this needs to be a full path where you have your Students.csv file
   WITH   
      (  
         FIELDTERMINATOR =',',  
         ROWTERMINATOR ='\n'
      );  
*/

/***************************************************************************************************************
*	For in class work the following code will be used for this question since the BULK INSERT command 
*	above gives a permission issue
***************************************************************************************************************/

INSERT INTO Roster VALUES ('Bizuayehu', 'Nigatu', 'BNigatu@coloradotech.edu'),
						  ('Julia', 'Bueno', 'julia.bueno@my.denver.coloradotech.edu'),
						  ('Trevor', 'Cullingsworth', 'trevor.cullingsworth@my.denver.coloradotech.edu'),
						  ('Scott', 'Herbert', 's.herbert16@my.denver.coloradotech.edu'),
						  ('Timothy', 'Hostetter', 't.hostetter@my.denver.coloradotech.edu'),
						  ('Troy', 'Kruger', 't.kruger1@my.denver.coloradotech.edu'),
						  ('William', 'Reid', 'w.reid6@my.denver.coloradotech.edu'),
						  ('Robert', 'Sanders', 'r.sanders67@my.denver.coloradotech.edu'),
						  ('Naximus', 'Tyrand', 'n.tyrand@my.denver.coloradotech.edu'),
						  ('Mark', 'Weber', 'm.weber26@my.denver.coloradotech.edu');

-- Check what's in the table
SELECT * FROM Roster;



-- 1)	Download the class Roster as CSV and create a new table to import the CSV to a new table Roster?
--			Query does the following:

-- --------------------------------------------------------------------------------------

-- Question 2:
-- 2)	Update sales to the same Sales agent to USASales table if the same agent has sales on both USA and Canada?
--		-- Configure the Excercise database first to answer this question.
--		-- hint FROM, and JOIN are allowed in DELETE AND UPDATE queries.

UPDATE dbo.USASales
SET Amount = U.[Amount] + C.[Amount]
FROM dbo.USASales U
JOIN dbo.CanadaSales C ON C.AgentID = U.AgentID;

SELECT *
FROM dbo.USASales;



