/*
Questions: What are the top paying data related jobs?
- Identify the top 10 highest paying roles related to Data analysis 
that are available in Finland. 
- Focus on job postings with specified salaries (remove nulls).
- Why? Highlight the top paying opportunities for Data analysts, offering insights into employment location. 
*/

SELECT
    job_id, 
    job_title_short, 
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact    
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id     
WHERE
    job_title_short LIKE '%Data%'AND
    job_location LIKE '%Finland%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC   

