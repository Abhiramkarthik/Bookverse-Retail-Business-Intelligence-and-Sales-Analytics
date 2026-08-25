-- 1.Identifying customers who have placed multiple orders

-- Tables Required: Customers, Orders

-- Relevant Columns: Customer_ID, Name (from Customers); Order_ID (from Orders)

-- Relationships: The tables are connected via the Customer_ID foreign key.

-- Logical Flow: You would group the records by the customer and count the number of unique order IDs associated with them. Then, filter to show only those with a count greater than one.

-- 2. Identifying which books have sold the highest number of copies

-- Tables Required: Books, Orders

-- Relevant Columns: Book_ID, Title (from Books); Quantity (from Orders)

-- Relationships: The tables are connected via the Book_ID foreign key.

-- Logical Flow: Group the data by book, calculate the sum of the quantities ordered for each, and sort the results in descending order.

-- 3. Comparing customers based on their total purchase amount

-- Tables Required: Customers, Orders

-- Relevant Columns: Customer_ID, Name (from Customers); Total_Amount (from Orders)

-- Relationships: The tables are connected via the Customer_ID foreign key.

-- Logical Flow: Group the data by customer and calculate the sum of the total amounts from their orders. You can then rank them from highest to lowest.

-- 4. Comparing customer purchasing behaviour across different countries

-- Tables Required: Customers, Orders

-- Relevant Columns: Country (from Customers); Total_Amount, Quantity, Order_ID (from Orders)

-- Relationships: The tables are connected via the Customer_ID foreign key.

-- Logical Flow: Group the data by country. You would then calculate aggregated metrics for each country, such as the total revenue, total quantity of books sold, and the number of orders.

-- 5. Identifying which genres generate the highest revenue

-- Tables Required: Books, Orders

-- Relevant Columns: Genre, Book_ID (from Books); Total_Amount (from Orders)

-- Relationships: The tables are connected via the Book_ID foreign key.

-- Logical Flow: Group the data by genre, sum the total amounts from the orders associated with those books, and sort the results in descending order.

-- 6. Identifying books with low stock levels

-- Tables Required: Books

-- Relevant Columns: Book_ID, Title, Stock

-- Relationships: None required.

-- Logical Flow: Query the Books table directly and filter for records where the stock value is below a specific threshold (e.g., less than 10).

-- 7. Understanding whether highly stocked genres also generate high sales

-- Tables Required: Books, Orders

-- Relevant Columns: Genre, Stock (from Books); Total_Amount or Quantity (from Orders)

-- Relationships: The tables are connected via the Book_ID foreign key.

-- Logical Flow: Group the data by genre and calculate both the total stock available and the total sales (either by quantity or revenue). Compare these two aggregated metrics for each genre.

-- 8. Identifying books that have never been purchased

-- Tables Required: Books, Orders

-- Relevant Columns: Book_ID, Title (from Books); Book_ID (from Orders)

-- Relationships: Connect the tables using a Left Join on Book_ID (from Books to Orders).

-- Logical Flow: Match all books to the orders table and filter for the books that have a NULL value for the order records, indicating no associated transactions.

-- 9. Comparing sales performance across different years and months

-- Tables Required: Orders

-- Relevant Columns: Order_Date, Total_Amount, Quantity

-- Relationships: None strictly required.

-- Logical Flow: Extract the year and month from the order dates. Group the data by these time periods and calculate the total revenue and total volume sold for each period.

-- 10. Identifying customers who have purchased books from multiple genres

-- Tables Required: Customers, Orders, Books

-- Relevant Columns: Customer_ID, Name (from Customers); Genre (from Books)

-- Relationships: Connect Customers to Orders via Customer_ID, and connect Orders to Books via Book_ID.

-- Logical Flow: Group the data by customer, perform a distinct count on the genres associated with their orders, and filter for customers where this distinct count is greater than one.

-- Sprint 2: Database Setup
-- 2.1 Design the Database from the ER Diagram
-- Using the provided ER diagram as the blueprint, create the database and tables in MySQL.

-- 2.2 Database Creation

CREATE DATABASE  bookverse_retail;
USE bookverse_retail;
-- 2.1 tables
-- 1. Books 
CREATE TABLE Books (
    Book_ID         INT PRIMARY KEY,
    Title           VARCHAR(100) NOT NULL,
    Author          VARCHAR(50)  NOT NULL,
    Genre           VARCHAR(30)  NOT NULL,
    Published_Year  INT        NOT NULL,
    Price           DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    Stock           INT          NOT NULL DEFAULT 0
);

