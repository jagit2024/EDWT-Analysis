/*
=====================================================
FILE: 07_data_quality_report.sql
PURPOSE: Data quality validation and reporting
EXECUTION: Run after Silver transformation
=====================================================
*/

USE ED_Analytics;
GO

PRINT '========================================';
PRINT 'DATA QUALITY VALIDATION REPORT';
PRINT '========================================';
PRINT '';

-- Record counts
PRINT 'RECORD COUNTS:';
SELECT 
    'Bronze (Source)' AS Layer,
    COUNT(*) AS RecordCount
FROM bronze_ed_visits
UNION ALL
SELECT 
    'Silver (Loaded)' AS Layer,
    COUNT(*) AS RecordCount
FROM silver_ed_visits;

PRINT '';
PRINT 'DATA QUALITY ISSUES:';

-- NULL checks
SELECT 
    'Records with NULL Acuity Level' AS Issue,
    COUNT(*) AS Count
FROM silver_ed_visits
WHERE acuity_level IS NULL
UNION ALL
SELECT 
    'Records with Capped Wait Time' AS Issue,
    COUNT(*) AS Count
FROM silver_ed_visits
WHERE wait_time_minutes = 300
UNION ALL
SELECT 
    'Records with NULL Length of Stay' AS Issue,
    COUNT(*) AS Count
FROM silver_ed_visits
WHERE length_of_stay_hours IS NULL;

PRINT '';
PRINT 'ACUITY DISTRIBUTION:';

-- Distribution analysis
SELECT 
    acuity_level,
    COUNT(*) AS patient_count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM silver_ed_visits) AS DECIMAL(5,2)) AS percentage
FROM silver_ed_visits
WHERE acuity_level IS NOT NULL
GROUP BY acuity_level
ORDER BY acuity_level;

PRINT '';
PRINT 'Data quality report complete';
GO
