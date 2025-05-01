from pathlib import Path
from css_data_downloader import CSSDownloader
from css_db_connector import DatabaseConnector
from css_table_builder import CSSTableBuilder
import argparse
import tempfile

## Main ##
def main():

    ## initiate args parser to get path to db_config.ini
    parser = argparse.ArgumentParser(description="Run the database connector.")
    parser.add_argument(
        "--file-path",
        type=str,
        required=True,
        help="Path to the db_config.ini file"
    )
    args = parser.parse_args()
    ini_path = args.file_path

    ## Create temp directory instance
    temp_dir_obj = tempfile.TemporaryDirectory()
    temp_dir = Path(temp_dir_obj.name)
    download_path = temp_dir / "download"
    extract_path = temp_dir / "unzipped"
    download_path.mkdir(parents=True, exist_ok=True)
    extract_path.mkdir(parents=True, exist_ok=True)

    ## initiate CSS Downloader instance
    downloader = CSSDownloader(temp_dir=temp_dir, download_path=download_path, extract_path=extract_path)

    # Download data
    hate_path, vawa_path = downloader.download_and_convert()

    ## initiate DB Connector instance
    db = DatabaseConnector(config_path=ini_path)

    # Connect to Database
    conn, cursor = db.connect()

    ## initiate CSS Table Builder instance for Oncampushate202122.csv
    builder = CSSTableBuilder(
        csv_path= hate_path,
        table_name= "css_hate_python",
        database_name= "css",
        primary_key= "UNITID_P",
        str_cols= ["INSTNM", "BRANCH", "Address", "City", "State", "Sector_desc", "ZIP"]
    )

    # insert data into DB
    builder.insert_into_database(cursor)

    ## initiate CSS Table Builder instance or Oncampusvawa202122.csv
    builder = CSSTableBuilder(
        csv_path= vawa_path,
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

    ## Garbage collection for temp directory
    temp_dir_obj.cleanup()
    print("Garbage collected.")


## Run ##
if __name__ == "__main__":
    main()
