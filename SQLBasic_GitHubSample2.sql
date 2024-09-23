-- 1) Select all columns and rows from a specific table (dimension.Employee)
SELECT * 
FROM dimension.Employee;

-- 2) Select only specific columns from the table
SELECT Employee, [Preferred Name], [WWI Employee ID] 
FROM dimension.Employee;

-- 3) Select records based on a numeric criterion
SELECT Employee, [Preferred Name], [WWI Employee ID] 
FROM dimension.Employee
WHERE [Employee Key] < 10;

-- 4) Select records using a string criterion
SELECT Employee, [Preferred Name], [WWI Employee ID] 
FROM dimension.Employee
WHERE [Preferred Name] = 'Hudson';

-- 5) Select using AND/OR conditions
SELECT Employee, [Preferred Name], [WWI Employee ID] 
FROM dimension.Employee
WHERE [Preferred Name] = 'Hudson' AND [WWI Employee ID] = 13;

SELECT Employee, [Preferred Name], [WWI Employee ID] 
FROM dimension.Employee
WHERE [Preferred Name] = 'Hudson' OR [WWI Employee ID] = 13;

-- 6) Sort data in ascending and descending order
-- Default is ascending
SELECT * 
FROM dimension.Employee;

-- Sort in descending order by [WWI Employee ID]
SELECT * 
FROM dimension.Employee
ORDER BY [WWI Employee ID] DESC;

-- Sort using multiple columns in descending order
SELECT * 
FROM dimension.Employee
ORDER BY Employee, [Employee Key] DESC;

-- 7) Use aliases to create more readable column names
SELECT [Preferred Name] AS NickName, [WWI Employee ID] AS ID, [Valid To] AS Validity
FROM dimension.Employee
ORDER BY NickName;

-- 8) Display unique records using DISTINCT
SELECT DISTINCT Employee, [WWI Employee ID]
FROM dimension.Employee;

-- 9) Search using wildcards for pattern matching
-- Select employees whose names end with 'E'
SELECT DISTINCT Employee, [WWI Employee ID]
FROM dimension.Employee
WHERE Employee LIKE '%E';

-- Select employees whose names start with 'E'
SELECT DISTINCT Employee, [WWI Employee ID]
FROM dimension.Employee
WHERE Employee LIKE 'E%';

-- Select employees whose second character is 'E'
SELECT DISTINCT Employee, [WWI Employee ID]
FROM dimension.Employee
WHERE Employee LIKE '_E%';

-- Select employees whose names do not start with 'A'
SELECT DISTINCT Employee, [WWI Employee ID]
FROM dimension.Employee
WHERE Employee LIKE '[^A]%';

-- 10) Creating runtime-calculated columns
-- Example from the [Fact].[Sale] table
SELECT [WWI Invoice ID], [Quantity], ([Unit Price] - 5) AS DiscountedRate, [Tax Rate], [Profit]
FROM [Fact].[Sale];

-- 11) Creating a CASE statement on a column
SELECT [WWI Invoice ID], [Quantity], ([Unit Price] - 5) AS DiscountedRate, [Tax Rate], [Profit],
  CASE
    WHEN [Total Excluding Tax] > 40 AND [Total Excluding Tax] < 80 THEN 'Medium Profit'
    WHEN [Total Excluding Tax] > 80 AND [Total Excluding Tax] < 150 THEN 'Good Profit'
    ELSE 'Loss'
  END AS ProfitCategory
FROM [Fact].[Sale];

-- 12) Joining data from two tables using UNION and UNION ALL
-- Selecting data from [Dimension].[Customer] and [Dimension].[Employee]
SELECT [Customer], [Valid From], [Valid To]
FROM [Dimension].[Customer]
UNION 
SELECT [Employee], [Valid From], [Valid To]
FROM [Dimension].[Employee];

-- Using UNION ALL (including duplicates)
SELECT [Customer], [Valid From], [Valid To]
FROM [Dimension].[Customer]
UNION ALL
SELECT [Employee], [Valid From], [Valid To]
FROM [Dimension].[Employee];

-- 13) INNER JOIN: Show matching data between two tables
SELECT * 
FROM [Fact].[Purchase] 
INNER JOIN [Dimension].[Supplier] 
ON [Fact].[Purchase].[Supplier Key] = [Dimension].[Supplier].[Supplier Key];

