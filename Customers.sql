/*
  --Which cities have the highest purchasing frequency?
  SELECT top 10
    City,COUNT([Order_ID]) AS PurchaseCount
FROM[Depi_Project].[dbo].[all] 
GROUP BY City
ORDER BY PurchaseCount DESC;

--Top 10 cities by number of customers per region

SELECT TOP 10
    Region,
    City,
    COUNT([Customer_ID]) AS CustomerCount
FROM [Depi_Project].[dbo].[all] 
GROUP BY Region, City
ORDER BY CustomerCount DESC;
--top city in each region
WITH CityCounts AS (
    SELECT
        Region,
        City,
        COUNT([Customer_ID]) AS CustomerCount,
        RANK() OVER (PARTITION BY Region ORDER BY COUNT([Customer_ID]) DESC) AS rnk
    FROM [Depi_Project].[dbo].[all]
    GROUP BY Region, City
)
SELECT
    Region,
    City,
    CustomerCount
FROM CityCounts
WHERE rnk = 1
ORDER BY CustomerCount DESC;
--Group customers by segment and calculate average sales
SELECT 
    Segment,
    AVG(sales) AS Avg_Sales_Per_Customer
FROM [Depi_Project].[dbo].[all] 
GROUP BY Segment
ORDER BY Avg_Sales_Per_Customer DESC;
--Identify cities with potential for customer expansion
SELECT top 10
    City,
    COUNT([Customer_ID]) AS CustomerCount,
    SUM(sales) AS TotalSales
FROM  [Depi_Project].[dbo].[all] 
GROUP BY City
HAVING COUNT([Customer_ID]) < 7 
ORDER BY TotalSales DESC;
--Find the region with the most active customers
SELECT 
    Region,
    COUNT(DISTINCT [Customer_iD]) AS ActiveCustomers
FROM  [Depi_Project].[dbo].[all]    
GROUP BY Region
ORDER BY ActiveCustomers DESC;
*/
--Rank customer segments by average order frequency
WITH CustomerOrders AS (
    SELECT 
        Segment,
        [Customer_ID],
        COUNT([Order_ID]) AS OrderCount
    FROM [Depi_Project].[dbo].[all] 
    GROUP BY Segment, [Customer_ID]
)
SELECT 
    Segment,
    AVG(OrderCount) AS AvgOrderFrequency,
    RANK() OVER (ORDER BY AVG(OrderCount) DESC) AS SegmentRank
FROM CustomerOrders
GROUP BY Segment
ORDER BY SegmentRank;
