-- 1. Protocol 1: WEB service
 
SELECT 
	protocol_code AS protocol_name,
    operator_name,
    reg_name as region_name,
        
    ROUND(AVG(acess_duration),2) AS avg_web_access_duration, -- FOR WEB 
    ROUND(SUM(loaded_in_less_5_secondes)*100.0 / COUNT(*), 2) AS less_5sec_load_perc,-- FOR WEB 
    ROUND((SUM(loaded_in_less_10_secondes) - SUM(loaded_in_less_5_secondes)) * 100.0 / COUNT(*), 2) AS loaded_between_5s_and_10s_perc, -- FOR WEB 
    ROUND((COUNT(*) - SUM(loaded_in_less_10_secondes)) * 100 / COUNT(*), 2) AS loaded_sup_10sec_perc  -- FOR WEB 
    
FROM qos_denormalized
WHERE protocol_code = "WEB"
GROUP BY
	protocol_code, operator_name, reg_name
ORDER BY operator_name, avg_web_access_duration ASC;

-- 2. Protocol 2: DOWNLOAD service    
SELECT 
	protocol_code AS protocol_name,
    operator_name,
    reg_name as region_name,
    ROUND(AVG(bitrate_dl), 2) AS avg_download_speed
        
FROM qos_denormalized
WHERE protocol_code = "DOWNLOAD"
GROUP BY
	protocol_code, operator_name, reg_name
ORDER BY operator_name, avg_download_speed DESC;

-- 3. Protocol 3: UPLOAD service  
SELECT 
	protocol_code AS protocol_name,
    operator_name,
    reg_name as region_name,
    ROUND(AVG(bitrate_ul), 2) AS avg_upload_speed
        
FROM qos_denormalized
WHERE protocol_code = "UPLOAD"
GROUP BY
	protocol_code, operator_name, reg_name

ORDER BY operator_name, avg_upload_speed DESC; 

-- 4. Protocol 4: STREAMING service
 
SELECT 
	protocol_code AS protocol_name,
    operator_name,
    reg_name as region_name,
    
    ROUND((SUM(quality_perfect))*100.0 / COUNT(*),2) AS perfect_quality_perc,
    ROUND((SUM(quality_correct) - SUM(quality_perfect)) *100.0 / COUNT(*),2) AS correct_quality_perc,
    ROUND((COUNT(*) - SUM(quality_correct))*100.0 / COUNT(*),2) AS less_than_correct_quality_perc
FROM qos_denormalized
WHERE protocol_code = "STREAM"
GROUP BY
	protocol_code, operator_name, reg_name
ORDER BY operator_name, perfect_quality_perc DESC;