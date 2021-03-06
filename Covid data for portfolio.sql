SELECT location,date, total_cases,new_cases, total_deaths, population
FROM `practice-337306.Portfolio_project.coviddeaths` 
ORDER BY 1,2 

--This shows the likelihood of dying when you get covid in Ghana 

SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE location = 'Ghana'
ORDER BY 1,2 


--Shows percentage of population that got covid in Ghana

SELECT location,date,population, total_cases, (total_cases/population)*100 as covidinfected_Percentage
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE location = 'Ghana'
ORDER BY 1,2 

--Showing countries with highest death count per population

SELECT location, MAX(total_deaths) as Total_death_count
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE continent is not null
GROUP BY location
ORDER BY Total_death_count desc

--LET'S LOOK AT continent

SELECT continent, MAX(total_deaths) as Total_death_count
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE continent != 
ORDER BY Total_death_count de'null'
GROUP BY continentsc

--Global Numbers

SELECT date, SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as Death_Percentage
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE continent != 'null'
GROUP BY date
ORDER BY 1,2

--World percentage

SELECT SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as Death_Percentage
FROM `practice-337306.Portfolio_project.coviddeaths` 
WHERE continent != 'null'
--GROUP BY date
ORDER BY 1,2

--Joining 2 dataset

SELECT *
FROM `practice-337306.Portfolio_project.coviddeaths` dea
join `practice-337306.Portfolio_project.covidVaccination` vac
on dea.location =vac.location
and dea.date = vac.date

--Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations
FROM `practice-337306.Portfolio_project.coviddeaths` dea
join `practice-337306.Portfolio_project.covidVaccination` vac
on dea.location =vac.location
and dea.date = vac.date
WHERE dea.continent != 'null' 
ORDER BY 2,3

-- Rolling People Vaccinated

SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM `practice-337306.Portfolio_project.coviddeaths` dea
join `practice-337306.Portfolio_project.covidVaccination` vac
on dea.location =vac.location
and dea.date = vac.date
WHERE dea.continent != 'null' 
ORDER BY 2,3

--USING CTE 

WITH PopvsVac 
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM `practice-337306.Portfolio_project.coviddeaths` dea
join `practice-337306.Portfolio_project.covidVaccination` vac
on dea.location =  vac.location
and dea.date = vac.date
WHERE dea.continent != 'null' 
)
SELECT *,  (RollingPeopleVaccinated/Population)*100 AS PercentPopulationVaccinated
FROM PopvsVac;
