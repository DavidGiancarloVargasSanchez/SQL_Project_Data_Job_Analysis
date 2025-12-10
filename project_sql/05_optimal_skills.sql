/*
What are the most optimal skills to learn?
Optimal: High demand and High paying.
*/

SELECT
    skills,
    COUNT(skills) AS count_skill,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills
HAVING
    COUNT(skills) > 10
ORDER BY
    average_salary DESC,
    count_skill DESC
LIMIT
    50;

