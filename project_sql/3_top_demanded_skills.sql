
/*
Questions: What are the most in demand skills for data analyst jobs? 
- Join job postings to inner join table similar to query 2
- Identify the top 5 in demand skills for a data analyst
- Focus on all job postings.
- Why? Retrieve top 5 skills with the highest demand in the job market in Finland, 
providing insighs into the mos valuable skills for job seekers. 
*/


WITH job_postings_Finland AS (
    SELECT
        job_id,
        job_location,
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
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_Finland

INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_Finland.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5        


