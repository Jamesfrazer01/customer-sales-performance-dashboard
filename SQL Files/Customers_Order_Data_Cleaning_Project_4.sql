SELECT *
FROM orders;

CREATE TABLE Orders_Staging1
LIKE orders;

INSERT Orders_Staging1
SELECT *
FROM orders;

SELECT *
FROM Orders_Staging1;

CREATE TABLE Orders_Staging1_Test_Table
LIKE orders;

INSERT Orders_Staging1_Test_Table
SELECT *
FROM orders;

DELETE
FROM Orders_Staging1_Test_Table
WHERE `Date:` = 'Date:' OR `Date:` = 'Time'
OR `Date:` = 'Order ID'
;

UPDATE orders_staging1_test_table
SET `Date:` = NULL
WHERE `Date:` = ''
;

UPDATE orders_staging1_test_table
SET `28/9/2023` = NULL
WHERE `28/9/2023` = ''
;

SELECT DISTINCT `Date:`
FROM orders_staging1_test_table
;

SELECT *
FROM orders_staging1_test_table
;


ALTER TABLE orders_staging1_test_table
CHANGE `Date:` Order_ID INT,
CHANGE `28/9/2023` Order_Date DATE,
CHANGE `MyUnknownColumn` Country varchar(50),
CHANGE `MyUnknownColumn_[0]` City varchar(50),
CHANGE `MyUnknownColumn_[1]` Branch varchar(10),
CHANGE `MyUnknownColumn_[2]` Latitude DECIMAL(10, 4),
CHANGE `MyUnknownColumn_[3]` Longitude DECIMAL(10, 4),
CHANGE `MyUnknownColumn_[4]` Customer_First_Name varchar(50),
CHANGE `MyUnknownColumn_[5]` Customer_Last_Name varchar(50),
CHANGE `MyUnknownColumn_[6]` Email varchar(50),
CHANGE `MyUnknownColumn_[7]` Phone_Number varchar(20),
CHANGE `MyUnknownColumn_[8]` Category varchar(50),
CHANGE `MyUnknownColumn_[9]` Sub_Category varchar(50),
CHANGE `MyUnknownColumn_[10]` Item varchar(100),
CHANGE `MyUnknownColumn_[11]` Sales_Person_ID varchar(10),
CHANGE `MyUnknownColumn_[12]` Quantity INT,
CHANGE `MyUnknownColumn_[13]` Unit_Price INT,
CHANGE `MyUnknownColumn_[14]` Discount DECIMAL(10, 2),
CHANGE `MyUnknownColumn_[15]` Transaction_Status varchar(50)
;



CREATE TABLE orders_staging1_test_table1
LIKE orders;


INSERT orders_staging1_test_table1
SELECT *
FROM orders;


SELECT *
FROM orders_staging1;




ALTER TABLE orders_staging1
RENAME COLUMN `Date:` TO Order_ID;

ALTER TABLE orders_staging1
RENAME COLUMN `28/9/2023` TO Order_Date; 

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn` TO Country; 

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[0]` TO City;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[1]` TO Branch;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[2]` TO Latitude;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[3]` TO Longitude;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[4]` TO Customer_First_Name;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[5]` TO Customer_Last_Name;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[6]` TO Email;  

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[7]` TO Phone_Number;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[8]` TO Category;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[9]` TO Sub_Category;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[10]` TO Item;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[11]` TO Sales_Person_ID;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[12]` TO Quantity;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[13]` TO Unit_Price;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[14]` TO Discount;

ALTER TABLE orders_staging1
RENAME COLUMN `MyUnknownColumn_[15]` TO Transaction_Status;


DELETE
FROM Orders_Staging1
WHERE Order_ID = 'Date:' OR Order_ID = 'Time'
OR Order_ID = 'Order ID'
;

SELECT *
FROM Orders_Staging1;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Order_ID, Order_Date, Country, City, 
Branch, Latitude, Longitude, Customer_First_Name, Customer_Last_Name,
Email, Phone_Number, Category, Sub_Category, Item, Sales_Person_ID,
Quantity, Unit_Price, Discount, Transaction_Status) AS Row_Num
FROM Orders_Staging1
;


