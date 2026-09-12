USE mobile_5g_network_fr;

# Compare Radio conditions in different environments RSRP, RSRQi ndifferent situations Indoor, Outdoor, Incar of the Operators
SELECT operator_name,
	situation,
    COUNT(*) AS nbr_measurements,
    ROUND(AVG(rsrp), 2) AS average_rsrp,
    ROUND(AVG(rsrq), 2) AS avergae_rsrq
FROM qos_denormalized
GROUP BY operator_name, situation
ORDER BY operator_name DESC, situation ASC;


    
