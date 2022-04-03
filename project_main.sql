/*
 * SQL project Engeto - main script
 * */

-- #########################################################################################
/*
 * PART 1:
 * - Czechia price
 * - Czechia payroll
 * - date from: 2006
 * - date to: 2014
 * */
-- #########################################################################################

/*
 * Czechia price
 * */
-- SELECT *
-- FROM czechia_price ci 
-- ORDER BY ci.date_from;

-- -- průměrné ceny za celé období pro jednotlivé kategorie zboží v celé republice
-- SELECT 
-- 	YEAR(ci.date_from) AS `date`,
-- 	cpc.name AS product_name,
-- 	cpc.price_value AS quantity, 
-- 	cpc.price_unit AS unit,
-- -- 	ci.category_code,
-- 	ROUND(AVG(ci.value), 2) AS product_avg_price -- průměrná cena zboží 
-- FROM czechia_price ci 
-- JOIN czechia_price_category cpc 
-- 	ON ci.category_code = cpc.code 
-- WHERE 1=1
-- -- 	AND YEAR(ci.date_from) = 2016
-- 	AND ci.region_code IS NULL
-- GROUP BY ci.category_code 
-- -- ORDER BY ci.category_code 
-- ;

-- SELECT 26*19*9;

-- ceny za více let pro celou republiku, pro jednotlivé kategorie zboží
SELECT 
-- 	ci.*,
	YEAR(ci.date_from) AS `date`,
	cpc.name AS product_name, 
	cpc.price_value AS quantity, 
	cpc.price_unit AS unit,
	ROUND(AVG(ci.value), 2) AS product_avg_price -- průměrná cena zboží
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
-- 	AND ci.category_code = 213201 -- pivo výčepní
GROUP BY YEAR(ci.date_from), ci.category_code 
-- ORDER BY ci.date_from
;

-- -- jiná varianta kodu, ale taky funguje
-- SELECT 
-- -- 	temp.*,
-- -- 	temp.category_code, 
-- 	YEAR(temp.date_from) AS `date`,
-- 	cpc.name AS product_name,
-- 	cpc.price_value AS quantity, 
-- 	cpc.price_unit AS unit,
-- 	ROUND(AVG(temp.value), 2) AS product_avg_price -- průměrná cena zboží
-- FROM 
-- 	(
-- 		SELECT 
-- 			ci.*
-- 		FROM czechia_price ci 
-- 		WHERE 1=1
-- -- 			AND YEAR(ci.date_from) = 2006
-- -- 			AND (YEAR(ci.date_from) = 2006
-- -- 			OR YEAR(ci.date_from) = 2007)
-- 			AND YEAR(ci.date_from) >= 2006
-- 			AND YEAR(ci.date_from) <= 2014
-- 			AND ci.region_code IS NULL
-- 	) AS temp
-- JOIN czechia_price_category cpc 
-- 	ON temp.category_code = cpc.code 
-- GROUP BY YEAR(temp.date_from), temp.category_code 
-- -- GROUP BY temp.category_code 
-- ;

/*
 * Czechia payroll
 * */
-- SELECT *
-- FROM czechia_payroll ca 
-- WHERE 1=1
-- 	AND ca.value_type_code = 5958
-- ORDER BY ca.industry_branch_code;

-- SELECT 
-- 	ca.value, ca.payroll_year, ca.payroll_quarter,
-- 	cpc.name,
-- 	cpib.name,
-- 	cpu.name,
-- 	cpvt.name
-- FROM czechia_payroll ca
-- JOIN czechia_payroll_calculation cpc 
-- 	ON ca.calculation_code = cpc.code 
-- JOIN czechia_payroll_industry_branch cpib 
-- 	ON ca.industry_branch_code = cpib.code 
-- JOIN czechia_payroll_unit cpu 
-- 	ON ca.unit_code = cpu.code 
-- JOIN czechia_payroll_value_type cpvt 
-- 	ON ca.value_type_code = cpvt.code
-- WHERE 1=1
-- 	AND ca.value_type_code = 5958
-- ORDER BY ca.payroll_year 
-- ;

