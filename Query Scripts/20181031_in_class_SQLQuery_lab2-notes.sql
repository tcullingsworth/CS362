-- 4)	Display the most widely spoken language in the continent Europe?
 	    -- hint refer to Encompasses table

		select --C.Name as CountryName,			  
			   top(1)
			   l.Name as LanguageName,
			   sum(l.Percentage *   C.Population ) as NumerOfSpeakers
		from Encompasses e
		join Country c on e.Country = c.Code and e.Continent='Europe'
		join [Language] l on l.Country = c.Code
		group by l.Name
		order by NumerOfSpeakers desc


-- For this question start with the smallest portion:
--	Find all of the European countries first
--	then find language spoken in each country
--  do the calculation with percentage 
--  and sum up the population from the calculation