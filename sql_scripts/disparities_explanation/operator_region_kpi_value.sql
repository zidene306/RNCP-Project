select * from qos_denormalized;
-- Long-format query: KPI per region per Protocol per operator:

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Average access duration (sec)' AS kpi_name,
    ROUND(AVG(acess_duration), 2) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'WEB'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Loaded in less than 5 seconds (%)' AS kpi_name,
    ROUND(SUM(loaded_in_less_5_secondes) * 100.0 / COUNT(*), 2) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'WEB'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Loaded between 5 and 10 seconds (%)' AS kpi_name,
    ROUND(
        (SUM(loaded_in_less_10_secondes) -
         SUM(loaded_in_less_5_secondes)) * 100.0 / COUNT(*),
        2
    ) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'WEB'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Loaded in more than 10 seconds (%)' AS kpi_name,
    ROUND(
        (COUNT(*) - SUM(loaded_in_less_10_secondes)) * 100.0 / COUNT(*),
        2
    ) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'WEB'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Average download speed (Mbps)' AS kpi_name,
    ROUND(AVG(bitrate_dl), 2) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'DOWNLOAD'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Average upload speed (Mbps)' AS kpi_name,
    ROUND(AVG(bitrate_ul), 2) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'UPLOAD'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Perfect quality (%)' AS kpi_name,
    ROUND(SUM(quality_perfect) * 100.0 / COUNT(*), 2) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'STREAM'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Correct quality (%)' AS kpi_name,
    ROUND(
        (SUM(quality_correct) -
         SUM(quality_perfect)) * 100.0 / COUNT(*),
        2
    ) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'STREAM'
GROUP BY operator_name, reg_name, protocol_code

UNION ALL

SELECT
    operator_name,
    reg_name AS region_name,
    protocol_code AS protocol_name,
    'Less than correct quality (%)' AS kpi_name,
    ROUND(
        (COUNT(*) -
         SUM(quality_correct)) * 100.0 / COUNT(*),
        2
    ) AS kpi_value
FROM qos_denormalized
WHERE protocol_code = 'STREAM'
GROUP BY operator_name, reg_name, protocol_code

ORDER BY
    operator_name,
    protocol_name,
    region_name,
    kpi_name;