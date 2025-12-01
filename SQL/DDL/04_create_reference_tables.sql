/*
=====================================================
FILE: 04_create_reference_tables.sql
PURPOSE: Create and populate acuity level reference table
DEPENDENCIES: 01_create_database.sql must be run first
EXECUTION ORDER: Run this FOURTH
=====================================================
*/

USE ED_Analytics;
GO

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

PRINT 'Reference table created and populated with 5 acuity levels';
GO
