/*
Additional sql exercises:  https://www.w3resource.com/sql-exercises/hospital-database-exercise/sql-exercise-on-hospital-database.php

Use Hospital database in class
*/

use [Hospital]
go

-- 1. Write a query in SQL to find all the information of the nurses who are yet to be registered.
SELECT EmployeeID,
       Name,
	   Position,
	   Registered
FROM dbo.Nurse
WHERE Registered = 0;


-- 2. Write a query in SQL to find the name of the nurse who are the head of their department.
SELECT EmployeeID,
       Name,
	   Position,
	   Registered
FROM dbo.Nurse
WHERE Position LIKE '%Head%';


-- 3. Write a query in SQL to obtain the name of the physicians who are the head of each department.
SELECT D.DepartmentID,
       D.Name,
	   P.Name AS "Head of Department"
FROM dbo.Department D
JOIN dbo.Physician P ON P.EmployeeID = D.Head;


-- 4. Write a query in SQL to count the number of patients who taken appointment with at least one physician.
SELECT A.AppointmentID,
       P1.Name AS "Patient Name",
	   P2.Name AS "Physician Name",
	   A.[Start],
	   A.[End],
	   A.ExaminationRoom
FROM dbo.Appointment A
JOIN dbo.Patient P1 ON P1.SSN = A.Patient
JOIN dbo.Physician P2 ON P2.EmployeeID = A.Physician
ORDER BY "Patient Name" ASC,
         A.[Start] ASC;


-- 5. Write a query in SQL to find the floor and block where the room number 212 belongs to.
SELECT RoomNumber,
       BlockFloor AS "Floor Number",
	   BlockCode AS "Block"
FROM dbo.Room
WHERE RoomNumber = 212;


-- 6. Write a query in SQL to count the number available rooms.
SELECT COUNT(*) AS "Count of Available Rooms"
FROM dbo.Room
WHERE Unavailable = 0;


-- 7. Write a query in SQL to count the number of unavailable rooms.
SELECT COUNT(*) AS "Count of Unavailable Rooms"
FROM dbo.Room
WHERE Unavailable = 1;


-- 8. Write a query in SQL to count the number of unavailable rooms. 
-- Duplicate of question 7
SELECT COUNT(*) AS "Count of Unavailable Rooms"
FROM dbo.Room
WHERE Unavailable = 1;


-- 9. Write a query in SQL to obtain the name of the physicians who are trained for a special treatement.
SELECT P2.Name,
	   P1.Name 
FROM dbo.Trained_In T
JOIN dbo.[Procedure] P1 ON P1.Code = T.Treatment
JOIN dbo.Physician P2 ON P2.EmployeeID = T.Physician
ORDER BY P2.Name ASC,
         P1.Name ASC;


-- 10. Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated.
SELECT P.Name AS "Physician Name",
       D.Name AS "Unaffiliated Department"
FROM dbo.Affiliated_With A
JOIN dbo.Physician P ON P.EmployeeID = A.Physician
JOIN dbo.Department D ON D.DepartmentID = A.Department
WHERE A.PrimaryAffiliation = 0
ORDER BY P.Name ASC;


-- 11. Write a query in SQL to obtain the name of the physicians who are not a specialized physician.

SELECT *
FROM dbo.Physician;


       






