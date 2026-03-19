/*
===================================================================================
Quality Checks
===================================================================================
Script Purpose:
		This Scripts performs various quality checks for data consistency, accuracy
		and standardization across the 'silver' schema. It includes checks for:
		- Null or duplicates primary keys.
		- Unwanted spaces in string fields.
		- Data Standardization and consistency.
		- Invalid date ranges and orders.
		- Data consistency between related fields.

Usage Notes:
	 - Run these checks after data loading silver layer.
	 - Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/

-- ==============================================================
-- Checking 'Silver.crm_cust_info'
-- ==============================================================
-- Check For Nulls or Duplicates in Primary Key
SELECT 
cst_id,
COUNT(*)
FROM Silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check For Unwanted Spaces
SELECT cst_lastname
FROM Silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_firstname
FROM Silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_gndr
FROM Silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT cst_firstname
FROM Silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM Silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM Silver.crm_cust_info;


-- =============================================================
-- Checking 'Silver.crm_prd_info'
-- =============================================================
-- Check for Nulls or Duplicates in Primary Key
SELECT 
prd_id,
COUNT(*)
FROM Silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
SELECT prd_nm
FROM Silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Check for Nulls Or Negative Numbers
SELECT prd_cost 
FROM Silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency 
SELECT DISTINCT prd_line 
FROM Silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT * 
FROM Silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ==========================================================
-- Checking 'Silver.crm_sales_details'
-- ==========================================================
-- Check For Invalid Dates
SELECT sls_order_dt
FROM Silver.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8;

SELECT sls_ship_dt
FROM Silver.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8;

SELECT sls_due_dt
FROM Silver.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8;

-- Check For Invalid Date Orders
SELECT * FROM Silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Between Sales, Quantity and Price
-- > Sales = Quantity * Price
-- > Values must not be NULL, Zero or Negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM Silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR  sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR  sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


-- ==============================================================
-- Checking 'Silver.erp_cust_az12'
-- ==============================================================
-- Identify Out-of-Rang Dates

SELECT DISTINCT 
bdate
FROM Silver.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > GETDATE();

-- Data Standardization & Consistency

SELECT DISTINCT
gen FROM Silver.erp_cust_az12;


-- =============================================================
-- Checking 'Silver.erp_loc_a101'
-- =============================================================
SELECT cid
FROM Silver.erp_loc_a101;

-- Data Standardization & Consistency
SELECT DISTINCT 
cntry
FROM Silver.erp_loc_a101;


-- =============================================================
-- Checking 'Silver.erp_px_cat_g1v2'
-- =============================================================
-- Check for Unwanted Spaces
SELECT * FROM Silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT
cat,
subcat,
maintenance
FROM Silver.erp_px_cat_g1v2;