-- -- průměrné platy za celé období pro jednotlivá odvětví v celé republice
-- SELECT 
-- 	ca.payroll_year AS `date`, 
-- 	cpib.name AS industry_name,
-- 	ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- průměrné platy
-- 	cpu.name AS currency
-- FROM czechia_payroll ca
-- JOIN czechia_payroll_calculation cpc 
-- 	ON ca.calculation_code = cpc.code 
-- JOIN czechia_payroll_industry_branch cpib 
-- 	ON ca.industry_branch_code = cpib.code 
-- JOIN czechia_payroll_unit cpu 
-- 	ON ca.unit_code = cpu.code 
-- JOIN czechia_payroll_value_type cpvt 
-- 	ON ca.value_type_code = cpvt.code
-- WHERE 1=1 
-- 	AND ca.value_type_code = 5958 
-- 	AND ca.calculation_code = 100 -- průměrná HM na fyzické osoby (HPP + vedlejší)
-- -- 	AND ca.industry_branch_code IS NOT NULL -- průměr pro všechny odvětví dohromady
-- GROUP BY ca.industry_branch_code
-- ORDER BY cpib.name
-- ;

-- platy za více let pro celou republiku, pouze pro jednotlivá odvětví
SELECT 
	ca.payroll_year AS `date`, 
	cpib.name AS industry_name,
	ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- průměrné platy
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
	AND ca.calculation_code = 100 -- průměrná HM na fyzické osoby (HPP + vedlejší)
	AND ca.payroll_year >= 2006
	AND ca.payroll_year <= 2014
-- 	AND ca.industry_branch_code IS NULL -- průměr pro všechny odvětví dohromady
GROUP BY ca.payroll_year, ca.industry_branch_code 
-- ORDER BY ca.payroll_year DESC
;

-- platy za více let pro celou republiku, pro jednotlivá odvětví i s celkovou průměrnou mzdou v celé CR
SELECT 
	ca.*,
	ROUND(AVG(ca.value), 2) AS industry_avg_salary -- průměrné platy
FROM czechia_payroll ca 
WHERE 1=1
	AND ca.value_type_code = 5958
	AND ca.calculation_code = 100 -- průměrná HM na fyzické osoby (HPP + vedlejší)
	AND ca.payroll_year >= 2006
	AND ca.payroll_year <= 2014
-- 	AND ca.industry_branch_code IS NULL -- průměr pro všechny odvětví dohromady
GROUP BY ca.payroll_year, ca.industry_branch_code 
-- ORDER BY ca.payroll_year DESC
;


/*
 * Czechia price + Czechia payroll = Primary table
 * */

-- ceny a platy za roky 2006-2014 pro celou republiku, pro jednotlivé kategorie zboží a pro jednotlivá odvětví

