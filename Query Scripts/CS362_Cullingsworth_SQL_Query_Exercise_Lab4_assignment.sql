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
--			- Checks if table named Roster exists
--			- If not create this table with the 3 columns: FirstName, LastName, EMail - all VARCHAR
--			- Can use BULK INSERT is permissable to populate the records into the table from .csv file
--			- If BULK INSERT is not available due to permissions use the INSERT INTO to populate
--			  the table with the specified data
--
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

/***************************************************************************************************************
*	If you wish to start from the beginning uncomment the following DROP TABLE lines and execute
*	Then you can re-run the above code to create the table again 
***************************************************************************************************************/

/*
DROP TABLE IF EXISTS Roster;  
GO

-- Check what's in the table - should give an error saying table doesn't exist (Invalid object name 'Roster')
SELECT * FROM Roster;
*/



-- 2)	Update sales to the same Sales agent to USASales table if the same agent has sales on both USA and Canada?
--		-- Configure the Excercise database first to answer this question.
--		-- hint FROM, and JOIN are allowed in DELETE AND UPDATE queries.
--		-- SalesDatabase database code at bottom of script - uncomment to execute and set up the database for this
--		-- question
--		Query does the following:
--			- Assumptions:
--				- SalesDatabase database is created and populated
--				- Amount in both tables (USASales, CanadaSales) is the cash sales agent received from sales
--				- So because of the assumption above query will check CanadaSales to see if there is a sales
--				  agent in both USASales and CanadaSales and if there is add the Amount from CanadaSales for 
--				  that agent to the agent's Amount in USASales - UPDATE the agent's record in USASales
--
USE SalesDatabase
GO

UPDATE dbo.USASales
SET Amount = U.[Amount] + C.[Amount]
FROM dbo.USASales U
JOIN dbo.CanadaSales C ON C.AgentID = U.AgentID;

SELECT *
FROM dbo.USASales;

SELECT *
FROM dbo.CanadaSales;

/***************************************************************************************************************
*	If you wish to start from the beginning uncomment the following DROP DATABASE lines and execute
*	Then you can re-run the exercise database code at bottom
***************************************************************************************************************/

/*
DROP DATABASE IF EXISTS SalesDatabase;  
GO
*/



-- 3)	After completing Question 2, Delete all sales from SalesCanada if the sales agent in CanadaSales has any sales in USASales?
--		Query does the following:
--			- Assumptions:
--				- SalesDatabase database is created and populated
--				- DELETE record FROM CanadaSales table WHERE the sales agent exists in both the CanadaSales table and the 
--				  USASales table (using AgentID as the search criteria)
--
USE SalesDatabase
GO

DELETE FROM dbo.CanadaSales
WHERE AgentID IN (SELECT AgentID FROM dbo.USASales);

SELECT *
FROM dbo.USASales;

SELECT *
FROM dbo.CanadaSales;

/***************************************************************************************************************
*	If you wish to start from the beginning uncomment the following DROP DATABASE lines and execute
*	Then you can re-run the exercise database code at bottom
***************************************************************************************************************/

/*
DROP DATABASE IF EXISTS SalesDatabase;  
GO
*/



-- 4)	Insert a new sales agent ('20','YourName','YourLastName','123 Some Address','100','CASH') to USASales?
--		Query does the following:
--			- uses the INSERT INTO to add the data/record to USASales table 
--
USE SalesDatabase
GO

INSERT INTO USASales VALUES ('20', 'Hanover', 'Fist', '123 Some Address', '100', 'CASH');

SELECT *
FROM dbo.USASales;

SELECT *
FROM dbo.CanadaSales;

/***************************************************************************************************************
*	If you wish to start from the beginning uncomment the following DROP DATABASE lines and execute
*	Then you can re-run the exercise database code at bottom
***************************************************************************************************************/

/*
DROP DATABASE IF EXISTS SalesDatabase;  
GO
*/



-- 5)	We can be able to undo deleted records in SQL Server. (True/False)?  **** TRUE ****
--		There are ways to create backups:
--			- BACKUP DATABASE
--			- use OUTPUT to log deleted or inserted records
--
/***************************************************************************************************************
* Demonstration of uisng OUTPUT to restore deleted records
****************************************************************************************************************/

USE SalesDatabase
GO

