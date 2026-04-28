# Data Dictionary
## Pharmacy Pricing Guarantee Monitor
**Author:** Barry Eldad  
**Last Updated:** April 2026  
**Version:** 1.0

---

## Overview
This data dictionary describes all tables, columns, and calculated fields 
in the PharmacyPricingDB database. It should be updated whenever the 
schema changes or new analytical fields are introduced.

---

## Tables

### 1. pharmacies
**Description:** Master list of network pharmacies. One row per pharmacy.  
**Type:** Dimension Table  
**Row Count:** 10 (current)

| Column | Data Type | Description | Example | Notes |
|---|---|---|---|---|
| pharmacy_id | VARCHAR(10) | Unique identifier for each pharmacy | PH001 | Primary key. Format: PH + 3 digits |
| pharmacy_name | VARCHAR(100) | Trading name of the pharmacy | CityMed Pharmacy | Never null |
| region | VARCHAR(50) | Geographic region of pharmacy | North | Values: North, South, East, West |

---

### 2. contracts
**Description:** Contracted rates agreed between the PBM and each pharmacy 
per drug category. One row per pharmacy per drug category.  
**Type:** Dimension Table  
**Row Count:** 10 (current)

| Column | Data Type | Description | Example | Notes |
|---|---|---|---|---|
| contract_id | INT | Auto-generated unique identifier | 1 | Primary key. IDENTITY(1,1) |
| pharmacy_id | VARCHAR(10) | Links to pharmacies table | PH001 | Foreign key |
| drug_category | VARCHAR(50) | Drug category covered by this contract | Generic | Values: Generic, Brand, Specialty |
| contracted_rate | DECIMAL(10,4) | Maximum agreed dispensing rate per unit | 0.8500 | Generic: 0.85, Brand: 1.20, Specialty: 2.50 |

---

### 3. transactions
**Description:** Records every individual dispensing event across the 
pharmacy network. This is the central fact table — highest volume table 
in the model. In production this table grows continuously as new 
transactions are ingested via the ADF pipeline.  
**Type:** Fact Table  
**Row Count:** 150 (simulated — Q1 2024 through Q1 2026)

| Column | Data Type | Description | Example | Notes |
|---|---|---|---|---|
| transaction_id | INT | Auto-generated unique identifier | 1 | Primary key. IDENTITY(1,1) |
| pharmacy_id | VARCHAR(10) | Links to pharmacies table | PH001 | Foreign key. Indexed |
| drug_category | VARCHAR(50) | Drug category of dispensed item | Generic | Values: Generic, Brand, Specialty. Indexed |
| actual_rate | DECIMAL(10,4) | Rate actually charged by pharmacy at dispensing | 0.9100 | Per unit. DECIMAL used for financial precision |
| units_dispensed | INT | Number of units dispensed in this transaction | 670 | Always positive |
| transaction_date | DATE | Date of dispensing event | 2026-01-15 | Indexed for period filtering |

---

## Indexes

| Index Name | Table | Columns | Purpose |
|---|---|---|---|
| IX_transactions_date | transactions | transaction_date | Speeds up period-based WHERE filtering |
| IX_transactions_pharmacy | transactions | pharmacy_id | Speeds up JOIN operations |
| IX_transactions_category | transactions | drug_category | Speeds up category aggregation |
| IX_transactions_pharmacy_date | transactions | pharmacy_id, transaction_date | Composite index for most common query pattern |

---

## Calculated Fields
These fields are not stored in tables — they are calculated at query time 
in the pricing analysis query and stored procedure.

| Field | Formula | Description |
|---|---|---|
| effective_rate | AVG(actual_rate) | Average rate charged across all transactions in the period |
| variance | effective_rate - contracted_rate | Gap between actual and contracted rate. Positive = breach |
| financial_impact | variance × volume_units | Financial exposure in monetary value |
| breach_flag | IF variance > 0 THEN BREACH ELSE OK | Automated breach identification |
| severity | Based on financial_impact thresholds | CRITICAL >500, HIGH 100-500, MEDIUM 1-99, OK ≤0 |

---

## Severity Classification Thresholds

| Severity | Financial Impact Range | Action Required |
|---|---|---|
| CRITICAL | > 500 | Immediate escalation to contracts team |
| HIGH | 100 — 500 | Review within current reporting cycle |
| MEDIUM | 1 — 99 | Monitor closely next quarter |
| OK | ≤ 0 | Compliant — no action required |

---

## Relationships

| Relationship | Type | Join Condition |
|---|---|---|
| pharmacies → transactions | One-to-many | pharmacy_id |
| pharmacies → contracts | One-to-many | pharmacy_id |
| transactions → contracts | Many-to-one | pharmacy_id AND drug_category |

---

## Change Log

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | April 2026 | Barry Eldad | Initial data dictionary created |