USE mobile_5g_network_fr;
ALTER TABLE dim_protocol
MODIFY protocol_code VARCHAR(10);
INSERT INTO dim_protocol(
    protocol_id,
    protocol_code,
    protocol_name
)
VALUES
    (1, 'WEB', 'WEB SERVICE'),
    (2, 'STREAM', 'VIDEO STREAMING'),
    (3, 'DOWNLOAD', 'FILE DOWNLOAD 200MB'),
    (4, 'UPLOAD', 'FILE UPLOAD 50MB');

SELECT * FROM dim_protocol;