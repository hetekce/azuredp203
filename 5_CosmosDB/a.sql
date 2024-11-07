-- Some of the Important T-SQL Commands

-- 1. OPENROWSET

-- OPENROWSET is used in SQL Server to access data from an external source 
-- or file as if it were a table. It is often used for ad-hoc querying of 
-- external data sources such as files (e.g., CSV, Parquet), databases, or 
-- Azure Blob Storage without needing to set up a linked server.

SELECT *
FROM OPENROWSET(
    BULK 'https://myaccount.blob.core.windows.net/mycontainer/myfile.csv',
    FORMAT = 'CSV'
) AS CSVData

-- Key Points
-- Often used for importing and querying external data sources.
-- Supports formats like CSV, Parquet, JSON, etc.
-- Commonly utilized with Azure SQL and SQL Server 2019+ to access data in Azure Blob Storage.
-- Requires enabling BULK INSERT and appropriate permissions.


-- 2. OPENJSON

-- OPENJSON is used to parse JSON text or JSON files in SQL Server and 
-- transform the data into a table format. This function lets you extract 
-- JSON data and manipulate it as if it were a table, making it easier to 
-- work with JSON data in relational queries.

SELECT *
FROM OPENJSON(@jsonData)
WITH (
    KeyColumn INT '$.keyColumnPath',
    ValueColumn NVARCHAR(50) '$.valueColumnPath'
)
