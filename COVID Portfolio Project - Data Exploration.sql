/* Covid 19 Data Exploration
   Skill used: Joins, CTE's, Temp Table, Windows Fuctions, Aggregate Function, Creating Views, Coverting Data Types
*/

Select *
From CovidDeath
Where continent is not null
Order by 3,4


--Select Data that we are going to be starting with
  --Note: Here in this data set date format is nvarchar(255) so we are coverting as date

  Select location, convert(date, date),population, total_cases,total_deaths
  From CovidDeath
  Where continent is not null
  Order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country 

  Select location, convert(date, date),population, total_cases,total_deaths,total_deaths/total_cases*100 as DeathPercentage
  From CovidDeath
  Where continent is not null
  Order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in India 

  Select location, convert(date, date),population, total_cases,total_deaths,total_deaths/total_cases*100 as DeathPercentage
  From CovidDeath
  Where continent is not null
  and location like '%India%'
  Order by 1,2


 -- Total Cases vs Population
 -- Shows what percentage of population infected with Covid

 Select location, convert(date, date),population, total_cases,total_deaths,total_cases/population*100 as PercentageInfectedCovid
 From CovidDeath
 Where continent is not null
 Order by 1,2


 -- Total Cases vs Population
 -- Shows what percentage of population infected with Covid in India

  Select location, convert(date, date),population, total_cases,total_deaths,total_cases/population*100 as PercentageInfectedCovid
  From CovidDeath
  Where continent is not null
  and location like '%India%'
  Order by 1,2

  -- Countries with Highest Infection Rate compared to Population

  Select location,population,max(total_cases) as HighestInfectionsCount, max(total_cases/population)*100 as HighestPopulationInfected
  From CovidDeath
  Where continent is not null 
  Group by location,population
  Order by HighestPopulationInfected desc

  -- Countries with Highest Death Count per Population

  Select location,population,max(cast(total_deaths as int)) as HighestDeathCount
  From CovidDeath
  Where continent is not null
  Group by location,population 
  Order by 3 desc

    -- Countries with Highest Death Count Percentage per Population

  Select location,population,max(cast(total_deaths as int)) as HighestDeathCount, max(cast(total_deaths as int))/population*100 as DeathPercent
  From CovidDeath
  Where continent is not null
  Group by location,population 
  Order by 3 desc


 -- BREAKING THINGS DOWN BY CONTINENT

 -- Showing contintents with the highest death count per population

 Select continent,max(convert(int,total_deaths)) as HighestDeathCount
 From CovidDeath
 Where continent is not null
 Group by continent
 Order by 2 desc

 -- Showing Continents with highest death count per poplation

 Select location,max(convert(int,total_deaths)) as HighestDeathCount
 From CovidDeath
 Where continent is null and location <> 'World' and location not like '%income%'
 Group by location 
 Order by HighestDeathCount desc

 -- GLOBAL NUMBERS

 Select sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, 
 sum(cast(new_deaths as int)) /sum(new_cases) * 100 as totaldeathpercent
 From CovidDeath
 Order by 1,2

 
 Select location , sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, 
 sum(cast(new_deaths as int)) /sum(new_cases) * 100 as totaldeathpercent
 From CovidDeath
 Where continent is not null and location <> 'North Korea'
 Group by location
 Order by totaldeathpercent desc



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select cd.continent,cd.location,convert(datetime,cd.date) as date,cd.population,cv.new_vaccinations,
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location,convert(datetime,cd.date)) as RollingPeopleVaccinated
From CovidDeath cd
Join CovidVaccinations cv
on 
cd.date = cv.date and 
cd.location = cv.location
Where cd.continent is not null 
Order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select cd.continent,cd.location,convert(datetime,cd.date) as date,cd.population,cv.new_vaccinations,
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location,convert(datetime,cd.date)) as RollingPeopleVaccinated
From CovidDeath cd
Join CovidVaccinations cv
on 
cd.date = cv.date and 
cd.location = cv.location
Where cd.continent is not null 
--Order by 2,3
)

Select *, RollingPeopleVaccinated/population
from popvsvac


-- Using Temp Table to perform Calculation on Partition By in previous query
 Drop Table if exists #PeoplePercentageVaccinated 
 Create Table #PeoplePercentageVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert Into #PeoplePercentageVaccinated
 Select cd.continent,cd.location,convert(datetime,cd.date) as date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location,convert(datetime,cd.date)) as RollingPeopleVaccinated
 From CovidDeath cd
 Join CovidVaccinations cv
 on 
 cd.date = cv.date and 
 cd.location = cv.location
 

 Select *,RollingPeopleVaccinated/Population
 From #PeoplePercentageVaccinated

 -- Creating View to store data for later visualizations

 Create view PeoplePercentageVaccinated as 
 Select cd.continent,cd.location,convert(datetime,cd.date) as date,cd.population,cv.new_vaccinations,
 sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location,convert(datetime,cd.date)) as RollingPeopleVaccinated
 From CovidDeath cd
 Join CovidVaccinations cv
 on 
 cd.date = cv.date and 
 cd.location = cv.location
 Where cd.continent is not null

