import pandas as pd
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import os
import sys
from pathlib import Path
import yaml

project_root = Path.cwd().parent
sys.path.append(str(project_root))
import functions as fn

#Data raw folder path:
raw_folder = r"C:\Users\ziden\Desktop\Trainings\RNCP-Project\data\raw"
#Data clean folder path:
clean_folder = r"C:\Users\ziden\Desktop\Trainings\RNCP-Project\data\clean"

# #---------------------------------------------------------------------------
# OUVRIR un FICHIER DEPUIS LE REPERTOIRE 'data/raw'
#-----------------------------------------------------------------------------

def open_raw_file(filex):
    
    try:
        with open("../config.yaml", "r") as file:
            config = yaml.safe_load(file)
    except:
        print("Yaml configuration file not found!")
    
    #read QoS file
    my_raw_file = pd.read_csv(config["data"]["raw"][filex], sep=";", dtype={"insee_com": "str"}, encoding="latin1")
    
    return my_raw_file

# #---------------------------------------------------------------------------
# OUVRIR un FICHIER DEPUIS LE REPERTOIRE 'clean/raw'
#-----------------------------------------------------------------------------

def open_clean_file(filex):
    
    try:
        with open("../config.yaml", "r") as file:
            config = yaml.safe_load(file)
    except:
        print("Yaml configuration file not found!")
    
    #read QoS file
    my_clean_file = pd.read_csv(config["data"]["clean"][filex], sep=",", dtype={"insee_com": "str"}, encoding="latin1")
    
    return my_clean_file

#-----------------------------------------------------------------------------
# Flat extraction and construction of insee_geo file
# ----------------------------------------------------------------------------

def insee_geo_flat_extract():
    """
    It merges 3 files to extract the collectivity insee_cod and name
    output: df with commune, department, region
    """

    try:
        with open("../config.yaml", "r") as cog_file:
            config = yaml.safe_load(cog_file)
    except:
        print("Yaml configuration file not found!")

    #read the 3 csv files
    cog_com_df = pd.read_csv(config["data"]["raw"]["file3"], dtype={"COM":"str", "REG": "str", "DEP": "str"})
    cog_com_df = cog_com_df[cog_com_df['TYPECOM'] == 'COM']
    cog_com_df = cog_com_df[['COM', 'REG', 'DEP', 'NCC']]

    cog_dept_df = pd.read_csv(config["data"]["raw"]["file4"], dtype={"REG": "str", "DEP": "str"})
    cog_dept_df = cog_dept_df[['DEP','NCC']]
    
    cog_reg_df = pd.read_csv(config["data"]["raw"]["file5"], dtype={"REG": "str"})
    cog_reg_df = cog_reg_df[['REG', 'NCC']]
    
    #rename columns
    cog_com_df = cog_com_df.rename(columns = {'COM': 'insee_com', 'REG': 'insee_reg', 'DEP':'insee_dep', 'NCC':'com_name'})
    cog_dept_df = cog_dept_df.rename(columns = {'DEP': 'insee_dep','NCC':'dep_name'})
    cog_reg_df = cog_reg_df.rename(columns = {'REG': 'insee_reg', 'NCC':'reg_name'})

    #merge df
    merged_com_dep = cog_com_df.merge(cog_dept_df, on='insee_dep', how='left').merge(
        cog_reg_df, on = "insee_reg", how="left")

    #reorder columns:
    merged_df = merged_com_dep[['insee_com', 'com_name', 'insee_dep', 'dep_name', 'insee_reg', 'reg_name']]

    #export to celan data
    file_name = "insee_geo.csv"
    file_path_clean = os.path.join(clean_folder, file_name)
    merged_df.to_csv(file_path_clean, index=False, encoding = "latin1")
    print(f"File '{file_name}' is successfully saved to 'data/clean' folder.")

    return merged_df

#-----------------------------------------------------------------------------
# 1. JOINING Population data with geo data
#-----------------------------------------------------------------------------

def pop_geo_merge_df(population_df, geo_df):
    """ input: geo(com+dep+reg) df and population df 
        This function merges the 2 df
        Output: merged df with population in com/dep/regions
    """

    try:
        with open("../config.yaml", "r") as file:
            config = yaml.safe_load(file)
           
    except:
        print("Yaml configuration file not found!")
    
    #open Geographic file
    geo_df = pd.read_csv(config["data"]["raw"]["file7"], dtype={"insee_com":"str", "insee_dep":"str", "insee_reg":"str"})
    #open population file
    population_df = pd.read_csv(config["data"]["raw"]["file6"], dtype={"year":"int", "population": "int", "insee_com":"str"})

    #reorder columns of population df
    population_df = population_df[["insee_com", "year", "measure", "population"]]
    
    #merge the 2 df
    pop_geo_df = population_df.merge(geo_df, on="insee_com", how="left")
    
    #copy the merged file into raw/clean folder
    geo_pop_file_name = "geo_population_table.csv"
    pop_geo_file_path = os.path.join(clean_folder, geo_pop_file_name)
    pop_geo_df.to_csv(pop_geo_file_path, index=False, encoding="latin1")
    print(f"File '{geo_pop_file_name}' is successfully saved to 'data/clean' folder.")

    return pop_geo_df



