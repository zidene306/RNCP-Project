USE mobile_5g_network_fr;
SELECT COUNT(*) AS number_of_sites FROM sites; -- 118087
SELECT COUNT(DISTINCT site_id) FROM sites;
SELECT operator_id, insee_com,
	COUNT(*) AS number_of_phys_sites,
    SUM(site_4G) as nbr_of_sites_4G, 
	SUM(site_5G) as nbr_of_sites_5G, 
	SUM(fake_5g) AS nbr_of_sites_fake_5g
FROM sites
GROUP BY insee_com, operator_id;
