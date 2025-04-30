from pathlib import Path
from css_data_downloader import CSSDownloader
from css_db_connector import DatabaseConnector
from css_table_builder import CSSTableBuilder

## Main ##
if __name__ == "__main__":

    ## initiate CSS Downloader instance
    downloader = CSSDownloader()

    # Download data
    downloader.download_and_convert()

    ## initiate DB Connector instance
    db = DatabaseConnector()

    # Connect to Database
    conn, cursor = db.connect()

    # Create parent directory
    base_dir = Path(__file__).parent

    ## initiate CSS Table Builder instance for Oncampushate202122.csv
    builder = CSSTableBuilder(
        csv_path= base_dir / "Oncampushate202122.csv",
        table_name= "css_hate_python",
        database_name= "css",
        primary_key= "UNITID_P",
        str_cols= ["INSTNM", "BRANCH", "Address", "City", "State", "Sector_desc", "ZIP"]
    )

    # insert data into DB
    builder.insert_into_database(cursor)

    ## initiate CSS Table Builder instance or Oncampusvawa202122.csv
    builder = CSSTableBuilder(
        csv_path= base_dir / "Oncampusvawa202122.csv",
        table_name= "css_vawa_python",
        database_name= "css",
        primary_key= "UNITID_P",
        str_cols= ["INSTNM", "BRANCH", "Address", "City", "State", "Sector_desc", "ZIP"]
    )

    # insert data into DB
    builder.insert_into_database(cursor)

    ## Commmit and Close DB connection
    conn.commit()
    db.close()
