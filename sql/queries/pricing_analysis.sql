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


-- ============================================
-- Pharmacy Pricing Guarantee Monitor
-- Query: Core Pricing Analysis
-- Author: Barry Eldad
-- Date: April 2026
-- Description: Calculates effective rate vs
-- contracted rate variance, breach flags, and
-- financial exposure by pharmacy for a given
-- reporting period. Results ordered by
-- financial impact descending for stakeholder
-- prioritisation.
-- ============================================

USE PharmacyPricingDB;

-- -----------------------------------------------
-- CORE PRICING ANALYSIS QUERY
-- Aggregates transaction data by pharmacy and
-- compares against contracted benchmarks
-- Replace date filter for different periods
-- -----------------------------------------------
SELECT
    p.pharmacy_id,
    p.pharmacy_name,
    p.region,
    t.drug_category,
    c.contracted_rate,

    -- Average all transactions to get effective rate
    ROUND(AVG(t.actual_rate), 4)                    AS effective_rate,

    -- Total units dispensed across the period
    SUM(t.units_dispensed)                          AS volume_units,

    -- Variance: positive = breach, negative = compliant
    ROUND(AVG(t.actual_rate) - c.contracted_rate, 4) AS variance,

    -- Breach flag: automates identification
    CASE
        WHEN AVG(t.actual_rate) - c.contracted_rate > 0
        THEN 'BREACH'
        ELSE 'OK'
    END                                             AS breach_flag,

    -- Financial exposure: variance amplified by volume
    ROUND(
        (AVG(t.actual_rate) - c.contracted_rate)
        * SUM(t.units_dispensed), 2
    )                                               AS financial_impact,

    -- Severity classification based on financial impact
    CASE
        WHEN (AVG(t.actual_rate) - c.contracted_rate)
             * SUM(t.units_dispensed) > 500
        THEN 'CRITICAL'
        WHEN (AVG(t.actual_rate) - c.contracted_rate)
             * SUM(t.units_dispensed) BETWEEN 100 AND 500
        THEN 'HIGH'
        WHEN (AVG(t.actual_rate) - c.contracted_rate)
             * SUM(t.units_dispensed) BETWEEN 1 AND 99
        THEN 'MEDIUM'
        ELSE 'OK'
    END                                             AS severity

FROM transactions t
JOIN pharmacies p
    ON t.pharmacy_id = p.pharmacy_id
JOIN contracts c
    ON t.pharmacy_id = c.pharmacy_id
    AND t.drug_category = c.drug_category

-- Filter to reporting period
WHERE t.transaction_date >= '2026-01-01'
    AND t.transaction_date < '2026-04-01'

GROUP BY
    p.pharmacy_id,
    p.pharmacy_name,
    p.region,
    t.drug_category,
    c.contracted_rate

-- Highest financial impact first for stakeholder prioritisation
ORDER BY financial_impact DESC;