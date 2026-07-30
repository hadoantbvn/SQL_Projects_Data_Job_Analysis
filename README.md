# Introduction
Dive into the data job market in Finland. Focusing on data analyst roles, this project explores top paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out more here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market in Finland more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs, while refreshing my SQL skills. 

Data hails from the SQL Course provided by Luke Barousse (http://lukebarousse.com/sql). It is packed with insights on job titles, salaries, locations, and essential skills.

The questions the SQL queries in this project help answer were:
What are the top-paying data analyst jobs?
What skills are required for these top-paying jobs?
What skills are most in demand for data analysts?
Which skills are associated with higher salaries?
What are the most optimal skills to learn?
# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

— **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
— **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
— **Visual Studio Code**: My go-to for database management and executing SQL queries.
— **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

## 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
```
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
```
Here's the breakdown of the top data analyst jobs in Finland in 2023:
- **Wolt dominates high-paying roles**, appearing across most top positions, it's the clear employer to target for top salaries in Finland.
- **SQL and Python are universal across every role and seniority level**, while the Wolt Senior Data Scientist role shows that top pay demands a broad stack (Spark, Kafka, Airflow, Docker, and more).
- **The further you move toward cloud and engineering skills, the higher the pay**. Meanwhile, Office tool roles (Excel, Word, PowerPoint) sit at the salary floor.  

![Top paying roles](/assets/1_top_paying_role.jpg)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; Claude.ai generated this graph from my SQL query results*

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```
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
```

Here are the key takeaways from the 7 unique job postings (26 skill rows after exploding skills):

- **Demand:** Go, SQL, and Looker are the most frequently required skills - each appearing in 3 postings. Python, R, and Tableau each appear twice. The remaining 11 skills appear only once.

- **Pay:** Azure is a strong salary signal at €152k avg, despite appearing in just one role (Nortal). Go follows at €123k and Alteryx at €115k. Standard analytics tools like SQL (€97k) and Tableau (€100k) sit in the mid-range, while Office tools (Excel, Word, PowerPoint, Visio, Flow) cluster at the bottom around €67k.

- **Skill mix:** Data tools dominate the category breakdown (Looker, Tableau, SQL, Alteryx, Snowflake, etc. = ~37%), followed by programming languages (Go, Python, R, Matlab = ~29%), then office tools (~21%) and cloud/DevOps (~13%).

The sweet spot for a Finnish data analyst role appears to be **SQL + Python + Go**, the three most in-demand skills that also carry above-average salaries.

![Skills frequency](/assets/2_skills_frequency.jpg)
![Average salary by skill](/assets/3_avg_salary_by_skill.jpg)
*Bar graph visualizing the skill count and average salary by skill for data analysts in Finland in 2023; Claude.ai generated this graph from my SQL query results*

## 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```
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
```
Key takeaways from the demand data:
- **Python edges out SQL as the top skill** (907 vs 852), though the gap is tight at just 6% - both are effectively mandatory for Finnish data analyst roles.
- **Cloud skills are essential but secondary** - Azure (502) notably outpaces AWS (416), reflecting Microsoft's strong foothold in the Finnish/Nordic enterprise market.
- **Power BI rounds out the stack** at 306 mentions, aligning with Azure's dominance (both are Microsoft products - employers hiring for one tend to hire for both).

The core stack a Finnish data analyst should target: **Python → SQL → Azure → Power BI, with AWS as a bonus.**

![Skills frequency](/assets/4_most_demanded_skills.jpg)
*Bar graph visualizing top 5 demanded skills for data analysts in Finland in 2023; Claude.ai generated this graph from my SQL query results*

## 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```
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

```
Here are the standout findings:
- **The Python/SQL paradox:** Both are the most demanded skills yet sit mid-table on pay (~€98–99k) — high candidate supply moderates salaries despite strong demand.
- **DevOps & cloud skills are the real differentiators**: Jenkins (€144,900), Azure, Docker, and Airflow dominate the top tier, paying 35–85% more than standard BI tools.
- **To maximise pay, layer up: Python/SQL is the baseline** — adding cloud (Azure/GCP) and data engineering tools (Airflow, Spark, Snowflake) pushes salaries from ~€98k to €110k+.

![Top 10 average salary](/assets/5_top_avg_salary.jpg)

*Table of the average salary for the top 10 paying skills for data analysts*

## 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```
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
```

Here are the key findings from the optimal skills data:
- **High pay, high demand** - Go (€106k, 5 mentions) and AWS (€105k, 5 mentions) offer the best balance of salary and demand. Looker stands out too — 4 mentions at €115k makes it arguably the single most optimal skill, combining strong demand with above-average pay.
- **SQL and Python: essential but commoditised**
Despite being the most demanded skills (9 and 8 mentions), Python (€98k) and SQL (€99k) rank near the bottom on pay. They're non-negotiable entry requirements, not salary differentiators — every analyst is expected to have them.
- **High pay, low demand — niche bets**
Jenkins (€145k), Azure (€117k), Docker and Airflow (both €117k) pay extremely well but appear only 1–3 times. These likely reflect senior or data engineering-adjacent roles rather than typical analyst positions — high reward but fewer opportunities.
- **DevOps skills skew the ceiling**
Jenkins, Docker, Airflow, and Kubernetes cluster at opposite salary extremes (Jenkins €145k, Kubernetes €84k), suggesting that DevOps skills are highly role-dependent — a full CI/CD stack commands a premium, individual tools less so.
- **Office/BI tools are the floor**
Excel, Flow (both €78k), Power BI and Java (both €89k) sit at the bottom. Roles relying on these without deeper technical skills represent the lowest-paid segment of the analyst market in Finland.

**Bottom line:** Build on Python/SQL as the foundation, then prioritise Go, AWS, Looker, and Snowflake for the best salary-to-opportunity ratio in the Finnish market.

![Optimal skills to obtain](/assets/6_most_optimal_skills.jpg)

*Table of top 10 optimal skills that are in high demand and pay well for data analysts*

# What I learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:
- **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions
From the analysis, several general insights emerged:
- **Python and SQL are the mandatory baseline** - by far the most demanded skills, but their abundance keeps salaries mid-range. Every analyst needs them; they won't set you apart on pay.
- **Cloud and data engineering skills are the real salary differentiators** - Azure, AWS, GCP, Docker, and Airflow consistently command the highest salaries, reflecting demand for analysts who can operate beyond traditional analytics into data infrastructure.
- **The optimal sweet spot is Go, AWS, Looker, and Snowflake** - these skills balance strong market demand with above-average pay, making them the highest-value additions to a core Python/SQL foundation.
- **Niche DevOps skills (Jenkins, Airflow) pay the most but appear rarely** - they signal senior or engineering-adjacent roles rather than typical analyst positions. High ceiling, but fewer doors to walk through.
- **Office and basic BI tools mark the lowest-paid roles** - Excel, Flow, and Power BI alone place analysts at the bottom of the pay scale. The Finnish market clearly rewards technical depth over spreadsheet proficiency.

# Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
