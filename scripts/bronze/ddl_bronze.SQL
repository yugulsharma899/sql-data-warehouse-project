/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

-- DDL Scripts to create Tables

if OBJECT_ID ('bronze.crm_cust_info' , 'U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_material_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);
if OBJECT_ID ('bronze.crm_prd_info' , 'U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);
if OBJECT_ID ('bronze.crm_sales_details' , 'U') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
if OBJECT_ID ('bronze.erp_cust_ax12' , 'U') is not null
	drop table bronze.erp_cust_ax12;
create table bronze.erp_cust_ax12(
	cid		nvarchar(50),
	bdate	date,
	gen		nvarchar(50)
);
if OBJECT_ID ('bronze.erp_loc_a101' , 'U') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
	cid		nvarchar(50),
	cntry	nvarchar(50)
);
if OBJECT_ID ('bronze.erp_px_cat_g1v2' , 'U') is not null
	drop table bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2(
	id		nvarchar(50),
	cat		nvarchar(50),
	subcat	nvarchar(50),
	maintanence	nvarchar(50)
);


-- Bulk import data from csv file to table here
-- ETL

exec bronze.load_bronze;
create or alter procedure bronze.load_bronze as
begin
	Declare @start_time datetime , @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		PRINT '=====================================';
		PRINT 'Loading Bronze layer';
		PRINT '=====================================';

		PRINT '-------------------------------------';
		PRINT 'Loading CRM Table';
		PRINT '-------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;

		PRINT '>> Inserting data into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		PRINT '>> Inserting data into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		PRINT '>> Inserting data into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		PRINT '-------------------------------------';
		PRINT 'Loading ERP Table';
		PRINT '-------------------------------------';


		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_ax12';
		truncate table bronze.erp_cust_ax12;
		PRINT '>> Inserting data into: bronze.erp_cust_ax12';
		bulk insert bronze.erp_cust_ax12
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		PRINT '>> Inserting data into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		set @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting data into: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Yugul Sharma\Desktop\MySql\Data_with_Baraa\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		PRINT '>> Load Duration; ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds';
		PRINT '>> -------------------'

		set @batch_end_time = getdate();
		PRINT '========================================='
		PRINT 'Loading Bronze layer is Completed';
		PRINT '   - Total load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
		PRINT '========================================='
	end try
	begin catch
		PRINT '==================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + Error_message();
		PRINT 'Error Message' + cast (Error_number() as nvarchar);
		PRINT 'Error Message' + cast (Error_state() as nvarchar);
		PRINT '===================================================';
	end catch
end

