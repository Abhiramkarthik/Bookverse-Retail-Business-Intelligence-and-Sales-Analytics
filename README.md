📚 BookVerse – Retail Business Intelligence & Sales Analytics

📌 Project Overview

BookVerse is a retail business intelligence and sales analytics project built using MySQL and SQL. The project analyzes bookstore data across books, customers, orders, genres, sales, and inventory to generate actionable business insights.

The goal is to transform historical bookstore transactions into meaningful insights that can support better sales decisions, customer engagement, product management, and inventory planning.

🎯 Business Objectives

* Analyze overall sales performance and revenue trends
* Identify high-performing genres and books
* Understand customer purchasing behavior
* Identify repeat and multi-genre customers
* Analyze product and catalog performance
* Detect low-stock and overstocked books
* Identify books that have never been ordered
* Generate data-driven business recommendations

🛠️ Technology Stack

* MySQL
* SQL
* MySQL Workbench
* CSV datasets
* Relational database concepts
* SQL Joins, Aggregations & Grouping

🗃️ Database Structure

The project uses a relational database consisting of three primary tables:

📖 Books

Contains information about the bookstore’s catalog, including:

* Book ID
* Title
* Author
* Genre
* Price
* Stock

👥 Customers

Contains customer information and location details.

🛒 Orders

Stores transaction information and connects customers with books through foreign keys.

🔗 Relationships

Books ───────< Orders >─────── Customers
                 │
                 └── Transaction Data

The Orders table acts as the central transaction table, connecting customers and purchased books.

📊 Dataset

Dataset	Records
Books	500
Customers	500
Orders	500
Genres	7
Countries	215

📈 Key KPIs

Metric	Result
Total Revenue	₹75.63K
Total Orders	500
Quantity Sold	2,697
Average Order Value	₹151.26
Total Stock	25,056 units
Inventory Value	₹684.6K
Repeat Buyers	139
Multi-Genre Buyers	123
Never-Ordered Books	183
Urgent Replenishment Books	25

🔍 Analysis Performed

1. Sales Performance

Analyzed revenue by genre and yearly sales trends.

Key finding: Romance generated the highest revenue at approximately ₹13,087, followed by Mystery at approximately ₹12,788.

Annual revenue was:

* 2022 — ₹2.5K
* 2023 — ₹36.3K
* 2024 — ₹36.8K

2. Customer Purchasing Behavior

Customer-level purchase patterns were analyzed to identify repeat buyers and customers purchasing across multiple genres.

* 139 repeat buyers
* 123 multi-genre buyers
* Highest number of orders by a single customer: 6

These patterns indicate opportunities for customer retention, personalized recommendations, and cross-selling.

3. Product & Genre Performance

The project identifies the best-performing books based on:

* Units sold
* Revenue generated

A major catalog insight was that 183 out of 500 books (36.6%) were never ordered, indicating potential opportunities for promotions, bundling, or catalog rationalization.

4. Inventory Analysis

Inventory was analyzed using stock levels and sales demand.

* 101 books had stock below 20 units
* 25 books had low stock and strong demand
* 66 books had stock above 70 units but sold 2 units or fewer

Science Fiction had the highest inventory value at approximately ₹112.7K.

💡 Business Recommendations

🔄 Restock

Prioritize the 25 high-demand, low-stock books for replenishment.

🏷️ Promote

Discount, bundle, or promote the 66 overstocked slow-moving books to reduce excess inventory.

🎯 Retain & Cross-Sell

Use purchasing patterns of repeat and multi-genre customers to create personalized recommendations and offers.

📚 Catalog Rationalization

Review the 183 never-ordered books to determine whether they should be promoted, bundled, or removed from the active catalog.

🧮 Example SQL Queries

Revenue by Genre

SELECT 
    b.Genre,
    SUM(o.Total_Amount) AS Revenue
FROM Books b
JOIN Orders o 
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue DESC;

Multi-Genre Customers

SELECT 
    Customer_ID,
    COUNT(DISTINCT b.Genre) AS Genres
FROM Orders o
JOIN Books b 
    ON o.Book_ID = b.Book_ID
GROUP BY Customer_ID
HAVING Genres > 1;

📌 Key Findings

* Revenue is concentrated among leading genres and books.
* 27.8% of customers are repeat buyers.
* 36.6% of the catalog has never been ordered.
* A significant portion of inventory is either low-stock or slow-moving.
* Inventory decisions should consider both stock levels and actual demand.
* Multi-genre customers provide a strong opportunity for cross-selling.

🚀 Conclusion

The BookVerse Retail Business Intelligence & Sales Analytics project demonstrates how MySQL and SQL can be used to transform bookstore transaction data into practical business insights.

By analyzing sales, customers, products, and inventory, the project provides management with actionable recommendations for improving inventory planning, customer engagement, product promotion, and overall retail performance.

👨‍💻 Project Team

* M Abhiram Karthik — B.Tech, CSE (AI & ML)
* K Vishwa Teja — B.Tech, Computer Science
* V Brahmaiah — B.Tech, CSE (AI & ML)

The team focused on SQL analysis, teamwork, and data-driven business insights.

⸻

⭐ If you found this project useful, consider giving the repository a star!
