# Grocery_Sales_Data_Analysis_Project

## 📌 Project Overview

The **Grocery Sales Analysis** project is a data-driven exploration of a simulated retail environment using a structured relational database. It provides a four-month snapshot of sales transactions, customer demographics, product inventory, employee performance, and geographic distribution across multiple cities and countries.
This project is designed to help data analysts and aspiring data scientists practice real-world SQL querying, data cleaning, and insight extraction. The dataset is fully normalized and includes over 1,00,000 records, offering a rich and realistic foundation for business intelligence reporting and exploratory data analysis.

## 📁 Dataset Schema
A quick overview of each CSV file included in the dataset:

| File Name       | Description                                                  |
|------------------|--------------------------------------------------------------|
| `categories.csv` | Defines the categories of the products.                      |
| `cities.csv`     | Contains city-level geographic data.                         |
| `countries.csv`  | Stores country-related metadata.                             |
| `customers.csv`  | Contains information about the customers who make purchases. |
| `employees.csv`  | Stores details of employees handling sales transactions.     |
| `products.csv`   | Stores details about the products being sold.                |
| `sales.csv`      | Contains transactional data for each sale.                   |


Below is a breakdown of each CSV file used in the project along with the meaning of each column:

---

### 🧾 `sales.csv`
| Column Name        | Description                                                  |
|--------------------|--------------------------------------------------------------|
| SalesID            | Unique identifier for each sales transaction                 |
| EmployeeID         | Foreign key linking to the employee who handled the sale     |
| CustomerID         | Foreign key linking to the purchasing customer               |
| ProductID          | Foreign key linking to the product sold                      |
| Quantity           | Number of product units sold                                 |
| Discount           | Discount applied to the transaction (0–1 scale)              |
| TotalPrice         | Final price after discount (can be recalculated)             |
| SalesDate          | Date of the transaction                                      |
| TransactionNumber  | Unique alphanumeric transaction reference                    |

---

### 📦 `products.csv`
| Column Name   | Description                                                       |
|---------------|-------------------------------------------------------------------|
| ProductID     | Unique identifier for each product                                |
| ProductName   | Name/description of the product                                   |
| Price         | Selling price of the product                                      |
| CategoryID    | Foreign key linking to the product category                       |
| Level_Type    | Quality level or classification of the product                   |
| ModifyDate    | Last modification date for the product entry                      |
| Resistant     | Durability classification (e.g., Durable, Weak)                   |
| IsAllergic    | Indicates if the product may cause allergies                      |
| VitalityDays  | Shelf life or freshness period in days                            |

---

### 👥 `customers.csv`
| Column Name   | Description                                      |
|---------------|--------------------------------------------------|
| CustomerID    | Unique identifier for each customer              |
| CustomerName  | Full name of the customer                        |
| Address       | Street address of the customer                   |
| CityID        | Foreign key linking to the customer's city       |

---

### 👨‍💼 `employees.csv`
| Column Name   | Description                                      |
|---------------|--------------------------------------------------|
| EmployeeID    | Unique identifier for each employee              |
| EmpName       | Employee’s full name                             |
| BirthDate     | Employee’s date of birth                         |
| Gender        | Gender of the employee (M/F)                     |
| CityID        | Foreign key linking to the employee's city       |
| HireDate      | Date the employee was hired                      |

---

### 🗂 `categories.csv`
| Column Name   | Description                                        |
|---------------|----------------------------------------------------|
| CategoryID    | Unique identifier for each product category        |
| CategoryName  | Name of the category (e.g., Dairy, Beverages)      |

---

### 🌆 `cities.csv`
| Column Name   | Description                                      |
|---------------|--------------------------------------------------|
| CityID        | Unique identifier for each city                  |
| CityName      | Name of the city                                 |
| Zipcode       | Postal code of the city                          |
| CountryID     | Foreign key linking to the country               |

---

### 🌍 `countries.csv`
| Column Name   | Description                                      |
|---------------|--------------------------------------------------|
| CountryID     | Unique identifier for each country               |
| CountryName   | Name of the country                              |
| CountryCode   | Abbreviated code for the country                 |

![ER Diagram](ERD_of_Sales.png)



## 🎯 Key Analytical Use Cases

This project enables data exploration across multiple business dimensions:

- **📅 Time-Based Analysis**
  - Track sales trends over the four-month period
  - Measure month-over-month performance
  - Identify seasonal peaks or dips

- **📦 Product Performance**
  - Determine top and bottom-selling products
  - Analyze sales revenue and quantity per product
  - Evaluate product types and their contribution to revenue

- **👤 Customer Behavior**
  - Identify high-value vs. low-engagement customers
  - Segment customers by purchase frequency and spending
  - Calculate average basket size and repeat purchases

- **👨‍💼 Employee Effectiveness**
  - Compare employee contributions to total sales
  - Highlight top-performing and underperforming staff
  - Track sales per employee over time

- **🌍 Regional Sales Insights**
  - Visualize sales across cities and countries
  - Identify high-performing regions
  - Support regional sales strategies and planning
