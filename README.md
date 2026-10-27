# E-Commerce Sales Analytics Dashboard

An end-to-end portfolio project demonstrating SQL analysis and an interactive Power BI dashboard for sales, products, customers, and order performance.

## Project at a glance

- **Tools:** MySQL, Power BI, DAX, Power Query
- **Dashboard pages:** Executive Overview, Product Analysis, Customer Analysis, Order Analysis
- **Analysis:** Revenue, orders, average order value, cancellation metrics, product performance, customer activity, and sales trends
- **Dataset:** Sample project dataset; the README describes 2,000 orders, 90 customers, 38 products, and 4,967 order items. Recheck these counts if the source data changes.

## Business questions

1. How much revenue comes from delivered orders?
2. Which products and categories sell the most?
3. Which customers contribute the most revenue?
4. How do monthly sales change over time?
5. How many customers are inactive or have never ordered?
6. How do order statuses and cancellations affect performance?

## Files

| File | Purpose |
|---|---|
| `e_commerce_project.pbix` | Power BI report |
| `E-Commerce Sales Analytics.sql` | SQL business analysis queries |
| `README.md` | Project documentation |

## Dashboard preview

### Executive Overview
![Executive Overview](https://github.com/user-attachments/assets/f8f71c6b-09bb-4c67-98e1-9f43fc0def6e)

### Product Analysis
![Product Analysis](https://github.com/user-attachments/assets/8e0b92f2-46e5-4d98-b854-a34f982b4ff9)

### Customer Analysis
![Customer Analysis](https://github.com/user-attachments/assets/bca18352-fd14-4793-8f43-db5913849bd8)

### Order Analysis
![Order Analysis](https://github.com/user-attachments/assets/54a80aa8-766e-4389-87a7-8fd5615d470e)

## How to use

1. Download or clone this repository.
2. Open `e_commerce_project.pbix` in Power BI Desktop.
3. If prompted, configure the data source paths to match your local files.
4. Open the SQL script in MySQL Workbench and ensure the database and table names match your imported schema before running queries.
5. Validate KPI definitions and totals against the source data before using results for business decisions.

## Data and metric notes

- Revenue queries should consistently specify which order statuses are included.
- Average Order Value should be calculated at the order level, not by averaging individual item prices.
- Customer and product counts should use distinct IDs when the data model contains multiple rows per entity.
- Dataset figures and screenshots should be refreshed if the underlying source data or report changes.

## Skills demonstrated

SQL joins, aggregation, CTEs, window functions, KPI definition, Power Query transformation, DAX measures, data visualization, and business analysis.

## Author

Swapnil Rathod
