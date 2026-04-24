USE PharmacyPricingDB;

-- -----------------------------------------------
-- Performance Indexes
-- Author: Barry Eldad
-- Date: April 2026
-- Description: Indexes on high-frequency query
-- columns to optimise analytical query performance
-- -----------------------------------------------

-- Index on transaction_date for period filtering
CREATE INDEX IX_transactions_date 
ON transactions(transaction_date);

-- Index on pharmacy_id for join performance
CREATE INDEX IX_transactions_pharmacy 
ON transactions(pharmacy_id);

-- Index on drug_category for category aggregation
CREATE INDEX IX_transactions_category 
ON transactions(drug_category);

-- Composite index for the most common query pattern
-- pharmacy + date combination used in every analysis
CREATE INDEX IX_transactions_pharmacy_date 
ON transactions(pharmacy_id, transaction_date);