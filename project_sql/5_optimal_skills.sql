/*
Questions: What are the optimal skills to learn? (High demand and high pay)
- Identify skills in high demand and associated with high average salaries for Data related roles
- Focus on positions in Finland with specified salaries
- Why? Target skills that offer job security (high demand) and financial benefit (high salaries). 
Offering strategic insights for career development in Data analytics
*/


WITH job_postings_Finland AS (
    SELECT
        job_id,
        job_location,
        salary_year_avg,
        job_title_short
    FROM 
        job_postings_fact
    WHERE
        job_location LIKE '%Finland%'
), skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_Finland

    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_Finland.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short LIKE '%Data%' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_finland.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_Finland
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_Finland.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%' AND 
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25    

--Rewrite same query more concisely

WITH job_postings_Finland AS (
    SELECT
        job_id,
        job_location,
        salary_year_avg,
        job_title_short
    FROM 
        job_postings_fact
    WHERE
        job_location LIKE '%Finland%'
)

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count, 
    ROUND(AVG(job_postings_Finland.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_Finland
INNER JOIN skills_job_dim ON job_postings_Finland.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id    
WHERE
    job_title_short LIKE '%Data%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id    
ORDER BY
    demand_count DESC, 
    avg_salary DESC
LIMIT 25;              