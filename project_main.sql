/*
 * SQL project Engeto - main script
 * */

/*
 * Czechia price
 * */
SELECT *
FROM czechia_price ci 
ORDER BY ci.date_from;

-- ceny za rok 2016 pro celou republiku, pro jednotlivé kategorie zboží
SELECT 
	cpc.name AS category_name,
	cpc.price_value AS quantity, 
	cpc.price_unit AS unit,
-- 	ci.category_code,
	ROUND(AVG(ci.value), 2) AS mean_price -- prùmìrná cena zboží 
FROM czechia_price ci 
JOIN czechia_price_category cpc 
	ON ci.category_code = cpc.code 
WHERE 1=1 AND
	YEAR(ci.date_from) = 2016 AND
	ci.region_code IS NULL
GROUP BY ci.category_code 
-- ORDER BY ci.category_code 
;

SELECT 12*27;

/*
 * Czechia payroll
 * */
SELECT *
FROM czechia_payroll ca 
ORDER BY ca.payroll_year DESC;

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
ORDER BY ca.payroll_year 
;

-- platy za rok 2016 pro celou republiku, pro jednotlivé odvìtví
SELECT 
	cpib.name AS industry_name,
	ROUND(AVG(ca.value), 2) AS mean_payroll, -- prùmìrné platy
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
WHERE 1=1 AND
	ca.value_type_code = 5958 AND
	ca.payroll_year = 2016 AND
	ca.calculation_code = 100 AND-- prùmìrná HM na fyzické osoby (HPP + vedlejší)
	ca.industry_branch_code IS NOT NULL -- prùmìr pro všechny odvìtví dohromady
GROUP BY ca.industry_branch_code 
ORDER BY cpib.name
;

/*
 * Czechia price + Czechia payroll
 * */