-- 14) LEFT and RIGHT joins
-- Left Join: All rows from Purchase, and matching rows from Supplier
SELECT * 
FROM [Fact].[Purchase]
LEFT JOIN [Dimension].[Supplier] 
ON [Fact].[Purchase].[Supplier Key] = [Dimension].[Supplier].[Supplier Key];

-- Right Join: All rows from Supplier, and matching rows from Purchase
SELECT * 
FROM [Fact].[Purchase]
RIGHT JOIN [Dimension].[Supplier] 
ON [Fact].[Purchase].[Supplier Key] = [Dimension].[Supplier].[Supplier Key];

-- Full Outer Join: All rows from both tables, matching or not
SELECT * 
FROM [Fact].[Purchase]
FULL OUTER JOIN [Dimension].[Supplier] 
ON [Fact].[Purchase].[Supplier Key] = [Dimension].[Supplier].[Supplier Key];

-- 15) Writing a complex SQL statement with multiple INNER JOINs
SELECT [Customer], [Buying Group], [Quantity], [Profit], [Bill To Customer], [City], [Region]
FROM [Fact].[Sale]
INNER JOIN [Dimension].[Customer] ON [Fact].[Sale].[Customer Key] = [Dimension].[Customer].[Customer Key]
INNER JOIN [Dimension].[City] ON [Fact].[Sale].[City Key] = [Dimension].[City].[City Key]
ORDER BY Profit ASC;

-- 16) Aggregate functions using GROUP BY
SELECT [Buying Group], SUM(Profit) AS TotalProfit, COUNT(Quantity) AS QuantitySold
FROM [Fact].[Sale]
INNER JOIN [Dimension].[Customer] ON [Fact].[Sale].[Customer Key] = [Dimension].[Customer].[Customer Key]
GROUP BY [Buying Group];

-- 17) Using HAVING clause with GROUP BY
SELECT [Buying Group], SUM(Profit) AS TotalProfit, COUNT(Quantity) AS QuantitySold
FROM [Fact].[Sale]
INNER JOIN [Dimension].[Customer] ON [Fact].[Sale].[Customer Key] = [Dimension].[Customer].[Customer Key]
GROUP BY [Buying Group]
HAVING SUM(Profit) > 28000000;

-- 18) Understanding Self Join
-- Creating a new table for self-join example
SELECT * INTO NewDimensionCustomer FROM [Dimension].[Customer];

-- Add a new column 'Referred_By'
ALTER TABLE [dbo].[NewDimensionCustomer] ADD Referred_By NVARCHAR(50);

-- Update the 'Referred_By' column with example data
UPDATE NewDimensionCustomer SET [Referred_By] = 3 WHERE [Customer Key] = 0;
-- More updates here...

-- Perform a self-join to display the 'Referred_By' column with actual names
SELECT t1.Customer AS CustomerName, ISNULL(t2.Customer, 'Walk-In') AS ReferenceName
FROM [dbo].[NewDimensionCustomer] t1
INNER JOIN [dbo].[NewDimensionCustomer] t2 ON t1.Referred_By = t2.[Customer Key];

-- 19) SUBQUERIES: Querying with a subquery
SELECT * 
FROM [Dimension].[Customer]
WHERE [Customer Key] IN (
  SELECT [Customer Key] 
  FROM [Fact].[Order]
)
ORDER BY [Customer Key];

-- More subquery examples...

-- 20) Using CO-RELATED subqueries
SELECT [Stock Item], [Unit Price]
FROM [Dimension].[Stock Item] t1
WHERE 3 = (SELECT COUNT(*) 
           FROM [Dimension].[Stock Item] t2
           WHERE t2.[Unit Price] >= t1.[Unit Price]);

-- 21) Aggregate Functions: MIN, MAX, AVG, SUM
SELECT MIN([Unit Price]) AS MinPrice, MAX([Tax Rate]) AS MaxTax, AVG([Unit Price]) AS AvgPrice, SUM([Unit Price]) AS TotalPrice
FROM [Dimension].[Stock Item];

-- 22) Finding data between numeric ranges
SELECT [Stock Item], [Unit Price]
FROM [Dimension].[Stock Item]
WHERE [Unit Price] BETWEEN 50 AND 150;

-- 23) SELECT INTO: Dump table data into a new table
SELECT * 
INTO NewDimensionCity
FROM [Dimension].[City];

-- 24) Bulk insert data into a table
INSERT INTO [dbo].[NewSupplier]
SELECT * 
FROM [Dimension].[Supplier];
