## Use command <pip install mysql-connector-python pandas> to install libraries ##
import pandas as pd
import mysql.connector
from pathlib import Path
import configparser

###########################################################################
## Load a database config file to establish a connection to the database
## Make sure to put css_import.py and db_config.ini under the same folder
## :Param config_filename: name of the database config file
## :Return database connection
###########################################################################
def get_db_connection(config_filename="db_config.ini"):
    # Get the absolute path to the config file, relative to the script location
    config_path = Path(__file__).parent / config_filename
    
    # Make sure the file exists
    if not config_path.is_file():
        raise FileNotFoundError(f"Config file not found: {config_path}")
    
    # Parse the config
    config = configparser.ConfigParser()
    config.read(config_path)
    
    db_config = {
        'host': config['mysql']['host'],
        'port': int(config['mysql']['port']),
        'user': config['mysql']['user'],
        'password': config['mysql']['password'],
        'database': config['mysql']['database']
    }
    
    return mysql.connector.connect(**db_config)

# Connect to MySQL
conn = get_db_connection()
cursor = conn.cursor()
print("Connection successful")

# Load Hate CSV
csv_path = 'C:/Users/shaoz3/Documents/RHIT/4 Senior/Capstone/Crime2023EXCEL/Oncampushate202122.csv'
df = pd.read_csv(csv_path)

# TABLE Configuration
table_name = "css_hate_python"
database_name = "css"
primary_key = "UNITID_P"
str_cols = ["INSTNM", "BRANCH", "Address", "City", "State", "Sector_desc", "ZIP"]

# Build CREATE TABLE statement
columns = []
for col in df.columns:
    if col == primary_key:
        columns.append(f"`{col}` INT PRIMARY KEY")
    elif col in str_cols:
        columns.append(f"`{col}` VARCHAR(128)")
    else:
        columns.append(f"`{col}` INT")

create_table_query = f"CREATE TABLE IF NOT EXISTS `{database_name}`.`{table_name}` (\n    "
create_table_query += ",\n    ".join(columns) + "\n);"

# Create table
cursor.execute(f"DROP TABLE IF EXISTS `{table_name}`") 
cursor.execute(create_table_query)

# Prepare INSERT query
placeholders = ', '.join(['%s'] * len(df.columns))
column_names = ', '.join(f"`{col}`" for col in df.columns)
insert_query = f"INSERT INTO `{table_name}` ({column_names}) VALUES ({placeholders})"

# Insert all rows
for row in df.itertuples(index=False):
    cursor.execute(insert_query, tuple(row))

print("CSS HATE Table created and data inserted successfully.")

# Load VAWA CSV
csv_path = 'C:/Users/shaoz3/Documents/RHIT/4 Senior/Capstone/Crime2023EXCEL/Oncampusvawa202122.csv'
df = pd.read_csv(csv_path)

# Configuration
table_name = "css_vawa_python"
database_name = "css"
primary_key = "UNITID_P"
str_cols = ["INSTNM", "BRANCH", "Address", "City", "State", "Sector_desc", "ZIP"]

# Build CREATE TABLE statement
columns = []
for col in df.columns:
    if col == primary_key:
        columns.append(f"`{col}` INT PRIMARY KEY")
    elif col in str_cols:
        columns.append(f"`{col}` VARCHAR(128)")
    else:
        columns.append(f"`{col}` INT")

create_table_query = f"CREATE TABLE IF NOT EXISTS `{database_name}`.`{table_name}` (\n    "
create_table_query += ",\n    ".join(columns) + "\n);"

# Create table
cursor.execute(f"DROP TABLE IF EXISTS `{table_name}`") 
cursor.execute(create_table_query)

# Prepare INSERT query
placeholders = ', '.join(['%s'] * len(df.columns))
column_names = ', '.join(f"`{col}`" for col in df.columns)
insert_query = f"INSERT INTO `{table_name}` ({column_names}) VALUES ({placeholders})"

# Insert all rows
for row in df.itertuples(index=False):
    cursor.execute(insert_query, tuple(row))

print("CSS VAWA Table created and data inserted successfully.")

# Close DB connection
conn.commit()
cursor.close()
conn.close()
