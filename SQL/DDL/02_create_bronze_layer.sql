/*
=====================================================
FILE: 02_create_bronze_layer.sql
PURPOSE: Create Bronze layer table (raw data ingestion)
DEPENDENCIES: 01_create_database.sql must be run first
EXECUTION ORDER: Run this SECOND
=====================================================
*/

USE ED_Analytics;
GO

-- Bronze Layer: Raw data as-is from source
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

PRINT 'Bronze layer table created';
GO
