# 🏥 Medical Appointment No-Show Analysis

An end-to-end data analysis project investigating factors associated with missed medical appointments using **SQL and Power BI**.

The analysis explores appointment lead time, patient demographics, SMS reminders, previous attendance behaviour, and neighbourhood patterns to identify factors associated with medical appointment no-shows.

---

## Project Overview

Missed medical appointments can create operational challenges for healthcare providers, including unused appointment capacity and difficulties in managing patient schedules.

This project analyses a dataset of medical appointments to understand **when and for whom no-shows are more frequently observed**.

The project follows an end-to-end data analytics workflow:

**Data Cleaning → Exploratory Data Analysis → SQL Analysis → Power BI Dashboard → Insights → Recommendations**

> **Note:** This is an observational analysis. The findings describe associations and patterns in the data and should not be interpreted as evidence of causal relationships.

---

## Business Questions

This analysis aims to answer the following questions:

1. What is the overall medical appointment no-show rate?
2. Does the time between scheduling and the appointment affect attendance?
3. Does the appointment day influence no-show behaviour?
4. Which age groups have higher observed no-show rates?
5. Is there an association between SMS reminders and appointment attendance?
6. Which neighbourhoods have relatively higher no-show rates?
7. Does previous appointment behaviour relate to future no-shows?
8. Are patients with chronic conditions more or less likely to miss appointments?

---

## Tools & Technologies

| Tool            | Purpose                                                 |
| --------------- | ------------------------------------------------------- |
| **MySQL / SQL** | Data cleaning, transformation, and exploratory analysis |
| **Power Query** | Data preparation and transformation                     |
| **Power BI**    | Interactive dashboard and data visualization            |
| **DAX**         | Measures and KPI calculations                           |
| **GitHub**      | Version control and project documentation               |

---

## Repository Structure

```text
medical-appointment-no-show-analysis/
│
├── data/
│   └── README.md
│
├── documentation/
│   ├── dashboard_preview.png
│   └── exploratory-analysis.pptx
│
├── sql/
│   └── medical_appointment_analysis.sql
│
├── Power BI/
│   └── medical appointment no-show report.pbix
│
└── README.md
```

---

## Dataset

The dataset contains information about medical appointments, patient characteristics, appointment scheduling, healthcare conditions, SMS reminders, and attendance status.

### Key Variables

| Column           | Description                                       |
| ---------------- | ------------------------------------------------- |
| `PatientId`      | Unique identifier for each patient                |
| `AppointmentID`  | Unique identifier for each appointment            |
| `Gender`         | Patient gender                                    |
| `ScheduledDay`   | Date when the appointment was scheduled           |
| `AppointmentDay` | Date of the scheduled appointment                 |
| `Age`            | Patient age                                       |
| `Neighbourhood`  | Location of the appointment                       |
| `Scholarship`    | Whether the patient received financial assistance |
| `Hipertension`   | Whether the patient has hypertension              |
| `Diabetes`       | Whether the patient has diabetes                  |
| `Alcoholism`     | Whether the patient has alcoholism                |
| `Handcap`        | Recorded disability/handicap status               |
| `SMS_received`   | Whether the patient received an SMS reminder      |
| `No-show`        | Whether the patient missed the appointment        |

---

## Data Preparation

Before conducting the analysis, the dataset was reviewed and prepared to improve data quality and analytical consistency.

The preparation process included:

* Checking for duplicate records
* Reviewing missing and invalid values
* Standardising column formats
* Validating date fields
* Reviewing age values and potential outliers
* Creating derived variables for analysis
* Calculating appointment lead time
* Creating age groups
* Creating appointment-day features
* Preparing categorical variables for analysis

The cleaned dataset was then used for exploratory analysis and dashboard development.

---

## Exploratory Data Analysis

The exploratory analysis focuses on identifying patterns in appointment attendance and potential factors associated with no-shows.

### 1. Overall Attendance

The overall proportion of attended versus missed appointments was analysed to establish the baseline no-show rate.

### 2. Appointment Lead Time

The analysis investigates whether the number of days between scheduling and the appointment is associated with attendance behaviour.

Appointments were grouped into lead-time categories to make the pattern easier to compare.

### 3. Age Groups

Patients were segmented into age groups to identify differences in observed no-show rates across demographics.

### 4. SMS Reminders

The analysis compares appointment attendance between patients who received an SMS reminder and those who did not.

Importantly, this comparison represents an **association rather than a causal effect**.

Patients receiving SMS reminders may differ systematically from those who did not.

### 5. Appointment Day

Attendance patterns were compared across different days of the week.

### 6. Neighbourhood

Neighbourhood-level no-show patterns were analysed while considering appointment volume to avoid over-interpreting areas with very few appointments.

### 7. Previous Attendance Behaviour

Previous appointment behaviour was examined to understand whether historical attendance patterns are associated with future no-shows.

### 8. Health Conditions

The analysis also explores attendance patterns across patients with recorded conditions such as hypertension, diabetes, alcoholism, and disability.

