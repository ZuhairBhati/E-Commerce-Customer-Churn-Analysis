USE ecommerce;

SELECT * FROM churn;

-- 1. Finding the total number of customers
SELECT DISTINCT
    COUNT(CustomerID) AS TotalNumberofCustomers
FROM
    churn;

-- There are a total of 5630 customers in the data

-- 2. Checking for duplicate rows
SELECT 
    CustomerID, COUNT(CustomerID) AS cnt
FROM
    churn
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 1;

-- The query returns nothing as there are no duplicate rows

-- 3. Check for NULL values
SELECT 'Tenure' AS Columnname, COUNT(*) AS nullcount
FROM churn
WHERE Tenure IS NULL
UNION
SELECT 'WarehouseToHome' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE warehousetohome IS NULL 
UNION
SELECT 'HourSpendonApp' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE hourspendonapp IS NULL
UNION
SELECT 'OrderAmountHikeFromLastYear' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE orderamounthikefromlastyear IS NULL 
UNION
SELECT 'CouponUsed' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE couponused IS NULL 
UNION
SELECT 'OrderCount' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE ordercount IS NULL 
UNION
SELECT 'DaySinceLastOrder' as ColumnName, COUNT(*) AS nullcount 
FROM churn
WHERE daysincelastorder IS NULL;

-- As we can see there are Null values in the specified columns

-- 4. Handling Null values
UPDATE churn
SET Tenure = (
	SELECT AVG(Tenure)
    FROM (
		SELECT Tenure
        FROM churn
        WHERE Tenure IS NOT NULL
        ) AS temp
	)
WHERE Tenure IS NULL;

UPDATE churn
SET WarehouseToHome = (
	SELECT AVG(WarehouseToHome)
    FROM (
		SELECT WarehouseToHome
        FROM churn
        WHERE WarehouseToHome IS NOT NULL
        ) AS temp
	)
WHERE WarehouseToHome IS NULL;

UPDATE churn
SET HourSpendOnApp = (
	SELECT AVG(HourSpendOnApp)
    FROM (
		SELECT HourSpendOnApp
        FROM churn
        WHERE HourSpendOnApp IS NOT NULL
        ) AS temp
	)
WHERE HourSpendOnApp IS NULL;

UPDATE churn
SET OrderAmountHikeFromLastYear = (
	SELECT AVG(OrderAmountHikeFromLastYear)
    FROM (
		SELECT OrderAmountHikeFromLastYear
        FROM churn
        WHERE OrderAmountHikeFromLastYear IS NOT NULL
        ) AS temp
	)
WHERE OrderAmountHikeFromLastYear IS NULL;

UPDATE churn
SET CouponUsed = (
	SELECT AVG(CouponUsed)
    FROM (
		SELECT CouponUsed
        FROM churn
        WHERE CouponUsed IS NOT NULL
        ) AS temp
	)
WHERE CouponUsed IS NULL;

UPDATE churn
SET OrderCount = (
	SELECT AVG(OrderCount)
    FROM (
		SELECT OrderCount
        FROM churn
        WHERE OrderCount IS NOT NULL
        ) AS temp
	)
WHERE OrderCount IS NULL;

-- 4. Creating a new column from the 'churn' column
ALTER TABLE churn
ADD CustomerStatus VARCHAR(50);

UPDATE churn
SET CustomerStatus =
CASE 
	WHEN Churn = 1 THEN 'Churned'
    WHEN Churn = 0 THEN 'Stayed'
END;

-- 5. Number of Customers stayed vs churned
SELECT CustomerStatus, COUNT(CustomerStatus) as StatusCount
FROM churn
GROUP BY CustomerStatus;

-- Churned = 948 & Stayed = 4682

-- 6. Fixing Redundancy in the PreferredLoginDevice Column
SELECT DISTINCT PreferredLoginDevice
FROM churn;

UPDATE churn
SET PreferredLoginDevice = 'Phone'
WHERE PreferredLoginDevice = 'Mobile Phone';

SELECT DISTINCT PreferredLoginDevice
FROM churn;

