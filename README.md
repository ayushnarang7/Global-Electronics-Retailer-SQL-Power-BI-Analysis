# Global Electronics Retailer — SQL & Power BI Analysis

## 📊 Project Overview

An end-to-end sales analytics project using SQL and Power BI to analyze the performance of a global electronics retailer.

The project covers data preparation, exploratory analysis, KPI development, advanced SQL analysis, data modeling, DAX calculations, and interactive business intelligence dashboards.

## 🎯 Business Problem

The retailer wants to understand its overall sales and profitability performance across products, customers, countries, and stores.

The analysis focuses on identifying key revenue and profit drivers, understanding performance trends over time, and highlighting high and low performing areas to support better business decisions.

## 🛠️ Tools & Technologies

- MySQL
- SQL
- Power BI
- DAX
- Power Query

## 📁 Project Structure

### SQL Analysis

**1. Importing & Cleaning**

- Imported relational datasets
- Converted date fields into `DATE` format
- Cleaned product price fields
- Checked converted fields for missing values
- Verified imported row counts

**2. Exploratory Data Analysis**

- Sales period analysis
- Customer demographics
- Product categories, subcategories, and brands
- Store distribution
- Store characteristics
- Sales currencies

**3. Measures & KPIs**

- Revenue
- Cost
- Profit
- Profit Margin
- Orders
- Quantity Sold
- Average Order Value
- Average Delivery Time
- Active Customer Rate

**4. Advanced Analysis**

- Monthly revenue and profit trends
- YTD revenue
- Customer base growth
- Category performance
- Product and brand performance
- Country performance
- Customer analysis
- Store performance
- Store area analysis
- Product rankings

## 📈 Power BI Dashboard

The Power BI dashboard contains five analytical pages:

1. **Executive Overview**
2. **Product Performance**
3. **Customer Performance**
4. **Geographic Performance**
5. **Store Performance**

The dashboard uses a relational data model with **Sales** as the central fact table and **Products, Customers, and Stores** as dimension tables.

A dedicated **Calendar** table is used for time-based analysis and YTD/PYTD calculations.

## 💡 Key Insights

- Revenue fell **75.28%** in Jan–Feb 2021 compared with Jan–Feb 2020, indicating a sharp decline in overall business performance.
- The United States accounts for **42.48%** of total revenue, making it the largest revenue-generating market.
- Offline sales dominate, contributing **79.31%** of total revenue, while online sales account for **20.69%**.
- Computers dominate category revenue at **37.21%**, followed by Cell Phones (**14.31%**) and Home Appliances (**13.63%**).

## 📊 Dashboard Preview

![Global Electronics Retailer Dashboard](Dashboard%20Preview.png)

## 🔍 Key Concepts Used

### SQL

- JOINs
- Aggregations
- GROUP BY
- Subqueries
- CTEs
- Window Functions
- Date Functions
- CASE Expressions
- Ranking
- YTD Analysis

### Power BI

- Data Modeling
- Relationships
- DAX Measures & Calculated Columns
- YTD / PYTD Calculations
- Calendar Table
- Field Parameters
- Interactive Slicers
- Data Visualization & Dashboard Design
- Power Query

## 📌 Dataset

The project uses the **Global Electronics Retailer** dataset from Maven Analytics.

## 👤 Author

**Ayush Narang**
