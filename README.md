# E-Commerce Customer Churn Analysis

## Project Overview

This project aims to analyze customer churn in an e-commerce platform. The goal is to understand the factors that contribute to customer churn and provide insights to help reduce it. We have performed data exploration and data transformation using SQL and visualized the results using Power BI.

### Table of Contents

- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Data Sources](#data-sources)
- [Data Exploration](#data-exploration)
- [Data Transformation](#data-transformation)
- [Visualization](#visualization)
- [Results](#results)
- [Technologies Used](#technologies-used)

## Project Structure

The project structure is organized as follows:


- `E_Commerce/`: Contains raw data.
- `E_Commerce Transformed/`: Contains processed data.
- `E_Commerce_Churn/`: Contains SQL queries and data transformation scripts.
- `E Commerce Analysis Dashboard/`: Stores visualizations and charts created using Power BI.
- `README.md`: The project's documentation (this file).

## Data Sources

We used the following data source for this analysis:

- **Ecommerce Customer Churn Analysis and Prediction**: The e-commerce database contains customer transaction and interaction data, which was obtained from [Kaggle](https://www.kaggle.com/datasets/ankitverma2010/ecommerce-customer-churn-analysis-and-prediction).

## Data Exploration

We conducted data exploration using SQL to gain insights into the dataset. Key findings from the exploratory analysis include:

- Total Customers: 5630
- Overall churn rate: 16.84%.
- Average Cashback for Churned Customers: Rs 160.4


## Data Transformation

Data transformation involved SQL queries, data cleaning, and feature engineering. Steps included handling missing values, outliers, and data normalization.

## Visualization

Visualizations were created using Power BI to enhance data understanding. Sample visualizations include:

- Churn rate trends by Preferred Payment Mode.
- Churn Rate by Marital Status
- Churn Rate by Login Device

  ![image](https://github.com/ZuhairBhati/E-Commerce-Customer-Churn-Analysis/assets/123544025/0e1819ac-79d5-4e76-a57f-22f016852480)


## Results

Main findings from the analysis:

- Churn Rate by Tenure:
  - Customers with 6 Months Tenure: 32.4%
  - Customers with 1-Year Tenure: 9.85%
  - Customers with 2-Year Tenure: 6.48%
  - Customers with More than 2 Years Tenure: 0%

- Churn Rate by Warehouse to Home Distance
  - Far: 20.90%
  - Moderate: 20.14%
  - Close: 17.60%
  - Very Close: 13.51%

Recommendations:

- Implement targeted marketing strategies for high-churn months.
- Develop loyalty programs to retain high-value customers.
- Enhance user engagement through personalized experiences.

## Technologies Used

- SQL ![](<https://img.shields.io/badge/MySQL-4479A1.svg?style=for-the-badge&logo=MySQL&logoColor=white>)
- Power BI ![](<https://img.shields.io/badge/Power%20BI-F2C811.svg?style=for-the-badge&logo=Power-BI&logoColor=black>)


