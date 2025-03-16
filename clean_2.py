"""This is a 2nd Cleaning file for EDA Process"""

import pandas as pd

# Load the cleaned CSV file
df = pd.read_csv("customer_churn_cleaned.csv")

# Convert 'Total Charges' to numeric (again ensuring it's handled properly)
df["Total Charges"] = pd.to_numeric(df["Total Charges"], errors='coerce')

# Fill missing values
df.fillna({
    "Total Charges": df["Total Charges"].median(),  # Fill missing numeric values with median
    "Churn Reason": "Unknown"  # Fill missing categorical values with 'Unknown'
}, inplace=True)

# Save the updated dataset
df.to_csv("cleaned_customer_churn_v2.csv", index=False)

print("Missing values handled successfully!")
print(df.isnull().sum())
print(df.describe())
df.hist(figsize=(12,8))
numeric_df = df.select_dtypes(include=['number'])  # Select only numeric columns
print(numeric_df.corr())  # Compute correlation only for numeric data
