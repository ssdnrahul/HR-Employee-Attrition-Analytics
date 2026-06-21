-- =====================================
-- HR ANALYTICS SQL PROJECT
-- Author: Rahul Chhabra
-- =====================================

/* ============================================================
     Employee Attrition Analysis using MySQL
   ============================================================ */

CREATE DATABASE hr_analytics;
USE hr_analytics;

-- Total Employees
SELECT COUNT(*) FROM Employees;  #1470 records

-- Q1. Total Employees Who Left the Company

SELECT COUNT(*) AS Employees_Left
FROM Employees
WHERE Attrition="Yes";  #237 left the company

-- Q2. Overall Attrition Rate
SELECT 
ROUND(SUM(CASE WHEN Attrition="Yes" THEN 1 ELSE 0 END)
/
COUNT(*)*100,2) AS Attrition_rate
FROM Employees;    							 #Attrition_rate = 16.12

-- Q3. Department-wise Attrition Rate

SELECT Department, 
ROUND(SUM(CASE WHEN Attrition="Yes" THEN 1 ELSE 0 END)
/
COUNT(*)*100,2) AS Attrition_rate
FROM Employees 
GROUP BY Department
ORDER BY Attrition_rate DESC;    

/* Sales department records the highest attrition rate (20.63%),
indicating a greater employee turnover risk compared to other departments. */

-- Q4. Job Role-wise Attrition Rate
SELECT JobRole, 
ROUND(SUM(CASE WHEN Attrition="Yes" THEN 1 ELSE 0 END)
/
COUNT(*)*100,2) AS Attrition_rate
FROM Employees 
GROUP BY JobRole
ORDER BY Attrition_rate DESC;  

/*Sales Representatives experience the highest attrition rate (39.76%),
making this role the most vulnerable to employee turnover. */

-- Q5. Overtime Attrition Rate

SELECT 
ROUND(SUM(CASE WHEN Attrition="Yes" AND OverTime="Yes" THEN 1 ELSE 0 END)/
SUM(CASE WHEN OverTime="Yes" THEN 1 ELSE 0 END)*100,2) AS Overtime_Attrition
FROM Employees;								

/*Employees working overtime show an attrition rate of 30.53%,
which is nearly double the overall company attrition rate (16.12%). */

-- Q6. Attrition by Age Group

WITH ninjas AS(
SELECT Attrition,
CASE WHEN Age <=30 THEN "18-30"
WHEN Age<=40 THEN "31-40"
WHEN Age<=50 THEN "41-50"
ELSE "51-60"
END AS Age_Group
FROM Employees
)
SELECT Age_Group, 
ROUND(SUM(CASE WHEN Attrition="Yes" THEN 1 ELSE 0 END)/
COUNT(*)*100,2) AS Attrition_rate
FROM ninjas
GROUP BY Age_Group
ORDER BY Attrition_rate DESC;				

/*Employees aged 18-30 exhibit the highest attrition rate (25.91%),
suggesting younger employees are more likely to leave the organization. */


-- Q7. Salary Group vs Attrition

WITH ninjas AS(
SELECT Attrition,
CASE WHEN MonthlyIncome < 5000 THEN "Low"
WHEN MonthlyIncome < 10000 THEN "Medium"
ELSE "High" END AS Salary_Group
FROM Employees
)
SELECT Salary_Group,
ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)/ 
COUNT(*)*100,2) AS Salary_Attrition_per
FROM ninjas
GROUP BY Salary_Group
ORDER BY Salary_Attrition_per DESC;  
 /*Employees in the low salary group have the highest attrition rate (21.76%), 
 suggesting compensation may be a key driver of employee turnover.*/

-- Q8. Promotion Gap vs Attrition
WITH ninjas AS(
SELECT Attrition,
CASE WHEN YearsSinceLastPromotion <= 3 THEN "0-3 Years"
WHEN YearsSinceLastPromotion <= 7 THEN "4-7 Years"
WHEN YearsSinceLastPromotion <=11 THEN "8-11 Years"
ELSE "12+ Years" END AS Promotion_Group
FROM Employees)
SELECT Promotion_Group,
ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)/ 
COUNT(*)*100,2) AS promotion_attrition_per
FROM ninjas
GROUP BY Promotion_Group
ORDER BY promotion_attrition_per DESC;       

/* Employees in the 0-3 years promotion band show the highest attrition rate (16.97%).
However, promotion gap alone does not appear to be a strong predictor of attrition and 
should be evaluated alongside tenure, salary, and job satisfaction.*/

