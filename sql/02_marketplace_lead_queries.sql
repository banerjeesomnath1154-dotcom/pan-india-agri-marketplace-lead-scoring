-- =================================================================
-- PAN-INDIA AGRI-MARKETPLACE: PRODUCTION SQL ANALYTICS QUERIES
-- Database: agri_marketplace.db
-- Tech: SQLite Window Functions, CTEs, Aggregations & Tiering
-- =================================================================

-- Query 1: All-India State Summary (Total FPOs, Members, Turnover)
SELECT 
    m.zone,
    m.state,
    COUNT(m.fpo_id) AS total_fpos,
    SUM(m.member_count) AS total_farmers,
    SUM(CASE WHEN s.composite_score >= 85 THEN 1 ELSE 0 END) AS tier_1_fpos,
    SUM(CASE WHEN s.composite_score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS tier_2_fpos,
    SUM(CASE WHEN s.composite_score < 70 THEN 1 ELSE 0 END) AS tier_3_fpos,
    ROUND(SUM(s.estimated_annual_production_tonnes), 2) AS total_production_tonnes,
    ROUND(SUM(s.estimated_gross_turnover_inr) / 10000000.0, 2) AS total_turnover_cr_inr
FROM fpo_master m
JOIN lead_scores s ON m.fpo_id = s.fpo_id
GROUP BY m.zone, m.state
ORDER BY total_turnover_cr_inr DESC;

-- Query 2: Top 3 Tier-1 FPO Leads per State using Window Function RANK() OVER
WITH RankedLeads AS (
    SELECT 
        m.state,
        m.fpo_name,
        m.district,
        m.major_crop,
        m.member_count,
        a.has_npop_organic_cert,
        a.is_apeda_cluster,
        s.composite_score,
        s.outreach_tier,
        s.estimated_gross_turnover_inr,
        RANK() OVER (PARTITION BY m.state ORDER BY s.composite_score DESC, m.member_count DESC) AS state_rank
    FROM fpo_master m
    JOIN apeda_export_clusters a ON m.fpo_id = a.fpo_id
    JOIN lead_scores s ON m.fpo_id = s.fpo_id
    WHERE s.composite_score >= 85
)
SELECT * FROM RankedLeads
WHERE state_rank <= 3
ORDER BY state, state_rank;

-- Query 3: Zone-Wise Organic & APEDA Export Cluster Breakdown
SELECT 
    m.zone,
    COUNT(m.fpo_id) AS total_fpos,
    SUM(a.has_npop_organic_cert) AS npop_certified_fpos,
    SUM(a.is_apeda_cluster) AS apeda_cluster_fpos,
    SUM(a.has_cbbo_support) AS cbbo_backed_fpos,
    ROUND(AVG(s.composite_score), 2) AS avg_composite_score,
    ROUND(SUM(s.estimated_gross_turnover_inr) / 10000000.0, 2) AS total_turnover_cr_inr
FROM fpo_master m
JOIN apeda_export_clusters a ON m.fpo_id = a.fpo_id
JOIN lead_scores s ON m.fpo_id = s.fpo_id
GROUP BY m.zone
ORDER BY total_turnover_cr_inr DESC;

-- Query 4: Commodity / Crop Specialty High-Value Ranking
SELECT 
    m.major_crop,
    COUNT(m.fpo_id) AS fpo_count,
    SUM(m.member_count) AS total_smallholders,
    ROUND(AVG(s.composite_score), 1) AS avg_score,
    ROUND(SUM(s.estimated_annual_production_tonnes), 2) AS total_tonnes,
    ROUND(SUM(s.estimated_gross_turnover_inr) / 10000000.0, 2) AS total_turnover_cr_inr
FROM fpo_master m
JOIN lead_scores s ON m.fpo_id = s.fpo_id
GROUP BY m.major_crop
HAVING fpo_count >= 5
ORDER BY total_turnover_cr_inr DESC;