-- 2. Customers 
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name        VARCHAR(50)  NOT NULL,
    Email       VARCHAR(60)  NOT NULL UNIQUE,
    Phone       VARCHAR(15)  NOT NULL UNIQUE,
    City        VARCHAR(40)  NOT NULL,
    Country     VARCHAR(60)  NOT NULL
);

-- 3. Orders 
CREATE TABLE Orders (
    Order_ID      INT PRIMARY KEY,
    Customer_ID   INT NOT NULL,
    Book_ID       INT NOT NULL,
    Order_Date    DATE NOT NULL,
    Quantity      INT NOT NULL DEFAULT 1,
    Total_Amount  DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),
    CONSTRAINT fk_orders_book FOREIGN KEY (Book_ID)
        REFERENCES Books(Book_ID)
);

-- 2.4 Data Import

-- 1. Number of records
SELECT 'Books' AS Table_Name, COUNT(*) AS Record_Count FROM Books
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;

-- 2. Column data types
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bookverse_retail'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 3. Missing values
SELECT * FROM Books
WHERE Title IS NULL OR Author IS NULL OR Genre IS NULL
   OR Published_Year IS NULL OR Price IS NULL OR Stock IS NULL;

SELECT * FROM Customers
WHERE Name IS NULL OR Email IS NULL OR Phone IS NULL
   OR City IS NULL OR Country IS NULL;

SELECT * FROM Orders
WHERE Customer_ID IS NULL OR Book_ID IS NULL OR Order_Date IS NULL
   OR Quantity IS NULL OR Total_Amount IS NULL;
   
-- 4. Duplicate records

-- Duplicate PKs
SELECT Book_ID, COUNT(*) FROM Books GROUP BY Book_ID HAVING COUNT(*) > 1;
SELECT Customer_ID, COUNT(*) FROM Customers GROUP BY Customer_ID HAVING COUNT(*) > 1;
SELECT Order_ID, COUNT(*) FROM Orders GROUP BY Order_ID HAVING COUNT(*) > 1;

-- Duplicate content (e.g. same title+author, or same email)
SELECT Title, Author, COUNT(*) FROM Books GROUP BY Title, Author HAVING COUNT(*) > 1;
SELECT Email, COUNT(*) FROM Customers GROUP BY Email HAVING COUNT(*) > 1;
SELECT Phone, COUNT(*) FROM Customers GROUP BY Phone HAVING COUNT(*) > 1;

-- 5. Primary key uniqueness
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT Book_ID) AS unique_ids FROM Books;
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT Customer_ID) AS unique_ids FROM Customers;
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT Order_ID) AS unique_ids FROM Orders;

-- 6. Foreign key consistency
-- Orders referencing a Customer_ID that doesn't exist
SELECT o.* FROM Orders o
LEFT JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- Orders referencing a Book_ID that doesn't exist
SELECT o.* FROM Orders o
LEFT JOIN Books b ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

-- 7. Imported data matches the provided datasets
-- Aggregate check for Books
SELECT COUNT(*) AS rowss, SUM(Price) AS total_price, SUM(Stock) AS total_stock,
       MIN(Published_Year) AS min_year, MAX(Published_Year) AS max_year
FROM Books;

-- Aggregate check for Customers
SELECT COUNT(*) AS rowss, COUNT(DISTINCT Country) AS distinct_countries
FROM Customers;

-- Aggregate check for Orders
SELECT COUNT(*) AS rowss, SUM(Quantity) AS total_qty, SUM(Total_Amount) AS total_revenue,
       MIN(Order_Date) AS earliest, MAX(Order_Date) AS latest
FROM Orders;


-- Sprint 3: Basic Analysis / Data Exploration
-- Write SQL queries to become familiar with the BookVerse database before moving into objective-based analysis.

-- 1. Total number of books
SELECT COUNT(*) AS Total_Books FROM Books;

-- 2.What is the total number of customers?
SELECT COUNT(*) AS Total_Customers FROM Customers;

-- 3. Total number of orders
SELECT COUNT(*) AS Total_Orders FROM Orders;

-- 4.Different genres available
SELECT DISTINCT Genre FROM Books ORDER BY Genre;

-- 5. Different countries represented in customer data
SELECT DISTINCT Country FROM Customers ORDER BY Country;

-- 6. Total quantity of books sold
SELECT SUM(Quantity) AS Total_Quantity_Sold FROM Orders;

-- 7. Total revenue generated
SELECT SUM(Total_Amount) AS Total_Revenue FROM Orders;

-- 8. Average order value
SELECT AVG(Total_Amount) AS Average_Order_Value FROM Orders;

-- Sprint 4: Objective-Based Business Analysis
-- 4.1 — understand  Sales Performance
-- Business Objective
-- The Sales team wants to understand overall sales performance and identify the books, authors, and genres that contribute most to revenue.

