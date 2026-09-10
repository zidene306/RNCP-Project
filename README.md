# API DATA EXTRACTION: INSEE MELODI
https://api.insee.fr/melodi

INSEE
  │
  ├── Sirene → companies ❌
  ├── BDM → economic/time series ❌
  ├── Local Data → legacy/being replaced ❌
  │
  └── Melodi → statistical datasets ✅
                         │
                         ▼
                 Commune-level data: Identifiant du jeu de données : DS_POPULATIONS_REFERENCE

# API data source — INSEE

## Objective:
Enrich ARCEP 5G performance measurements with demographic information at commune level.

## Source selection:
INSEE was selected because it is the official French statistical institute and provides territorial statistical data.

## API selection:
the INSEE Melodi API was selected because it provides programmatic access to the statistical datasets available in the INSEE data catalogue.

## Dataset selection:
the DS_POPULATIONS_REFERENCE dataset was selected because it provides reference population data at commune level.

## Variables selected:

GEO = COM → commune
TIME_PERIOD = 2023
POPREF_MEASURE = PMUN → population municipale

## Integration key: 
the commune INSEE code (insee_com) is used to connect the INSEE population data to the ARCEP QoS measurements


# Data Extraction and methodology
## ARCEP — 5G QoS

Acquisition: Web scraping
File:

../data/raw/2025_QoS_Metropole_data_habitations.csv

Key facts:

354,282 measurement records
5G only
4 operators
insee_com available for all records
1,614 distinct geographic codes originally
4 problematic codes excluded from the analytical dataset:
12076
92201
44701
69159
Therefore: 1,610 communes retained for analysis

This is our main performance dataset.

2. INSEE — Population + geographic hierarchy

Acquisition: INSEE Melodi API + INSEE geographic reference

You have already created the table containing:

insee_com
com_name
insee_dep
dep_name
insee_reg
reg_name

Example:

insee_com	com_name	insee_dep	dep_name	insee_reg	reg_name
01001	ABERGEMENT CLEMENCIAT	01	AIN	84	AUVERGNE RHONE ALPES
01002	ABERGEMENT DE VAREY	01	AIN	84	AUVERGNE RHONE ALPES
01004	AMBERIEU EN BUGEY	01	AIN	84	AUVERGNE RHONE ALPES

And separately, your INSEE population extraction contains:

insee_com
year
measure
population

with:

year = 2023
measure = PMUN

## rscp	RSCP (Received Signal Code Power) au moment de la mesure (en dBm)	Décimal		- 76	Non ==>3G
## rsrp	RSRP (Reference Signal Receive Power) au moment de la mesure (en dBm)	Décimal		- 136	Non
## rsrq	RSRQ (Reference Signal Receive Quality) au moment de la mesure (en dB)	Décimal

Nom du protocole de test	Description	Champs associés
SMS	Test d'envoi de SMS	intra_inter_op_couple, sms_content, sms_delai, sms_reception_date_time, sms_sending_date_time, sms_sending_number, sms_success
VOIX	Test d'appel	average_mos_couple, call_direction, call_number, call_setup_time_to_alerting, call_type, dialed_number, intra_inter_op_couple, list_mos, min_mos, min_mos_couple, mos_average, operator_called, operator_calling, opertaor_identical, real_communication_time, time_to_call
WEB	Chargement de pages web	acess_duration, loaded_in_less_10_secondes, loaded_in_less_5_secondes, transfert_duration, transfert_file_size, url
STREAM	Test de qualité vidéo	quality_correct, quality_perfect, video_freez_duration, video_initialisation_duration, video_viewing_duration
PING	Test d'accès	ping_result
DLH	Réception de fichier 5Mo	bitrate_dl, dl_volume, download_ok, transfert_duration, transfert_file_size, url
ULH	Envoi de fichier 1Mo	bitrate_ul, transfert_file_size, ul_volume, url
DOWNLOAD	Mesure de débit descendant sur fichier 250Mo	bitrate_dl, dl_superior_3mbps, dl_volume, transfert_duration, transfert_file_size, url
UPLOAD	Mesure de débit montant sur fichier 50Mo	bitrate_ul, transfert_file_size, ul_volume, upload_ok, url

# 4G/5G KPIs

RSRP → signal strength / coverage
RSRQ → signal quality / radio conditions

## 5G QoS
│
├── WEB
│   ├── Access duration
│   ├── Loaded < 5 seconds
│   └── Loaded < 10 seconds
│
├── STREAM
│   ├── Correct quality
│   └── Perfect quality
│
├── DOWNLOAD
│   └── Download bitrate
│
├── UPLOAD
│   └── Upload bitrate
│
└── RADIO CONDITIONS
    ├── RSRP
    └── RSRQ

## df comparison:
What your results tell us
Check	Result	Interpretation
QoS communes	1,610	Communes represented in QoS
Sites communes	20,690	Communes represented in Sites
QoS communes without Sites	124	QoS communes with no matching Site record
Those 124 in DIM_GEO	124	✅ All are valid geographic references

