Select *
From [New Portfolio Project ]..CovidDeaths
Where continent is not null
Order by 3,4

--Select * 
--From dbo.['CovidVaccinations ]
--Order by 3,4

-- Selecting the data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From [New Portfolio Project ]..CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- Showing likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentOfPopulationInfected
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Group by Location, Population
Order by PercentOfPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
--Showing Continents with the highest Death Count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [New Portfolio Project ]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by date 
Order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [New Portfolio Project ]..CovidDeaths dea
Join [New Portfolio Project ]..['CovidVaccinations ] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [New Portfolio Project ]..CovidDeaths dea
Join [New Portfolio Project ]..['CovidVaccinations ] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac

 -- TEMP TABLE 

 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric, 
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [New Portfolio Project ]..CovidDeaths dea
Join [New Portfolio Project ]..['CovidVaccinations ] vac
    On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

 Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated
 

-- Creating a View for Visualizations

Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [New Portfolio Project ]..CovidDeaths dea
Join [New Portfolio Project ]..['CovidVaccinations ] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select * 
From PercentPopulationVaccinated