WITH CTE_Duplicate AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Order_ID, Order_Date, Country, City, 
Branch, Latitude, Longitude, Customer_First_Name, Customer_Last_Name,
Email, Phone_Number, Category, Sub_Category, Item, Sales_Person_ID,
Quantity, Unit_Price, Discount, Transaction_Status) AS Row_Num
FROM Orders_Staging1
)
SELECT *
FROM CTE_Duplicate
WHERE Row_Num > 1
;

CREATE TABLE `orders_staging2` (
  `Order_ID` text,
  `Order_Date` text,
  `Country` text,
  `City` text,
  `Branch` text,
  `Latitude` text,
  `Longitude` text,
  `Customer_First_Name` text,
  `Customer_Last_Name` text,
  `Email` text,
  `Phone_Number` text,
  `Category` text,
  `Sub_Category` text,
  `Item` text,
  `Sales_Person_ID` text,
  `Quantity` text,
  `Unit_Price` text,
  `Discount` text,
  `Transaction_Status` text,
  `Row_Num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM orders_staging2
WHERE Row_Num > 1
;

INSERT INTO orders_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Order_ID, Order_Date, Country, City, 
Branch, Latitude, Longitude, Customer_First_Name, Customer_Last_Name,
Email, Phone_Number, Category, Sub_Category, Item, Sales_Person_ID,
Quantity, Unit_Price, Discount, Transaction_Status) AS Row_Num
FROM Orders_Staging1
;

DELETE 
FROM orders_staging2
WHERE Row_Num > 1
;

SELECT *
FROM orders_staging2_holding1;

CREATE TABLE orders_staging2_Holding1
LIKE orders_staging2;

INSERT orders_staging2_Holding1
SELECT *
FROM orders_staging2;

SELECT *
FROM orders_staging2;

SELECT DISTINCT Email, UPPER(REPLACE(Email, '@', '@g')), REPLACE(Email, ' ', ''), LOWER(REPLACE(Email, ' ', '.'))
FROM orders_staging2
WHERE Email LIKE '% %'
;

SELECT Order_ID, MAX(Order_ID), MIN(Order_ID)
FROM orders_staging2
GROUP BY Order_ID
ORDER BY 1 DESC
;

SELECT DISTINCT Order_ID
FROM orders_staging2
WHERE Order_ID IS NULL
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Order_ID = NULL
WHERE Order_ID = ''
;

SELECT DISTINCT Order_ID
FROM orders_staging2
ORDER BY 1 ASC
;

ALTER TABLE orders_staging2
MODIFY COLUMN Order_ID INT
;

CREATE TABLE orders_staging2_holding2
LIKE orders_staging2
;

INSERT orders_staging2_holding2
SELECT *
FROM orders_staging2
;

SELECT Order_ID
FROM orders_staging2_holding2
ORDER BY 1 
;

UPDATE orders_staging2
SET Order_ID = TRIM(Order_ID)
;

SELECT *
FROM orders_staging2_holding2;

SELECT DISTINCT Order_Date
FROM orders_staging2
;

UPDATE orders_staging2
SET Order_Date = NULL
WHERE Order_Date = ''
;


SELECT Order_Date, STR_TO_DATE(Order_Date, '%d/%m/%Y')
FROM orders_staging2
;

UPDATE orders_staging2
SET Order_Date = STR_TO_DATE(Order_Date, '%d/%m/%Y')
;

ALTER TABLE orders_staging2
MODIFY COLUMN Order_Date DATE;

UPDATE orders_staging2
SET Order_Date = TRIM(Order_Date);

SELECT *
FROM orders_staging2;

CREATE TABLE orders_staging2_holding3
LIKE orders_staging2
;

INSERT orders_staging2_holding3
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Country
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Country = NULL
WHERE Country = ''
;

SELECT DISTINCT Country,
CASE
	WHEN TRIM(UPPER(Country)) = 'USA' THEN 'United States'
    ELSE Country
END AS New_Country
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Country = 'United States'
WHERE TRIM(UPPER(Country)) = 'USA'
;

UPDATE orders_staging2
SET Country = TRIM(Country);

SELECT *
FROM orders_staging2_holding4;

CREATE TABLE orders_staging2_holding4
LIKE orders_staging2
;

INSERT orders_staging2_holding4
SELECT *
FROM orders_staging2
;

SELECT DISTINCT City, UPPER(LEFT(City, 1)), LOWER(SUBSTRING(City, 2)), 
CONCAT(UPPER(LEFT(City, 1)), LOWER(SUBSTRING(City, 2)))
FROM orders_staging2;

UPDATE orders_staging2
SET City = CONCAT(UPPER(LEFT(City, 1)), LOWER(SUBSTRING(City, 2)));

SELECT DISTINCT City, LEFT(City, 3), UPPER(SUBSTRING(City, 5, 1)), LOWER(SUBSTRING(City, 6)), 
CONCAT(LEFT(City, 3), ' ', UPPER(SUBSTRING(City, 5, 1)), LOWER(SUBSTRING(City, 6)))
FROM orders_staging2
WHERE City = 'Abu dhabi' OR City = 'Las vegas' OR City = 'New york'
;

UPDATE orders_staging2
SET City = CONCAT(LEFT(City, 3), ' ', UPPER(SUBSTRING(City, 5, 1)), LOWER(SUBSTRING(City, 6)))
WHERE City = 'Abu dhabi' OR City = 'Las vegas' OR City = 'New york'
;

SELECT DISTINCT City
FROM orders_staging2;

UPDATE orders_staging2
SET City = NULL
WHERE City = ''
;


SELECT *
FROM orders_staging2_holding5;

CREATE TABLE orders_staging2_holding5
LIKE orders_staging2
;

INSERT orders_staging2_holding5
SELECT *
FROM orders_staging2
;

SELECT *
FROM orders_staging2;

UPDATE orders_staging2
SET Branch = NULL
WHERE Branch = ''
;

SELECT DISTINCT Branch, City
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Branch = TRIM(Branch)
;

CREATE TABLE orders_staging2_holding6
LIKE orders_staging2
;

INSERT orders_staging2_holding6
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Latitude
FROM orders_staging2
ORDER BY 1 DESC
;

SELECT City , Latitude, COUNT(City)
FROM orders_staging2
GROUP BY City, Latitude
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Latitude = TRIM(Latitude);

UPDATE orders_staging2
SET Latitude = NULL
WHERE Latitude = ''
;

ALTER TABLE orders_staging2
MODIFY COLUMN Latitude DECIMAL(9, 4);

SELECT *
FROM orders_staging2;

SELECT DISTINCT Longitude
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Longitude = NULL
WHERE Longitude = ''
;

UPDATE orders_staging2
SET Longitude = TRIM(Longitude);

SELECT DISTINCT Longitude
FROM orders_staging2
WHERE Longitude LIKE '_______' AND Longitude LIKE '-%'
ORDER BY 1 ASC
;

UPDATE orders_staging2
SET Longitude = CAST(Longitude AS DECIMAL(9, 4))
WHERE Longitude LIKE '_______' AND Longitude LIKE '-%'
;

ALTER TABLE orders_staging2
MODIFY COLUMN Longitude DECIMAL(9, 4)
;

CREATE TABLE orders_staging2_holding7
LIKE orders_staging2
;

INSERT orders_staging2_holding7
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Customer_Last_Name, UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2)),
CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))),
LEFT(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 3),
UPPER(SUBSTRING(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 5, 1)), 
LOWER(RIGHT(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 4)),
CONCAT(LEFT(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 3), ' ', 
UPPER(SUBSTRING(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 5, 1)),
LOWER(RIGHT(CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))), 4))) AS Last_Name
FROM orders_staging2
WHERE Customer_Last_Name LIKE '% %' AND Customer_Last_Name LIKE '_________' AND Customer_Last_Name LIKE '%b%'
;

SELECT *
FROM orders_staging2;

UPDATE orders_staging2
SET Customer_First_Name = NULL
WHERE Customer_First_Name = ''
;


SELECT DISTINCT Customer_First_Name, UPPER(LEFT(Customer_First_Name, 1)), LOWER(SUBSTRING(Customer_First_Name, 2)),
CONCAT(UPPER(LEFT(Customer_First_Name, 1)), LOWER(SUBSTRING(Customer_First_Name, 2))) AS First_Name
FROM orders_staging2
WHERE Customer_First_Name IS NOT NULL
;

UPDATE orders_staging2
SET Customer_First_Name = CONCAT(UPPER(LEFT(Customer_First_Name, 1)), LOWER(SUBSTRING(Customer_First_Name, 2)))
WHERE Customer_First_Name IS NOT NULL
;

UPDATE orders_staging2
SET Customer_First_Name = TRIM(Customer_First_Name)
;

SELECT *
FROM orders_staging2;

UPDATE orders_staging2
SET Customer_Last_Name = NULL
WHERE Customer_Last_Name = ''
;

SELECT DISTINCT Customer_Last_Name
FROM orders_staging2;


SELECT DISTINCT Customer_Last_Name, UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2)),
CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2))) AS Last_Name
FROM orders_staging2
WHERE Customer_Last_Name IS NOT NULL
;


SELECT *
FROM orders_staging2;

UPDATE orders_staging2
SET Customer_Last_Name = CONCAT(UPPER(LEFT(Customer_Last_Name, 1)), LOWER(SUBSTRING(Customer_Last_Name, 2)))
WHERE Customer_Last_Name IS NOT NULL
;

UPDATE orders_staging2
SET Customer_Last_Name = TRIM(Customer_Last_Name)
;

UPDATE orders_staging2
SET Email = NULL
WHERE Email = ''
;


SELECT DISTINCT Email, REPLACE(LOWER(Email), ' ', '.')
FROM orders_staging2
;

UPDATE orders_staging2
SET Email = REPLACE(LOWER(Email), ' ', '.')
;

SELECT DISTINCT Email
FROM orders_staging2
;

UPDATE orders_staging2
SET Email = TRIM(Email)
;

SELECT Customer_First_Name, Customer_Last_Name, Email
FROM orders_staging2
WHERE LOWER(Email) NOT LIKE 
LOWER(CONCAT(REPLACE(Customer_First_Name, ' ', '.'), '.', REPLACE(Customer_Last_Name, ' ', '.'), '%'))
;

SELECT *
FROM orders_staging2;

SELECT *
FROM orders_staging2
;

SELECT *
FROM orders_staging2_holding8
;

CREATE TABLE orders_staging2_holding8
LIKE orders_staging2
;

INSERT orders_staging2_holding8
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Phone_Number, TRIM(REPLACE(Phone_Number, 'Tel:', '')), 
RIGHT(Phone_Number, 10), LENGTH(Phone_Number), 
TRIM(CONCAT(SUBSTRING(Phone_Number, 5, 1), 
SUBSTRING(Phone_Number, 6))), SUBSTRING(Phone_Number, 6), RIGHT(REPLACE(Phone_Number, 'Tel:', ''), 10)
FROM orders_staging2
;

SELECT DISTINCT Phone_Number
FROM orders_staging2
;

UPDATE orders_staging2
SET Phone_Number = NULL
WHERE Phone_Number = ''
;

UPDATE orders_staging2
SET Phone_Number = RIGHT(REPLACE(Phone_Number, 'Tel:', ''), 10)
WHERE Phone_Number IS NOT NULL
;

UPDATE orders_staging2
SET Phone_Number = TRIM(Phone_Number);

SELECT *
FROM orders_staging2
;

SELECT DISTINCT Category
FROM orders_staging2;

UPDATE orders_staging2
SET Category = NULL
WHERE Category = ''
;

UPDATE orders_staging2
SET Category = TRIM(Category);

CREATE TABLE orders_staging2_holding9
LIKE orders_staging2
;

INSERT orders_staging2_holding9
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Sub_Category
FROM orders_staging2
WHERE Sub_Category LIKE 'l%'
ORDER BY 1 DESC
;

SELECT DISTINCT Sub_Category
FROM orders_staging2
WHERE Sub_Category LIKE '%'
;

UPDATE orders_staging2
SET Sub_Category = NULL
WHERE Sub_Category = ''
;

UPDATE orders_staging2
SET Sub_Category = TRIM(Sub_Category)
;

SELECT DISTINCT Item
FROM orders_staging2
;

SELECT DISTINCT Item, TRIM(TRAILING '"' FROM Item)
FROM orders_staging2
WHERE Item LIKE '%(5th Gen)"'
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Item = TRIM(TRAILING '"' FROM Item)
WHERE Item LIKE '%(5th Gen)"'
;

UPDATE orders_staging2
SET Item = REPLACE(Item, '" "', '"')
WHERE Item LIKE '%" "'
;

UPDATE orders_staging2
SET Item = REPLACE(Item, '""', '"')
WHERE Item LIKE '%""'
;

UPDATE orders_staging2
SET Item = REPLACE(Item, '  ', ' ')
WHERE Item LIKE '%  %'
;

UPDATE orders_staging2
SET Item = TRIM(Item)
;

UPDATE orders_staging2
SET Item = NULL
WHERE Item = ''
;

SELECT *
FROM orders_staging2
;

CREATE TABLE orders_staging2_holding10
LIKE orders_staging2
;

INSERT orders_staging2_holding10
SELECT *
FROM orders_staging2
;

SELECT DISTINCT Sales_Person_ID
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Sales_Person_ID = NULL
WHERE Sales_Person_ID = ''
;

UPDATE orders_staging2
SET Sales_Person_ID = TRIM(Sales_Person_ID)
;

SELECT DISTINCT Phone_Number, LEFT(Phone_Number, 3), RIGHT(Phone_Number, 7),
CONCAT('+(', LEFT(Phone_Number, 3), ')', '-', SUBSTRING(Phone_Number, 4, 4), '-', RIGHT(Phone_Number, 3))
FROM orders_staging2
;

SELECT DISTINCT Quantity
FROM orders_staging2
WHERE Quantity LIKE ' %'
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Quantity = TRIM(Quantity)
;

UPDATE orders_staging2
SET Quantity = NULL
WHERE Quantity = ''
;

SELECT DISTINCT Quantity
FROM orders_staging2
ORDER BY 1 DESC
;

ALTER TABLE orders_staging2
MODIFY COLUMN Quantity INT;

SELECT DISTINCT Unit_Price
FROM orders_staging2
ORDER BY 1 ASC
;

UPDATE orders_staging2
SET Unit_Price = TRIM(Unit_Price)
;

UPDATE orders_staging2
SET Unit_Price = NULL
WHERE Unit_Price = ''
;

ALTER TABLE orders_staging2
MODIFY COLUMN Unit_Price INT;

SELECT DISTINCT Discount, CAST(Discount AS DECIMAL(10, 2))
FROM orders_staging2
ORDER BY 2 DESC
;

UPDATE orders_staging2
SET Discount = NULL
WHERE Discount = ''
;

SELECT MAX(Discount), MIN(Discount)
FROM orders_staging2;

UPDATE orders_staging2
SET Discount = CAST(Discount AS DECIMAL(10, 2))
;

SELECT DISTINCT Discount
FROM orders_staging2
ORDER BY 1 ASC
;

ALTER TABLE orders_staging2
MODIFY COLUMN Discount DECIMAL(10, 2)
;

SELECT DISTINCT Transaction_Status
FROM orders_staging2
ORDER BY 1 DESC
;

UPDATE orders_staging2
SET Transaction_Status = NULL
WHERE Transaction_Status = ''
;

UPDATE orders_staging2
SET Transaction_Status = TRIM(Transaction_Status)
;

CREATE TABLE orders_staging2_holding11
LIKE orders_staging2
;

INSERT orders_staging2_holding11
SELECT *
FROM orders_staging2
;

SELECT *
FROM orders_staging2_holding11
;

SELECT *
FROM orders_staging2
WHERE Order_ID IS NULL
;

DELETE 
FROM orders_staging2_holding11
WHERE Order_ID IS NULL
;

DELETE 
FROM orders_staging2
WHERE Order_ID IS NULL
;

SELECT *
FROM orders_staging2
;

ALTER TABLE orders_staging2
DROP COLUMN Row_Num;

ALTER TABLE orders_staging2_holding11
DROP COLUMN Row_Num;

SELECT *
FROM orders_staging2
;