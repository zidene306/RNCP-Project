CREATE DATABASE IF NOT EXISTS mobile_5g_network_fr;
USE mobile_5g_network_fr;

CREATE TABLE IF NOT EXISTS `fact_qos_measurements` (
	`measure_id` BIGINT UNSIGNED NOT NULL UNIQUE,
	`acess_duration` FLOAT,
	`bitrate_dl` FLOAT,
	`bitrate_ul` FLOAT,
	`date_start` DATE,
	`hour_start` TIME,
	`insee_com` VARCHAR(5),
	`latitude_start` FLOAT,
	`loaded_in_less_10_secondes` FLOAT,
	`loaded_in_less_5_secondes` FLOAT,
	`longitude_start` FLOAT,
	`quality_correct` FLOAT,
	`quality_perfect` FLOAT,
	`rsrp` FLOAT,
	`rsrq` FLOAT,
	`protocol_id` INTEGER,
	`operator_id` INTEGER,
	`situation` VARCHAR(255),
	`techno_start` VARCHAR(255),
	`terminal` VARCHAR(255),
	`url` VARCHAR(255),
	`zone` VARCHAR(255),
	`zone_name` VARCHAR(255),
	`Result` VARCHAR(255),
	PRIMARY KEY(`measure_id`)
);


CREATE TABLE IF NOT EXISTS `sites` (
	`site_id` BIGINT UNSIGNED NOT NULL UNIQUE,
	`operator_id` INTEGER,
	`num_site` VARCHAR(255),
	`id_site_partage` VARCHAR(255),
	`id_station_anfr` VARCHAR(255),
	`latitude` FLOAT,
	`longitude` FLOAT,
	`site_4g` INTEGER,
	`site_5g` INTEGER,
	`mes_4g_trim` INTEGER,
	`date_ouverturecommerciale_5g` DATE,
	`site_5g_700_m_hz` INTEGER,
	`site_5g_800_m_hz` INTEGER,
	`site_5g_1800_m_hz` INTEGER,
	`site_5g_2100_m_hz` INTEGER,
	`site_5g_3500_m_hz` INTEGER,
	`insee_com` VARCHAR(5),
	PRIMARY KEY(`site_id`)
);


CREATE TABLE IF NOT EXISTS `dim_geo` (
	`insee_com` VARCHAR(5) NOT NULL UNIQUE,
	`com_name` VARCHAR(100),
	`insee_dep` VARCHAR(5),
	`dep_name` VARCHAR(255),
	`insee_reg` INTEGER,
	`reg_name` VARCHAR(100),
	PRIMARY KEY(`insee_com`)
);


CREATE TABLE IF NOT EXISTS `dim_operator` (
	`operator_id` INTEGER UNSIGNED NOT NULL UNIQUE,
	`code_op` INTEGER,
	`operator_name` CHAR(50),
	PRIMARY KEY(`operator_id`)
);


CREATE TABLE IF NOT EXISTS `dim_protocol` (
	`protocol_id` INTEGER UNSIGNED NOT NULL UNIQUE,
	`protocol_code` VARCHAR(5),
	`protocol_name` VARCHAR(255),
	PRIMARY KEY(`protocol_id`)
);


ALTER TABLE `fact_qos_measurements`
ADD FOREIGN KEY(`insee_com`) REFERENCES `dim_geo`(`insee_com`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `fact_qos_measurements`


ADD FOREIGN KEY(`protocol_id`) REFERENCES `dim_protocol`(`protocol_id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `fact_qos_measurements`
ADD FOREIGN KEY(`operator_id`) REFERENCES `dim_operator`(`operator_id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `sites`
ADD FOREIGN KEY(`operator_id`) REFERENCES `dim_operator`(`operator_id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `sites`
ADD FOREIGN KEY(`insee_com`) REFERENCES `dim_geo`(`insee_com`)
ON UPDATE NO ACTION ON DELETE NO ACTION;

USE mobile_5g_network_fr;

ALTER TABLE fact_qos_measurements
MODIFY protocol_id INT UNSIGNED;

ALTER TABLE fact_qos_measurements
MODIFY operator_id INT UNSIGNED;

ALTER TABLE sites
MODIFY operator_id INT UNSIGNED;

SHOW TABLES;
DESCRIBE dim_operator;
DESCRIBE dim_protocol;
DESCRIBE sites;
DESCRIBE fact_qos_measurements;