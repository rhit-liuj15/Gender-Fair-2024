from pathlib import Path
from css_downloader import CSSDownloader
from css_db_connector import DatabaseConnector
from css_table_builder import CSSTableBuilder
import argparse

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
    download_dir = "download/"
    download_path = Path(download_dir + "raw")
    extract_path = Path(download_dir + "unzipped")
    download_path.mkdir(parents=True, exist_ok=True)
    extract_path.mkdir(parents=True, exist_ok=True)

    ## initiate CSS Downloader instance
    downloader = CSSDownloader(temp_dir=download_dir, download_path=download_path, extract_path=extract_path)

    # Download data
    download_url = "https://ope.ed.gov/campussafety/api/dataFiles/file?fileName=Crime2023EXCEL.zip"
    hate_path, vawa_path = downloader.download_and_convert(download_url=download_url)

    ## initiate DB Connector instance
    db = DatabaseConnector(config_path=ini_path)

    # Connect to Database
    conn, cursor = db.connect()

    ## Create dtype dict obj for Oncampushate202122
    dtypes_hate = {
        "INSTNM": "VARCHAR(95)",
        "OPEID": "VARCHAR(10)",
        "BRANCH": "VARCHAR(124)",
        "Address": "VARCHAR(103)",
        "City": "VARCHAR(32)",
        "State": "VARCHAR(2)",
        "ZIP": "VARCHAR(13)",
        "Sector_desc": "VARCHAR(36)"
    }

    ## initiate CSS Table Builder instance for Oncampushate202122.csv
    builder = CSSTableBuilder(
        csv_path= hate_path,
        table_name= "css_hate_python",
        database_name= "css",
        primary_key= "UNITID_P",
        column_dtype=dtypes_hate
    )

    # insert data into DB
    builder.insert_into_database(cursor)

    # Create dtype dict obj for Oncampusvawa202122
    dtypes_vawa = {
        "INSTNM": "VARCHAR(91)",
        "OPEID": "VARCHAR(8)",
        "BRANCH": "VARCHAR(124)",
        "Address": "VARCHAR(103)",
        "City": "VARCHAR(32)",
        "State": "VARCHAR(2)",
        "ZIP": "VARCHAR(13)",
        "Sector_desc": "VARCHAR(36)"
    }

    ## initiate CSS Table Builder instance or Oncampusvawa202122.csv
    builder = CSSTableBuilder(
        csv_path= vawa_path,
        table_name= "css_vawa_python",
        database_name= "css",
        primary_key= "UNITID_P",
        column_dtype=dtypes_vawa
    )

    # insert data into DB
    builder.insert_into_database(cursor)

    ## Commmit and Close DB connection
    conn.commit()
    db.close()

## Run ##
if __name__ == "__main__":
    main()
