-- File: 10_sp_data_quality_check.sql
USE ED_Analytics;
GO

CREATE PROCEDURE sp_data_quality_check
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Temp table for results
    CREATE TABLE #QualityResults (
        check_name VARCHAR(100),
        result_value INT,
        status VARCHAR(20)
    );
    
    -- Check 1: Record count match
    DECLARE @bronze_count INT, @silver_count INT;
    SELECT @bronze_count = COUNT(*) FROM bronze_ed_visits;
    SELECT @silver_count = COUNT(*) FROM silver_ed_visits;
    
    INSERT INTO #QualityResults VALUES 
        ('Bronze Records', @bronze_count, 'INFO'),
        ('Silver Records', @silver_count, 
         CASE WHEN @silver_count = @bronze_count THEN 'PASS' ELSE 'WARN' END);
    
    -- Check 2: NULL acuity levels
    DECLARE @null_acuity INT;
    SELECT @null_acuity = COUNT(*) FROM silver_ed_visits WHERE acuity_level IS NULL;
    
    INSERT INTO #QualityResults VALUES 
        ('NULL Acuity Levels', @null_acuity,
         CASE WHEN @null_acuity = 0 THEN 'PASS' ELSE 'FAIL' END);
    
    -- Check 3: Capped wait times
    DECLARE @capped_wait INT;
    SELECT @capped_wait = COUNT(*) FROM silver_ed_visits WHERE wait_time_minutes = 300;
    
    INSERT INTO #QualityResults VALUES 
        ('Capped Wait Times', @capped_wait, 'INFO');
    
    -- Check 4: NULL wait times
    DECLARE @null_wait INT;
    SELECT @null_wait = COUNT(*) FROM silver_ed_visits WHERE wait_time_minutes IS NULL;
    
    INSERT INTO #QualityResults VALUES 
        ('NULL Wait Times', @null_wait,
         CASE WHEN @null_wait = 0 THEN 'PASS' ELSE 'WARN' END);
    
    -- Return results
    SELECT * FROM #QualityResults ORDER BY status DESC, check_name;
    
    -- Clean up
    DROP TABLE #QualityResults;
END;
GO

-- Usage: EXEC sp_data_quality_check;
