-- ==========================
-- CUSTOMER CHURN ANALYSIS - SQL QUERIES
-- ==========================

-- First create a Database
CREATE DATABASE customer_churn;
USE customer_churn;


--Create a Table as same as in cleaned_customer_churn_v2.csv
CREATE TABLE customer_churn (
    CustomerID VARCHAR(20) PRIMARY KEY,
    City VARCHAR(100),
    Zip_Code INT,
    Latitude FLOAT,
    Longitude FLOAT,
    Gender VARCHAR(10),
    Senior_Citizen VARCHAR(5),
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    Tenure_Months INT,
    Phone_Service VARCHAR(10),
    Multiple_Lines VARCHAR(20),
    Internet_Service VARCHAR(20),
    Online_Security VARCHAR(20),
    Online_Backup VARCHAR(20),
    Device_Protection VARCHAR(20),
    Tech_Support VARCHAR(20),
    Streaming_TV VARCHAR(20),
    Streaming_Movies VARCHAR(20),
    Contract VARCHAR(20),
    Paperless_Billing VARCHAR(5),
    Payment_Method VARCHAR(50),
    Monthly_Charges FLOAT,
    Total_Charges FLOAT,
    Churn_Label VARCHAR(5),
    Churn_Value INT,
    Churn_Score INT,
    CLTV INT,
    Churn_Reason VARCHAR(100)
);



--Use this quary to load the .csv file directly
USE customer_churn;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_customer_churn_v2.csv' --Change this PATH According to your system
INTO TABLE customer_churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


--Check for any missing values (Same as we had done in clean_2.py)
SELECT * FROM customer_churn LIMIT 5;
SHOW COLUMNS FROM customer_churn;
SELECT * FROM customer_churn WHERE CustomerID IS NULL;  --Change "CustomerID" to other columns names to check



--This quary will give you overall Churn Rate
SELECT 
    COUNT(*) AS Total_Customers, 
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn;


--Here comes the Main Queries (These queries will tell you what affects the churn most and least)

/*Analyze churn distribution across different contract types.*/
SELECT 
    Contract, 
    COUNT(*) AS Total_Customers, 
    SUM(Churn_Value) AS Churned_Customers, 
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Contract
ORDER BY Churn_Rate DESC;



/*Let's check if the payment method influences churn*/
SELECT 
    Payment_Method, 
    COUNT(*) AS Total_Customers, 
    SUM(Churn_Value) AS Churned_Customers, 
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Payment_Method
ORDER BY Churn_Rate DESC;



/*Now, let’s analyze how Internet Service Type affects churn*/
SELECT 
    Internet_Service, 
    COUNT(*) AS Total_Customers, 
    SUM(Churn_Value) AS Churned_Customers, 
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Internet_Service
ORDER BY Churn_Rate DESC;
/*Fiber Optic has the highest churn rate (41.89%)
DSL churn rate is much lower (18.96%)
Customers without Internet Service churn the least (7.41%)
This suggests Fiber Optic users are more likely to leave, possibly due to cost or service issues. */



/*Let’s see if customer tenure (how long they’ve been with the company) affects churn*/
SELECT 
    CASE 
        WHEN Tenure_Months BETWEEN 0 AND 12 THEN '0-1 Year'
        WHEN Tenure_Months BETWEEN 13 AND 24 THEN '1-2 Years'
        WHEN Tenure_Months BETWEEN 25 AND 48 THEN '2-4 Years'
        WHEN Tenure_Months BETWEEN 49 AND 72 THEN '4-6 Years'
        ELSE '6+ Years'
    END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Tenure_Group
ORDER BY Churn_Rate DESC;
/*Customers in their first year churn the most (47.44%) 
Churn rate decreases as tenure increases 
1-2 years: 28.71%
2-4 years: 20.39%
4-6 years: Only 9.51%

Conclusion:
Early retention is a big issue! New customers leave within the first year at a very high rate.
The longer a customer stays, the less likely they are to churn.
The company should focus on improving onboarding, customer support, and incentives to retain new customers.*/




/*Let’s check if customers with higher bills churn more.*/
SELECT 
    CASE 
        WHEN Monthly_Charges < 30 THEN 'Low (<$30)'
        WHEN Monthly_Charges BETWEEN 30 AND 60 THEN 'Medium ($30-$60)'
        WHEN Monthly_Charges BETWEEN 60 AND 90 THEN 'High ($60-$90)'
        ELSE 'Very High (>$90)'
    END AS Charge_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Charge_Group
