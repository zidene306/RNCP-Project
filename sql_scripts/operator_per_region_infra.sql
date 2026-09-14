USE mobile_5g_network_fr;

SELECT 
	p.operator_name,
    p.operator_id,
    sr.region_name,
	sr.tot_phys_sites,
    sr.tot_4g_per_op_com,
    sr.tot_5g_per_op_com,
    sr.tot_fake_5g_per_op_com,
    sr.tot_5g_sites    
FROM (
SELECT
    s.operator_id,
    g.reg_name AS region_name,
    COUNT(*) AS tot_phys_sites,
    SUM(s.site_4g) AS tot_4g_per_op_com,
    SUM(s.site_5g) AS tot_5g_per_op_com,
    SUM(s.fake_5g) AS tot_fake_5g_per_op_com,
    SUM(s.site_5g) + SUM(s.fake_5g) AS tot_5g_sites
    
FROM sites AS s
JOIN dim_geo AS g
ON s.insee_com = g.insee_com
GROUP BY
    s.operator_id,
    g.reg_name
ORDER BY s.operator_id ASC, g.reg_name ASC) AS sr
JOIN dim_operator as p
ON sr.operator_id = p.operator_id
ORDER BY sr.operator_id ;



