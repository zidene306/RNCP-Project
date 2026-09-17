# 5G Mobile Network Performance in Metropolitan France

## Project Overview

This project investigates **territorial disparities in 5G mobile network performance in Metropolitan France** and explores potential factors associated with these differences.

The central research question is:

> **Are there significant territorial inequalities in mobile network performance in France, and what can explain these disparities?**

The project combines:

* **ARCEP 5G Quality of Service (QoS)** measurements
* **ARCEP mobile network site infrastructure**
* **INSEE demographic data**
* **INSEE geographical reference data**

The resulting analytical dataset is used for exploratory analysis, statistical testing and interactive visualization in Power BI.

This project was developed as part of the **Ironhack Data Analytics Bootcamp** and the **RNCP 37827 Data Analyst certification project**.

**Training period:** May 4th – July 3rd

---

# 1. Project Objectives

The project aims to:

* Measure and compare 5G network performance across French territories.
* Identify differences in performance between mobile network operators.
* Examine differences in 5G network deployment.
* Investigate relationships between network performance and population.
* Analyze the relationship between download speed and radio conditions.
* Statistically test whether observed operator differences are significant.
* Develop an interactive Power BI dashboard to communicate the findings.

---

# 2. Research Questions

The analysis addresses the following questions:

1. How does 5G network performance vary across French territories?
2. Are there significant differences in download speed between operators?
3. How does 5G infrastructure deployment vary between operators and territories?
4. Is population associated with 5G download performance?
5. How are radio indicators such as RSRP and RSRQ related to download speed?
6. Can infrastructure, demographic and radio characteristics help explain observed performance disparities?

---

# 3. Data Sources

Three principal data sources are used.

| Source | Data                 | Acquisition method           | Purpose                                 |
| ------ | -------------------- | ---------------------------- | --------------------------------------- |
| ARCEP  | 5G QoS measurements  | Web scraping / file download | Network performance                     |
| ARCEP  | Mobile network sites | File download                | Infrastructure and 5G deployment        |
| INSEE  | Population           | Melodi API                   | Demographic information                 |
| INSEE  | Geographic reference | INSEE reference data         | Commune → department → region hierarchy |

---

# 4. ARCEP — 5G QoS Data

## Acquisition

The ARCEP 5G QoS dataset was acquired from the ARCEP data platform.

**Acquisition method:** Web scraping / automated file retrieval

**Raw file:**

```text
../data/raw/2025_QoS_Metropole_data_habitations.csv
```

### Initial dataset

The raw dataset contained:

* **354,282 measurement records**
* **5G measurements**
* **4 mobile network operators**
* An `insee_com` geographic identifier for every record
* **1,614 distinct geographic codes**

Four problematic geographic codes were excluded from the analytical dataset:

```text
12076
92201
44701
69159
```

This resulted in:

> **1,610 communes represented in the final QoS analysis.**

The ARCEP QoS dataset is the **main performance dataset** of the project.

---

# 5. ARCEP QoS Protocols and KPIs

ARCEP provides several types of mobile network tests.

| Protocol | Test               | Main fields                                   |
| -------- | ------------------ | --------------------------------------------- |
| SMS      | SMS transmission   | Success, delay, sending/receiving information |
| VOIX     | Voice call         | MOS, call setup and communication indicators  |
| WEB      | Web page loading   | Access duration, loading indicators, URL      |
| STREAM   | Video quality      | Correct and perfect quality, freezing         |
| PING     | Network access     | Ping result                                   |
| DLH      | 5 MB file download | Download bitrate and transfer indicators      |
| ULH      | 1 MB file upload   | Upload bitrate and transfer indicators        |
| DOWNLOAD | 250 MB download    | Download bitrate and transfer indicators      |
| UPLOAD   | 50 MB upload       | Upload bitrate and transfer indicators        |

The analytical project focuses on the four principal 5G QoS protocols:

