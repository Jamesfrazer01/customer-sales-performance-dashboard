#note that revenue was calculated as gross revenue using unit price and quantity 
#because the discount column wasnt clear enough to get the net revenue.

SELECT *
FROM orders_staging2
;

SELECT MAX(Unit_Price), MIN(Unit_Price), MAX(Discount), MIN(Discount)
FROM orders_staging2
;

SELECT Unit_Price, Quantity, Unit_Price * Quantity AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
ORDER BY 3 DESC
;

WITH CTE_Sum_Gross_Revenue AS
(
SELECT Unit_Price, Quantity, Unit_Price * Quantity AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
ORDER BY 3 DESC
)
SELECT SUM(Gross_Revenue) AS Total_Gross_Revenue
FROM CTE_Sum_Gross_Revenue 
;
# Total Gross Revenue is 16523060 


SELECT COUNT(DISTINCT Order_ID) AS Total_True_Orders
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
;
# Total True Orders = 14013


SELECT COUNT(DISTINCT Order_ID) AS Total_False_Orders
FROM orders_staging2
WHERE Transaction_Status = 'FALSE'
;
# Total True Orders = 5987


SELECT SUM(Unit_Price * Quantity) / COUNT(DISTINCT Order_ID) AS Avg_Order_Value
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
;
# Avg Order Value is 1179.1237


SELECT Category, SUM(Unit_Price * Quantity) AS Revenue_By_Category
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Category
ORDER BY 2 DESC
;
# revenue by category breakdown with laptop highest - 4281728


SELECT Sub_Category, SUM(Unit_Price * Quantity) AS Revenue_By_Sub_Category
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Sub_Category
ORDER BY 2 DESC
;
# revenue by sub category breakdown with ASUS ROG highest - 1093568


SELECT Item, SUM(Quantity) AS Total_Quantity_Sold
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Item
ORDER BY 2 DESC
LIMIT 10
;
# This shows the top 10 selling item or items with xps 13 selling 235 times


SELECT Item, SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Item
ORDER BY 2 DESC
LIMIT 10
;
# This shows the top 10 item or items with highest revenue generation with Canon EOS R5 topping


SELECT Country, SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Country
ORDER BY 2 DESC
;
# above shows revenue by country with saudi arabia at the top with 5065732


SELECT City, SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY City
ORDER BY 2 DESC
;
# above shows revenue by city with jeddah at the top with 2584797


SELECT Branch, 
SUM(Unit_Price * Quantity) AS Gross_Revenue, COUNT(Order_ID) AS Total_Orders
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Branch
ORDER BY 2 DESC
;
# above shows branch performance by revenue and total units sold. lv01 was highest


SELECT Sales_Person_ID,
SUM(Unit_Price * Quantity) AS Gross_Revenue,
SUM(Quantity) AS Total_Item_Sold,
COUNT(Order_ID) AS Number_Of_Orders_Handled
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Sales_Person_ID
ORDER BY 4 DESC
;
# above shows sales person performance by revenue, item sold and orders handled


SELECT MONTH(Order_Date), SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY MONTH(Order_Date)
ORDER BY 2 DESC
;
# above gives the monthly gross revenue sales trend. May with the highest revenue


SELECT DAY(Order_Date), SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY DAY(Order_Date)
ORDER BY 2 DESC
;
# GROSS revenue by day with day 24 highest


SELECT YEAR(Order_Date), SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY YEAR(Order_Date)
ORDER BY 2 DESC
;
# 16523060 gross revenue was recorded in 2023


SELECT YEAR(Order_Date), MONTH(Order_Date), SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY 2 DESC
;

WITH CTE_Revenue_Total_Ranking_By_Month AS
(
SELECT YEAR(Order_Date) AS Order_Year, MONTH(Order_Date) AS Order_Month, SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT *,
DENSE_RANK() OVER(PARTITION BY Order_Year ORDER BY Gross_Revenue DESC) AS Gross_Revenue_Rank
FROM CTE_Revenue_Total_Ranking_By_Month
;
# ranking gross revenue by month from highest to lowest


WITH CTE_Revenue_Rolling_Total AS
(
SELECT YEAR(Order_Date) AS Order_Year, MONTH(Order_Date) AS Order_Month, SUM(Unit_Price * Quantity) AS Gross_Revenue
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT *,
SUM(Gross_Revenue) OVER(PARTITION BY Order_Year ORDER BY Gross_Revenue DESC) AS Gross_Revenue_Rolling_Total
FROM CTE_Revenue_Rolling_Total
;
#rolling total for gross revenue by month


SELECT Order_Date, COUNT(Order_ID) AS Total_True_Orders
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Order_Date
ORDER BY 2 DESC 
;
#total orders per day


SELECT Email, SUM(Unit_Price * Quantity) AS Total_Spent
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Email
ORDER BY 2 DESC
LIMIT 10
;
# TOP 10 customers that spent most


SELECT Country, COUNT(Email) AS Total_Customer
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Country
ORDER BY 2 DESC
;
#total number of customer by country


SELECT Order_ID, SUM(Quantity) AS Quantity_Per_Order
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Order_ID
;

WITH CTE_Average_Quantity_Per_Order AS
(
SELECT Order_ID, SUM(Quantity) AS Quantity_Per_Order
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Order_ID
)
SELECT AVG(Quantity_Per_Order)
FROM CTE_Average_Quantity_Per_Order
;
# Above gives the avg total quantity per order


SELECT SUM(
CASE 
WHEN Transaction_Status = 'TRUE' THEN 1 
ELSE 0 
END) * 100 / COUNT(*) AS Success_Rate_Percent
FROM orders_staging2
;


SELECT Transaction_Status, COUNT(Transaction_Status) AS Number_Of_Transactions
FROM orders_staging2
GROUP BY Transaction_Status
;

WITH CTE_Transaction_Success_Rate AS
(
SELECT Transaction_Status, COUNT(Transaction_Status) AS Number_Of_Transactions
FROM orders_staging2
GROUP BY Transaction_Status
)
SELECT *, (Number_Of_Transactions / 20000) * 100 AS Success_Rate_In_Percent
FROM CTE_Transaction_Success_Rate
WHERE Transaction_Status = 'TRUE'
;
#Success rate for true or successful transactions is 70.1%


SELECT Transaction_Status, COUNT(Transaction_Status) AS Failed_Transactions
FROM orders_staging2
WHERE Transaction_Status = 'False'
GROUP BY Transaction_Status
;
# failed transactions are 5987


SELECT Order_ID, SUM(Unit_Price * Quantity) AS Sales
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Order_ID
ORDER BY 2 DESC
LIMIT 10
;
#top 10 orders with largest sales


SELECT Category, SUM(Quantity) AS Quantity_Sold
FROM orders_staging2
WHERE Transaction_Status = 'TRUE'
GROUP BY Category
ORDER BY 2 DESC
;
#Quantity of items sold in each category