-- ============================================
-- Pharmacy Pricing Guarantee Monitor
-- Data: Insert Script
-- Author: Barry Eldad
-- Date: April 2026
-- Description: Loads simulated pharmacy,
-- contract, and transaction data for
-- Q1-Q4 2024 and Q1 2026
-- ============================================

USE PharmacyPricingDB;

-- -----------------------------------------------
-- LOAD DIMENSION TABLE 1: pharmacies
-- 10 network pharmacies across 4 regions
-- -----------------------------------------------
INSERT INTO pharmacies (pharmacy_id, pharmacy_name, region)
VALUES
('PH001', 'CityMed Pharmacy', 'North'),
('PH002', 'HealthFirst Rx', 'South'),
('PH003', 'QuickCare Drugs', 'East'),
('PH004', 'MediPlus', 'West'),
('PH005', 'PharmaHub', 'North'),
('PH006', 'CarePlus Rx', 'South'),
('PH007', 'NorthStar Pharmacy', 'East'),
('PH008', 'WellnessRx', 'West'),
('PH009', 'TotalCare Drugs', 'North'),
('PH010', 'PrimeCare Pharmacy', 'South');

-- -----------------------------------------------
-- LOAD DIMENSION TABLE 2: contracts
-- Contracted rates by pharmacy and drug category
-- Generic: 0.85 | Brand: 1.20 | Specialty: 2.50
-- -----------------------------------------------
INSERT INTO contracts (pharmacy_id, drug_category, contracted_rate)
VALUES
('PH001', 'Generic', 0.85),
('PH002', 'Brand', 1.20),
('PH003', 'Generic', 0.85),
('PH004', 'Specialty', 2.50),
('PH005', 'Brand', 1.20),
('PH006', 'Generic', 0.85),
('PH007', 'Specialty', 2.50),
('PH008', 'Generic', 0.85),
('PH009', 'Brand', 1.20),
('PH010', 'Specialty', 2.50);

-- -----------------------------------------------
-- LOAD FACT TABLE: transactions
-- Q1 2024 - 3 months of dispensing data
-- -----------------------------------------------
INSERT INTO transactions
(pharmacy_id, drug_category, actual_rate, units_dispensed, transaction_date)
VALUES
('PH001','Generic',0.83,400,'2024-01-15'),
('PH001','Generic',0.82,400,'2024-02-15'),
('PH001','Generic',0.84,400,'2024-03-15'),
('PH002','Brand',1.35,270,'2024-01-15'),
('PH002','Brand',1.34,260,'2024-02-15'),
('PH002','Brand',1.36,270,'2024-03-15'),
('PH003','Generic',0.86,500,'2024-01-15'),
('PH003','Generic',0.86,500,'2024-02-15'),
('PH003','Generic',0.86,500,'2024-03-15'),
('PH004','Specialty',2.48,100,'2024-01-15'),
('PH004','Specialty',2.48,100,'2024-02-15'),
('PH004','Specialty',2.48,100,'2024-03-15'),
('PH005','Brand',1.19,320,'2024-01-15'),
('PH005','Brand',1.19,315,'2024-02-15'),
('PH005','Brand',1.19,315,'2024-03-15'),
('PH006','Generic',0.91,670,'2024-01-15'),
('PH006','Generic',0.91,665,'2024-02-15'),
('PH006','Generic',0.91,665,'2024-03-15'),
('PH007','Specialty',2.75,50,'2024-01-15'),
('PH007','Specialty',2.75,50,'2024-02-15'),
('PH007','Specialty',2.75,50,'2024-03-15'),
('PH008','Generic',0.84,585,'2024-01-15'),
('PH008','Generic',0.84,583,'2024-02-15'),
('PH008','Generic',0.84,582,'2024-03-15'),
('PH009','Brand',1.20,200,'2024-01-15'),
('PH009','Brand',1.20,200,'2024-02-15'),
('PH009','Brand',1.20,200,'2024-03-15'),
('PH010','Specialty',2.55,140,'2024-01-15'),
('PH010','Specialty',2.55,140,'2024-02-15'),
('PH010','Specialty',2.55,140,'2024-03-15');

-- -----------------------------------------------
-- Q1 2026 (January - March)
-- Current period -- highest breach levels yet
-- PH002, PH006, PH007 at critical exposure
-- -----------------------------------------------
INSERT INTO transactions
(pharmacy_id, drug_category, actual_rate, units_dispensed, transaction_date)
VALUES
('PH001','Generic',0.87,470,'2026-01-15'),
('PH001','Generic',0.86,465,'2026-02-15'),
('PH001','Generic',0.88,475,'2026-03-15'),
('PH002','Brand',1.48,320,'2026-01-15'),
('PH002','Brand',1.49,315,'2026-02-15'),
('PH002','Brand',1.50,325,'2026-03-15'),
('PH003','Generic',0.93,550,'2026-01-15'),
('PH003','Generic',0.94,545,'2026-02-15'),
('PH003','Generic',0.95,560,'2026-03-15'),
('PH004','Specialty',2.46,125,'2026-01-15'),
('PH004','Specialty',2.47,122,'2026-02-15'),
('PH004','Specialty',2.45,128,'2026-03-15'),
('PH005','Brand',1.18,350,'2026-01-15'),
('PH005','Brand',1.19,345,'2026-02-15'),
('PH005','Brand',1.17,340,'2026-03-15'),
('PH006','Generic',0.98,750,'2026-01-15'),
('PH006','Generic',0.99,745,'2026-02-15'),
('PH006','Generic',1.00,760,'2026-03-15'),
('PH007','Specialty',2.95,70,'2026-01-15'),
('PH007','Specialty',2.97,68,'2026-02-15'),
('PH007','Specialty',2.99,72,'2026-03-15'),
('PH008','Generic',0.83,620,'2026-01-15'),
('PH008','Generic',0.84,615,'2026-02-15'),
('PH008','Generic',0.83,625,'2026-03-15'),
('PH009','Brand',1.24,235,'2026-01-15'),
('PH009','Brand',1.25,230,'2026-02-15'),
('PH009','Brand',1.23,240,'2026-03-15'),
('PH010','Specialty',2.67,165,'2026-01-15'),
('PH010','Specialty',2.68,162,'2026-02-15'),
('PH010','Specialty',2.70,168,'2026-03-15');