/*
=====================================================
FILE: 08_analytical_queries.sql
PURPOSE: Sample analytical queries for Power BI and ad-hoc analysis
EXECUTION: Run against Gold layer for insights
=====================================================
*/

USE ED_Analytics;
GO

-- Query 1: Average wait time by acuity level
SELECT 
    acuity_level,
    acuity_name,
    COUNT(*) AS patient_count,
    AVG(wait_time_minutes) AS avg_wait_time,
    acuity_target_time
FROM gold_ed_analytics
GROUP BY acuity_level, acuity_name, acuity_target_time
ORDER BY acuity_level;

-- Query 2: Peak hours analysis
SELECT 
    arrival_hour,
    COUNT(*) AS visit_count,
    AVG(wait_time_minutes) AS avg_wait_time
FROM gold_ed_analytics
GROUP BY arrival_hour
ORDER BY visit_count DESC;

-- Query 3: Day of week patterns
SELECT 
    arrival_day_of_week,
    COUNT(*) AS visit_count,
    AVG(wait_time_minutes) AS avg_wait_time
FROM gold_ed_analytics
GROUP BY arrival_day_of_week
ORDER BY 
    CASE arrival_day_of_week
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

-- Query 4: Chief complaint distribution
SELECT 
    chief_complaint,
    COUNT(*) AS visit_count,
    AVG(wait_time_minutes) AS avg_wait_time
FROM gold_ed_analytics
GROUP BY chief_complaint
ORDER BY visit_count DESC;

-- Query 5: Target achievement summary
SELECT 
    wait_time_status,
    COUNT(*) AS patient_count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM gold_ed_analytics) AS DECIMAL(5,2)) AS percentage
FROM gold_ed_analytics
GROUP BY wait_time_status;

PRINT 'Analytical queries executed';
GO
