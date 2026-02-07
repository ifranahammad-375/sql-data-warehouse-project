/*
====================================================================
Create Database and Schemas
====================================================================
Script Purpose:
	This scripts creates a new database named 'Datawarehouse' after checking if it already 
	exists. If the database exists, it is dropped and recreated. Additionally, the scripts sets
	up three schemas within the database: 'Bronze', 'Silver', 'Gold'.

Warning:
	Running this scripts will drop the entire 'Datawarehouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution and 
	ensure you have proper backups before running this scripts
*/

-- Drop & Recreate Database 'Datawarehouse'

IF EXISTS (SELECT 1 FROM sys.databases WHERE name= 'Datawarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END;
GO 

-- Create the 'Datawarehouse' database 
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO

-- Create Schemas
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