#-----------------------------------------------------------------------------
# CLEANING ARCEP QOS FILE
#-----------------------------------------------------------------------------

def clean_qos_df(raw_qos_df):
    
    raw_qos_df = fn.open_raw_file("file1")
    clean_qos_df = raw_qos_df.copy()

    #Exlude 4 communes that have no population data in INSEE population
    clean_qos_df['insee_com'] = clean_qos_df.insee_com.apply(lambda x: x.strip()).astype("string").str.zfill(5)
    excluded_communes = ["12076", "92201", "44701", "69159"] # communes having no population data
    clean_qos_df = clean_qos_df[~clean_qos_df['insee_com'].isin(excluded_communes)]

    empty_columns = clean_qos_df.columns[clean_qos_df.isna().all()]
    other_columns_to_drop = [ "mcc_start",
        "mnc_start",
        "rscp",
        "transfert_file_size",
        "upload_ok",
        "territory"
                      ]
    
    #print("Number of completeley empty colunms is:", len(empty_columns))
    #print("Number of irrelevant columns is:", len(other_columns_to_drop))
    #drop completely empty columns
    #print("Empty columns: ", empty_columns)
    clean_qos_df = clean_qos_df.drop(columns = empty_columns)
    clean_qos_df = clean_qos_df.drop(columns = other_columns_to_drop )
    
    #Drop protocol lines: 
    protocol_rows_to_drop = ["ICMP", "ULH", "DLH"]
    clean_qos_df = clean_qos_df[~clean_qos_df['protocole'].isin(protocol_rows_to_drop)].reset_index(drop=True)
    #print("\nnumber of columns before cleaning: ", len(raw_qos_df.columns))
    #print("\nnumber of columns after cleaning: ", len(clean_qos_df.columns))
    
    #Convert bitrate_ul, bitrate_dl, acess duration to float
    clean_qos_df['bitrate_dl'] = clean_qos_df['bitrate_dl'].astype("string").str.replace(",", ".").astype(float)
    clean_qos_df['bitrate_ul'] = clean_qos_df['bitrate_ul'].astype("string").str.replace(",", ".").astype(float)
    clean_qos_df['acess_duration'] = clean_qos_df['acess_duration'].astype("string").str.replace(",", ".").astype(float)

    #Convert start_date, start_time to date & time respectively
    clean_qos_df['date_start'] = pd.to_datetime(clean_qos_df['date_start'], format="%d-%m-%Y", errors="coerce")
    clean_qos_df['hour_start'] = pd.to_datetime(clean_qos_df['hour_start'], format="%H:%M:%S", errors="coerce").dt.time

    #Clean 'situation' column: former: ['Incar', 'Indoor', 'Outdoor', 'indoor', 'outdoor', 'incar']
    clean_qos_df['situation'] = clean_qos_df['situation'].str.capitalize()

    #Add protocol_id and operator_id columns
    clean_qos_df['operator_id'] = [4 if item == "Bouygues" else 2 if item == "SFR" else 1 if item == "Orange" else 4 for item in clean_qos_df['operator']]
    clean_qos_df['protocol_id'] = [1 if item == "WEB" else 2 if item == "STREAM" else 3 if item == "DOWNLOAD" else 4 for item in clean_qos_df['protocole']]

    #create id_measure

    clean_qos_df.insert(0,
                        "measure_id",
                        range(1, len(clean_qos_df)+1)
                        )

    #Export file to the clean data folder
    file_name = "5G_qos_clean.csv"
    file_path = os.path.join(clean_folder, file_name)
    clean_qos_df.to_csv(file_path, index=False, encoding="latin1")
    print(f"File '{file_name}' is successfully saved to 'data/clean' folder.")

    return clean_qos_df

#-----------------------------------------------------------------------------
# CLEANING INSEE SITES FILE. file2 in "data/raw" folder
#-----------------------------------------------------------------------------

def clean_sites_file(site_file):

    sites_clean_df = fn.open_raw_file(site_file).copy()
        
    #columns to drop
    columns_to_drop = [
        
        "x",
        "y",
        "site_2g",
        "site_3g",
        "site_ZB",
        "site_DCC",
        "site_strategique",
        "site_capa_240mbps"
    ]
    sites_clean_df = sites_clean_df.drop(columns = columns_to_drop)
    
    #convert date_ouverturecommerciale_5g to datetime
    sites_clean_df["date_ouverturecommerciale_5g"] = pd.to_datetime(
        sites_clean_df["date_ouverturecommerciale_5g"], format="%d-%m-%Y",
        errors="coerce"
    )

    #create PK site_id
    sites_clean_df.insert(0,
                        "site_id",
                        range(1, len(sites_clean_df)+1)
                        )
    
    #Export to data/clean folder
    file_name = "insee_sites_clean.csv"
    file_path = os.path.join(clean_folder, file_name)
    sites_clean_df.to_csv(file_path, index=False, encoding="latin1")
    print(f"File '{file_name}' is successfully saved to 'data/clean' folder.")
    
    return sites_clean_df