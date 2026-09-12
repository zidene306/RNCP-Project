-- Which operators have the best and worst mobile network performance?
-- Data distribution
SELECT
	COUNT(*) AS total_measurements,
    COUNT(DISTINCT operator_name) AS nbr_of_operators,
    COUNT(DISTINCT protocol_code) AS nbr_of_protocols,
    COUNT(DISTINCT insee_com) AS nbr_of_communes,
    COUNT(DISTINCT insee_dep) AS nbr_of_depts,
    COUNT(DISTINCT insee_reg) AS nbr_of_regions,
    MIN(date_start) AS start_date, MAX(date_start) AS end_date;

-- Measurements by protocol ==> represent in stack bar chart
  
SELECT 	protocol_code,
		COUNT(*) AS number_of_measurements,
        ROUND(
			COUNT(*) * 100.0/ (SELECT COUNT(*) FROM qos_denormalized),
            2) as percentage
FROM qos_denormalized
GROUP BY protocol_code
ORDER BY number_of_measurements DESC;


	
    