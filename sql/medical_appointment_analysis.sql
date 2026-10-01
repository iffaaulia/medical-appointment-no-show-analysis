/* =======================================================
MEDICAL APPOINTMENT NO-SHOW ANALYSIS
==========================================================
Project: Medical Appointment No-Show Analysis
Purpose: Clean, transform, and explore the Medical Appointment
No Shows dataset using MySQL.

Main analysis areas:
1. Overall no-show rate
2. No-show rate by day of the week
3. No-show rate by lead time
4. No-show rate by age group
5. No-show rate by SMS reminder
6. No-show rate by neighbourhood
7. Previous appointment history and patient risk
8. Handicap status
9. Chronic disease status

Tools: - MySQL - Power BI
==========================================================
*/

/* =======================================================
SECTION 1 — INITIAL DATA INSPECTION
==========================================================
Purpose: Inspect the raw table and review the structure
and values before starting the cleaning process.
==========================================================
 */
 
-- Preview the first 10 records
SELECT * FROM medicalappointment
LIMIT 10;

-- Check the distribution of disability/handicap values
-- to understand how the original Handcap field is recorded.
SELECT 
		disability_count,
        COUNT(*)
FROM medicalappointment
GROUP BY disability_count;

-- Preview the original date fields before cleaning
SELECT ScheduledDay,
AppointmentDay
FROM medicalappointment
LIMIt 10;


/*
=========================================================
SECTION 2 — STANDARDISE COLUMN NAMES
==========================================================
Purpose: Rename columns to make them easier to work with
and more consistent in SQL and Power BI.
Notes: - Hipertension → hypertension
	   - Handcap → disability_count
       - No-show → no_show
==========================================================
*/
ALTER TABLE medicalappointment
	CHANGE COLUMN Hipertension hypertension INT,
    CHANGE COLUMN Handcap disability_count INT,
    CHANGE COLUMN `No-show` no_show VARCHAR (3);

/* 
==========================================================
SECTION 3 — CLEAN AND STANDARDISE DATE FIELDS
==========================================================
Purpose: The original ScheduledDay and AppointmentDay fields
contain date/time values in a format that is less
convenient for analysis.

The cleaned fields are converted into:
- ScheduledDay_clean → DATETIME
- AppointmentDay_clean → DATE
==========================================================
*/

-- Remove previously created cleaning columns if they exist
ALTER TABLE medicalappointment
	DROP COLUMN ScheculedDay_clean,
    DROP COLUMN AppointmentDay_clean;

-- Create new columns for the cleaned date values
ALTER TABLE medicalappointment
	ADD COLUMN ScheduledDay_clean DATETIME,
    ADD COLUMN AppointmentDay_clean DATE;

-- Convert the original date strings into proper date formats
UPDATE medicalappointment
SET ScheduledDay_clean  = str_to_date(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''), '%Y-%m-%d %H:%i:%s'),
	AppointmentDay_clean = str_to_date(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''), '%Y-%m-%d %H:%i:%s')
WHERE PatientId IS NOT NULL;

-- Verify that the cleaned date values were created correctly
SELECT ScheduledDay_clean,
AppointmentDay_clean, ScheduledDay, AppointmentDay
FROM medicalappointment
LIMIT 10;

-- Review the final table structure
DESCRIBE medicalappointment;

/*
==========================================================
SECTION 4 — RE-CLEAN DATE FIELDS
==========================================================
Purpose: Re-run the date conversion without the PatientId
condition to ensure all records are converted.

SQL_SAFE_UPDATES is temporarily disabled because
the UPDATE statement does not use a key column in its WHERE clause.
==========================================================
*/
SET SQL_SAFE_UPDATES = 0;

