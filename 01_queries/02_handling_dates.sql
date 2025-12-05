/*:: Cast type (convierte un tipo de dato en otro) 
Convert all strings into DATE, INTEGER, BOOLEAN, REAL
*/
SELECT
    '2023-02-19':: DATE,
    '123' :: INTEGER,
    'true':: BOOLEAN,
    '3.14':: REAL;

/*Remove time portion of the date */
SELECT 
    job_title AS title,
    job_location AS location,
    job_posted_date:: DATE AS date
FROM
    job_postings_fact;

/*Convert from one timezone to another */
SELECT
    job_title AS title,
    job_location AS location,
    -- job_posted_date AT TIME ZONE 'EST' (When the column specifies the time zone)
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
LIMIT 5;

/*Extract the year and the month from a date time */
SELECT
    job_title AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(YEAR FROM job_posted_date) AS year
FROM
    job_postings_fact
LIMIT 5;

/*jobs posting trending for month to month*/
SELECT
    COUNT(job_id) AS total,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    total DESC;

/*jobs posting trending from month to month for data analyst*/
SELECT
    COUNT(job_id) AS total,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    total DESC;

/*Problem01:
Write a query to find the average salary (yearly and hourly)
for job postings that were posted after june 1, 2023. Group 
the results by job schedule type.*/
SELECT
    job_schedule_type AS job_schedule_type,
    AVG(salary_year_avg) AS salary_year_avg,
    AVG(salary_hour_avg) AS salary_hour_avg
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;

/*Problem02:
Write a query to count the number of job posting for each month
in 2023, adjusting the job posted date to be in 'America/New York'
time zone. Group by and order by month
*/
SELECT
    COUNT(job_id) AS total,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') AS month
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month; 

/*Problem03:
Write a query to find companies (include company name) that have posted
jobs offering health insurance, where these postings were made in the 
second quarter of 2023
*/
SELECT
    company_dim.name,
    EXTRACT(QUARTER FROM job_postings_fact.job_posted_date:: DATE) as quarter
FROM
    company_dim
JOIN
    job_postings_fact
ON
    company_dim.company_id = job_postings_fact.company_id
WHERE
    job_postings_fact.job_health_insurance = '1'
    AND EXTRACT(QUARTER FROM job_postings_fact.job_posted_date:: DATE) = 2
ORDER BY
    company_dim.name,
    quarter;

/*Practice probelm 06 (Creating tables fron another table):
Create 3 trables:
    Jan 2023 jobs
    Feb 2023 jobs
    Mar 2023 jobs
*/
--January
CREATE TABLE january_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        Extract(MONTH FROM job_posted_date) = 1;

--February
CREATE TABLE february_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        Extract(MONTH FROM job_posted_date) = 2;

--March
CREATE TABLE march_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        Extract(MONTH FROM job_posted_date) = 3;

/*Testing the creation of the tables */
SELECT
    *
FROM
    march_jobs;

/*Label new columns as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- 'Otherwise' 'Onsite'
*/ 
SELECT
    job_title_short,
    job_location,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE
        'Onsite'
    END AS job_location_category
FROM
    job_postings_fact;

/*Label new columns as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- 'Otherwise' 'Onsite'
Group by 'Remote', 'Local' and 'Onsite'
*/ 
SELECT
    COUNT(job_id) AS total_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS job_location_category
FROM
    job_postings_fact
GROUP BY
    job_location_category;
    
/*Label new columns as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- 'Otherwise' 'Onsite'
Group by 'Remote', 'Local' and 'Onsite'
filter by data analyst job
*/ 
SELECT
    COUNT(job_id) as total,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END job_location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    job_location_category;

/*Practice problem 01
Categorizes the salaries for each job. To see if it fits my desired
salary range. Put the salary in these three buckets: High, Standard
adn Low. Filter by Data Analyst role and order them grom highest to 
lowest
*/
SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 645000 THEN 'High'
        WHEN salary_year_avg >= 330000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_range
FROM
    job_postings_fact
WHERE
    salary_year_avg IS Not NULL
ORDER BY
    salary_year_avg DESC;

/*Practice problem 02
Categorizes the salaries for each job. To see if it fits my desired
salary range. Put the salary in these three buckets: High, Standard
adn Low. Order them grom highest to lowest
*/
SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 645000 THEN 'High'
        WHEN salary_year_avg >= 330000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_range
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS Not NULL
ORDER BY
    salary_year_avg DESC;

/*Subqueries and CTEs
===================== */
/*Subqueries*/
SELECT
    *
FROM (-- SubQuery starts here
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1 
)AS january_jobs;
--SubQuery ends here

/*Show the companies that offer jobs that have no requirment
for degree*/
SELECT
    company_id,
    name as company_name
FROM
    company_dim
WHERE
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = true
        ORDER BY
            company_id
    )


/*CTEs*/
WITH january_jobs AS(--CTE definition starts here
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
)--CTE definition ends here

SELECT
    *
FROM
    january_jobs

