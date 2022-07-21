SELECT *
FROM [Portfolio Project]..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project]..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
order by 1,2

--Total cases VS Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
where location like '%India%' and continent is NOT NULL
order by 1,2

--Total cases VS Population

SELECT location, date, total_cases, population, (total_cases/population)*100 as PopulationCasePercentage
FROM [Portfolio Project]..CovidDeaths
--where location like '%india%'
order by 1,2

-- Countries with highest infection rate compared to Population

SELECT location, max(total_cases) as HighestInfectionCount, population, MAX(total_cases/population)*100 as PopulationInfectedPercentage
FROM [Portfolio Project]..CovidDeaths
where continent is NOT NULL
group by location, population
order by PopulationInfectedPercentage desc

-- Showing countries with highest death count per population

SELECT location, max(cast(total_deaths as int)) as HighestDeathCount
FROM [Portfolio Project]..CovidDeaths
where continent is NOT NULL
group by location
order by HighestDeathCount desc

-- By continent

-- Showing continents with highest death count per population

SELECT continent, max(cast(total_deaths as int)) as HighestDeathCount
FROM [Portfolio Project]..CovidDeaths
where continent is NOT NULL
group by continent
order by HighestDeathCount desc

-- Global Data

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
where continent is NOT NULL
--group by date
order by 1,2


-- Total population vs Vaccinations

-- CTE 

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- Creating views for data visualizations

CREATE VIEW percentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

SELECT *
FROM percentPopulationVaccinated
