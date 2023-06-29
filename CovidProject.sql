-- change the data type of the date column
ALTER TABLE covid_data.coviddeath
MODIFY date date;

ALTER TABLE covid_data.covidvaccinations
MODIFY date date;

ALTER TABLE covid_data.coviddeath
MODIFY total_cases int;

ALTER TABLE covid_data.coviddeath
MODIFY total_deaths int;

-- select data that we are going to use
Select location, date, total_cases, new_cases, total_deaths, population
From covid_data.coviddeath
Order by 1,2;

-- looking at the total cases vs total deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covid_data.coviddeath
where location = "China"
Order by 1,2;

-- looking at the total cases vs population
-- show the percentage of population got Covid
Select location, date, total_cases, total_deaths, (total_cases/population)*100 as PecentageInfected
From covid_data.coviddeath
where location = "Slovenia"
Order by 1,2 desc;

-- looking at countries with highest infection rate compared to population
Select location, population,max(total_cases) as HighestInfectionCount, (max(total_cases)/population)*100 as PecentageInfected
From covid_data.coviddeath
where continent != ''
Group by location,population
Order by PecentageInfected desc;

-- showing countries with highest death count per population
Select location, population,max(total_deaths) as TotalDeathCount, (max(total_deaths)/population) AS DeathRate
From covid_data.coviddeath
where continent != ''
Group by location,population
Order by DeathRate DESC;


-- lets break things down by continent
-- show the continent with the highest death count per population
Select continent,max(total_deaths) as TotalDeathCount
From covid_data.coviddeath
where continent != ''
Group by continent
order by TotalDeathCount Desc;

-- Global numbers
-- find the global death percentage everyday
SELECT date, sum(new_cases), sum(new_deaths), sum(new_deaths)/sum(new_cases)*100 DeathPercentage
From covid_data.coviddeath
where continent != ''
Group by date;

-- covid vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covid_data.coviddeath dea
JOIN covid_data.covidvaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent != ''
ORDER by 1,2,3 desc;
    










