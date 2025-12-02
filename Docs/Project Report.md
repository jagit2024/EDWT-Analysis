# Emergency Department Wait Time Analysis: Project Report

## Project Overview
**Author:** Justin O. Ajuogu  
**Date:** November 2025  
**Project Duration:** 4 weeks  
**Tech Stack:** SQL Server, Python, Power BI

## Executive Summary
This project involved building an end-to-end healthcare analytics pipeline to analyze Emergency Department wait times and patient flow. The goal was to demonstrate practical data engineering skills by addressing a real-world problem: how hospitals can use data to reduce ED wait times and improve operational efficiency.

## Project Objectives
- Build a complete analytics pipeline from data generation to visualization
- Process patient visit data through three transformation layers (Bronze, Silver, Gold)
- Ensure HIPAA compliance through proper de-identification
- Deliver actionable insights via an interactive dashboard
- Create comprehensive technical documentation

## Solution Architecture
The pipeline follows the medallion architecture pattern:

**Data Flow:**
Synthetic Data → Bronze Layer (raw) → Silver Layer (cleaned) → Gold Layer (analytics) → Power BI Dashboard

**Key Components:**
- 300 synthetic patient records spanning 18 days
- 12 automated data quality validation rules
- HIPAA-compliant de-identification using Safe Harbor method
- Real-time dashboard with 6 visualizations

## Technical Implementation

### Medallion Architecture
The project implemented the industry-standard Bronze → Silver → Gold pattern for several reasons:
- **Separation of concerns:** Raw data preservation versus transformation logic
- **Clear data lineage:** Easy traceability of data origins and transformations
- **Scalability:** Independent optimization of each layer
- **Audit trail:** Complete history of transformations for compliance

### Bronze Layer: Raw Data Preservation
The Bronze layer stores data exactly as received from source systems without transformations. This approach supports:
- **Debugging:** Ability to trace back to original data when issues arise
- **Compliance:** Meeting healthcare regulations requiring raw data preservation
- **Reproducibility:** Re-running transformations without re-extracting from source systems

### Silver Layer: Data Quality Engineering
The Silver layer applies 12 validation rules to ensure data quality:

**Text Standardization:**
- Convert all text to UPPERCASE
- Remove leading/trailing whitespace

**Range Validation:**
- Acuity levels must be 1-5 (Emergency Severity Index standard)
- Wait times capped at 300 minutes (5 hours maximum)
- Length of stay under 24 hours

**Derived Fields:**
- Extract hour from timestamp for hourly analysis
- Parse day of week for staffing pattern analysis
- Create date-only field for daily aggregations

### Gold Layer: Analytics-Ready Views
The Gold layer serves as the interface for business users and Power BI, with these key principles:

**HIPAA Compliance:**
- Patient IDs replaced with random GUIDs
- Exact timestamps aggregated to hour-level
- Age groups instead of exact ages
- No Protected Health Information (PHI) exposed

**Business Logic:**
- Calculate 30-minute wait time target achievement
- Determine ESI-specific target achievement
- Join reference tables for user-friendly labels

## Dashboard Implementation
The Power BI dashboard includes 6 core visualizations:

**KPI Cards:**
- Average wait time: 94 minutes
- Total patients: 300

**Charts:**
- Line chart showing wait times by hour (identifies peak times)
- Bar chart showing patient volume by acuity level
- Pie chart showing chief complaint distribution
- Donut chart showing 30-minute target achievement

**Interactivity:** The entire dashboard features cross-filtering—clicking any visual updates all others with relevant filters.

## Key Insights
Analysis of the synthetic data revealed several patterns:

**Peak Hours:**
- Highest volume between 10 AM - 2 PM (60 visits)
- Average wait time of 94 minutes overall
- **Recommendation:** Add additional triage nurses during peak hours

**Acuity Distribution:**
- Level 3 (Urgent) is the largest segment at 33% of visits
- These mid-acuity patients are at risk of long waits
- **Opportunity:** Create fast-track pathway for this segment

**Day-of-Week Patterns:**
- Monday has 20% more volume than other weekdays
- Weekend volumes are 15% lower
- **Implication:** Staffing models should reflect these patterns

## Challenges and Solutions

### Challenge 1: CSV Import Issues
**Problem:** SQL Server data type mismatch errors during BULK INSERT
**Solution:** Used Python with pandas for data cleaning, then inserted row-by-row with proper type casting
**Lesson:** Sometimes slower solutions ensure data integrity, which takes priority over performance optimization

