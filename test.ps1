DECLARE @DaysList VARCHAR(MAX) = '7,30,60';

-- Sample table
-- Assuming you have a table named MyTable with a column DateColumn (of DATE or DATETIME type)
-- CREATE TABLE MyTable (DateColumn DATE);

-- Step 1: Split the comma-separated string into a table of integers
;WITH SplitDays AS (
    SELECT 
        value AS DaysToAdd
    FROM STRING_SPLIT(@DaysList, ',')
)
-- Step 2: Add each day to GETDATE() and get the target dates
, TargetDates AS (
    SELECT 
        CAST(DATEADD(DAY, TRY_CAST(DaysToAdd AS INT), CAST(GETDATE() AS DATE)) AS DATE) AS TargetDate
    FROM SplitDays
)
-- Step 3: Match records in your table
SELECT *
FROM MyTable
WHERE CAST(DateColumn AS DATE) IN (SELECT TargetDate FROM TargetDates);