ORDER BY Churn_Rate DESC;
/*Customers with high bills churn the most
$60-$90: 33.91% churn rate
>$90: 32.78% churn rate
Low-paying customers ($<30) rarely churn (9.80%) 

Conclusion:
Customers paying higher bills are more likely to leave – they may feel they’re not getting enough value for their money.
The company should analyze if these customers are getting proper services (Internet speed, Customer support, etc.).

Possible solutions:
Offer discounts or loyalty benefits to high-paying customers.
Improve customer experience & support for premium users.
Create customized plans for high-value customers to reduce dissatisfaction.*/




/*Let’s see if lack of tech support increases churn.*/
SELECT 
    Tech_Support,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Tech_Support
ORDER BY Churn_Rate DESC;
/*Customers without Tech Support churn the most!
41.63% churn rate if they don’t have tech support.
15.17% churn rate for those with tech support.
Customers without internet services churn the least (7.41%)

Conclusion:
Lack of Tech Support is a major reason for churn.
Customers who don’t get support might struggle with issues and decide to switch providers.

Possible Solutions:
Encourage tech support subscription – Provide incentives or bundle it with other services.
Improve self-service options – AI chatbots, FAQs, and troubleshooting guides.
Better customer education – Explain the value of tech support at sign-up.*/




/*Now, let’s check if lack of online security impacts churn*/
SELECT 
    Online_Security,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Online_Security
ORDER BY Churn_Rate DESC;
/*Customers without Online Security churn the most!
41.77% churn rate if they don’t have online security.
Only 14.61% churn rate for those who have it.
Customers without internet service churn the least (7.41%)

Conclusion:
Lack of Online Security is a strong churn indicator.
Customers might feel vulnerable to cyber threats, phishing, or hacking and decide to switch to a provider that offers better security.

Possible Solutions:
Promote online security packages – Offer free trials or discounts.
Educate customers – Show them real threats and how security features protect them.
Bundle security with other services – Create premium plans with security, tech support, and device protection.*/




/*Now, let’s check if not having online backup increases churn*/
SELECT 
    Online_Backup,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Online_Backup
ORDER BY Churn_Rate DESC;
/*Customers without Online Backup have a high churn rate of 39.93%!
Customers with Online Backup churn at a much lower rate (21.53%).
Again, "No internet service" customers have the lowest churn (7.41%).

Conclusion:
Online Backup reduces churn significantly! Customers who have it are less likely to leave.
This suggests that data security and convenience matter to customers.

Possible Solutions:
Offer free online backup trials for new customers.
Create awareness campaigns on how backup prevents data loss.
Bundle backup with other features like Online Security or Tech Support.*/




/*Let’s now analyze if Device Protection impacts customer retention*/
SELECT 
    Device_Protection,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Device_Protection
ORDER BY Churn_Rate DESC;
/*Customers without Device Protection have a high churn rate of 39.13%!
Customers with Device Protection churn at a much lower rate (22.50%).
Again, "No internet service" customers have the lowest churn (7.41%).

Conclusion:
Device Protection helps reduce churn! Customers who have it are more likely to stay.
This suggests that customers value security for their devices.

Possible Solutions:
Offer free Device Protection trials for new customers.
Create bundled plans (Internet + Device Protection) at a discounted rate.
Educate customers on the risks of not having Device Protection.*/





/*Let’s now analyze if Tech Support impacts customer retention*/
SELECT 
    Tech_Support,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Tech_Support
ORDER BY Churn_Rate DESC;
/*Customers without Tech Support have a high churn rate of 41.64%!
Customers with Tech Support churn significantly less (15.17%).
"No internet service" customers have the lowest churn (7.41%).

Conclusion:
Tech Support drastically reduces churn! Customers who get assistance are much more likely to stay.
Many customers might be leaving due to unresolved technical issues.

Possible Solutions:
Offer free Tech Support for the first few months to new customers.
Introduce 24/7 Tech Support for premium customers.
Proactively reach out to customers who contact support frequently.*/




/*Let’s now analyze if having Streaming TV impacts churn*/
SELECT 
    Streaming_TV,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Streaming_TV
ORDER BY Churn_Rate DESC;
/*Customers without Streaming TV have the highest churn rate (33.52%).
Customers with Streaming TV also churn at a slightly lower rate (30.07%).
"No internet service" customers again have the lowest churn (7.41%).

Conclusion:

Streaming TV does not significantly reduce churn.
Customers without internet service are the most stable.
 
Possible Actions:

Bundle Streaming TV with discounts on long-term contracts to encourage retention.
Analyze whether Streaming TV users face service issues that cause them to leave.
Offer exclusive content or personalized recommendations to engage customers more.*/




