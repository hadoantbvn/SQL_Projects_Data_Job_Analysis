/*
Questions: What are the top skills based on salary?
- Look at average salary associated with each skill for data related positions
- Focus on roles with specified salaries, in Finland
- Why? Reveal how different skills impact salary levels for Data related roles
 and help identify the most financially rewarding skills to acquire or improve
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
    ORDER BY
        job_id
)

SELECT 
    skills,
    ROUND(AVG(job_postings_finland.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_Finland
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_Finland.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%' AND 
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25   

/*
A few clear trends jump out from this dataset:
- DevOps/infra skills (Jenkins, Docker, Airflow) lead salaries at $127–158K,
 reflecting demand for data professionals who can work close to the engineering stack.
- Cloud platforms (Azure, GCP, AWS) form a reliable mid-tier around $114–128K, 
consistently outperforming traditional analytics tools.
- Core skills like SQL and Python are table stakes (~$107–108K), while
 Office tools (Excel, Flow) mark the salary floor at $85K.
*/



