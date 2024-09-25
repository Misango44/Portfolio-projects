select *
From [Portfolio Projects]..CovidDeaths$
where continent is not null
order by 3,4

select *
From [Portfolio Projects]..CovidVaccinations$

order by 3,4



Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Projects]..CovidDeaths$
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Projects]..CovidDeaths$
order by 2,3

--looking at total cases vs Total Deaths
--shows likelyhood of ying of you contract covid in the USA
Select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Projects]..CovidDeaths$
where location  like '%states%'
order by 1,2

--Looking at the total cases vs the population

Select Location, date, total_cases,population,(total_cases/population)*100 as Percentpopulationinfected
From [Portfolio Projects]..CovidDeaths$
where location  like '%kenya%'
order by 1,2

--Looking at countries with highest infection Rate compared to the population

Select Location, population, Max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as Percentpopulationinfected
From [Portfolio Projects]..CovidDeaths$
--where location  like '%kenya%'
Group by Location ,Population
Order by Percentpopulationinfected desc


--showing countries with Highest death counts per population

Select Location, Max(cast(total_deaths as int)) as TotaldeathCounts
From [Portfolio Projects]..CovidDeaths$
--where location  like '%kenya%'
where continent is not null
Group by Location ,Population
Order by TotaldeathCounts desc


--lETS BREAK THINGS DOWN BY CONTINENT

select location, Max(cast(total_deaths as int)) as TotaldeathCounts
From [Portfolio Projects]..CovidDeaths$
--where location  like '%kenya%'
where continent is null
Group by location
Order by TotaldeathCounts desc

--showing the continents with the hghest death counts

select continent, Max(cast(total_deaths as int)) as TotaldeathCounts
From [Portfolio Projects]..CovidDeaths$
--where location  like '%kenya%'
where continent is not null
Group by continent
Order by TotaldeathCounts desc

--GLOBAL NUMBERS

SELECT date, SUM(cast(new_deaths as int)), SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS Deathpercentage
From [Portfolio Projects]..CovidDeaths$
--where location  like '%kenya%'
where continent is not null
Group by date
Order by 1,2

--looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [Portfolio Projects]..CovidDeaths$ dea
join [Portfolio Projects]..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
Order by 1,2

--TEMPT TABLE


CREATE TABLE #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations)
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portfolio Projects]..CovidDeaths$ dea
JOIN [Portfolio Projects]..covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Selecting from the temporary table with the calculated percentage
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;