### Challenge 2: Understanding Medallion Architecture
**Problem:** Initial perception that the three-layer pattern was overkill for a small dataset
**Solution:** Implemented the full pattern and discovered its value during transformation logic changes
**Lesson:** Good architecture pays dividends even on small projects through improved maintainability

### Challenge 3: HIPAA Compliance
**Problem:** Balancing de-identification with analytical usefulness
**Solution:** Implemented HIPAA's Safe Harbor method using SQL's NEWID() function and appropriate data aggregation
**Lesson:** Compliance is a design constraint that forces critical thinking about necessary data elements

### Challenge 4: Data Quality Without Data Loss
**Problem:** Determining appropriate strictness for validation rules
**Solution:** Implemented tiered approach with hard rejections for critical failures and soft corrections for outliers
**Lesson:** Data quality involves trade-offs that must be documented for future understanding

## Skills Developed

### Technical Skills
- **SQL:** Complex CASE statements, JOIN operations, view creation, date/time functions
- **Python:** pandas data manipulation, pyodbc for SQL Server connections, error handling
- **Power BI:** Data connection, visualization selection, cross-filtering implementation
- **Data Engineering Patterns:** Medallion architecture, ETL/ELT processes, idempotent transformations

### Professional Skills
- **Documentation:** Created data dictionary, ETL process flow, source-to-target mappings, and setup instructions
- **Problem Scoping:** Learned to define problems before jumping to solutions
- **Iterative Development:** Implemented stepwise validation before progressing through pipeline stages

## Lessons Learned

### What Worked Well
- Medallion architecture pattern proved scalable and maintainable
- Comprehensive documentation facilitated project sharing and understanding
- Synthetic data eliminated privacy concerns while allowing public sharing
- Version control through GitHub enabled effective change tracking

### Areas for Improvement
- Add automated testing for transformation logic validation
- Implement incremental loads instead of truncate-and-reload approach
- Use stored procedures for easier automation
- Include error logging for failed records and transformation errors
- Implement CI/CD with automated testing on commit

### Future Enhancements
- Real-time streaming simulation with tools like Apache Kafka or Azure Event Hub
- Predictive modeling for wait time forecasting
- Alerting mechanisms for threshold exceedances
- Multiple dashboard views for different stakeholder needs

## Business Impact Assessment
Based on the analysis of 300 patient visits, these recommendations would be presented to hospital leadership:

### Immediate Actions
1. **Increase staffing 10 AM - 2 PM:** Address disproportionate wait times during peak volume hours
2. **Implement fast-track for Level 4-5 patients:** Use nurse practitioners for low-acuity cases to free physicians for urgent care
3. **Monday surge staffing:** Adjust schedules to accommodate 20% higher Monday volumes

### Strategic Initiatives
1. **Build Level 3 optimization pathway:** Create standardized protocols for the largest patient segment
2. **Predictive scheduling:** Use historical patterns for volume forecasting and staff scheduling
3. **Enhanced patient communication:** Set expectations based on acuity level and current wait times

### Expected Outcomes
- 15-20% reduction in average wait times through optimized staffing
- 10% reduction in left-without-being-seen (LWBS) rate
- Improved patient satisfaction scores correlated with wait time perception

## Conclusion
This project demonstrated that data engineering extends beyond technical implementation to include:
- Understanding and addressing business problems
- Building maintainable systems
- Balancing data quality with practical constraints
- Creating documentation that enables knowledge transfer

The most valuable lesson was starting with the problem rather than the tools. While specific technologies may vary (PostgreSQL vs. SQL Server, Tableau vs. Power BI), the methodology remains consistent: understand data, ensure quality, deliver insights, and document thoroughly.

## Project Links
- **GitHub Repository:** [EDWT Analysis Demo]
- **Technologies:** SQL Server 2019, Python 3.x, Power BI Desktop
- **Architecture:** Medallion (Bronze/Silver/Gold)
- **Documentation:** Complete data dictionary, ETL process flow, source-to-target mappings
- **Dashboard:** 6 interactive visualizations with cross-filtering

*This project represents four weeks of intensive learning, building, debugging, and documenting. The experience has equipped me with transferable skills for real-world healthcare analytics challenges.*
