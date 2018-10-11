/*
* Author:	Trevor Cullingsworth
* Email:	school email
* Description:
* Notes:
*/

USE [trevor.cullingsworth];
go

-- 1) Select the top 10 Lakes with the largest area size?
SELECT TOP(10) [Name], [Area]
FROM dbo.Lake
ORDER BY [Area] DESC;

--  2) You found an expert prediction that a Sea level will raise six feet at the end of the next five year,
-- 	   calculate the depth of each Sea five years from now?
SELECT [Name], [Depth] AS Current_Depth, ([Depth] + 6) AS Projected_Depth_after_5_years
FROM dbo.Sea;

-- 3) Display unique Rivers for your report?
SELECT [Name]
FROM dbo.River
GROUP by [Name];