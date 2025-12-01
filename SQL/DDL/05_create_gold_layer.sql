/*
=====================================================
FILE: 05_create_gold_layer.sql
PURPOSE: Create Gold layer analytics view (HIPAA-compliant)
DEPENDENCIES: 
  - 03_create_silver_layer.sql (silver_ed_visits table)
  - 04_create_reference_tables.sql (ref_acuity_levels table)
EXECUTION ORDER: Run this FIFTH (LAST)
=====================================================
*/

USE ED_Analytics;
GO

-- Gold Layer: De-identified analytics view
CREATE VIEW gold_ed_analytics AS
SELECT 
    -- De-identification: Replace patient_id with random GUID
    NEWID() AS anonymous_id,
    
    -- Pass-through fields from Silver
    s.acuity_level,
    s.age_group,
    s.chief_complaint,
    s.arrival_hour,
    s.arrival_day_of_week,
    s.arrival_date,
    s.wait_time_minutes,
    s.length_of_stay_hours,
    
    -- Reference data from acuity levels table
    r.acuity_name,
    r.target_time_minutes AS acuity_target_time,
    
    -- Calculated business metrics
    CASE 
        WHEN s.wait_time_minutes <= 30 THEN 'Met Target'
        ELSE 'Exceeded Target'
    END AS wait_time_status,
    
    CASE 
        WHEN s.wait_time_minutes <= r.target_time_minutes 
        THEN 'Met Acuity Target'
        ELSE 'Exceeded Acuity Target'
    END AS acuity_target_status
    
FROM silver_ed_visits s
LEFT JOIN ref_acuity_levels r ON s.acuity_level = r.acuity_level;
GO

PRINT 'Gold layer view created';
GO
