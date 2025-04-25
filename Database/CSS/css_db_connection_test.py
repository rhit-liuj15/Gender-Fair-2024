import mysql.connector
from pathlib import Path
import configparser

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

# config_path = "db_config.ini"
conn = get_db_connection()
cursor = conn.cursor()
print("Connection successful")

cursor.close()
conn.close()
print("Connection closed")