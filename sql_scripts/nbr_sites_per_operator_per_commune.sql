USE mobile_5g_network_fr;
DROP TABLE IF EXISTS mobile_5g_network_fr.sites_by_operator_commune ;
CREATE TABLE mobile_5g_network_fr.sites_by_operator_commune AS
SELECT
    operator_id,
    insee_com,
    COUNT(*) AS tot_phys_sites,
    SUM(site_4g) AS tot_4g_per_op_com,
    SUM(site_5g) AS tot_5g_per_op_com,
    SUM(fake_5g) AS tot_fake_5g_per_op_com,
    SUM(site_5g) + SUM(fake_5g) AS tot_5g_sites
FROM sites
GROUP BY
    operator_id,
    insee_com
ORDER BY operator_id ASC, insee_com ASC;