-- Order volume & totals
SELECT COUNT(*) AS Total_Orders, SUM(Quantity) AS Total_Qty, SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- Top 5 books by revenue
SELECT b.Title, SUM(o.Total_Amount) AS Revenue
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title ORDER BY Revenue DESC LIMIT 5;

-- Top 5 books by quantity sold
SELECT b.Title, SUM(o.Quantity) AS Qty_Sold
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title ORDER BY Qty_Sold DESC LIMIT 5;

-- Top authors by revenue
SELECT b.Author, SUM(o.Total_Amount) AS Revenue
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author ORDER BY Revenue DESC LIMIT 5;

-- Revenue by genre
SELECT b.Genre, SUM(o.Total_Amount) AS Revenue
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre ORDER BY Revenue DESC;

-- Yearly trend
SELECT YEAR(Order_Date) AS Yr, SUM(Total_Amount) AS Revenue
FROM Orders GROUP BY Yr ORDER BY Yr;

-- Monthly trend
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Month, SUM(Total_Amount) AS Revenue
FROM Orders GROUP BY Month ORDER BY Month;
-- Results / insights:

-- Revenue by genre: Romance (₹13,087) and Mystery (₹12,788) lead; Fiction is lowest (₹7,271) despite genre being one of the largest catalogs — worth flagging as underperforming relative to shelf space.
-- Yearly trend: 2023 (₹36,340) and 2024 (₹36,775) are almost flat year-over-year — no real growth, a useful thing to call out to management.
-- Monthly trend shows volatility (e.g. Jan 2024 spikes to ₹4,905, June 2024 dips to ₹2,048) — worth investigating seasonality.
-- 2022 only has partial data (Dec only, ₹2,513) since the dataset starts December 2022 — mention this as a data limitation, not a real decline.

-- 4.2 Understand Customer Purchasing Behaviour
-- The Marketing team wants to understand how customers interact with BookVerse and identify valuable and highly active customers.

-- Orders per customer
SELECT Customer_ID, COUNT(*) AS Order_Count
FROM Orders GROUP BY Customer_ID ORDER BY Order_Count DESC;

-- Repeat customers (placed more than 1 order)
SELECT COUNT(*) AS Repeat_Customers FROM (
    SELECT Customer_ID FROM Orders GROUP BY Customer_ID HAVING COUNT(*) > 1
) t;

-- Top 5 customers by total spend
SELECT c.Name, SUM(o.Total_Amount) AS Total_Spend
FROM Orders o JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name ORDER BY Total_Spend DESC LIMIT 5;

-- Average spend per customer
SELECT AVG(Customer_Total) AS Avg_Spend FROM (
    SELECT Customer_ID, SUM(Total_Amount) AS Customer_Total
    FROM Orders GROUP BY Customer_ID
) t;

-- Revenue by country
SELECT c.Country, SUM(o.Total_Amount) AS Revenue
FROM Orders o JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Country ORDER BY Revenue DESC LIMIT 10;

-- Customers purchasing across multiple genres
SELECT o.Customer_ID, COUNT(DISTINCT b.Genre) AS Genre_Count
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Customer_ID HAVING Genre_Count > 1
ORDER BY Genre_Count DESC;

-- Results / insights:

-- 139 of 500 customers (28%) are repeat buyers, ordering up to 6 times — this is your most loyal base and a strong retention/loyalty-program candidate.
-- Average customer spend is ₹246.35; the top customer (Kim Turner) spent ₹1,398.90 — over 5x the average, worth flagging as a VIP.
-- 123 customers (25%) bought across multiple genres (up to 4 distinct genres) — cross-genre buyers, good targets for genre-based upsell campaigns.
-- Revenue is extremely spread across 215 countries with no single dominant market (top country is only ~₹1,399) — the customer base is highly international/fragmented rather than concentrated.

-- 4.3 — Product and Genre Performance
-- Business Objective
-- The management team wants to understand how different books, authors, and genres are performing in the marketplace.


-- Books never ordered
SELECT b.Book_ID, b.Title
FROM Books b LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
WHERE o.Order_ID IS NULL;

-- Books with low sales (qty <= 2)
SELECT b.Title, COALESCE(SUM(o.Quantity),0) AS Qty_Sold
FROM Books b LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title HAVING Qty_Sold <= 2 ORDER BY Qty_Sold;

-- Highest priced books
SELECT Title, Price FROM Books ORDER BY Price DESC LIMIT 5;

-- Genre-wise quantity and revenue
SELECT b.Genre, SUM(o.Quantity) AS Qty_Sold, SUM(o.Total_Amount) AS Revenue
FROM Orders o JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre ORDER BY Revenue DESC;

