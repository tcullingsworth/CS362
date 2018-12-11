

CREATE VIEW IndependenceTimeline
AS
SELECT C.Name AS "Country Name",
	   P.Independence AS "Independence Date"
FROM dbo.Politics P
JOIN dbo.Country C ON C.Code = P.Country
WHERE P.Independence IS NOT NULL;
GO

SELECT *
FROM IndependenceTimeline
ORDER BY "Independence Date";

