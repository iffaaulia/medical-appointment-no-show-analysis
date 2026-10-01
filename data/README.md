# Dataset

The dataset used in this project is the **Medical Appointment No Shows** dataset from Kaggle.

## Source

The original dataset is available on Kaggle:

**Medical Appointment No Shows**
Dataset by `joniarroba`

## Dataset Description

The dataset contains information about medical appointments and whether patients attended or missed their scheduled appointments.

Key variables include:

* `PatientId` – unique identifier for the patient
* `AppointmentID` – unique identifier for the appointment
* `Gender` – patient's gender
* `ScheduledDay` – date when the appointment was scheduled
* `AppointmentDay` – date of the appointment
* `Age` – patient's age
* `Neighbourhood` – location of the appointment
* `Scholarship` – whether the patient received financial assistance
* `Hipertension` – whether the patient had hypertension
* `Diabetes` – whether the patient had diabetes
* `Alcoholism` – whether the patient was recorded as having alcoholism
* `Handcap` – patient's handicap status
* `SMS_received` – whether the patient received an SMS reminder
* `No-show` – whether the patient missed the appointment

## Data Preparation

The dataset was cleaned using MySQL before exploratory analysis.

The cleaning process included:

* Cleaning and standardising the `ScheduledDay` and `AppointmentDay` fields
* Removing duplicate records
* Identifying and handling invalid age values, including negative ages
* Checking data consistency and validity before analysis

The cleaned data was then analysed using SQL and visualised in Power BI.

## Data Availability

The raw dataset is not included directly in this repository. Please refer to the original Kaggle source to access the dataset.
