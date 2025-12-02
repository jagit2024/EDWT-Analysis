/*
=====================================================
MASTER SETUP SCRIPT
Emergency Department Wait Time Analysis Project
=====================================================

PROJECT: ED Analytics Pipeline
AUTHOR: Justin O. Ajuogu
DATE: November 2025
DATABASE: ED_Analytics (SQL Server 2019)

PURPOSE: Complete database setup in single script
         Combines all DDL scripts in correct execution order

EXECUTION: Run this entire script in SSMS (F5)
           - Creates database
           - Creates all tables
           - Creates reference data
           - Creates views
           - Ready for data load

DEPENDENCIES: None - this is a fresh setup

NEXT STEPS AFTER RUNNING:
1. Run: python/load_to_sql.py (loads Bronze layer)
2. Run: sql/dml/06_etl_bronze_to_silver.sql (transforms to Silver)
3. Run: sql/dml/07_data_quality_report.sql (validates data)
4. Connect Power BI to gold_ed_analytics view

=====================================================
*/

-- =====================================================
-- SECTION 1: DATABASE CREATION
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 1: Creating Database';
PRINT '================================================';

-- Drop database if exists (for clean re-runs)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ED_Analytics')
BEGIN
    PRINT 'Dropping existing ED_Analytics database...';
    ALTER DATABASE ED_Analytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ED_Analytics;
END

-- Create new database
CREATE DATABASE ED_Analytics;
GO

USE ED_Analytics;
GO

PRINT '✅ Database ED_Analytics created successfully';
GO

-- =====================================================
-- SECTION 2: BRONZE LAYER (Raw Data)
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 2: Creating Bronze Layer';
PRINT '================================================';

-- Bronze Layer: Immutable raw data from source systems
CREATE TABLE bronze_ed_visits (
    patient_id VARCHAR(50),
    arrival_time DATETIME,
    acuity_level INT,
    age_group VARCHAR(20),
    chief_complaint VARCHAR(100),
    wait_time_minutes INT,
    length_of_stay_hours DECIMAL(5,2),
    load_timestamp DATETIME DEFAULT GETDATE()
);
GO

PRINT 'Bronze layer table (bronze_ed_visits) created';
GO

-- =====================================================
-- SECTION 3: SILVER LAYER (Cleaned Data)
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 3: Creating Silver Layer';
PRINT '================================================';

-- Silver Layer: Validated, standardized operational data
CREATE TABLE silver_ed_visits (
    patient_id VARCHAR(50),
    arrival_time DATETIME,
    acuity_level INT,
    age_group VARCHAR(20),
    chief_complaint VARCHAR(100),
    wait_time_minutes INT,
    length_of_stay_hours DECIMAL(5,2),
    arrival_hour INT,
    arrival_day_of_week VARCHAR(20),
    arrival_date DATE,
    processed_timestamp DATETIME DEFAULT GETDATE()
);
GO

PRINT 'Silver layer table (silver_ed_visits) created';
GO

-- =====================================================
-- SECTION 4: REFERENCE TABLES
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 4: Creating Reference Tables';
PRINT '================================================';

-- Reference Table: Emergency Severity Index (ESI) definitions
CREATE TABLE ref_acuity_levels (
    acuity_level INT PRIMARY KEY,
    acuity_name VARCHAR(50),
    description VARCHAR(500),
    target_time_minutes INT,
    example_conditions VARCHAR(500)
);
GO

-- Populate reference data
INSERT INTO ref_acuity_levels VALUES
(1, 'Resuscitation/Critical', 
 'Life-threatening condition requiring immediate intervention',
 0, 
 'Cardiac arrest, severe trauma, respiratory failure'),

(2, 'Emergency/High Acuity',
 'Serious condition requiring immediate physician evaluation',
 10,
 'Chest pain, severe breathing difficulty, major trauma'),

(3, 'Urgent/Moderate Acuity',
 'Requires timely care but not immediately life-threatening',
 30,
 'Moderate abdominal pain, minor head injury, fractures'),

(4, 'Semi-Urgent/Lower Acuity',
 'Requires minimal resources with low risk of deterioration',
 60,
 'Minor lacerations, sprains, mild infections'),

(5, 'Non-Urgent/Low Acuity',
 'Minor problem that may not require emergency care',
 120,
 'Prescription refills, minor rashes, cold symptoms');
GO

PRINT 'Reference table (ref_acuity_levels) created and populated with 5 ESI levels';
GO

-- =====================================================
-- SECTION 5: GOLD LAYER (Analytics Views)
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 5: Creating Gold Layer';
PRINT '================================================';

-- Gold Layer: HIPAA-compliant analytics view
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

PRINT 'Gold layer view (gold_ed_analytics) created';
GO

-- =====================================================
-- SECTION 6: VERIFICATION
-- =====================================================

PRINT '';
PRINT '================================================';
PRINT 'STEP 6: Verifying Database Setup';
PRINT '================================================';

-- List all created objects
SELECT 
    name AS ObjectName,
    type_desc AS ObjectType,
    create_date AS CreatedDate
FROM sys.objects
WHERE name IN ('bronze_ed_visits', 'silver_ed_visits', 'ref_acuity_levels', 'gold_ed_analytics')
ORDER BY 
    CASE type_desc 
        WHEN 'USER_TABLE' THEN 1 
        WHEN 'VIEW' THEN 2 
    END,
    name;

PRINT '';
PRINT '================================================';
PRINT '✅ DATABASE SETUP COMPLETE!';
PRINT '================================================';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. Run: python/load_to_sql.py (loads data into Bronze layer)';
PRINT '2. Run: sql/dml/06_etl_bronze_to_silver.sql (transforms to Silver)';
PRINT '3. Run: sql/dml/07_data_quality_report.sql (validates data quality)';
PRINT '4. Connect Power BI to gold_ed_analytics view';
PRINT '';
PRINT 'DATABASE OBJECTS CREATED:';
PRINT '  - Database: ED_Analytics';
PRINT '  - Tables: bronze_ed_visits, silver_ed_visits, ref_acuity_levels';
PRINT '  - Views: gold_ed_analytics';
PRINT '';
PRINT '================================================';
GO
