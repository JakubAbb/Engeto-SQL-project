/*
 * SQL project Engeto - main script
 * */

/*
 * Czechia price
 * */
SELECT *
FROM czechia_price ci 
ORDER BY ci.date_from;

-- pr�m�rn� ceny za cel� obdob� pro jednotliv� kategorie zbo�� v cel� republice
SELECT 
	YEAR(ci.date_from) AS `date`,
	cpc.name AS product_name,
	cpc.price_value AS quantity, 
	cpc.price_unit AS unit,
-- 	ci.category_code,
	ROUND(AVG(ci.value), 2) AS product_avg_price -- pr�m�rn� cena zbo�� 
FROM czechia_price ci 
JOIN czechia_price_category cpc 
	ON ci.category_code = cpc.code 
WHERE 1=1
-- 	AND YEAR(ci.date_from) = 2016
	AND ci.region_code IS NULL
GROUP BY ci.category_code 
-- ORDER BY ci.category_code 
;

SELECT 26*19*9;

-- ceny za v�ce let pro celou republiku, pro jednotliv� odv�tv�
SELECT 
-- 	ci.*,
	YEAR(ci.date_from) AS `date`,
	cpc.name AS product_name, 
	cpc.price_value AS quantity, 
	cpc.price_unit AS unit,
	ROUND(AVG(ci.value), 2) AS product_avg_price -- pr�m�rn� cena zbo��
-- 	ci.value,
-- 	ci.category_code
FROM czechia_price ci 
JOIN czechia_price_category cpc 
	ON ci.category_code = cpc.code 
WHERE 1=1
-- 	AND YEAR(ci.date_from) = 2006
	AND YEAR(ci.date_from) >= 2006
	AND YEAR(ci.date_from) <= 2014
	AND ci.region_code IS NULL
-- 	AND ci.category_code = 213201 -- pivo v��epn�
GROUP BY YEAR(ci.date_from), ci.category_code 
-- ORDER BY ci.date_from
;

-- jin� varianta k�du, ale taky funguje
SELECT 
-- 	temp.*,
-- 	temp.category_code, 
	YEAR(temp.date_from) AS `date`,
	cpc.name AS product_name,
	cpc.price_value AS quantity, 
	cpc.price_unit AS unit,
	ROUND(AVG(temp.value), 2) AS product_avg_price -- pr�m�rn� cena zbo��
FROM 
	(
		SELECT 
			ci.*
		FROM czechia_price ci 
		WHERE 1=1
-- 			AND YEAR(ci.date_from) = 2006
-- 			AND (YEAR(ci.date_from) = 2006
-- 			OR YEAR(ci.date_from) = 2007)
			AND YEAR(ci.date_from) >= 2006
			AND YEAR(ci.date_from) <= 2014
			AND ci.region_code IS NULL
	) AS temp
JOIN czechia_price_category cpc 
	ON temp.category_code = cpc.code 
GROUP BY YEAR(temp.date_from), temp.category_code 
-- GROUP BY temp.category_code 
;

/*
 * Czechia payroll
 * */
SELECT *
FROM czechia_payroll ca 
WHERE 1=1
	AND ca.value_type_code = 5958
ORDER BY ca.industry_branch_code;

SELECT 
	ca.value, ca.payroll_year, ca.payroll_quarter,
	cpc.name,
	cpib.name,
	cpu.name,
	cpvt.name
FROM czechia_payroll ca
JOIN czechia_payroll_calculation cpc 
	ON ca.calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON ca.industry_branch_code = cpib.code 
JOIN czechia_payroll_unit cpu 
	ON ca.unit_code = cpu.code 
JOIN czechia_payroll_value_type cpvt 
	ON ca.value_type_code = cpvt.code
WHERE 1=1
	AND ca.value_type_code = 5958
ORDER BY ca.payroll_year 
;

-- pr�m�rn� platy za cel� obdob� pro jednotliv� odv�tv� v cel� republice
SELECT 
	ca.payroll_year AS `date`, 
	cpib.name AS industry_name,
	ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- pr�m�rn� platy
	cpu.name AS currency
FROM czechia_payroll ca
JOIN czechia_payroll_calculation cpc 
	ON ca.calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON ca.industry_branch_code = cpib.code 
JOIN czechia_payroll_unit cpu 
	ON ca.unit_code = cpu.code 
JOIN czechia_payroll_value_type cpvt 
	ON ca.value_type_code = cpvt.code
WHERE 1=1 
	AND ca.value_type_code = 5958 
	AND ca.calculation_code = 100 -- pr�m�rn� HM na fyzick� osoby (HPP + vedlej��)
