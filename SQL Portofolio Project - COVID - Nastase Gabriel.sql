SELECT *
FROM PortofolioProject..CovidDeaths$
WHERE continent is not null	
ORDER BY 3,4

--Shows likelyhood of dying if you contact covid in Romania
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortofolioProject..CovidDeaths$
WHERE location = 'Romania'
ORDER BY 1,2

--Shows what % of population got covid


SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortofolioProject..CovidDeaths$
WHERE location = 'Romania'
ORDER BY 1,2 


--looking at countries with highest infection rate compared to population

	SELECT location, population, MAX (total_cases) AS HighestInfectionCount, MAX ((total_cases/population))*100 AS PercentPopulationInfected
	FROM PortofolioProject..CovidDeaths$
	-- WHERE location = 'Romania'
	GROUP BY location, population
	ORDER BY PercentPopulationInfected DESC


--showing countries with highest death count per population

	SELECT location, MAX (cast(total_deaths AS int)) AS TotalDeathCount
		FROM PortofolioProject..CovidDeaths$
		--WHERE location = 'Romania'
		WHERE continent is not null	
		GROUP BY location, population
		ORDER BY TotalDeathCount DESC

-- let's break things down by continent


-- Showing continents with highest death count

SELECT continent, MAX (cast(total_deaths AS int)) AS TotalDeathCount
		FROM PortofolioProject..CovidDeaths$
		--WHERE location = 'Romania'
		WHERE continent is not null	
		GROUP BY continent
		ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

	SELECT date, SUM (new_cases) AS total_cases, SUM (CAST(new_deaths AS INT)) AS total_deaths, SUM (cast(new_deaths AS INT))/SUM (New_Cases)*100 AS DeathPercentage
	FROM PortofolioProject..CovidDeaths$
	-- WHERE location = 'Romania'
	WHERE continent IS NOT NULL
	GROUP BY date
	ORDER BY 1,2

SELECT *
FROM PortofolioProject..CovidDeaths$ dea
JOIN PortofolioProject..CovidVaccinations$ vac
ON dea.location = vac.location AND dea.date = vac.date

--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortofolioProject..CovidDeaths$ dea
JOIN PortofolioProject..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- USE CTE

	WITH PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
	AS
	(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
	--, (RollingPeopleVaccinated/population)*100
	FROM PortofolioProject..CovidDeaths$ dea
	JOIN PortofolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	--ORDER BY 2,3)
	SELECT * FROM PopvsVac