```text
5G QoS
│
├── WEB
│   ├── Access duration
│   ├── Loaded < 5 seconds
│   └── Loaded < 10 seconds
│
├── STREAM
│   ├── Correct quality
│   └── Perfect quality
│
├── DOWNLOAD
│   └── Download bitrate
│
├── UPLOAD
│   └── Upload bitrate
│
└── RADIO CONDITIONS
    ├── RSRP
    └── RSRQ
```

## Main KPIs

### WEB

* `acess_duration`
* `loaded_in_less_5_secondes`
* `loaded_in_less_10_secondes`

### STREAM

* `quality_correct`
* `quality_perfect`

### DOWNLOAD

* `bitrate_dl`

### UPLOAD

* `bitrate_ul`

### Radio conditions

* `rsrp`
* `rsrq`

---

# 6. Radio Environment Indicators

Two radio indicators are used to investigate the relationship between radio conditions and 5G performance.

### RSRP — Reference Signal Received Power

RSRP measures the received signal power of the reference signal.

It is expressed in dBm and is used as an indicator of **signal strength**.

### RSRQ — Reference Signal Received Quality

RSRQ measures the quality of the received reference signal.

It is expressed in dB and provides information about **radio/network conditions**.

These indicators are analyzed in relation to download speed to investigate whether radio conditions are associated with observed performance.

---

# 7. INSEE — Population Data

## Objective

The objective of the INSEE data integration is to:

> **Enrich ARCEP 5G performance measurements with demographic information at commune level.**

---

## Source Selection

INSEE was selected because it is the **official French statistical institute** and provides statistical and territorial data at multiple geographic levels.

Several INSEE data services were considered:

```text
INSEE
│
├── Sirene → companies ❌
├── BDM → economic / time series ❌
├── Local Data → legacy / being replaced ❌
│
└── Melodi → statistical datasets ✅
                         │
                         ▼
                Commune-level data
```

The **INSEE Melodi API** was selected because it provides programmatic access to statistical datasets available through the INSEE data catalogue.

API:

