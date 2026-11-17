# Pan-India Agri-Marketplace: FPO Lead-Scoring & Expansion Architecture

## Executive Project Overview

This repository presents an industrial-grade **Pan-India Agricultural Marketplace Architecture & Lead-Scoring Pipeline** designed to aggregate registered **Farmer Producer Organisations (FPOs)** across **28 States and Union Territories**.

By bridging official government datasets (**SFAC, UPAg, APEDA, and DES**) with an automated **100-Point Lead-Scoring Engine**, the framework identifies, evaluates, and prioritizes high-capacity FPOs for digital marketplace onboarding and direct commercial buyer linkage.

### Key Highlights
- **Total FPOs Scored:** 1,252 FPOs across 28 States & UTs
- **Smallholder Farmers Mapped:** 524,193 Farmers
- **Total Cultivated Land Area:** 935,528.3 Hectares
- **Estimated Gross Annual Turnover:** INR 14,990.23 Crores

---

## Repository Directory Structure

```text
pan-india-agri-marketplace-lead-scoring/
│
├── README.md                                  <-- Master documentation & architecture guide
├── EXECUTIVE_REPORT_MARKETPLACE_EXPANSION.md  <-- CFO/COO-level All-India Strategic Brief
├── fpo_scoring_engine.py                      <-- Standalone Python modular scoring script
│
├── data/
│   ├── fpo_marketplace_raw.csv               <-- Raw All-India FPO dataset (1,250+ records)
│   ├── fpo_lead_scoring_master.csv           <-- Cleaned, scored, and tier-assigned master dataset
│   ├── fpo_state_summary.csv                 <-- Aggregated state & tier summary for Tableau/BI
│   └── agri_marketplace.db                   <-- Relational SQLite database (4 tables)
│
├── sql/
│   └── 02_marketplace_lead_queries.sql       <-- Production SQL queries (RANK() OVER, Window Functions)
│
├── excel/
│   └── fpo_marketplace_lead_reconciliation.xlsx <-- Audit-ready Excel reconciliation model (SUMIF/XLOOKUP)
│
└── notebooks/
    └── 01_fpo_lead_scoring_pipeline.ipynb    <-- Jupyter notebook walking through EDA & scoring pipeline
```

---

## The 100-Point Lead-Scoring Logic

Our objective scoring engine evaluates each FPO across 4 strategic criteria:

1. **Export & Market Alignment (Max 40 Points):** Active NPOP Organic Certification (+25 pts) + APEDA Notified Export Cluster (+15 pts).
2. **District Yield & Capacity (Max 30 Points):** High Yield Tier (+30 pts) | Moderate (+15 pts) | Low (+5 pts).
3. **FPO Scale & Membership Base (Max 20 Points):** Active Members >=500 (+20 pts) | 200-499 (+10 pts) | <200 (+5 pts).
4. **Technical & CBBO Support (Max 10 Points):** Empanelled CBBO / SFAC Support (+10 pts).

### Action Tiers
- **Tier 1: High Priority (Score 85-100)** -> Immediate Commercial Onboarding
- **Tier 2: Medium Priority (Score 70-84)** -> Mid-Term Capacity Building
- **Tier 3: Secondary Priority (Score < 70)** -> Agronomic Nurturing

---

## Zero-Variance Audit Proof

To guarantee strict compliance across Python data engineering, SQLite database queries, and Excel financial spreadsheets:

- **FPO Count Verification:** 1,252 Raw = 1,252 Scored Master = 1,252 SQLite Database (**0.00 Variance**).
- **Farmer Member Count Verification:** 524,193 Raw = 524,193 Scored Master = 524,193 SQL Query (**0.00 Variance**).
- **Marketplace Turnover Verification:** INR 14,990.23 Cr Python = INR 14,990.23 Cr Excel `SUMIF` Formula (**0.00 Variance**).

---

## How to Reproduce & Run

1. **Run Standalone Scoring Engine:**
   ```bash
   python3 fpo_scoring_engine.py
   ```
2. **Execute Jupyter Notebook Pipeline:**
   ```bash
   jupyter notebook notebooks/01_fpo_lead_scoring_pipeline.ipynb
   ```
3. **Run SQL Analytics Queries:**
   ```bash
   sqlite3 data/agri_marketplace.db < sql/02_marketplace_lead_queries.sql
   ```
4. **Inspect Excel Audit Model:**  
   Open `excel/fpo_marketplace_lead_reconciliation.xlsx` to inspect formulas and variance checks.

---

## 👤 Author & Contact
* **Author:** Somnath Banerjee
* **Role:** Aspiring Agri-Business Analyst & Geospatial BI Specialist
* **LinkedIn:** linkedin.com/in/somnath-banerjee-621720239
* **GitHub:** https://github.com/banerjeesomnath1154-dotcom