---

## Power BI Dashboard

The Power BI dashboard provides an interactive view of appointment attendance and no-show patterns.

### Dashboard Preview

<p align="center">
  <img src="documentation/dashboard_preview.png" alt="Power BI Dashboard Preview" width="900">
</p>

### Dashboard Focus

The dashboard presents:

* Overall appointment volume
* No-show rate
* Attendance breakdown
* No-show patterns by lead time
* No-show patterns by age group
* SMS reminder comparisons
* Appointment-day patterns
* Neighbourhood analysis
* Patient and appointment characteristics

---

## Key Findings

### Overall No-Show Rate

Approximately **20.19% of appointments were recorded as no-shows**.

This means roughly one in five appointments in the analysed dataset was missed.

### Lead Time

Appointments with longer lead times showed higher observed no-show rates compared with appointments scheduled closer to the appointment date.

This suggests that the time between scheduling and the appointment may be an important factor to consider when analysing attendance behaviour.

### Age

Younger patient groups, particularly teenagers, showed relatively higher observed no-show rates compared with several older age groups.

### SMS Reminders

Patients who received an SMS reminder had a higher observed no-show rate than patients who did not receive one.

However, this should **not** be interpreted as evidence that SMS reminders increase no-shows.

One possible explanation is that SMS reminders may have been targeted toward appointments with higher underlying risk, such as appointments with longer lead times.

Further analysis would be required to isolate the effect of reminders.

### Neighbourhood

Some neighbourhoods showed relatively higher no-show rates.

Neighbourhood comparisons should be interpreted alongside appointment volume because areas with a small number of appointments can produce unstable percentages.

### Previous Attendance

Previous appointment behaviour provides additional information about attendance patterns and may be useful when identifying appointment groups that warrant further investigation.

---

## Business Recommendations

Based on the observed patterns, several areas could be considered for further operational investigation:

### 1. Monitor Long Lead-Time Appointments

Appointments scheduled far in advance could be monitored more closely because they show higher observed no-show rates.

### 2. Consider Targeted Reminder Strategies

Rather than evaluating SMS reminders only at an overall level, future analysis could investigate whether reminders are more effective for specific appointment groups.

### 3. Investigate Younger Patient Groups

The relatively higher no-show rates among younger patients suggest that age-specific engagement strategies could be explored.

### 4. Monitor Historical Attendance

Previous attendance behaviour could be considered as one factor when identifying appointments that may require additional follow-up.

### 5. Investigate Neighbourhood Differences

Areas with consistently higher observed no-show rates could be investigated further to understand whether operational, demographic, accessibility, or scheduling factors contribute to the observed differences.

---

## Limitations

Several limitations should be considered when interpreting the results:

* The analysis is observational and does not establish causality.
* A higher no-show rate among SMS recipients does not mean SMS reminders caused missed appointments.
* Some neighbourhoods may have relatively small appointment volumes.
* The dataset does not contain all potential factors affecting attendance, such as transportation difficulties, socioeconomic circumstances, appointment urgency, or patient-specific barriers.
* Historical patterns may not necessarily represent future behaviour.
* Some variables may contain inconsistencies or limitations inherent to the original dataset.

These limitations mean that the findings should primarily be used to identify **patterns and areas for further investigation**, rather than definitive causal explanations.

---

## Project Files

| File                                                                           | Description                                                    |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------- |
| [SQL Analysis](sql/medical_appointment_analysis.sql)                           | SQL queries used for data preparation and exploratory analysis |
| [Power BI Dashboard](Power%20BI/medical%20appointment%20no-show%20report.pbix) | Interactive Power BI report                                    |
| [Dashboard Preview](documentation/dashboard_preview.png)                       | Screenshot of the Power BI dashboard                           |
| [Exploratory Analysis](documentation/exploratory-analysis.pptx)                | Supporting exploratory analysis presentation                   |
| [Data](data/)                                                                  | Raw datasets                                    |

---

## Analytical Workflow

```text
                    ┌──────────────────┐
                    │   Raw Dataset    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Data Cleaning   │
                    │   & Preparation  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   SQL Analysis   │
                    │      & EDA       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │     Power BI     │
                    │     Dashboard    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Key Insights &  │
                    │  Recommendations │
                    └──────────────────┘
```

---

## Conclusion

This project demonstrates an end-to-end data analytics workflow using **SQL and Power BI** to investigate medical appointment no-show patterns.

The analysis identifies several observable differences across lead time, age groups, SMS reminders, neighbourhoods, and previous attendance behaviour.

Rather than treating these patterns as causal relationships, the project uses them to identify **potential areas for operational investigation and further analysis**.

---

## About

This project was created as part of my **Data Analyst portfolio**, demonstrating practical skills in:

* SQL
* Data cleaning
* Exploratory data analysis
* Data visualization
* Power BI
* DAX
* Business insight generation
* Data storytelling
* Analytical documentation

---

