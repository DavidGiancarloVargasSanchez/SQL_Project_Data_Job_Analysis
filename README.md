# Introduction
📊Dive into the data job market! Focusing on Data Analyst roles, this project explores top-paying jobs, 🔥in-demand skills, and 📈where high demand meets high salary in data analytics.

🔍SQL queries? check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the Data Analyst job market effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Analyst?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: Th backbone of my analysis and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigaring specific aspects of the data analyst job market. Here's how I approched each question:

### 1. Top paying Data Analyst jobs
To identify the highest-paying roles I filtered data analyst position  by average yearly salary and location, focusing on remotes jobs. This query highlights the high paying oportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    name As company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
![Top Paying Roles](put the relative path of the assets)

### 2. Skills for top paying jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compesation roles.

```sql
WITH jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name As company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
    ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    jobs.*,
    skills.skills
FROM
    jobs
INNER JOIN
    skills_job_dim
ON
    jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim AS skills
ON
    skills_job_dim.skill_id = skills.skill_id
ORDER BY
    salary_year_avg DESC
```
### 3. In-Demand skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_dim.skill_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

### 4. Skills based on salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25
```

### 5. Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skills development.

# What I learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

🧩 Complex Query Crafting: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
📊 Data Aggregation: Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
💡 Analytical Wizardry: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

Top-Paying Data Analyst Jobs: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
Optimal Skills for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

