import pandas as pd

# Load the CSV file
file_path = "output.csv"
df = pd.read_csv(file_path)

# Drop unnecessary columns
df = df.drop(columns=["Count", "Country", "State", "Lat Long"])

# Save the cleaned data
df.to_csv("customer_churn_cleaned.csv", index=False)