/*let’s analyze whether having Streaming Movies affects churn*/
SELECT 
    Streaming_Movies,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Streaming_Movies
ORDER BY Churn_Rate DESC;
/*Customers without Streaming Movies have the highest churn rate (33.68%).
Customers with Streaming Movies churn slightly less (29.94%).
"No internet service" customers again have the lowest churn (7.41%).
💡 Conclusion:

Streaming Movies, like Streaming TV, does not significantly reduce churn.
Customers who don’t use Streaming Movies have a slightly higher churn rate than those who do.
The most stable customers are still those without internet service.
✅ Possible Actions:

Improve Streaming Movie content to retain customers better.
Offer bundled discounts on Streaming TV & Movies to increase engagement.
Investigate service quality issues—are Streaming users leaving due to poor experience?*/




/* let’s analyze whether having Tech Support affects churn*/
SELECT 
    Tech_Support,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Tech_Support
ORDER BY Churn_Rate DESC;
/*Customers without Tech Support have the highest churn rate (41.64%) 📉
Customers with Tech Support churn significantly less (15.17%) ✅
"No internet service" customers again have the lowest churn (7.41%)
💡 Conclusion:

Tech Support is a major factor in reducing churn!
Customers without Tech Support are nearly 3x more likely to churn than those with support.
Customers with Tech Support are more satisfied and loyal.
✅ Possible Actions:

Promote Tech Support to at-risk customers. Offer it as a free trial or discounted add-on.
Analyze customer complaints/issues—do customers churn due to unresolved technical problems?
Bundle Tech Support with premium plans to increase retention.*/




/*let’s check if Online Security reduces churn. */
SELECT 
    Online_Security,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Online_Security
ORDER BY Churn_Rate DESC;
/*Customers without Online Security have the highest churn rate (41.77%) 📉
Customers with Online Security churn much less (14.61%) ✅
"No internet service" customers have the lowest churn (7.41%)
💡 Conclusion:

Online Security is a key factor in reducing churn.
Customers without Online Security are almost 3x more likely to churn than those who have it.
Security features may improve customer trust and satisfaction.
✅ Possible Actions:

Upsell Online Security to high-risk customers. Offer discounts or bundle it with internet plans.
Identify pain points of customers who canceled their Online Security.
Educate customers on cyber threats and the value of Online Security.*/




/*let’s analyze if Online Backup reduces churn*/
SELECT 
    Online_Backup,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Online_Backup
ORDER BY Churn_Rate DESC;
/*Customers without Online Backup have a high churn rate (39.93%) 📉
Customers with Online Backup churn significantly less (21.53%) ✅
"No internet service" customers again have the lowest churn (7.41%)
💡 Conclusion:

Online Backup appears to reduce churn but not as much as Online Security.
Customers without it are almost 2x more likely to churn.
Backup services might increase perceived value and retention.
✅ Possible Actions:

Encourage customers to subscribe to Online Backup via targeted marketing.
Offer limited-time free trials to showcase the benefits.
Bundle it with other services like Online Security to increase adoption.*/




/*let’s check if Device Protection affects churn*/
SELECT 
    Device_Protection,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Device_Protection
ORDER BY Churn_Rate DESC;
/*Customers without Device Protection have a high churn rate (39.13%) 📉
Customers with Device Protection churn significantly less (22.50%) ✅
"No internet service" customers have the lowest churn (7.41%)
💡 Conclusion:

Device Protection reduces churn, but not as much as Online Security or Backup.
Customers without it are almost 1.75x more likely to churn.
Customers may find this service beneficial for device safety and support.
✅ Possible Actions:

Promote Device Protection as an added value service to retain customers.
Bundle it with Online Security and Tech Support for increased adoption.
Offer discounts for first-time subscribers to encourage sign-ups.*/




/*Analyze Paperless Billing & Churn*/
SELECT 
    Paperless_Billing,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Value) AS Churned_Customers,
    (SUM(Churn_Value) / COUNT(*)) * 100 AS Churn_Rate
FROM customer_churn
GROUP BY Paperless_Billing
ORDER BY Churn_Rate DESC;
/*Customers with Paperless Billing:

Total: 4,171
Churned: 1,400
Churn Rate: 33.57%
Customers without Paperless Billing:

Total: 2,872
Churned: 469
Churn Rate: 16.33%
📌 Observation:
Customers with Paperless Billing have a significantly higher churn rate than those without it. 
This suggests that traditional billing methods might encourage higher retention—perhaps due to
 customers paying more attention to their bills or finding digital payments inconvenient.*/
