select * from Profolioproject1..CovidDeaths$
where continent is not null
order by 3,4

--select * from PortfolioProject..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population 
from Profolioproject1..CovidDeaths$
where continent is not null
order by 1,2

select location, date, total_cases, total_deaths,  (total_deaths/total_cases)*100 as PercentPopulationInfected
from Profolioproject1..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from Profolioproject1..CovidDeaths$
--where location like '%states%'
where continent is not null
order by 1,2


select location,   population, date, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfected
from Profolioproject1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location, population, date
order by PercentPopulationInfected desc


select location, max(cast(total_deaths as int)) as TotalDeathCount
from Profolioproject1..CovidDeaths$
--where location like '%states%'
where continent is  null
and location not in ('World', 'European Union','International')
group by location
order by TotalDeathCount desc

Select sum(new_cases) as ToTalcases ,Sum(cast(new_deaths as int)) as totalDeaths,Sum(cast(new_deaths as int))/sum(new_cases)*100 as DEathPercentage
from Profolioproject1..CovidDeaths$
where continent is not null
order by 1,2

--
with popvsvac (continent,location,date,population,New_vaccination,Rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations)) over(Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
From Profolioproject1..CovidDeaths$ dea
join Profolioproject1..CovidVaccinations$ vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
)
select *, Rollingpeoplevaccinated/population *100 as Percentagevaccinated
from popvsvac order by continent,location
where continent is not null
--
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
Rollingpeoplevaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations)) over(Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
From Profolioproject1..CovidDeaths$ dea
join Profolioproject1..CovidVaccinations$ vac on dea.date=vac.date and dea.location=vac.location
--where dea.continent is not null

select *, Rollingpeoplevaccinated/population *100 as Percentagevaccinated
from #PercentPopulationVaccinated

--
create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations)) over(Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
From Profolioproject1..CovidDeaths$ dea
join Profolioproject1..CovidVaccinations$ vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
--
select *
from  PercentPopulationVaccinated