-- Price vs sales relationship (avg price of high-sellers vs low-sellers)
SELECT b.Title, b.Price, SUM(o.Quantity) AS Qty_Sold
FROM Books b LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Price ORDER BY Qty_Sold DESC;
-- Results / insights:

-- 183 of 500 books (37%) have never been ordered at all — a significant chunk of dead catalog. This is one of the biggest actionable findings.
-- 42 books have very low sales (≤2 units total) — combined with the 183 unordered, over 44% of the catalog is essentially non-performing.
-- Price and quantity sold show almost no correlation (0.045) — pricing is not the reason certain books underperform, which suggests the issue is discoverability, marketing, or genre demand rather than price sensitivity.

-- 4.4 Understand Inventory Position
-- Business Objective
-- The Operations team wants to understand the current inventory position and identify products that may require attention before the next procurement cycle.


-- Total stock and inventory value
SELECT SUM(Stock) AS Total_Stock, SUM(Price * Stock) AS Total_Inventory_Value FROM Books;

-- Low stock books
SELECT Title, Stock FROM Books WHERE Stock < 20 ORDER BY Stock ASC;

-- Inventory value by genre
SELECT Genre, SUM(Price * Stock) AS Inventory_Value
FROM Books GROUP BY Genre ORDER BY Inventory_Value DESC;

-- High stock but low/no sales (overstocked, slow-moving)
SELECT b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Qty_Sold
FROM Books b LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Stock
HAVING b.Stock > 70 AND Qty_Sold <= 2
ORDER BY b.Stock DESC;

-- Low stock but high sales (at risk of stockout)
SELECT b.Title, b.Stock, SUM(o.Quantity) AS Qty_Sold
FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Stock
HAVING b.Stock < 20 AND Qty_Sold >= 10
ORDER BY Qty_Sold DESC;

-- Results / insights:

-- Total inventory across all books: 25,056 units, worth ₹684,644.
-- 101 books (20%) are already at low stock (<20 units) — a sizeable chunk needs replenishment review.
-- 66 books are overstocked and barely selling (stock > 70, sold ≤2 units) — tied-up capital that should be candidates for discounting or clearance.
-- 25 books are in the opposite, riskier position — low stock but high demand (e.g. "Networked contextually-based encryption" has just 1 unit left but sold 11; "Total explicit open architecture" has 7 units left but sold 19). These are prime restock-urgently candidates — you're at real risk of stockouts on your best sellers.
-- By genre, Science Fiction holds the highest inventory value (₹112,746) despite not being the top revenue generator — worth comparing stock allocation against actual genre demand

-- 4.5 Identify Sales and Inventory Opportunities
-- Business Objective
-- Management wants to identify potential business opportunities by combining sales performance, customer behaviour, and current inventory information.

-- High-selling, low-stock books = urgent restock priority
SELECT b.Title, b.Genre, b.Stock, SUM(o.Quantity) AS Qty_Sold, SUM(o.Total_Amount) AS Revenue
FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Genre, b.Stock
HAVING b.Stock < 20 AND Qty_Sold >= 10
ORDER BY Qty_Sold DESC;

-- Overstocked, low-selling books = promotional/clearance candidates
SELECT b.Title, b.Genre, b.Stock, COALESCE(SUM(o.Quantity),0) AS Qty_Sold
FROM Books b LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Genre, b.Stock
HAVING b.Stock > 70 AND Qty_Sold <= 2
ORDER BY b.Stock DESC;

-- Popular genres (by revenue) vs their current stock allocation
SELECT b.Genre,
       SUM(b.Stock) AS Current_Stock,
       (SELECT SUM(o2.Total_Amount) FROM Orders o2 JOIN Books b2 ON o2.Book_ID=b2.Book_ID WHERE b2.Genre = b.Genre) AS Genre_Revenue
FROM Books b
GROUP BY b.Genre;

-- High-value customers to target for promotions
SELECT c.Name, c.Country, SUM(o.Total_Amount) AS Total_Spend, COUNT(*) AS Orders
FROM Orders o JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name, c.Country
HAVING Total_Spend > 500
ORDER BY Total_Spend DESC;

-- Recommendations for management (tie it all together):

-- Restock immediately: the 25 low-stock/high-demand books — these are actively losing potential sales.
-- Run clearance/discount promotions on the 66 overstocked slow-movers to free up capital and shelf space.
-- Investigate the 183 never-ordered books — consider delisting, bundling, or promoting them; that's over a third of the catalog generating zero return.
-- Double down on Romance and Mystery genres (highest revenue) in marketing and possibly increase their stock
-- Target the 139 repeat customers and 123 multi-genre buyers with loyalty offers — they're your most engaged segment and most likely to respond to cross-sell.
