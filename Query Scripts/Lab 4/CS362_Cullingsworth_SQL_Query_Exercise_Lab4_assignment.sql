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