/*Find the companies that have the most jobs openning
-Get the total number of job postings per company id
-Return the total number of jobs with the company names
*/
WITH company_jobs AS (
    SELECT
        company_id,
        COUNT(company_id) as total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    name,
    company_jobs.total_jobs
FROM 
    company_dim
LEFT JOIN --Utilizamos left join porque algunas compañías pueden tener 0 jobs publicados
    company_jobs
ON company_dim.company_id = company_jobs.company_id
ORDER BY
    company_jobs.total_jobs DESC;

/*Practice Problem01:
Identify the top 5 skills that are most frequently mentioned in job postings.
Use a sub query to find the skill IDs with the highest counts in the skills_job_dim table
and then join this result with the skills_dim table to get skills name
*/
SELECT 
    skills,
    total_skills.skills_number
FROM
    skills_dim
INNER JOIN (
    SELECT
       skill_id,
       COUNT(*) as skills_number
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        skills_number DESC
    LIMIT 5 
) AS total_skills
ON
    skills_dim.skill_id = total_skills.skill_id

--Solving with CTEs
WITH top_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS total_skills
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        total_skills DESC
    LIMIT 5
)

SELECT
    skills,
    top_skills.total_skills
FROM
    skills_dim
INNER JOIN
    top_skills
ON
    skills_dim.skill_id = top_skills.skill_id

/*Practice Problem2:
Determine the size category(small, medium or large) for each company by first
identifying the number of jobs postings they have. Use a subquery to calculate
the total job postings per company. A company is consider small if it has less
than 10 jos postings, medium if the number of job postings is between 10 an 50,
and large, if it has more than 50 job postings. Implement a subquery to aggregate
job counts per company before classifying them based on  size. */

--With subquery
SELECT
    name,
    total_posts.job_posted,
    CASE
        WHEN total_posts.job_posted > 50 THEN 'Large'
        WHEN total_posts.job_posted > 10 THEN 'Medium'
        ELSE 'Small'
    END AS company_size
FROM
    company_dim
INNER JOIN (
        SELECT company_id, COUNT(*) AS job_posted
        FROM job_postings_fact
        GROUP BY company_id
    ) AS total_posts
ON company_dim.company_id = total_posts.company_id
ORDER BY
    company_size, total_posts.job_posted DESC;



--With CTEs
WITH total_posts AS(
    SELECT
        company_id,
        COUNT(*) AS job_posted
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    name,
    total_posts.job_posted,
    CASE
        WHEN total_posts.job_posted > 50 THEN 'Large'
        WHEN total_posts.job_posted > 10 THEN 'Medium'
        ELSE 'Small'
    END AS company_size
FROM
    company_dim
INNER JOIN
    total_posts
ON
    company_dim.company_id = total_posts.company_id
ORDER BY
    company_size,
    total_posts.job_posted DESC;

/*Practice Problem 07:
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs of Data Analyst
- Include skill ID, name and count of posting requiring the skil
*/
WITH job_skill AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS sjd
    INNER JOIN
        job_postings_fact AS jpf
    ON
        sjd.job_id = jpf.job_id
    WHERE
        jpf.job_work_from_home = 'True' AND
        jpf.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    job_skill.skill_id,
    skills,    
    job_skill.skill_count
FROM
    skills_dim AS sd
INNER JOIN
    job_skill
ON
    sd.skill_id = job_skill.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

/*Another way to solve it*/
WITH job_skill AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS sjd
    INNER JOIN
        job_postings_fact AS jpf
    ON
        sjd.job_id = jpf.job_id
    WHERE
        jpf.job_work_from_home = 'True' AND
        jpf.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    sd.skill_id,
    sd.skills,
    skill_count
FROM
    job_skill
INNER JOIN
    skills_dim AS sd
ON
    job_skill.skill_id = sd.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;


/*Union and Union All
===================== */
/*Union: joins all tables, but remove duplicated rows*/
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

/*Union All: joins all tables, include duplicated rows.
Most used*/
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION All

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION All

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;


/*Practice Problem01 (07):
Get the corresponding skill and skill type for each job in q1
includes all without any skills too. And the salary must be 
>= 7000
*/
WITH job_skills AS (
    SELECT DISTINCT  -- Add DISTINCT to avoid duplicate jobs
        job_id,
        job_title_short
    FROM january_jobs
    WHERE salary_year_avg >= 70000
    
    UNION ALL
    
    SELECT DISTINCT
        job_id,
        job_title_short
    FROM february_jobs
    WHERE salary_year_avg >= 70000
    
    UNION ALL
    
    SELECT DISTINCT
        job_id,
        job_title_short
    FROM march_jobs
    WHERE salary_year_avg >= 70000
)

SELECT
    job_skills.job_id,
    job_skills.job_title_short,
    skills_dim.skills,
    skills_dim.type
FROM
    job_skills  
LEFT JOIN
    skills_job_dim ON job_skills.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    job_skills.job_id, skills_dim.skills;


/*Practice Problem02 (08):
Find jobs posting from the first quarter that have a salary greater than 70000
*/

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE
FROM(
    SELECT
        *
    FROM
        january_jobs
    WHERE
        salary_year_avg > 70000
    UNION ALL
    SELECT
        *
    FROM
        february_jobs
    WHERE
        salary_year_avg > 70000
    UNION ALL
    SELECT
        *
    FROM
        march_jobs
    WHERE
        salary_year_avg > 70000
)


SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE
FROM(
    SELECT
        *
    FROM
        january_jobs
    UNION ALL
    SELECT
        *
    FROM
        february_jobs
    UNION ALL
    SELECT
        *
    FROM
        march_jobs
) AS q1_jobs
    WHERE
        salary_year_avg > 70000