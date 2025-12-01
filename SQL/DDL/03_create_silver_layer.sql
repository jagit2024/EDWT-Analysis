/*
=====================================================
FILE: 03_create_silver_layer.sql
PURPOSE: Create Silver layer table (cleaned and transformed data)
DEPENDENCIES: 01_create_database.sql must be run first
EXECUTION ORDER: Run this THIRD
=====================================================
*/

USE ED_Analytics;
GO

-- Silver Layer: Cleaned and validated data with derived fields
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

PRINT 'Silver layer table created';
GO
