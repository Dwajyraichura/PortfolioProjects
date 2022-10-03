--1
--Global Numbers

Select sum(new_cases) Total_Cases,sum(cast(new_deaths as int)) Total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percent
From CovidDeath

--2
--Total death count per continent

Select continent,sum(cast(new_deaths as int)) Total_Deaths
From CovidDeath
Where continent is not null
Group by continent
Order by Total_Deaths desc


--3
--Percentage of population infected per country

select location,max(population) as Total_Population,max(total_cases) as Total_Cases,max(total_cases/population)*100 as Population_Infected
from CovidDeath
Where continent is not null
Group by location
Order by Population_Infected desc

--4
--Percent of population infected 


select location,max(population) as Total_Population,cast(date as date) as date,max(total_cases) as Total_Cases,max(total_cases/population)*100 as Population_Infected
from CovidDeath
Where continent is not null
Group by location,date
Order by location, Population_Infected desc
