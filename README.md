# Emergency Department Wait Time Analysis

Healthcare analytics pipeline using medallion architecture to analyze ED patient flow, wait times, and operational bottlenecks.

![SQL Server](https://img.shields.io/badge/SQL%20Server-2019-CC2927?logo=microsoft-sql-server)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?logo=powerbi)
![HIPAA Compliant](https://img.shields.io/badge/HIPAA-Compliant-green)

---

## 📊 Project Overview

End-to-end data engineering project demonstrating:

- **Medallion Architecture** (Bronze/Silver/Gold layers)
- **Data Quality Engineering** (12 validation rules, 100% pass rate)
- **HIPAA Compliance** (Safe Harbor de-identification)
- **ETL Pipeline Design** (Python + SQL Server)
- **Business Intelligence** (Power BI dashboard with 6 visuals)

---

## 💼 Business Impact

- 📊 **Identified peak hours** with 94-minute average wait times (10 AM - 2 PM)
- 📈 **Analyzed 300 patient visits** across 5 acuity levels
- 🎯 **Provided staffing recommendations** to reduce wait times 15-20%
- ✅ **Achieved 100% data quality** pass rate across all validation rules

---

## 🏗️ Technical Architecture

### Data Flow Pipeline

```
CSV (300 records) → Bronze (raw) → Silver (cleaned) → Gold (analytics) → Power BI
```

### Medallion Architecture Layers

| Layer | Table/View | Purpose | Key Features |
|-------|-----------|---------|--------------|
| **🥉 Bronze** | `bronze_ed_visits` | Raw data ingestion | Immutable source, audit trail |
| **🥈 Silver** | `silver_ed_visits` | Cleaned & validated | 12 quality rules, derived fields |
| **🥇 Gold** | `gold_ed_analytics` | Analytics-ready | HIPAA-compliant, business logic |

### Technology Stack

- **Database**: SQL Server 2019
- **ETL**: Python 3.x (pandas, pyodbc), T-SQL
- **Visualization**: Power BI Desktop
- **Version Control**: Git/GitHub

---

## 📁 Project Structure

```
EDWT-Analysis/
│
├── README.md                           # Project overview
│
├── data/                               # Synthetic patient data
│   └── ed_visits_synthetic.csv        # 300 records, 8 fields
│
├── sql/                                # Database scripts
│   ├── ddl/                           # Data Definition Language
│   │   ├── 01_create_database.sql
│   │   ├── 02_create_bronze_layer.sql
│   │   ├── 03_create_silver_layer.sql
│   │   ├── 04_create_reference_tables.sql
│   │   └── 05_create_gold_layer.sql
│   │
│   ├── dml/                           # Data Manipulation Language
│   │   ├── 06_etl_bronze_to_silver.sql
│   │   ├── 07_data_quality_report.sql
│   │   └── 08_analytical_queries.sql
│   │
│   └── stored_procedures/             # Automation scripts (optional)
│       ├── 09_sp_transform_to_silver.sql
│       └── 10_sp_data_quality_check.sql
│
├── python/                             # Data generation & loading
│   ├── generate_ed_data.py            # Creates synthetic CSV
│   └── load_to_sql.py                 # Loads CSV to Bronze layer
│
├── docs/                               # Technical documentation
│   ├── 01_Data_Dictionary.md
│   ├── 02_ETL_Process_Flow.md
│   ├── 03_Data_Mapping_Specification.md
│   └── Project_Report.pdf
│
├── powerbi/                            # Business Intelligence
│   └── ED_Analytics_Dashboard.pbix
│
└── .gitignore                          # Git exclusions
```

---

## 🚀 Quick Start Guide

### Step 1: Generate Synthetic Data
```bash
python python/generate_ed_data.py
```
**Output**: `ed_visits_synthetic.csv` created in `data/` folder (300 records)

### Step 2: Set Up SQL Database
Run the following scripts in order using SQL Server Management Studio (SSMS):

```sql
-- 1. Create database
:r sql/ddl/01_create_database.sql

-- 2. Create Bronze layer
:r sql/ddl/02_create_bronze_layer.sql

-- 3. Create Silver layer
:r sql/ddl/03_create_silver_layer.sql

-- 4. Create reference tables
:r sql/ddl/04_create_reference_tables.sql

-- 5. Create Gold layer
:r sql/ddl/05_create_gold_layer.sql
```

### Step 3: Load Data to Bronze Layer
```bash
python python/load_to_sql.py
```
**Output**: 300 rows loaded into `bronze_ed_visits` table

### Step 4: Transform to Silver Layer
```sql
-- Run ETL transformation
:r sql/dml/06_etl_bronze_to_silver.sql
```
**Output**: 300 cleaned rows in `silver_ed_visits` table

### Step 5: Validate Data Quality
```sql
-- Run quality report
:r sql/dml/07_data_quality_report.sql
```
**Output**: Data quality metrics displayed

### Step 6: Open Power BI Dashboard
1. Open `powerbi/ED_Analytics_Dashboard.pbix`
2. Update connection string to your SQL Server
3. Refresh data to populate visuals

---

## 🔍 Key Features

### Data Quality Framework

Implemented **12 automated validation rules**:

- ✅ Text standardization (UPPER/TRIM on all fields)
- ✅ Range validation (acuity 1-5, wait time 0-300 minutes)
- ✅ Null handling with rejection logic
- ✅ Outlier capping (wait times exceeding 300 minutes)
- ✅ Date/time consistency checks
- ✅ Referential integrity validation

**Result**: 100% pass rate across all validation rules

### HIPAA Compliance Measures

Safe Harbor de-identification method applied:

- 🔒 Patient IDs replaced with anonymous GUIDs (`NEWID()`)
- 🔒 Timestamps aggregated to hour-level (no exact times)
- 🔒 Age groups instead of exact ages
- 🔒 Zero PHI (Protected Health Information) in Gold analytics layer

### Power BI Dashboard Metrics

**6 Key Visuals**:
1. Average wait time by hour
2. Patient volume by acuity level
3. Peak hours analysis (10 AM - 2 PM)
4. Chief complaint distribution
5. 30-minute target achievement rate
6. Day-of-week patterns

---

## 📊 Key Insights & Findings

### Operational Bottlenecks Identified

- **Peak Hours**: 10 AM - 2 PM show 94-minute average wait times
- **Volume Patterns**: Monday and Friday have 20% higher patient volumes
- **Acuity Distribution**: 65% of visits are Level 3-4 (semi-urgent)

### Performance Metrics

- **Overall Average Wait Time**: 52 minutes
- **High-Acuity Response**: Level 1-2 patients seen within 15 minutes (98% compliance)
- **Target Achievement**: 63% of patients seen within 30-minute target

### Data-Driven Recommendations

1. **Staffing Optimization**: Increase coverage 10 AM - 2 PM (projected 15-20% wait time reduction)
2. **Fast Track Implementation**: Dedicated pathway for Level 3-4 patients
3. **Predictive Scheduling**: Use day-of-week patterns for resource allocation

---

## 📚 Documentation

Complete technical documentation available in `docs/` folder:

- **[Data Dictionary](docs/01_Data_Dictionary.md)**: Field definitions, data types, and schemas
- **[ETL Process Flow](docs/02_ETL_Process_Flow.md)**: Pipeline documentation and data lineage
- **[Data Mapping Specification](docs/03_Data_Mapping_Specification.md)**: Source-to-target transformations

---

## 💻 Sample SQL Queries

### Average Wait Time by Hour
```sql
SELECT 
    arrival_hour,
    COUNT(*) AS visit_count,
    AVG(wait_time_minutes) AS avg_wait_time,
    AVG(CASE WHEN wait_time_status = 'Met Target' THEN 1.0 ELSE 0.0 END) AS target_achievement_rate
FROM gold_ed_analytics
GROUP BY arrival_hour
ORDER BY arrival_hour;
```

### Acuity-Based Performance
```sql
SELECT 
    acuity_description,
    COUNT(*) AS total_visits,
    AVG(wait_time_minutes) AS avg_wait_time,
    MAX(wait_time_minutes) AS max_wait_time,
    MIN(wait_time_minutes) AS min_wait_time
FROM gold_ed_analytics
GROUP BY acuity_level, acuity_description
ORDER BY acuity_level;
```

### Peak Hour Analysis
```sql
SELECT 
    arrival_hour,
    arrival_day_of_week,
    COUNT(*) AS visit_count,
    AVG(wait_time_minutes) AS avg_wait_time
FROM gold_ed_analytics
WHERE arrival_hour BETWEEN 10 AND 14
GROUP BY arrival_hour, arrival_day_of_week
ORDER BY avg_wait_time DESC;
```

---

## 🎓 Skills Demonstrated

### Data Engineering
- ✅ Medallion architecture implementation (Bronze/Silver/Gold)
- ✅ ETL pipeline design with data quality validations
- ✅ Data modeling and schema design
- ✅ Healthcare data standards (Emergency Severity Index)

### SQL Proficiency
- ✅ Advanced T-SQL (CTEs, window functions, stored procedures)
- ✅ Database design and normalization
- ✅ Performance optimization techniques
- ✅ Data quality framework implementation

### Healthcare Domain
- ✅ HIPAA compliance and PHI de-identification
- ✅ Emergency Severity Index (ESI) acuity framework
- ✅ Healthcare operational metrics and KPIs
- ✅ Clinical workflow understanding

### Python Programming
- ✅ Synthetic data generation (pandas, numpy)
- ✅ Database connectivity (pyodbc)
- ✅ Data manipulation and transformation
- ✅ ETL automation scripting

### Business Intelligence
- ✅ Power BI dashboard development
- ✅ Data visualization best practices
- ✅ KPI definition and tracking
- ✅ Executive-level reporting

---

## 👥 Stakeholders & Use Cases

### Primary Stakeholders
- **ED Medical Director**: Operational decision-making and clinical workflow optimization
- **Hospital Operations Manager**: Resource allocation and staffing strategies
- **Nursing Leadership**: Daily workflow improvements
- **Quality & Patient Safety Team**: Compliance monitoring and performance tracking

### Business Use Cases
- Daily operational monitoring
- Staffing optimization planning
- Quality improvement initiatives
- Regulatory compliance reporting

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project uses synthetic data and is for portfolio demonstration purposes only.

---

## 👤 Author

**Justin O. Ajuogu**  
Data Engineer | Chicago, IL  

📧 Email: jajuogu1@gmail.com  
💼 LinkedIn: www.linkedin.com/in/justin-ajuogu  
🐙 GitHub: jagit2024

---

## 🙏 Acknowledgments

- Emergency Severity Index (ESI) Implementation Handbook
- Healthcare Information and Management Systems Society (HIMSS)
- SQL Server documentation and community resources
- Power BI community for visualization best practices

---

## 📞 Questions?

Feel free to reach out if you have questions about this project or want to discuss data engineering opportunities!

**Project Link**: (https://github.com/jagit2024/EDWT-Analysis)
