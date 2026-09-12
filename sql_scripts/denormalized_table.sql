USE mobile_5g_network_fr;
CREATE TABLE sites_by_operator_commune AS
SELECT
    operator_id,
    insee_com,
    COUNT(*) AS nbr_sites,
    SUM(site_4g) AS nbr_sites_4g,
    SUM(site_5g) AS nbr_sites_5g,
    SUM(fake_5g) AS nbr_sites_fake_5g
FROM sites
GROUP BY
    operator_id,
    insee_com;
    
    SELECT * FROM sites_by_operator_commune;


-- DENORMALIZE QOS_measurements

DROP TABLE IF EXISTS qos_denormalized;
CREATE TABLE IF NOT EXISTS qos_denormalized AS
SELECT 
	q.measure_id,
    q.date_start,
	q.insee_com,
    q.hour_start,
    q.acess_duration,
    q.bitrate_dl,
    q.bitrate_ul,
    q.loaded_in_less_10_secondes,
    q.loaded_in_less_5_secondes,
    q.quality_correct,
    q.quality_perfect,
    q.rsrp,
    q.rsrq,
    q.situation,
	q.terminal,
    q.url,
    q.zone,
    q.zone_name,
    q.Result,
    
    -- from dim geo
    g.com_name,
    g.insee_dep,
    g.dep_name,
    g.insee_reg,
    g.reg_name,
    
    -- from dim_operator
    o.operator_name,
    
    -- from dim_protocol
    p.protocol_code,
    
    -- from sites_by_operator_commune
    s.nbr_sites,
    s.nbr_sites_4g,
    s.nbr_sites_5g,
    s.nbr_sites_fake_5g
    
FROM fact_qos_measurements as q
LEFT JOIN dim_geo as g
ON q.insee_com = g.insee_com

LEFT JOIN dim_operator as o
ON q.operator_id = o.operator_id

LEFT JOIN dim_protocol as p
ON q.protocol_id = p.protocol_id

LEFT JOIN sites_by_operator_commune as s
ON q.insee_com = s.insee_com AND q.operator_id = s.operator_id;

SELECT COUNT(*) FROM qos_denormalized;

