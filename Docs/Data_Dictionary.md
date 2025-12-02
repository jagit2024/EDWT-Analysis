# ED Analytics Pipeline: Emergency Department Wait Time Analysis

## 📋 Project Overview
**Author:** Justin O. Ajuogu  
**Last Updated:** November 2025

This document serves as a comprehensive reference guide to the data pipeline for the Emergency Department Wait Time Analysis project. It explains field definitions, data origins, and how data evolves through the pipeline's three layers.

---

## Data Architecture: The Three Layers

### **Bronze Layer – Raw Data**
- **Purpose:** Raw, unaltered data exactly as it comes from the source system
- **Characteristics:** No cleaning, no transformations
- **Analogy:** "A snapshot of what the source system gave us"

### **Silver Layer – Cleaned Data**
- **Purpose:** Standardized, validated, and enriched data
- **Key Activities:**
  - Standardization (UPPERCASE text, trimmed whitespace)
  - Validation (range checks, outlier capping)
  - Field enrichment
- **Analogy:** "Make the data trustworthy and usable"

### **Gold Layer – Analytics Data**
- **Purpose:** HIPAA-compliant, analysis-ready data
- **Key Activities:**
  - Full de-identification
  - Business logic application
  - Dashboard optimization
- **Analogy:** "Insights without exposing sensitive information"

---

## 📊 Data Layer Details

### Bronze Layer: `bronze_ed_visits`
**Description:** Raw patient visit data from the ED system  
**Source:** Synthetic generator (`generate_ed_data.py`)  
**Loading Process:** Python → CSV → SQL

| Field | Description | Data Type | Notes |
|-------|-------------|-----------|-------|
| `patient_id` | Unique identifier for each visit | VARCHAR(50) | Example: PT0001; Replaced with anonymous IDs in Gold |
| `arrival_time` | Exact date/time patient arrived | DATETIME | Example: 2024-11-01 08:15:23; Used for hour/day/date calculations |
| `acuity_level` | Urgency rating 1–5 (ESI standard) | INT | 1 = most critical; Determines care priority |
| `age_group` | Age bracket (not exact age) | VARCHAR(10) | Categories: 0-17, 18-34, 35-54, 55-74, 75+; HIPAA-safe grouping |
| `chief_complaint` | Reason patient came to ED | VARCHAR(100) | Example: Chest Pain; Standardized to 9 categories in project |
| `wait_time_minutes` | Minutes from arrival → provider | INT | Example: 45; Industry target: 30 minutes |
| `length_of_stay_hours` | Total time spent in ED | DECIMAL(5,2) | Example: 3.2; Typical ED visit = 1–8 hrs |
| `load_timestamp` | When record was loaded into Bronze | DATETIME | Audit trail for debugging |

---

### Silver Layer: `silver_ed_visits`
**Description:** Cleaned, standardized Bronze data  
**Created By:** SQL ETL (`06_etl_bronze_to_silver.sql`)  
**Includes:** All Bronze fields + new calculated fields

#### 🔧 Data Transformations from Bronze
- `patient_id` → `UPPER()` + `TRIM()`
- `arrival_time` → validated (no null/future dates)
- `acuity_level` → must be 1–5
- `chief_complaint` → standardized categories
- `wait_time_minutes` → outliers capped at 300
- `length_of_stay_hours` → must be 0–24 hrs

#### ✨ New Fields in Silver
| Field | Description | Example |
|-------|-------------|---------|
| `arrival_hour` | Hour of arrival (0–23) | 8 |
| `arrival_day_of_week` | Day name (Monday–Sunday) | Monday |
| `arrival_date` | Date only (no time) | 2024-11-01 |
| `processed_timestamp` | When Silver transformation occurred | System-generated |

---

### Gold Layer: `gold_ed_analytics`
**Description:** HIPAA-compliant analytics view  
**Built From:** Silver + reference tables  
**Defined In:** `05_create_gold_layer.sql`  
**Note:** This is a VIEW (no physical storage)

| Field | Description | Notes |
|-------|-------------|-------|
| `anonymous_id` | GUID replacing patient_id | Example: 3F2504E0-4F89-11D3-9A0C-0305E82C3301; Changes each query → ensures anonymity |
| `acuity_name` | Descriptive label | Examples: "Resuscitation/Critical", "Urgent / Moderate Acuity" |
| `acuity_target_time` | Target wait time for each acuity | From ESI guidelines; Example: Level 1 = 0, Level 3 = 30 min |
| `wait_time_status` | "Met Target" or "Exceeded Target" | Based on 30-minute standard |
| `acuity_target_status` | "Met Acuity Target" or "Exceeded Acuity Target" | Based on acuity-specific benchmark |
| **All Silver Fields** | | `age_group`, `chief_complaint`, `arrival_hour`, `arrival_day_of_week`, `arrival_date`, `wait_time_minutes`, `length_of_stay_hours` |

---

## Reference Table: `ref_acuity_levels`
Defines what each acuity level means.

| Field | Description |
|-------|-------------|
| `acuity_level` | Numeric value (1–5) |
| `acuity_name` | Descriptive name (e.g., "Emergency / High Acuity") |
| `description` | Detailed explanation |
| `target_time_minutes` | Target wait time in minutes |
| `example_conditions` | Clinical examples (e.g., "chest pain, severe breathing difficulty") |

---

## ❓ Frequently Asked Questions (FAQ)

**Q: Why use three data layers?**  
A: Each layer serves a distinct purpose:
- **Bronze** → Audit trail preservation
- **Silver** → Data quality & standardization
- **Gold** → Analytics & HIPAA compliance

**Q: Why are some fields NULL?**  
A: Invalid data from Bronze is kept but flagged. Example: `acuity_level = 7` becomes NULL.

**Q: Why does anonymous_id change between queries?**  
A: Generated on-the-fly using `NEWID()` to prevent patient tracking across queries.

**Q: How is missing data handled?**  
A: Critical fields → record rejected; Optional fields → set to NULL.

**Q: How can I check data quality?**  
A: Run `07_data_quality_report.sql` to see NULLs, outliers, and validation counts.

**Q: Can BI tools connect to this data?**  
A: Yes – Power BI, Tableau, Excel, and SQL clients can connect directly to `gold_ed_analytics`.

---

## ⚙️ Technical Notes

### Data Types
- `VARCHAR` = Text
- `INT` = Whole number
- `DECIMAL(5,2)` = Numeric decimal
- `DATETIME` = Timestamp
- `DATE` = Date only

### NULL vs Empty String
- `NULL` = Value missing
- `""` = Blank string

### Time Zones
All timestamps are in local time.

### Data Retention
- **Bronze:** 2 years
- **Silver:** Regenerable
- **Gold:** View (no physical storage)

---

## 📚 Further Documentation
Explore the following resources for deeper understanding:

- `/docs` folder:
  - ETL Process Flow
  - Data Mapping Specification
  - Project Report
- `/sql` folder for full ETL logic

---