-- Create Question5_Log table to be used for the backup
IF OBJECT_ID('Question5_Log') IS NULL
CREATE TABLE [dbo].[Question5_Log](
            [AgentID] [int],
			[FirstName] [nvarchar](255),
            [LastName] [nvarchar](255),
            [Address] [nvarchar](255),
            [Amount] [float],
            [Payment_Method] [nvarchar](255),
			[Operation] [VARCHAR](50),
			[UserName] [VARCHAR](50)
) ;
GO

-- Check USASales table to see what is in there before any deletes
SELECT *
FROM dbo.USASales;

-- DELETE FROM USASales WHERE agent name is Hanover Fist but we will log this action into Question5_Log
DELETE FROM dbo.USASales
OUTPUT deleted.AgentID,
	   deleted.FirstName,
	   deleted.LastName,
	   deleted.Address,
	   deleted.Amount,
	   deleted.Payment_Method,
	   'Deleted',
	   SYSTEM_USER INTO Question5_Log
WHERE FirstName = 'Hanover' AND
      LastName = 'Fist';

-- Check USASales table to see that record is deleted
SELECT *
FROM dbo.USASales;

-- Check Question5_Log table
SELECT *
FROM Question5_Log;

-- Insert deleted record back into USASales
INSERT INTO dbo.USASales (AgentID,
						  FirstName,
						  LastName,
						  Address,
						  Amount,
						  Payment_Method)
SELECT DISTINCT AgentID,
				FirstName,
				LastName,
				Address,
				Amount,
				Payment_Method
FROM Question5_Log
WHERE Operation = 'Deleted' AND
	  FirstName = 'Hanover' AND
      LastName = 'Fist';

-- Check USASales table to see that record is restored
SELECT *
FROM dbo.USASales;

/***************************************************************************************************************
*	If you wish to start from the beginning uncomment the following DROP DATABASE lines and execute
*	Then you can re-run the exercise database code at bottom
***************************************************************************************************************/

/*
DROP DATABASE IF EXISTS SalesDatabase;  
GO
DROP TABLE IF EXISTS Question5_Log
GO
*/





/*==============================================================================================
 * Exercise Database
 *==============================================================================================*/
CREATE DATABASE SalesDatabase;
GO

USE SalesDatabase
GO  

IF OBJECT_ID ('USASales','U') IS NOT NULL
    DROP TABLE USASales;
GO

CREATE TABLE [dbo].[USASales](
            [AgentID] [int],
			[FirstName] [nvarchar](255),
            [LastName] [nvarchar](255),
            [Address] [nvarchar](255),
            [Amount] [float],
            [Payment_Method] [nvarchar](255)
) ;
GO

IF OBJECT_ID ('CanadaSales','U') IS NOT NULL
    DROP TABLE CanadaSales;
GO
CREATE TABLE [dbo].[CanadaSales](
             [AgentID] [int],
			 [FirstName] [nvarchar](255),
             [LastName] [nvarchar](255),
             [Address] [nvarchar](255),
             [Amount] [float],
             [Payment_Method] [nvarchar](255)
);
GO
 
INSERT INTO [dbo].[USASales]
           ([AgentID]
		   ,[FirstName]
           ,[LastName]
           ,[Address]
           ,[Amount]
           ,[Payment_Method])
Values
	('11','James','Smith','388 Beechwood Dr. New Milford, CT 06776','11','CASH'),
	('12','Michael','Brown','287 James Dr. Dekalb, IL 60115','12','CASH'),
	('13','Robert','Lee','9641 South St. Orange, NJ 07050','13','CASH'),
	('14','Maria','Garcia','7586 South Virginia Street Hixson, TN 37343','14','CASH'),
	('15','David','Hill','82 East Livingston Street Southampton, PA 18966','15','CASH');
 
INSERT INTO [dbo].[CanadaSales]
           ([AgentID]
		   ,[FirstName]
           ,[LastName]
           ,[Address]
           ,[Amount]
           ,[Payment_Method])
Values
	('1','Maria','Rodriguez:','1528 110th Avenue, Dawson Creek British Columbia, Canada','11','CASH'),
	('2','Mary','Johnson','930 Seymour Street, Vancouver British Columbia, Canada','12','CASH'),
	('3','Paul','Gonzalez','8727 Brooke Road, Delta British Columbia, Canada','13','CASH'),
	('4','Daniel','Williams','315 Agnes Street, New Westminster British Columbia, Canada','14','CASH'),
	('5','Chris','Jones','1430 Summit Drive, Kamloops British Columbia, Canada','15','CASH'),
	('11','James','Smith','388 Beechwood Dr. New Milford, CT 06776','11','CASH');

GO
-- End of exercise database



