-- Data cleaning for survey report data

-- Remkark : Q1 = Which Title Best Fits your Current Role?
-- Q2 = Did you switch careers into Data?
-- Q3 = Current Yearly Salary (in USD)
-- Q4 = What Industry do you Work in?
-- Q5 = Favorite Programming Language
-- Q6 = How Happ are you in your Current Position With the following
-- Q61 = Salary
-- Q62 = Work Life Balance
-- Q63 = Coworkers
-- Q64 = Management
-- Q65 = Upward Mobility
-- Q66 = Learning New Things
-- Q7 = How difficult was it for you to break into Data?
-- Q8 =  If you were to look for a new job today, what would be the most important thing to you?
-- Q9 = Male/female
-- Q10 = Age
-- Q11 = Country you love in
-- Q12 = Education level
-- Q13 = Ethnicity


SELECT *
FROM raw_data
;

CREATE TABLE data_staging1
LIKE raw_data
;

INSERT data_staging1
SELECT *
FROM raw_data
;

SELECT * 
FROM data_staging1
;

-- Check for any duplicate

SELECT * , 
ROW_NUMBER() OVER(PARTITION BY unique_id) AS row_num 
FROM data_staging1
;

WITH duplicate_check AS
(
SELECT * , 
ROW_NUMBER() OVER(PARTITION BY unique_id) AS row_num 
FROM data_staging1
)

SELECT *
FROM duplicate_check
WHERE row_num > 1
;

-- Standardizing data

SELECT * 
FROM data_staging1
;

-- Changing date format

SELECT `Date_Taken`
FROM data_staging1
;

UPDATE data_staging1
SET `Date_Taken` = str_to_date(`Date_Taken`, '%m/%d/%Y')
;

ALTER TABLE data_staging1
MODIFY COLUMN `Date_Taken` DATE
;

-- Check Q1 row

SELECT DISTINCT Q1
FROM data_staging1
ORDER BY 1
;

SELECT DISTINCT Q1
FROM data_staging1
WHERE Q1 LIKE "Other (Please Specify):Business Ana%"
;

UPDATE data_staging1
SET Q1 = TRIM(TRAILING FROM Q1)
;

UPDATE data_staging1
SET Q1 = 'Other (Please Specify):Business Analyst'
WHERE Q1 LIKE "Other (Please Specify):Business Ana%"
;

-- Check Q4 row

SELECT DISTINCT Q4
FROM data_staging1
ORDER BY 1
;

SELECT DISTINCT Q4
FROM data_staging1
WHERE Q4 LIKE "Other (Please Specify):Automotive"
;

UPDATE data_staging1
SET Q4 = TRIM(TRAILING FROM Q4)
;

SELECT DISTINCT Q4
FROM data_staging1
WHERE Q4 LIKE 'Other (Please Specify):Air transpo'
;

UPDATE data_staging1
SET Q4 = 'Other (Please Specify):Air Transport'
WHERE Q4 LIKE 'Other (Please Specify):Air transpo'
;

UPDATE data_staging1
SET Q4 = 'Other (Please Specify):Manufacturering'
WHERE Q4 LIKE 'Other (Please Specify): Manufacturering'
;

UPDATE data_staging1
SET Q4 = 'Other (Please Specify):Consulting'
WHERE Q4 LIKE 'Other (Please Specify):Consulti'
;

UPDATE data_staging1
SET Q4 = 'Other (Please Specify):E-commerce'
WHERE Q4 LIKE 'Other (Please Specify):Ecom%'
;

UPDATE data_staging1
SET Q4 = 'Other (Please Specify):Food & Beverage'
WHERE Q4 LIKE 'Other (Please Specify):Food and%'
;

-- Check Q5 row

SELECT DISTINCT Q5
FROM data_staging1
ORDER BY 1
;

UPDATE data_staging1
SET Q5 = TRIM(TRAILING FROM Q5)
;

UPDATE data_staging1
SET Q5 = 'Other:None'
WHERE Q5 LIKE 'Other:N%'
;

-- Check Q11 row

SELECT DISTINCT Q11
FROM data_staging1
ORDER BY 1
;

UPDATE data_staging1
SET Q11 = TRIM(TRAILING FROM Q11)
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Argentina'
WHERE Q11 LIKE 'Other (Please Specify):Argentine'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Australia'
WHERE Q11 LIKE 'Other (Please Specify):Austr'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Brazil'
WHERE Q11 LIKE 'Other (Please Specify):Brazik'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Nigeria'
WHERE Q11 LIKE 'Other (Please Specify):Niger'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Portugal'
WHERE Q11 LIKE 'Other (Please Specify):Portug%'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Singapore'
WHERE Q11 LIKE 'Other (Please Specify):SG'
;

UPDATE data_staging1
SET Q11 = 'Other (Please Specify):Tunisia'
WHERE Q11 LIKE 'Other (Please Specify):TUNISIA'
;

-- Check Q13 row

SELECT DISTINCT Q13
FROM data_staging1
ORDER BY 1
;

UPDATE data_staging1
SET Q13 = TRIM(TRAILING FROM Q13)
;

-- Theres some unanswered question on 'Specify', but for now we will let it to gather the data, for deleting it, depends of company regulation

SELECT * 
FROM data_staging1
;

CREATE TABLE data_staging2
LIKE data_staging1
;

INSERT data_staging2
SELECT *
FROM data_staging1
;

SELECT * 
FROM data_staging2
;

ALTER TABLE data_staging2
DROP COLUMN Browser;

ALTER TABLE data_staging2
DROP COLUMN OS;

ALTER TABLE data_staging2
DROP COLUMN City;

ALTER TABLE data_staging2
DROP COLUMN Country;

ALTER TABLE data_staging2
DROP COLUMN Referrer;