-- Q9. Marital Status vs Attrition

SELECT MaritalStatus,
ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)/
COUNT(*)*100,2) AS Marital_attrition_per
FROM Employees
GROUP BY MaritalStatus
ORDER BY Marital_attrition_per DESC;		

/* Single employees have the highest attrition rate (25.53%),
indicating they are more likely to leave compared to married or divorced employees. */

-- Q10. Work-Life Balance vs Attrition
SELECT WorkLifeBalance,
ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)/
COUNT(*)*100,2) AS wlb_attrition_per
FROM Employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance; 		
/*Employees reporting poor work-life balance (Rating 1) had the highest attrition rate (31.25%), 
indicating that work-life balance is a key factor influencing employee retention.*/

/* ============================================================
   WORKFORCE DEMOGRAPHICS
   ============================================================ */

-- Q11. Employee Distribution by Department
SELECT Department, COUNT(*) AS total_employees
FROM Employees
GROUP BY Department
ORDER BY total_employees DESC;

-- Q12. Gender Distribution
SELECT Gender, COUNT(*) AS total_employees
FROM Employees
GROUP BY Gender
ORDER BY total_employees DESC;		# Male- 882, Female- 588

-- Q13. Education Field Distribution
SELECT EducationField, COUNT(*) AS total_employees
FROM Employees
GROUP BY EducationField
ORDER BY total_employees DESC;				#LifeSciences- 606, Medical-464

/* ============================================================
   COMPENSATION ANALYSIS
   ============================================================ */

-- Q14. Average Salary by Department

SELECT Department, ROUND(AVG(MonthlyIncome),2) AS Avg_Income
FROM Employees
GROUP BY Department
ORDER BY Avg_Income DESC;					

/*Sales department offers the highest average monthly income (₹6,959),
followed by Human Resources (₹6,655) and Research & Development (₹6,281).
This suggests that employees in Sales roles receive comparatively higher compensation than other departments. */

-- Q15. Average Salary by Job Role
SELECT JobRole, ROUND(AVG(MonthlyIncome),2) AS Avg_Income
FROM Employees
GROUP BY JobRole
ORDER BY Avg_Income DESC;				

/* Managers and Research Directors receive the highest average salaries,
reflecting greater responsibilities and leadership-level positions. */

-- Q16. Education Level vs Salary
SELECT Education, ROUND(AVG(MonthlyIncome),2) AS Avg_Income
FROM Employees
GROUP BY Education
ORDER BY Avg_Income DESC;
/* Employees with Education Level 5 earn the highest average income, while those 
with Level 1 earn the lowest, indicating a strong positive correlation between education and compensation.*/

/* ============================================================
   SATISFACTION & EXPERIENCE ANALYSIS
   ============================================================ */

-- Q17. Department-wise Job Satisfaction
SELECT Department, ROUND(AVG(JobSatisfaction),2) AS avg_satisfaction_score
FROM Employees
GROUP BY Department
ORDER BY avg_satisfaction_score DESC;					

/* Sales department reports the highest average job satisfaction (2.75),
suggesting employees in Sales are generally more satisfied with their jobs
compared to other departments. */

-- Q18. Department-wise Work-Life Balance
SELECT Department, ROUND(AVG(WorkLifeBalance),2) AS avg_wlb_score
FROM Employees
GROUP BY Department
ORDER BY avg_wlb_score DESC;							

/* Human Resources reports the highest average work-life balance score (2.92),
indicating better perceived work-life balance than other departments. */

-- Q19. Department-wise Experience
SELECT Department, ROUND(AVG(TotalWorkingYears),2) AS avg_experience
FROM Employees
GROUP BY Department
ORDER BY avg_experience DESC;							

/*Human Resources has the most experienced workforce,
with an average of approximately 11.5 years of total working experience. */

-- Q20. Average Employee Tenure

SELECT ROUND(AVG(YearsAtCompany),2) AS avg_tenure_employees
FROM Employees;											
/* Employees stay with the company for an average of approximately
7 years, indicating moderate workforce stability. */

-- Q21. Job Role-wise Tenure
SELECT JobRole, ROUND(AVG(YearsAtCompany),2) AS avg_tenure
FROM Employees
GROUP BY JobRole
ORDER BY avg_tenure DESC;							   

/* Managers and Research Directors demonstrate the longest average tenure,
suggesting stronger long-term retention in leadership and senior roles. */ 






