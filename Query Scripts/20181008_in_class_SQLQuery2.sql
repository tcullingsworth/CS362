/* 10/08/2018 in class lecture demo */

USE [trevor.cullingsworth];
go

select Name, count(Province) AS City_Count
from [dbo].[City]
where Country = 'USA'
group by Name
having count(Province)>1
order by Name desc;