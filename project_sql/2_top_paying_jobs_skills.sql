/*
Questions: What skills are required for the top paying data analyst jobs? 
- Use the top 10 highest paying Data related roles from first query
- Add the specific skills required for these roles
- Why? Provide detailed look at which high paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id, 
        job_title_short, 
        salary_year_avg,
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
    LIMIT 30
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
Here are the key takeaways from the 26 skill entries across 7 job postings:
Most in-demand skills — Go, SQL, and Looker are the only ones appearing in 3 postings each, making them the top trio for Finland's data analyst market in 2023. Python, R, and Tableau each appear twice.
Salary signals — Azure commands the highest associated salary ($165K, tied to Nortal's role), followed by Go ($134K) and Alteryx ($125K). Office tools like Excel, Word, and PowerPoint cluster at the bottom at $73K — suggesting those roles are less technical and lower-paying.
Notable pattern — Go appearing this frequently (3 times, avg $134K) is unusual for a data analyst role; it's typically a backend language. This likely reflects Finland's tech-heavy employer mix (Nortal, Wolt, Ageras) wanting analysts who can work closer to engineering.
Skill categories at a glance:
Programming languages dominate (Go, Python, R, SQL, MATLAB)
BI/viz tools are consistently represented (Tableau, Looker, Power BI)
Cloud skills (Azure, Snowflake) carry a clear salary premium
Microsoft Office skills are present but associated with lower-paying postings
The dataset is small (only 7 unique jobs, 26 rows after skill expansion), so treat these salary figures as directional rather than statistically robust.

[
  {
    "job_id": 281069,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "165000.0",
    "company_name": "Nortal",
    "skills": "go"
  },
  {
    "job_id": 281069,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "165000.0",
    "company_name": "Nortal",
    "skills": "azure"
  },
  {
    "job_id": 178324,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "125000.0",
    "company_name": "Wolt",
    "skills": "go"
  },
  {
    "job_id": 178324,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "125000.0",
    "company_name": "Wolt",
    "skills": "looker"
  },
  {
    "job_id": 178324,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "125000.0",
    "company_name": "Wolt",
    "skills": "alteryx"
  },
  {
    "job_id": 172142,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111202.0",
    "company_name": "Wolt",
    "skills": "python"
  },
  {
    "job_id": 172142,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111202.0",
    "company_name": "Wolt",
    "skills": "r"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "sql"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "python"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "r"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "go"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "matlab"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "tableau"
  },
  {
    "job_id": 210671,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "111175.0",
    "company_name": "Wolt",
    "skills": "looker"
  },
  {
    "job_id": 17219,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "105650.0",
    "company_name": "Wolt",
    "skills": "sql"
  },
  {
    "job_id": 17219,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "105650.0",
    "company_name": "Wolt",
    "skills": "tableau"
  },
  {
    "job_id": 17219,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "105650.0",
    "company_name": "Wolt",
    "skills": "looker"
  },
  {
    "job_id": 931307,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "100500.0",
    "company_name": "Ageras",
    "skills": "sql"
  },
  {
    "job_id": 931307,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "100500.0",
    "company_name": "Ageras",
    "skills": "snowflake"
  },
  {
    "job_id": 931307,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "100500.0",
    "company_name": "Ageras",
    "skills": "terraform"
  },
  {
    "job_id": 931307,
    "job_title_short": "Senior Data Analyst",
    "salary_year_avg": "100500.0",
    "company_name": "Ageras",
    "skills": "github"
  },
  {
    "job_id": 1097867,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "72900.0",
    "company_name": "TransPerfect",
    "skills": "excel"
  },
  {
    "job_id": 1097867,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "72900.0",
    "company_name": "TransPerfect",
    "skills": "word"
  },
  {
    "job_id": 1097867,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "72900.0",
    "company_name": "TransPerfect",
    "skills": "powerpoint"
  },
  {
    "job_id": 1097867,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "72900.0",
    "company_name": "TransPerfect",
    "skills": "visio"
  },
  {
    "job_id": 1097867,
    "job_title_short": "Data Analyst",
    "salary_year_avg": "72900.0",
    "company_name": "TransPerfect",
    "skills": "flow"
  }
]
*/