-- 7. Fixing Redundancy in the PreferedOrderCat Column
SELECT DISTINCT PreferedOrderCat 
FROM churn;

UPDATE churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

SELECT DISTINCT PreferedOrderCat 
FROM churn;

-- 8. Fixing Redundancy in the PrefeRredPaymentMode
SELECT DISTINCT PreferredPaymentMode 
FROM churn;

UPDATE churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

SELECT DISTINCT PreferredPaymentMode 
FROM churn;

-- 9. Fixing values in the WarehouseToHome Column
SELECT DISTINCT WarehouseToHome
FROM churn;

UPDATE churn
SET WarehouseToHome = 27
WHERE WarehouseToHome = 127;

UPDATE churn
SET WarehouseToHome = 26
WHERE WarehouseToHome = 126;

SELECT DISTINCT WarehouseToHome
FROM churn;

# QUESTIONS

# 1. What is the overall customer churn rate?
SELECT 
    TotalNumberofCustomers,
    TotalNumberofChurnedCustomers,
    CAST((TotalNumberofChurnedCustomers * 1.0 / TotalNumberofCustomers * 1.0) * 100
        AS DECIMAL (10 , 2 )) AS ChurnRate
FROM
    (SELECT 
        COUNT(*) AS TotalNumberofCustomers
    FROM
        churn) AS Total,
    (SELECT 
        COUNT(*) AS TotalNumberofChurnedCustomers
    FROM
        churn
    WHERE
        CustomerStatus = 'Churned') AS Churned;
        
-- The churn rate is 16.84%

# 2. How does the churn rate vary based on preferred login device
SELECT * FROM churn;

SELECT PreferredLoginDevice,
	   COUNT(*) AS TotalCustomers
FROM churn
GROUP BY PreferredLoginDevice;

SELECT PreferredLoginDevice,
		SUM('Churned') AS ChurnedCustomers
FROM churn
GROUP BY PreferredLoginDevice;

SELECT PreferredLoginDevice,
	   SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers
FROM churn
GROUP BY PreferredLoginDevice;

SELECT PreferredLoginDevice,
	   COUNT(*) AS TotalCustomers,
	   SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
       CAST((SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS DECIMAL(10, 2))  AS ChurnRate
FROM churn
GROUP BY PreferredLoginDevice;

# 3. What is the distribution of customers across different city tiers?
SELECT DISTINCT CityTier
FROM churn;

SELECT CityTier, 
       COUNT(*) AS TotalCustomers,
       SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers
FROM churn
GROUP BY CityTier
ORDER By CityTier;

# 4. Is there any correlation between the warehouse-to-home distance and customer churn?
ALTER TABLE churn
ADD WarehouseToHomeSatus VARCHAR(50);

UPDATE churn
SET WarehouseToHomeSatus = 
CASE
	WHEN WarehouseToHome <= 10 THEN 'Very Close'
    WHEN WarehouseToHome > 10 AND WarehouseToHome <= 20 THEN 'Close'
    WHEN WarehouseToHome > 20 AND WarehouseToHome <= 30 THEN 'Moderate'
    WHEN WarehouseToHome > 30 THEN 'Far'
END;

SELECT DISTINCT WarehouseToHomeSatus 
FROM churn;

-- Finding a cor-relation
SELECT 
	WarehouseToHomeSatus,
    COUNT(*) AS TotalCustomer,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
	CAST((SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS DECIMAL(10, 2))  AS ChurnRate
FROM churn
GROUP BY WarehouseToHomeSatus
ORDER BY ChurnRate DESC;

# 5. Which is the most preferred payment mode among churned customers?
SELECT 
	PreferredPaymentMode,
    COUNT(*) AS TotalCustomer,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
	CAST((SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS DECIMAL(10, 2))  AS ChurnRate
FROM churn
GROUP BY PreferredPaymentMode
ORDER BY ChurnRate DESC;

# 6. What is the Tenure for churned customers?
ALTER TABLE churn
ADD TenureRange VARCHAR(50);

UPDATE churn
SET TenureRange = 
CASE WHEN Tenure <= 6 THEN '6 Months'
	 WHEN Tenure > 6 AND TENURE <= 12 THEN '1 Year'	
     WHEN Tenure > 12 AND TENURE <= 24 THEN '2 Years'
     WHEN Tenure > 24 THEN 'More Than 2 Years'
END;

-- Finding Tenure
SELECT TenureRange, COUNT(*) AS TotalCustomers,
	   SUM(Churn) AS ChurnedCustomers,
       CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10,2)) AS ChurnRate
FROM churn
GROUP BY TenureRange
ORDER BY ChurnRate DESC;

# 7. Is there any difference in churn rate between male and female customers?
SELECT Gender,
	   COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
	   CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10,2)) AS ChurnRate
