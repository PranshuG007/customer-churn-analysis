# Customer Churn Analysis

## Introduction
This project focuses on analyzing customer churn data from a telecom company. The goal is to clean, process, and visualize the data using SQL and Power BI to gain insights into customer behavior and churn patterns.

## Steps to Reproduce

### 1️⃣ Convert Excel to CSV
- Start with the provided `Telco_customer_churn.xlsx` file.
- Convert it to `output.csv` for further processing.

### 2️⃣ Data Cleaning - Remove Unnecessary Columns
- Run `clean_1.py` to clean the dataset.
- Input: `output.csv`
- Output: `customer_churn_cleaned.csv`

### 3️⃣ Exploratory Data Analysis (EDA)
- Run `clean_2.py` to perform EDA and further clean the dataset.
- Input: `customer_churn_cleaned.csv`
- Output: `cleaned_customer_churn_v2.csv`

### 4️⃣ Load Data into MySQL
- Place `cleaned_customer_churn_v2.csv` in MySQL’s **server/uploads** folder (or a directory based on your setup).
  (For me the path was "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_customer_churn_v2.csv")
- Open MySQL and create a new database.
- Run all queries from `project.sql` to extract meaningful insights.

### 5️⃣ Data Visualization with Power BI
- Open Power BI and load the processed data.
- You can design your own dashboard or refer to the provided `customer_churn_analysis.pbix` file for inspiration.

---
📌 **Note:** Ensure that MySQL and Power BI are properly set up before running the queries and visualizations.

