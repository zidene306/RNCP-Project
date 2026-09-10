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