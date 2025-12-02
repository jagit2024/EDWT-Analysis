-- File: 09_sp_transform_to_silver.sql
USE ED_Analytics;
GO

CREATE PROCEDURE sp_transform_to_silver
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Clear existing silver data
        TRUNCATE TABLE silver_ed_visits;
        
        -- Transform Bronze → Silver
        INSERT INTO silver_ed_visits (
            patient_id, arrival_time, acuity_level, age_group, 
            chief_complaint, wait_time_minutes, length_of_stay_hours,
            arrival_hour, arrival_day_of_week, arrival_date
        )
        SELECT 
            UPPER(LTRIM(RTRIM(patient_id))) AS patient_id,
            CASE 
                WHEN arrival_time IS NULL THEN NULL
                WHEN arrival_time > GETDATE() THEN NULL
                ELSE arrival_time 
            END AS arrival_time,
            CASE 
                WHEN acuity_level BETWEEN 1 AND 5 THEN acuity_level 
                ELSE NULL
            END AS acuity_level,
            UPPER(LTRIM(RTRIM(age_group))) AS age_group,
            UPPER(LTRIM(RTRIM(chief_complaint))) AS chief_complaint,
            CASE 
                WHEN wait_time_minutes IS NULL THEN NULL
                WHEN wait_time_minutes < 0 THEN NULL
                WHEN wait_time_minutes > 300 THEN 300
                ELSE wait_time_minutes
            END AS wait_time_minutes,
            CASE 
                WHEN length_of_stay_hours IS NULL THEN NULL
                WHEN length_of_stay_hours < 0 THEN NULL
                WHEN length_of_stay_hours > 24 THEN NULL
                ELSE ROUND(length_of_stay_hours, 1)
            END AS length_of_stay_hours,
            DATEPART(HOUR, arrival_time) AS arrival_hour,
            DATENAME(WEEKDAY, arrival_time) AS arrival_day_of_week,
            CAST(arrival_time AS DATE) AS arrival_date
        FROM bronze_ed_visits
        WHERE arrival_time IS NOT NULL
          AND patient_id IS NOT NULL
          AND patient_id <> '';
        
        COMMIT TRANSACTION;
        
        PRINT 'Silver transformation successful: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records processed';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        PRINT 'Error during transformation:';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR);
        
        -- Re-throw error
        THROW;
    END CATCH
END;
GO

-- Usage: EXEC sp_transform_to_silver;
