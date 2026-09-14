-- Cretae the radio_conditions per region per operator
DROP VIEW IF EXISTS radio_per_reg_per_op;
CREATE VIEW radio_per_reg_per_op AS
SELECT 
	operator_name,
    reg_name,
    ROUND(AVG(rsrp), 2) AS average_RSRP,
    ROUND(AVG(rsrq), 2) AS average_RSRQ
FROM qos_denormalized
GROUP BY operator_name, reg_name
order by operator_name;

SELECT operator_name, reg_name, average_RSRP FROM radio_per_reg_per_op
ORDER BY average_RSRP DESC;

-- define the max RSRP & RSRQ per region per operator
-- 1. by RSRP
WITH ranked_regions AS (
    SELECT
        operator_name,
        reg_name,
        average_rsrp,
        ROW_NUMBER() OVER (
            PARTITION BY operator_name
            ORDER BY average_rsrp DESC
        ) AS best_rank,
        ROW_NUMBER() OVER (
            PARTITION BY operator_name
            ORDER BY average_rsrp ASC
        ) AS worst_rank
    FROM radio_per_reg_per_op
),

best_worst AS (
    SELECT
        operator_name,
        MAX(CASE WHEN best_rank = 1 THEN reg_name END) AS best_region,
        MAX(CASE WHEN best_rank = 1 THEN average_rsrp END) AS best_rsrp,
        MAX(CASE WHEN worst_rank = 1 THEN reg_name END) AS worst_region,
        MAX(CASE WHEN worst_rank = 1 THEN average_rsrp END) AS worst_rsrp
    FROM ranked_regions
    GROUP BY operator_name
)

SELECT
    operator_name,
    best_region,
    best_rsrp,
    worst_region,
    worst_rsrp,
    ROUND(best_rsrp - worst_rsrp, 2) AS territorial_gap_db
FROM best_worst
ORDER BY territorial_gap_db DESC;

--  2. by RSRQ
WITH ranked_regions AS (
    SELECT
        operator_name,
        reg_name,
        average_rsrq,
        ROW_NUMBER() OVER (
            PARTITION BY operator_name
            ORDER BY average_rsrq DESC
        ) AS best_rank,
        ROW_NUMBER() OVER (
            PARTITION BY operator_name
            ORDER BY average_rsrq ASC
        ) AS worst_rank
    FROM radio_per_reg_per_op
),

best_worst AS (
    SELECT
        operator_name,
        MAX(CASE WHEN best_rank = 1 THEN reg_name END) AS best_region,
        MAX(CASE WHEN best_rank = 1 THEN average_rsrq END) AS best_rsrq,
        MAX(CASE WHEN worst_rank = 1 THEN reg_name END) AS worst_region,
        MAX(CASE WHEN worst_rank = 1 THEN average_rsrq END) AS worst_rsrq
    FROM ranked_regions
    GROUP BY operator_name
)

SELECT
    operator_name,
    best_region,
    best_rsrq,
    worst_region,
    worst_rsrq,
    ROUND(best_rsrq - worst_rsrq, 2) AS territorial_gap_db
FROM best_worst
ORDER BY territorial_gap_db DESC;