CREATE TABLE IF NOT EXISTS t_jakub_abbrent_project_SQL_primary_final
(
	WITH products AS (
		-- ceny za rok 2006-2014 pro celou republiku, pro jednotlivé kategorie zboží
		SELECT 
		YEAR(ci.date_from) AS `date`,
		cpc.name AS product_name,
		cpc.price_value AS quantity, 
		cpc.price_unit AS unit,
		ROUND(AVG(ci.value), 2) AS product_avg_price -- průměrná cena zboží 
		FROM czechia_price ci 
		JOIN czechia_price_category cpc 
			ON ci.category_code = cpc.code 
		WHERE 1=1
			AND YEAR(ci.date_from) >= 2006
			AND YEAR(ci.date_from) <= 2014
			AND ci.region_code IS NULL
		GROUP BY YEAR(ci.date_from), ci.category_code 
	), 
	salaries AS (
		-- platy za rok 2006-2014 pro celou republiku, pro jednotlivá odvětví
		SELECT 
		ca.payroll_year AS `date`, 
		cpib.name AS industry_name,
		ROUND(AVG(ca.value), 2) AS industry_avg_salary, -- průměrné platy
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
			AND ca.calculation_code = 100 -- průměrná HM na fyzické osoby (HPP + vedlejší)
			AND ca.payroll_year >= 2006
			AND ca.payroll_year <= 2014
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
	
SELECT 
	tab1.*
FROM t_jakub_abbrent_project_SQL_primary_final tab1
;

-- #########################################################################################
/* PART 1:
 * - Výzkumné otázky 1-4
 * */
-- #########################################################################################

/*
 * 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 * */

-- SELECT DISTINCT 
-- -- 	tab1.*
-- 	tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
-- FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- WHERE 1=1
-- 	AND tab1.industry_name = 'Informační a komunikační činnosti'
-- ;

-- zobrazení průběhu růstu/poklesu platů u všech odvětví v celém rozmezí let
WITH temp1 AS 
(
	SELECT DISTINCT 
	-- 	tab1.*
		tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
	FROM t_jakub_abbrent_project_SQL_primary_final tab1
	WHERE 1=1
-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
),
temp2 AS 
(
	SELECT DISTINCT 
	-- 	tab1.*
		tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
	FROM t_jakub_abbrent_project_SQL_primary_final tab1
	WHERE 1=1
-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
)
SELECT 
	a.industry_name,
	a.`date`,
	a.industry_avg_salary,
	b.`date` AS previous_date,
	b.industry_avg_salary AS previous_industry_avg_salary,
	ROUND((a.industry_avg_salary - b.industry_avg_salary) / b.industry_avg_salary * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu platů
FROM temp1 a
JOIN temp2 b
	ON a.`date` = b.`date` + 1
	AND a.industry_name = b.industry_name 
-- 	AND a.`date` = b.`date` + 1
WHERE 1=1
	-- AND (a.industry_avg_salary - b.industry_avg_salary) < 0
ORDER BY a.industry_name, a.`date` 
;

-- zobrazení průměrného růstu/poklesu platů u všech odvětví v celém rozmezí let
SELECT 
-- 	*,
	ind.industry_name,
	ROUND(AVG(ind.avg_salary_growth_percent), 2) AS salary_growth_percent_avg
FROM 
(
	WITH temp1 AS 
	(
		SELECT DISTINCT 
		-- 	tab1.*
			tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		WHERE 1=1
-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
	),
	temp2 AS 
	(
		SELECT DISTINCT 
		-- 	tab1.*
			tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		WHERE 1=1
-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
	)
	SELECT 
		a.industry_name,
		a.`date`,
		a.industry_avg_salary,
		b.`date` AS previous_date,
		b.industry_avg_salary AS previous_industry_avg_salary,
		ROUND((a.industry_avg_salary - b.industry_avg_salary) / b.industry_avg_salary * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu platů
	FROM temp1 a
	JOIN temp2 b
		ON a.`date` = b.`date` + 1
		AND a.industry_name = b.industry_name 
	-- 	AND a.`date` = b.`date` + 1
) AS ind	-- industry_growth 
GROUP BY ind.industry_name 
-- HAVING MIN(ind.avg_salary_growth_percent) > 0
;


-- odvětví, u kterých někdy v průběhu let došlo k poklesu platů
SELECT 
	ind2.industry_name 
FROM
(
	SELECT 
	-- 	*,
		ind.industry_name,
		MIN(ind.avg_salary_growth_percent) AS max_salary_drop
	FROM 
	(
		WITH temp1 AS 
		(
			SELECT DISTINCT 
			-- 	tab1.*
				tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
			FROM t_jakub_abbrent_project_SQL_primary_final tab1
			WHERE 1=1
	-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
		),
		temp2 AS 
		(
			SELECT DISTINCT 
			-- 	tab1.*
				tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
			FROM t_jakub_abbrent_project_SQL_primary_final tab1
			WHERE 1=1
	-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
		)
		SELECT 
			a.industry_name,
			a.`date`,
			a.industry_avg_salary,
			b.`date` AS previous_date,
			b.industry_avg_salary AS previous_industry_avg_salary,
			ROUND((a.industry_avg_salary - b.industry_avg_salary) / b.industry_avg_salary * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu platů
		FROM temp1 a
		JOIN temp2 b
			ON a.`date` = b.`date` + 1
			AND a.industry_name = b.industry_name 
		-- 	AND a.`date` = b.`date` + 1
	) AS ind	-- industry_growth 
	GROUP BY ind.industry_name 
) AS ind2
WHERE ind2.max_salary_drop < 0
;

-- odvětví, u kterých nedošlo k poklesu platů
SELECT 
	ind2.industry_name 
FROM
(
	SELECT 
	-- 	*,
		ind.industry_name,
		MIN(ind.avg_salary_growth_percent) AS max_salary_drop
	FROM 
	(
		WITH temp1 AS 
		(
			SELECT DISTINCT 
			-- 	tab1.*
				tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
			FROM t_jakub_abbrent_project_SQL_primary_final tab1
			WHERE 1=1
	-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
		),
		temp2 AS 
		(
			SELECT DISTINCT 
			-- 	tab1.*
				tab1.`date`, tab1.industry_name, tab1.industry_avg_salary, tab1.salary_currency  
			FROM t_jakub_abbrent_project_SQL_primary_final tab1
			WHERE 1=1
	-- 			AND (tab1.industry_name = 'Informační a komunikační činnosti'
-- 			OR tab1.industry_name = 'Stavebnictví')
		)
		SELECT 
			a.industry_name,
			a.`date`,
			a.industry_avg_salary,
			b.`date` AS previous_date,
			b.industry_avg_salary AS previous_industry_avg_salary,
			ROUND((a.industry_avg_salary - b.industry_avg_salary) / b.industry_avg_salary * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu platů
		FROM temp1 a
		JOIN temp2 b
			ON a.`date` = b.`date` + 1
			AND a.industry_name = b.industry_name 
		-- 	AND a.`date` = b.`date` + 1
	) AS ind	-- industry_growth 
	GROUP BY ind.industry_name 
) AS ind2
WHERE ind2.max_salary_drop > 0
;

/*
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 * */

-- -- množství produktu na jednotlivé odvětví pro roky 2006-2014
-- SELECT 
-- 	tab1.*,
-- 	tab1.`date`, tab1.product_name, tab1.industry_name, 
-- 	ROUND(tab1.industry_avg_salary / tab1.product_avg_price, 2) AS  quantity,
-- 	tab1.unit 
-- FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- WHERE 1=1
-- 	AND (tab1.product_name = 'Ml�ko polotu�n� pasterovan�' 
-- 	OR tab1.product_name = 'Chl�b konzumn� km�nov�')
-- 	AND (tab1.`date` = 2006
-- 	OR tab1.`date` = 2014)
-- GROUP BY tab1.`date`, tab1.product_name, tab1.industry_name 
-- ;

-- množství produktu průměrně za celou republiku pro roky 2006 a 2014
WITH salaries AS (
	SELECT DISTINCT 
		tab1.`date`, 
		ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary,
		tab1.salary_currency
	FROM t_jakub_abbrent_project_SQL_primary_final tab1
	WHERE 1=1
		AND (tab1.`date` = 2006
		OR tab1.`date` = 2014)
	GROUP BY tab1.`date`
),
products AS (
	SELECT DISTINCT 
	-- 	tab1.*
		tab1.`date`, tab1.product_name, tab1.product_avg_price, tab1.unit  
	FROM t_jakub_abbrent_project_SQL_primary_final tab1
	WHERE 1=1
		AND (tab1.product_name = 'Mléko polotučné pasterované' 
		OR tab1.product_name = 'Chléb konzumní kmínový')
		AND (tab1.`date` = 2006
		OR tab1.`date` = 2014)
)
SELECT 
	p.date, p.product_name, 
	ROUND(s.avg_salary / p.product_avg_price, 2) AS  quantity,
	p.unit
FROM products p
JOIN salaries s 
	ON p.date = s.date
;

/*
 * 3. Která kategorie potravin zdržuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 * */
SELECT 
-- 	ppg.*
	ppg.product_name,
	ROUND(AVG(ppg.product_avg_price_growth_percent), 2) AS product_growth_percent -- meziroční nárůst cen potravin
FROM (
	WITH product1 AS (
		SELECT DISTINCT 
		-- 	tab1.*
			tab1.`date`, tab1.product_name, tab1.product_avg_price, tab1.unit  
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
	),
	product2 AS (
		SELECT DISTINCT 
		-- 	tab1.*
			tab1.`date`, tab1.product_name, tab1.product_avg_price, tab1.unit  
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
	)
	SELECT 
		p1.product_name,
		p1.`date`,
		p1.product_avg_price,
		p2.`date` AS previous_date,
		p2.product_avg_price AS previous_product_avg_price,
		ROUND((p1.product_avg_price - p2.product_avg_price) / p2.product_avg_price * 100, 2) AS product_avg_price_growth_percent -- výpočet meziročního nárůstu cen potravin
	FROM product1 p1
	JOIN product2 p2
		ON p1.`date` = p2.`date` + 1
		AND p1.product_name = p2.product_name 
-- 	WHERE p1.product_name = 'Rajská jablka červená kulatá'
	) AS ppg -- product_price_growth
GROUP BY ppg.product_name 
ORDER BY product_growth_percent
LIMIT 1
;

/*
 * 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 * */

-- -- product price
-- SELECT DISTINCT 
-- -- 	tab1.*
-- 	tab1.`date`, 
-- 	ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
-- FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- GROUP BY tab1.`date`  
-- ;
-- 
-- WITH product1 AS (
-- 	SELECT DISTINCT 
-- 		tab1.`date`, 
-- 		ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
-- 	FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- 	GROUP BY tab1.`date`  
-- ),
-- product2 AS (
-- 	SELECT DISTINCT 
-- 		tab1.`date`, 
-- 		ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
-- 	FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- 	GROUP BY tab1.`date`  
-- )
-- SELECT 
-- 	p1.`date`,
-- -- 	p1.all_products_price,
-- 	p2.`date` AS previous_date,
-- -- 	p2.all_products_price AS previous_all_products_price,
-- 	ROUND((p1.all_products_price - p2.all_products_price) / p2.all_products_price * 100, 2) AS all_products_price_growth_percent -- výpočet meziročního nárůstu cen potravin
-- FROM product1 p1
-- JOIN product2 p2
-- 	ON p1.`date` = p2.`date` + 1 
-- ;

-- -- average salary
-- SELECT DISTINCT 
-- -- 	tab1.*
-- 	tab1.`date`, 
-- 	ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
-- FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- GROUP BY tab1.`date` 
-- ;
-- 
-- WITH salary1 AS (
-- 	SELECT DISTINCT 
-- 		tab1.`date`, 
-- 		ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
-- 	FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- 	GROUP BY tab1.`date` 
-- ),
-- salary2 AS (
-- 	SELECT DISTINCT 
-- 		tab1.`date`, 
-- 		ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
-- 	FROM t_jakub_abbrent_project_SQL_primary_final tab1
-- 	GROUP BY tab1.`date` 
-- )
-- SELECT 
-- 	s1.`date`,
-- -- 	s1.avg_salary_per_year,
-- 	s2.`date` AS previous_date,
-- -- 	s2.avg_salary_per_year AS previous_avg_salary_per_year,
-- 	ROUND((s1.avg_salary_per_year - s2.avg_salary_per_year) / s2.avg_salary_per_year * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu cen potravin
-- FROM salary1 s1
-- JOIN salary2 s2
-- 	ON s1.`date` = s2.`date` + 1
-- ;


-- product price + average salary
WITH product_price_growth AS ( 
	WITH product1 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date`  
	),
	product2 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date`  
	)
	SELECT 
		p1.`date`,
	-- 	p1.all_products_price,
		p2.`date` AS previous_date,
	-- 	p2.all_products_price AS previous_all_products_price,
		ROUND((p1.all_products_price - p2.all_products_price) / p2.all_products_price * 100, 2) AS all_products_price_growth_percent -- výpočet meziročního nárůstu cen potravin
	FROM product1 p1
	JOIN product2 p2
		ON p1.`date` = p2.`date` + 1 
), 
avg_salary_growth AS (
	WITH salary1 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date` 
	),
	salary2 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date` 
	)
	SELECT 
		s1.`date`,
	-- 	s1.avg_salary_per_year,
		s2.`date` AS previous_date,
	-- 	s2.avg_salary_per_year AS previous_avg_salary_per_year,
		ROUND((s1.avg_salary_per_year - s2.avg_salary_per_year) / s2.avg_salary_per_year * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu cen potravin
	FROM salary1 s1
	JOIN salary2 s2
		ON s1.`date` = s2.`date` + 1
)
SELECT 
	ppg.`date`, ppg.previous_date, ppg.all_products_price_growth_percent,
	asg.avg_salary_growth_percent,
	CASE
		WHEN ppg.all_products_price_growth_percent - asg.avg_salary_growth_percent > 10 THEN 1
		ELSE 0
	END AS products_price_growth_higher_more_than_10_than_avg_salary_growth
FROM product_price_growth ppg
JOIN avg_salary_growth asg
	ON ppg.`date` = asg.`date`
;


-- #########################################################################################
/*
 * PART 2:
 * - Economies
 * - GDP, GINI, ...
 * - date from: 2006
 * - date to: 2014
 * */
-- #########################################################################################

-- SELECT DISTINCT 
-- 	e.country 
-- FROM economies e;

-- SELECT 
-- 	e.*, c.country, c.continent 
-- -- 	e.country, e.`year`, e.GDP, e.population, e.gini 
-- FROM economies e 
-- JOIN countries c 
-- 	ON e.country = c.country
-- WHERE 1=1
-- 	AND e.`year` >= 2006
-- 	AND e.`year` <= 2014
-- 	AND c.continent = 'Europe'
-- ;

-- Secondary table
CREATE TABLE IF NOT EXISTS t_jakub_abbrent_project_SQL_secondary_final
(
	SELECT 
		e.country, e.`year`, e.GDP, e.population, e.gini 
	FROM economies e 
	JOIN countries c 
		ON e.country = c.country
	WHERE 1=1
		AND e.`year` >= 2006
		AND e.`year` <= 2014
		AND c.continent = 'Europe'
)
;

SELECT 
	tab2.*
FROM t_jakub_abbrent_project_sql_secondary_final tab2;

-- #########################################################################################
/* PART 2:
 * - Výzkumná otázka 5
 * */
-- #########################################################################################

/*
 * 5. Má výškaka HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 * */

-- data pouze pro Českou republiku
SELECT 
-- 	tab2.*,
	tab2.`year`, tab2.GDP 
FROM t_jakub_abbrent_project_sql_secondary_final tab2
WHERE 1=1
	AND tab2.country = 'Czech Republic'
ORDER BY tab2.`year` 
;

-- hdp
WITH hdp1 AS (
	SELECT 
		tab2.`year`, tab2.GDP 
	FROM t_jakub_abbrent_project_sql_secondary_final tab2
	WHERE 1=1
		AND tab2.country = 'Czech Republic'
	ORDER BY tab2.`year` 
),
hdp2 AS (
	SELECT 
		tab2.`year`, tab2.GDP 
	FROM t_jakub_abbrent_project_sql_secondary_final tab2
	WHERE 1=1
		AND tab2.country = 'Czech Republic'
	ORDER BY tab2.`year` 
)
SELECT 
	hdp1.`year` AS `date`, 
	hdp2.`year` AS previous_date,
	ROUND((hdp1.GDP - hdp2.GDP) / hdp2.GDP * 100, 2) AS hdp_growth_percent -- výpočet meziročního nárůstu HDP
FROM hdp1
JOIN hdp2
	ON hdp1.`year` = hdp2.`year` + 1
ORDER BY hdp1.`year`
;

-- product price + average salary + hdp
WITH product_price_growth AS ( 
	WITH product1 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date`  
	),
	product2 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(SUM(tab1.product_avg_price), 2) AS all_products_price
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date`  
	)
	SELECT 
		p1.`date`,
	-- 	p1.all_products_price,
		p2.`date` AS previous_date,
	-- 	p2.all_products_price AS previous_all_products_price,
		ROUND((p1.all_products_price - p2.all_products_price) / p2.all_products_price * 100, 2) AS all_products_price_growth_percent -- výpočet meziročního nárůstu cen potravin
	FROM product1 p1
	JOIN product2 p2
		ON p1.`date` = p2.`date` + 1 
), 
avg_salary_growth AS (
	WITH salary1 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date` 
	),
	salary2 AS (
		SELECT DISTINCT 
			tab1.`date`, 
			ROUND(AVG(tab1.industry_avg_salary), 2) AS avg_salary_per_year
		FROM t_jakub_abbrent_project_SQL_primary_final tab1
		GROUP BY tab1.`date` 
	)
	SELECT 
		s1.`date`,
	-- 	s1.avg_salary_per_year,
		s2.`date` AS previous_date,
	-- 	s2.avg_salary_per_year AS previous_avg_salary_per_year,
		ROUND((s1.avg_salary_per_year - s2.avg_salary_per_year) / s2.avg_salary_per_year * 100, 2) AS avg_salary_growth_percent -- výpočet meziročního nárůstu cen potravin
	FROM salary1 s1
	JOIN salary2 s2
		ON s1.`date` = s2.`date` + 1
),
hdp_growth AS (
	WITH hdp1 AS (
		SELECT 
			tab2.`year`, tab2.GDP 
		FROM t_jakub_abbrent_project_sql_secondary_final tab2
		WHERE 1=1
			AND tab2.country = 'Czech Republic'
		ORDER BY tab2.`year` 
	),
	hdp2 AS (
		SELECT 
			tab2.`year`, tab2.GDP 
		FROM t_jakub_abbrent_project_sql_secondary_final tab2
		WHERE 1=1
			AND tab2.country = 'Czech Republic'
		ORDER BY tab2.`year` 
	)
	SELECT 
		hdp1.`year` AS `date`, 
		hdp2.`year` AS previous_date,
		ROUND((hdp1.GDP - hdp2.GDP) / hdp2.GDP * 100, 2) AS hdp_growth_percent -- výpočet meziročního nárůstu HDP
	FROM hdp1
	JOIN hdp2
		ON hdp1.`year` = hdp2.`year` + 1
	ORDER BY hdp1.`year`
)
SELECT 
	ppg.`date`, ppg.previous_date, ppg.all_products_price_growth_percent,
	asg.avg_salary_growth_percent,
-- 	CASE
-- 		WHEN ppg.all_products_price_growth_percent - asg.avg_salary_growth_percent > 10 THEN 1
-- 		ELSE 0
-- 	END AS products_price_growth_higher_more_than_10_than_avg_salary_growth
	hg.hdp_growth_percent 
FROM product_price_growth ppg
JOIN avg_salary_growth asg
	ON ppg.`date` = asg.`date`
JOIN hdp_growth hg 
	ON ppg.`date` = hg.`date`
;