UPDATE medicalappointment
SET 
    ScheduledDay_clean = STR_TO_DATE(
        REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    AppointmentDay_clean = STR_TO_DATE(
        REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
        '%Y-%m-%d %H:%i:%s'
    );

SET SQL_SAFE_UPDATES = 1;

-- Verify the cleaned values again
SELECT 
    ScheduledDay,
    ScheduledDay_clean,
    AppointmentDay,
    AppointmentDay_clean
FROM medicalappointment
LIMIT 10;

/*
==========================================================
SECTION 5 — REPLACE ORIGINAL DATE COLUMNS
==========================================================
Purpose: Replace the original string-based date fields with
the cleaned DATETIME and DATE fields.
==========================================================
*/

ALTER TABLE medicalappointment
		DROP COLUMN ScheduledDay,
        DROP COLUMN AppointmentDay;
        
ALTER TABLE medicalappointment
	CHANGE COLUMN ScheduledDay_clean ScheduledDay DATETIME,
    CHANGE COLUMN AppointmentDay_clean AppointmentDay DATE;
    
-- Final check of the cleaned date columns
SELECT ScheduledDay, AppointmentDay FROM medicalappointment
LIMIT 10;

/*
==========================================================
SECTION 6 — VALIDATE AND CLEAN AGE VALUES
==========================================================
Purpose: Check the minimum and maximum age values and identify invalid negative ages.
The dataset contains an invalid age value of -1, which is removed before further analysis.
==========================================================
*/

-- Check the age range
SELECT 
	MIN(Age),
    MAX(Age)
FROM medicalappointment;

-- Temporarily disable safe updates for the DELETE statement
SET SQL_SAFE_UPDATES = 0;

-- Remove invalid negative age values
DELETE FROM medicalappointment
WHERE Age = -1;

/*
==========================================================
SECTION 7 — CREATE LEAD TIME
==========================================================
Purpose: Calculate the number of days between the appointment being scheduled
and the actual appointment date.
Lead time is later grouped into four categories: - Same Day: 0 days
												 - Short: 1–3 days
                                                 - Within a Week: 4–7 days
                                                 - Long Lead: 8+ day
==========================================================
*/

ALTER TABLE medicalappointment ADD COLUMN lead_time_days INT;

UPDATE medicalappointment
SET lead_time_days = DATEDIFF(AppointmentDay, DATE(ScheduledDay));

-- Check the minimum and maximum lead time
SELECT
MAX(lead_time_days),
MIN(lead_time_days)
FROM medicalappointment;

-- Identify records with an invalid negative lead time
SELECT * FROM medicalappointment WHERE lead_time_days<0;

-- Remove records with invalid negative lead time
DELETE FROM medicalappointment WHERE lead_time_days<0;

SET SQL_SAFE_UPDATES = 1;

/*
==========================================================
SECTION 8 — EXPLORATORY DATA ANALYSIS
==========================================================

The following queries answer the main business questions defined for this project.
==========================================================
*/

/*
----------------------------------------------------------
EDA 1 — OVERALL NO-SHOW RATE
----------------------------------------------------------

Question: What is our overall no-show rate?

Purpose: Establish the overall baseline for appointment attendance
and provide a reference point for the other analyses.
----------------------------------------------------------
*/

SELECT no_show,
	COUNT(*) as total_appointments,
    ROUND(COUNT(*) * 100.0/(SELECT COUNT(*) FROM medicalappointment),2) as
    pct_of_total
FROM medicalappointment
GROUP BY no_show;

/*
----------------------------------------------------------
EDA 2 — NO-SHOW RATE BY DAY OF THE WEEK
----------------------------------------------------------
Question: Does the day of the week matter?
Purpose: Compare appointment attendance across different days of the week.
----------------------------------------------------------
*/
   
SELECT
    DAYNAME(AppointmentDay) AS appointment_day,
    COUNT(*) AS total_appointments,
    SUM(CASE
        WHEN no_show = 'Yes' THEN 1
        ELSE 0
    END) AS no_shows,
    ROUND(
        SUM(CASE
            WHEN no_show = 'Yes' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS rate_of_no_show
FROM medicalappointment
GROUP BY DAYNAME(AppointmentDay)
ORDER BY rate_of_no_show DESC;

/*
----------------------------------------------------------
EDA 3 — NO-SHOW RATE BY LEAD TIME
----------------------------------------------------------
Question: Does lead time matter?

Lead time is grouped into four categories:
- Same Day: 0 days
- Short: 1–3 days
- Within a Week: 4–7 days
- Long Lead: 8+ days

Purpose: Compare no-show rates based on how far in advance
appointments were scheduled.
----------------------------------------------------------
*/

SELECT 
    CASE 
        WHEN lead_time_days = 0 THEN 'same day'
        WHEN lead_time_days BETWEEN 1 AND 3 THEN 'short (1-3 days)'
        WHEN lead_time_days BETWEEN 4 AND 7 THEN 'within a week'
        ELSE 'long lead'
    END AS lead_time_bucket,
    COUNT(*) AS total_appointments,
    ROUND(
        SUM(CASE 
            WHEN no_show = 'Yes' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM medicalappointment
GROUP BY lead_time_bucket
ORDER BY no_show_rate DESC;

/*
----------------------------------------------------------
EDA 4 — NO-SHOW RATE BY AGE GROUP
----------------------------------------------------------
Question: Do different age groups
have different no-show rates?
Age groups:
- Child: 0–12
- Teen: 13–19
- Young Adult: 20–39
- Adult: 40–59
- Senior: 60+
Purpose: Compare appointment attendance
across different age groups.
----------------------------------------------------------
*/

SELECT
	CASE
		WHEN Age BETWEEN 0 AND 12 THEN 'Child'
        WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
        WHEN Age BETWEEN 20 AND 39 THEN 'Young Adult'
        WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
        ELSE 'Senior'
	END as age_group,
    COUNT(*) AS total_appointments,
    ROUND(
        SUM(CASE 
            WHEN no_show = 'Yes' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM medicalappointment
GROUP BY age_group
ORDER BY no_show_rate DESC;

/*
----------------------------------------------------------
EDA 5 — NO-SHOW RATE BY SMS REMINDER
----------------------------------------------------------
Question: Is there an association between receiving an SMS reminder
and appointment attendance?
Purpose: Compare no-show rates between patients who received
an SMS reminder and those who did not.

Note: This analysis describes an association
and does not establish that SMS reminders directly caused a change in attendance.
----------------------------------------------------------
*/

SELECT 
	CASE WHEN SMS_received =1 THEN 'Received SMS' ELSE 'No SMS'
    END as sms_status,
    COUNT(*) as total_appointments,
    ROUND(
        SUM(CASE 
            WHEN no_show = 'Yes' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM medicalappointment
GROUP BY sms_status;

/*
----------------------------------------------------------
EDA 6 — NO-SHOW RATE BY NEIGHBOURHOOD
----------------------------------------------------------
Question: Which neighbourhoods have the highest no-show rates?
Method: Only neighbourhoods with at least 100 appointments are included.
Purpose: Reduce the influence of very small appointment volumes
when comparing neighbourhood-level no-show rates.
The results are ranked by no-show rate
and limited to the top 15 neighbourhoods.
----------------------------------------------------------
*/

SELECT 
	Neighbourhood,
	COUNT(*) as total_appointments,
    ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100/COUNT(*), 2) as no_show_rate,
    RANK() OVER (ORDER BY ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100/COUNT(*), 2) DESC) as risk_rank
	FROM medicalappointment
	GROUP BY Neighbourhood
	HAVING COUNT(*) >= 100
	ORDER BY no_show_rate DESC
	LIMIT 15;
    
/*
==========================================================
SECTION 9 — PATIENT APPOINTMENT HISTORY
==========================================================
Purpose: Examine whether previous appointment behaviour
is associated with the likelihood of missing the current appointment.
Two historical measures are calculated:
- prior_appointments 
- prior_no_shows

Only appointments occurring before the current appointment
are included in the historical counts.
========================================================== 
*/

SELECT
	PatientId,
    AppointmentID,
    AppointmentDay,
    no_show,
    -- Number of appointments before the current appointment
    COUNT(*) OVER (
		PARTITION BY PatientId            
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) as prior_appointments,
	-- Number of previous appointments that were missed
    SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) OVER
		(PARTITION BY PatientID
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) as prior_no_shows
	FROM medicalappointment
    ORDER BY PatientID, AppointmentID;
    
/*
----------------------------------------------------------
PATIENT-LEVEL RISK VIEW
----------------------------------------------------------
Purpose: Create a reusable view that combines appointment history,
lead time, and previous no-show behaviour
into patient-level appointment risk features.

Features created:
- prior_appointments 
- prior_no_shows 
- prior_no_show_rate 
- risk_tier

Risk tiers are rule-based and intended for exploratory
segmentation rather than predictive modelling.
----------------------------------------------------------
*/

CREATE VIEW v_appointment_risk AS
WITH patient_history AS (
	SELECT
		PatientID,
        AppointmentID,
        AppointmentDay,
        Neighbourhood,
        lead_time_days,
        sms_received,
        Scholarship,
        no_show,
        -- Count of previous appointments
        COUNT(*) OVER (
			PARTITION BY PatientID
            ORDER BY AppointmentDay
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS prior_appointments,
        -- Count of previous no-shows
		SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) OVER(
			PARTITION BY PatientID
            ORDER BY AppointmentDay
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS prior_no_shows
	FROM medicalappointment
)
SELECT 
	PatientId,
    AppointmentID,
    AppointmentDay,
    Neighbourhood,
    lead_time_days,
    prior_appointments,
    prior_no_shows,
    -- Previous no-show rate
    ROUND(prior_no_shows / NULLIF(prior_appointments,0), 2) AS prior_no_show_rate,
    -- Rule-based risk segmentation
	CASE
		WHEN prior_appointments = 0 THEN 'New Patient - Monitor'
        WHEN (prior_no_shows / NULLIF(prior_appointments, 0)) >= 0.5
			OR lead_time_days>= 8 THEN 'High Risk'
		WHEN (prior_no_shows / NULLIF(prior_appointments, 0)) >= 0.2
			OR lead_time_days BETWEEN 4 AND 7 THEN 'Medium Risk'
		ELSE 'Low Risk'
	END AS risk_tier
FROM patient_history;

/*
----------------------------------------------------------
REVIEW HIGH-RISK APPOINTMENTS
----------------------------------------------------------
Purpose: Review examples of appointments
classified as "High Risk" by the rule-based risk segmentation.
----------------------------------------------------------
*/

SELECT * FROM v_appointment_risk
WHERE risk_tier = 'High Risk'
ORDER BY AppointmentDay
LIMIT 50;

/*
----------------------------------------------------------
REVIEW THE COMPLETE RISK VIEW
----------------------------------------------------------
*/
SELECT * FROM medicalappointment;

SELECT * FROM v_appointment_risk;


/*
========================================================== 
EDA 7 — PREVIOUS APPOINTMENT HISTORY
 ==========================================================
 The v_appointment_risk view can be used to further
 investigate the relationship between previous appointment behaviour
 and current appointment attendance.
 The key variables available for analysis are:
 - prior_appointments 
 - prior_no_shows 
 - prior_no_show_rate 
 - risk_tier
 ==========================================================
 */

/*
==========================================================
EDA 8 — HANDICAP / DISABILITY STATUS
==========================================================
Question: Is there an association between handicap status
and appointment attendance?
Classification: 
- Handicap Patient: disability_count between 1 and 4 
- Non-Handicap Patient: all other values 
Purpose: Compare no-show rates between the two groups.
==========================================================
*/

SELECT 
    CASE 
        WHEN disability_count BETWEEN 1 AND 4 THEN 'Handicap Patient'
        ELSE 'Non-Handicap Patient'
    END AS Disability,
        COUNT(*) AS total_appointments,
        ROUND(
        SUM(
            CASE 
                WHEN no_show = 'Yes' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM medicalappointment
GROUP BY 
		 CASE 
        WHEN disability_count BETWEEN 1 AND 4 THEN 'Handicap Patient'
        ELSE 'Non-Handicap Patient'
    END;
 
/*
==========================================================
EDA 9 — CHRONIC DISEASE STATUS
==========================================================
Question: Are patients with chronic disease more
or less likely to miss their appointments compared with
non-chronic patients?

Definition used in this project:
A patient is classified as having a chronic disease if they have either:
- Diabetes OR
- Hypertension

Purpose: Compare no-show rates between chronic disease
and non-chronic disease groups.
==========================================================
*/

SELECT 
    CASE 
        WHEN Diabetes = 1 OR Hypertension = 1 
            THEN 'Chronic Disease'
        ELSE 'Non-Chronic Disease'
    END AS chronic_disease_status,
    COUNT(*) AS total_appointments,
    ROUND(
        SUM(
            CASE 
                WHEN no_show = 'Yes' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS no_show_rate
FROM medicalappointment
GROUP BY 
    CASE 
        WHEN Diabetes = 1 OR Hypertension = 1 
            THEN 'Chronic Disease'
        ELSE 'Non-Chronic Disease'
    END
ORDER BY chronic_disease_status;

/*
==========================================================
END OF ANALYSIS
==========================================================
The cleaned and analysed data was subsequently
used to build an interactive Power BI dashboard.
Power BI analysis includes:
- Overall no-show rate
- Day of the week
- Lead time
- Age groups
- SMS reminders
- Scholarship status
- Neighbourhood
- Previous appointment history 
- Handicap status 
- Chronic disease status
==========================================================
*/