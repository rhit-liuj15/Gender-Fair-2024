import configparser
from pathlib import Path
import mysql.connector

class DatabaseConnector:
    ##################################################################################
    ## Load a database config file to establish a connection to the database        ##
    ## Make sure to put css_db_connector.py and db_config.ini under the same folder ##
    ## :Param config_filename: name of the database config file                     ##
    ## :Return database connection                                                  ##
    ##################################################################################
    def __init__(self, config_filename="db_config.ini"):
        self.config_filename = config_filename
        self.connection = None
        self.cursor = None

    def connect(self):
        config_path = Path(__file__).parent / self.config_filename

        if not config_path.is_file():
            raise FileNotFoundError(f"Config file not found: {config_path}")

        config = configparser.ConfigParser()
        config.read(config_path)

        db_config = {
            'host': config['mysql']['host'],
            'port': int(config['mysql']['port']),
            'user': config['mysql']['user'],
            'password': config['mysql']['password'],
            'database': config['mysql']['database']
        }

        self.connection = mysql.connector.connect(**db_config)
        self.cursor = self.connection.cursor()
        print("Connection successful")
        return self.connection, self.cursor

    def close(self):
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        print("Connection closed")