[INSEE Melodi API](https://api.insee.fr/melodi?utm_source=chatgpt.com)

---

# 8. INSEE Melodi API — Dataset Selection

The selected dataset is:

```text
DS_POPULATIONS_REFERENCE
```

### Reason for selection

The dataset provides reference population information at commune level and is therefore suitable for enriching the ARCEP QoS measurements.

### Variables selected

| Variable         | Selection | Meaning               |
| ---------------- | --------- | --------------------- |
| `GEO`            | `COM`     | Commune               |
| `TIME_PERIOD`    | `2023`    | Reference year        |
| `POPREF_MEASURE` | `PMUN`    | Population municipale |

The extracted population data contains:

```text
insee_com
year
measure
population
```

with:

```text
year = 2023
measure = PMUN
```

---

# 9. Geographic Reference Data

A geographic reference table was created to establish the territorial hierarchy:

```text
Commune
   │
   └── Department
          │
          └── Region
```

The table contains:

```text
insee_com
com_name
insee_dep
dep_name
insee_reg
reg_name
```

Example:

| insee_com | com_name              | insee_dep | dep_name | insee_reg | reg_name             |
| --------- | --------------------- | --------- | -------- | --------- | -------------------- |
| 01001     | ABERGEMENT CLEMENCIAT | 01        | AIN      | 84        | AUVERGNE RHONE ALPES |
| 01002     | ABERGEMENT DE VAREY   | 01        | AIN      | 84        | AUVERGNE RHONE ALPES |
| 01004     | AMBERIEU EN BUGEY     | 01        | AIN      | 84        | AUVERGNE RHONE ALPES |

This geographic hierarchy is used to aggregate and visualize QoS results at regional and departmental levels.

---

# 10. Data Integration

The main integration key is the **commune INSEE code**:

```text
insee_com
```

This common identifier connects the datasets:

```text
ARCEP QoS
    │
    │ insee_com
    ▼
Geographic Reference
    │
    ├── Commune
    ├── Department
    └── Region
    │
    │ insee_com
    ▼
INSEE Population
```

The same geographic key is also used to connect ARCEP QoS measurements with mobile-site information.

---

# 11. ARCEP Mobile Sites

The ARCEP mobile-site dataset provides information about network infrastructure at commune level.

The analysis uses infrastructure indicators including:

* Total physical sites
* 4G sites
* Real 5G sites
* Operator-level 5G deployment

The project deliberately excludes aggregated **"fake 5G"** indicators based on 5G using existing 4G frequency bands.

The analysis therefore focuses on:

> **Physical sites + 4G + real 5G deployment**

This avoids combining different technologies into a single deployment indicator and keeps the interpretation focused on actual 5G deployment.

---

# 12. Geographic Coverage and Data Validation

A comparison was performed between the geographical coverage of the QoS and mobile-site datasets.

| Check                      |     Result | Interpretation                                  |
| -------------------------- | ---------: | ----------------------------------------------- |
| QoS communes               |  **1,610** | Communes represented in QoS measurements        |
| Sites communes             | **20,690** | Communes represented in the mobile-site dataset |
| QoS communes without Sites |    **124** | QoS communes with no matching site record       |
| Those 124 in DIM_GEO       |    **124** | All have valid geographic references            |

The 124 communes without a matching mobile-site record were therefore **not treated as invalid geographic codes**.

All 124 were successfully found in the geographic reference table (`DIM_GEO`), confirming that they are valid geographical references.

This distinction is important:

> **Missing infrastructure records do not necessarily mean invalid geographical records.**

---

# 13. Data Processing Pipeline

The project follows a reproducible data pipeline:

```text
                RAW DATA
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
    ARCEP        ARCEP       INSEE
     QoS          Sites       API
       │           │           │
       └───────────┼───────────┘
                   ▼
          DATA CLEANING
                   │
                   ▼
       GEOGRAPHIC STANDARDIZATION
                   │
                   ▼
          DATA INTEGRATION
                   │
          ┌────────┴────────┐
          ▼                 ▼
       MySQL             BigQuery
          │                 │
          └────────┬────────┘
                   ▼
           ANALYTICAL DATASET
                   │
          ┌────────┴─────────┐
          ▼                  ▼
        Python             Power BI
          │
          ▼
   EDA + Statistical Tests
```

Raw datasets are preserved separately from processed datasets to maintain traceability and reproducibility.

---

# 14. Database Architecture

## MySQL

A relational database was created to structure the cleaned datasets.

Database:

```text
mobile_5g_network_fr
```

The relational architecture separates the main data entities and uses geographical and operator identifiers to establish relationships.

---

## BigQuery

A denormalized analytical dataset was created in Google BigQuery for analytical processing and visualization.

Project:

```text
capstoneproject-500310
```

Dataset:

```text
mobile_5g_network_fr
```

The analytical table combines:

* QoS measurements
* Operator information
* Commune information
* Department and region information
* Population
* Mobile-site infrastructure indicators

### BigQuery optimization

The table is:

* **Partitioned by:** `date_start`
* **Clustered by:** `operator_name`, `protocol_code`, `insee_dep`, `insee_com`

This architecture supports analytical queries while retaining the measurement-level granularity of the QoS data.

---

# 15. Exploratory Data Analysis

The exploratory analysis investigates performance differences according to:

* Operator
* Region
* Population
* Network infrastructure
* Radio environment

The main KPI for explaining 5G performance disparities is:

> **Download bitrate**

Other QoS indicators are retained to provide broader context.

---

# 16. Operator Performance

The observed average download-speed ordering was:

```text
Orange
Bouygues Telecom
SFR
Free Mobile
```

The analysis also examined real 5G deployment.

The observed deployment pattern differs from the download-speed pattern, showing that:

> **The quantity of 5G deployment alone does not directly determine measured download performance.**

Operator-specific differences and deployment strategies therefore need to be considered when interpreting network performance.

---

# 17. Infrastructure and Download Performance

The relationship between infrastructure and download speed was examined both globally and by operator.

The aggregated analysis showed a negative relationship between the number of sites and download speed.

However, when operators were analyzed individually, the relationship was predominantly positive.

This illustrates an important analytical point:

> **Aggregated relationships can hide operator-specific patterns.**

Consequently, infrastructure should not be interpreted independently from operator characteristics and deployment strategies.

---

# 18. Population and Download Performance

Population was compared with regional download performance.

The overall relationship was positive, although its strength varied between operators.

Spearman correlation was used to measure the strength and direction of the relationship.

The analysis indicates an **association**, not a causal relationship.

Population alone therefore cannot be considered a complete explanation for differences in 5G performance.

---

# 19. Radio Conditions and Download Performance

The analysis also examined the relationship between radio conditions and download speed.

### RSRP

The relationship between RSRP and download speed was positive overall and also positive when considering operators individually.

This is consistent with the role of signal strength in mobile network performance.

### RSRQ

The relationship between RSRQ and download speed was more heterogeneous.

The aggregated relationship was positive, while operator-level relationships differed.

This indicates that radio quality interacts with other factors and should not be interpreted as a single independent explanation for performance disparities.

---

# 20. Statistical Testing

A one-way ANOVA was conducted to determine whether the mean download speeds of the four operators were statistically equal.

## Hypotheses

### H₀ — Null hypothesis

> The mean download speed is equal across the four operators.

### H₁ — Alternative hypothesis

> At least one operator has a different mean download speed.

## Results

The ANOVA produced:

```text
F = 32.44
p = 1.32 × 10⁻¹¹
```

Since:

```text
p < 0.05
```

the null hypothesis is rejected.

Therefore:

> **There is statistically significant evidence that the four operators do not all have the same mean download speed.**

The ANOVA does **not** establish that every pair of operators differs significantly. Pairwise differences would require a post-hoc test such as Tukey's HSD.

---

# 21. Main Findings

The analysis identifies measurable differences in 5G performance across operators and territories.

Several dimensions are associated with these disparities:

* Operator-specific characteristics
* 5G infrastructure deployment
* Population
* Radio conditions
* Territorial characteristics

The results also demonstrate that relationships can change depending on the level of aggregation.

For example, an overall relationship between infrastructure and performance can differ from the relationships observed when operators are analyzed individually.

The findings therefore support a **multidimensional analysis of network performance rather than relying on a single explanatory variable**.

---

# 22. Power BI Dashboard

A Power BI dashboard was developed to communicate the main findings interactively.

The dashboard provides views of:

* 5G performance
* Operator differences
* Regional disparities
* 5G deployment
* Population
* Radio environment
* Relationships between explanatory variables

The dashboard is designed to support the analytical story rather than simply display individual KPIs.

---

# 23. Challenges

Several challenges were encountered during the project.

### Data integration

The datasets originate from different organizations and have different structures, granularities and purposes.

The main integration challenge was establishing consistent geographical identifiers between:

* QoS measurements
* Mobile sites
* Population
* Geographic reference data

### Data quality

The project required:

* Validation of INSEE codes
* Identification of problematic geographic codes
* Handling of missing infrastructure matches
* Standardization of operator and geographical information
* Validation of joins

### Different geographic granularities

QoS measurements, infrastructure information and demographic information do not necessarily represent the same geographical level.

This creates an important methodological limitation when comparing measurement-level performance with commune-, department- or region-level characteristics.

### Explaining performance differences

Correlation analysis can identify associations but cannot demonstrate causality.

A complete explanation of network performance would require additional variables such as:

* Traffic/load
* Topography
* Building characteristics
* Spectrum configuration
* Backhaul capacity
* More detailed network configuration information

---

# 24. Next Steps

Several extensions could deepen the analysis.

## Finer territorial analysis

Extend the analysis from regions to:

* Departments
* Communes
* More localized geographic areas

## Additional explanatory variables

Potential additional variables include:

* Population density
* Urban/rural classification
* Topography
* Land use
* Building density
* Spectrum characteristics

## Temporal analysis

Analyze how 5G performance evolves over time as network deployment progresses.

## Operator-level analysis

Investigate how different network deployment strategies relate to observed performance.

## Predictive modelling

Explore whether demographic, infrastructure and environmental variables can be used to predict network performance.

---

# 25. Project Structure

A simplified project structure is:

```text
RNCP-Project/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── ...
│
├── notebooks/
│   ├── data_collection/
│   ├── data_cleaning/
│   ├── exploratory_analysis/
│   └── statistical_analysis/
│
├── sql/
│   ├── mysql/
│   └── bigquery/
│
├── powerbi/
│   └── input_files/
│
├── functions.py
├── config.yaml
├── requirements.txt
└── README.md
```

The exact structure may evolve during project development.

---

# 26. Technologies

## Programming & Data Analysis

* Python
* Pandas
* NumPy
* SciPy
* Matplotlib

## Data Acquisition

* Web scraping / automated file retrieval
* REST API
* INSEE Melodi API

## Databases & Cloud

* MySQL
* Google BigQuery

## Visualization

* Microsoft Power BI

## Project Management

* Jira / task-based project planning

## Data Providers

* ARCEP
* INSEE

---

# 27. Reproducibility

The project follows the following workflow:

1. Acquire raw data.
2. Preserve raw source files.
3. Clean each source independently.
4. Validate geographical identifiers.
5. Standardize commune, department and region information.
6. Integrate population and infrastructure data.
7. Load structured data into MySQL.
8. Create a denormalized analytical dataset in BigQuery.
9. Perform exploratory data analysis.
10. Perform statistical testing.
11. Build Power BI visualizations.
12. Interpret and document the results.

Raw data is kept separate from processed data and should not be overwritten during transformation.

---

# 28. Limitations

The results should be interpreted within the scope of the available data.

### Geographic limitations

The study focuses on **Metropolitan France**.

### Measurement limitations

QoS measurements represent sampled measurement locations rather than the experience of every mobile user.

### Aggregation limitations

Population and infrastructure information is aggregated at commune level, while QoS observations represent individual measurement records.

### Causality limitations

Observed correlations do not establish causal relationships.

### Explanatory-variable limitations

The project does not include all factors that may affect mobile network performance.

### Temporal limitations

The QoS analysis covers a specific measurement period in 2025, while population data is based on the selected 2023 reference population.

---

# 29. Conclusion

This project provides a data-driven investigation of **5G mobile network performance disparities in Metropolitan France**.

By combining:

* ARCEP QoS measurements,
* ARCEP mobile-site infrastructure,
* INSEE population data,
* and INSEE geographic reference data,

the project examines network performance from both an **operator** and **territorial** perspective.

The statistical analysis provides significant evidence that the four operators do not all have the same mean download speed.

The exploratory analysis further shows that infrastructure deployment, population and radio conditions are associated with performance, but that these relationships can vary by operator and level of aggregation.

The project therefore demonstrates the importance of combining multiple data sources and analytical approaches when investigating territorial disparities in mobile network performance.

---

# 30. Skills Demonstrated

This project demonstrates an end-to-end Data Analyst workflow:

```text
Data Acquisition
       ↓
Web Scraping + API
       ↓
Data Cleaning & Validation
       ↓
Data Integration
       ↓
Relational Database Design
       ↓
MySQL
       ↓
BigQuery
       ↓
Exploratory Data Analysis
       ↓
Statistical Testing
       ↓
Power BI
       ↓
Data Storytelling & Interpretation
```

The project demonstrates practical skills in:

* Python
* Data cleaning
* API data extraction
* Web data acquisition
* Data integration
* SQL
* Relational database design
* Big Data processing
* Statistical analysis
* Data visualization
* Power BI
* Data storytelling
* Analytical interpretation

---

# Author

**Zidene Aourdache**

Data Analyst | Telecom Network Engineering

**Ironhack Data Analytics Bootcamp**

**RNCP 37827 — Data Analyst Certification Project**

**Training period:** May 4th – July 3rd
