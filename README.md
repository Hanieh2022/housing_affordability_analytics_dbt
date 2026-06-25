# 🏠 Helsinki Metropolitan Area — Housing Affordability Analysis

An end-to-end analytics project analyzing housing affordability trends 
across Helsinki, Espoo, and Vantaa using public data from Statistics Finland.

---

## 📌 Project Overview

This project investigates whether housing in the Helsinki metropolitan area 
is becoming less affordable over time by tracking the gap between housing 
price growth and income growth since 2015.

**Key Questions:**
- How have housing prices and incomes grown since 2015?
- Which postal codes are least affordable relative to local incomes?
- Which areas show the highest gentrification risk?

---

## 🔧 Tech Stack

| Layer | Tool |
|---|---|
| Data Ingestion | Statistics Finland PxWeb API + Python |
| Data Storage | PostgreSQL |
| Data Modeling | dbt |
| Data Visualization | Power BI (Power Query + DAX) |

---

## 🗂️ Data Sources

All data is publicly available from [Statistics Finland](https://www.stat.fi/en):

| Dataset | Description | Coverage |
|---|---|---|
| Household Population | Number of households by postal code | 2015–2024 |
| Median Income | Median income by postal code | 2015–2024 |
| Housing Prices | Price per m² by postal code | 2015–2024 |

---

## 🏗️ Architecture
