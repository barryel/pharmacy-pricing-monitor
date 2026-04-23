-- ============================================
-- Pharmacy Pricing Guarantee Monitor
-- Schema: Table Creation Script
-- Author: Barry Eldad
-- Date: April 2026
-- Description: Creates the three core tables
-- for the pharmacy pricing monitor star schema
-- ============================================

USE PharmacyPricingDB;

-- -----------------------------------------------
-- DIMENSION TABLE 1: pharmacies
-- Stores master list of network pharmacies
-- One row per pharmacy
-- -----------------------------------------------
CREATE TABLE pharmacies (
    pharmacy_id VARCHAR(10) PRIMARY KEY,  -- Unique identifier e.g. PH001
    pharmacy_name VARCHAR(100),            -- Trading name of the pharmacy
    region VARCHAR(50)                     -- Geographic region: North, South, East, West
);

-- -----------------------------------------------
-- DIMENSION TABLE 2: contracts
-- Stores contracted rate per pharmacy per drug category
-- One row per pharmacy per drug category
-- -----------------------------------------------
CREATE TABLE contracts (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-generated unique ID
    pharmacy_id VARCHAR(10),                      -- Links to pharmacies table
    drug_category VARCHAR(50),                    -- Generic, Brand, or Specialty
    contracted_rate DECIMAL(10,4)                 -- Maximum agreed dispensing rate
);

-- -----------------------------------------------
-- FACT TABLE: transactions
-- Records every individual dispensing event
-- Highest volume table -- millions of rows in production
-- -----------------------------------------------
CREATE TABLE transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-generated unique ID
    pharmacy_id VARCHAR(10),                         -- Links to pharmacies table
    drug_category VARCHAR(50),                       -- Drug category of dispensed item
    actual_rate DECIMAL(10,4),                       -- Rate actually charged at dispensing
    units_dispensed INT,                             -- Number of units in this transaction
    transaction_date DATE                            -- Date of dispensing event
);