-- 	AND ca.industry_branch_code IS NOT NULL -- pr�m�r pro v�echny odv�tv� dohromady
GROUP BY ca.industry_branch_code
ORDER BY cpib.name
;

-- platy za v�ce let pro celou republiku, pouze pro jednotliv� odv�tv�
SELECT 
	ca.payroll_year AS `date`, 
	cpib.name AS industry_name,
	ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- pr�m�rn� platy
	cpu.name AS currency
FROM czechia_payroll ca 
JOIN czechia_payroll_calculation cpc 
	ON ca.calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON ca.industry_branch_code = cpib.code 
JOIN czechia_payroll_unit cpu 
	ON ca.unit_code = cpu.code 
JOIN czechia_payroll_value_type cpvt 
	ON ca.value_type_code = cpvt.code
WHERE 1=1
	AND ca.value_type_code = 5958
	AND ca.calculation_code = 100 -- pr�m�rn� HM na fyzick� osoby (HPP + vedlej��)
	AND ca.payroll_year >= 2006
	AND ca.payroll_year <= 2014
-- 	AND ca.industry_branch_code IS NULL -- pr�m�r pro v�echny odv�tv� dohromady
GROUP BY ca.payroll_year, ca.industry_branch_code 
-- ORDER BY ca.payroll_year DESC
;

-- platy za v�ce let pro celou republiku, pro jednotliv� odv�tv� i s celkovou pr�m�rnou mzdou v cel� �R
SELECT 
	ca.*,
	ROUND(AVG(ca.value), 2) AS industry_avg_salary -- pr�m�rn� platy
FROM czechia_payroll ca 
WHERE 1=1
	AND ca.value_type_code = 5958
	AND ca.calculation_code = 100 -- pr�m�rn� HM na fyzick� osoby (HPP + vedlej��)
	AND ca.payroll_year >= 2006
	AND ca.payroll_year <= 2014
-- 	AND ca.industry_branch_code IS NULL -- pr�m�r pro v�echny odv�tv� dohromady
GROUP BY ca.payroll_year, ca.industry_branch_code 
-- ORDER BY ca.payroll_year DESC
;

;

/*
 * Czechia price + Czechia payroll
 * */

-- ceny a platy za rok 2016 pro celou republiku, pro jednotliv� kategorie zbo�� a pro jednotliv� odv�tv�

CREATE TABLE IF NOT EXISTS t_jakub_abbrent_project_SQL_primary_final
(
	WITH products AS (
		-- ceny za rok 2006-2014 pro celou republiku, pro jednotliv� kategorie zbo��
		SELECT 
		YEAR(ci.date_from) AS `date`,
		cpc.name AS product_name,
		cpc.price_value AS quantity, 
		cpc.price_unit AS unit,
		ROUND(AVG(ci.value), 2) AS product_avg_price -- pr�m�rn� cena zbo�� 
		FROM czechia_price ci 
		JOIN czechia_price_category cpc 
			ON ci.category_code = cpc.code 
		WHERE 1=1
			AND YEAR(ci.date_from) >= 2006
			AND YEAR(ci.date_from) <= 2014
			AND ci.region_code IS NULL
		-- 	AND ci.category_code = 213201 -- pivo v��epn�
		GROUP BY YEAR(ci.date_from), ci.category_code 
	), 
	salaries AS (
		-- platy za rok 2006-2014 pro celou republiku, pro jednotliv� odv�tv�
		SELECT 
		ca.payroll_year AS `date`, 
		cpib.name AS industry_name,
		ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- pr�m�rn� platy
		cpu.name AS currency
		FROM czechia_payroll ca 
		JOIN czechia_payroll_calculation cpc 
			ON ca.calculation_code = cpc.code 
		JOIN czechia_payroll_industry_branch cpib 
			ON ca.industry_branch_code = cpib.code 
		JOIN czechia_payroll_unit cpu 
			ON ca.unit_code = cpu.code 
		JOIN czechia_payroll_value_type cpvt 
			ON ca.value_type_code = cpvt.code
		WHERE 1=1
			AND ca.value_type_code = 5958
			AND ca.calculation_code = 100 -- pr�m�rn� HM na fyzick� osoby (HPP + vedlej��)
			AND ca.payroll_year >= 2006
			AND ca.payroll_year <= 2014
		-- 	AND ca.industry_branch_code IS NULL -- pr�m�r pro v�echny odv�tv� dohromady
		GROUP BY ca.payroll_year, ca.industry_branch_code 
	)
	SELECT 
		p.*,
		s.currency AS product_currency,
		s.industry_name, s.industry_avg_salary, s.currency AS salary_currency
	-- 	COUNT(1)
	FROM products p
	JOIN salaries s 
		ON p.date = s.date 
);
	