FROM churn
GROUP BY Gender
ORDER BY ChurnRate DESC;

# 8. How does the average time spent on the app differ for churned and non-churned customers?
SELECT CustomerStatus,
	   AVG(HourSpendOnApp) AS AverageHourSpentOnApp
FROM churn
GROUP BY CustomerStatus;

# 9. Does the Number of Registered Devices impact the Churn?
SELECT NumberOfDeviceRegistered,
	   COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
	   CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10,2)) AS ChurnRate
FROM churn
GROUP BY NumberOfDeviceRegistered
ORDER BY ChurnRate DESC;

# 10. Which Order category is most preferred among churned customers?
SELECT PreferedOrderCat,
	   COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
	   CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10,2)) AS ChurnRate
FROM churn
GROUP BY PreferedOrderCat
ORDER BY ChurnRate DESC;

# 11. Is there any relationship between Customer satisfaction score and churn?
SELECT SatisfactionScore,
       COUNT(*) AS TotalCustomers,
       SUM(Churn) AS ChurnedCustomers,
	   CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10,2)) AS ChurnRate
FROM churn
GROUP BY SatisfactionScore
ORDER BY ChurnRate DESC;

# 12. Does the marital status of the customers impact churn?
SELECT 
    MaritalStatus,
    COUNT(*) AS TotalCustomers,
    SUM(Churn) AS ChurnedCustomers,
    CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10 , 2 )) AS ChurnRate
FROM churn
GROUP BY MaritalStatus
ORDER BY ChurnRate DESC;

# 13. Do customers complaints influence churn?
SELECT 
    Complain,
    COUNT(*) AS TotalCustomers,
    SUM(Churn) AS ChurnedCustomers,
    CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10 , 2 )) AS ChurnRate
FROM churn
GROUP BY Complain
ORDER BY ChurnRate DESC;

# 14. How does the use of coupons differ between churned and non-churned customers?
SELECT 
    CustomerStatus, SUM(CouponUsed) AS CouponUsed
FROM churn
GROUP BY CustomerStatus; 

# 15. What is the average number of days since the last order for churned customers?
SELECT AVG(DaySinceLastOrder) AS AverageNumberofDaySinceLastOrder
FROM churn
WHERE CustomerStatus = 'Churned';

# 16. Is there any correlation between cashback amount and churn rate?
ALTER TABLE churn
ADD CashBackAmountRange VARCHAR(50);

UPDATE churn
SET CashBackAmountRange = 
CASE WHEN CashBackAmount <= 100 THEN 'Low CashBack Amount'
	 WHEN CashBackAmount > 100 AND CashBackAmount <= 200 THEN 'Moderate CashBack Amount'
     WHEN CashBackAmount > 200 AND CashBackAmount <= 300 THEN 'High CashBack Amount'
     WHEN CashBackAmount > 300 THEN 'Very High CashBack Amount'
END;

SELECT 
    CashBackAmountRange,
    COUNT(*) AS TotalCustomers,
    SUM(Churn) AS ChurnedCustomers,
    CAST(SUM(Churn) / COUNT(*) * 100 AS DECIMAL (10 , 2 )) AS ChurnRate
FROM churn
GROUP BY CashbackAmountRange
ORDER BY ChurnRate DESC;

# 17. How many addresses do churned customers have on average?
SELECT AVG(NumberOfAddress) AS AveraegNumberOfAddress
FROM churn
WHERE CustomerStatus = 'Churned';

SELECT * FROM churn;