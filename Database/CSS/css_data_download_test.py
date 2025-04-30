import zipfile
import pandas as pd
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# Wait for download to complete given a download path #
# Param: download path (css website)
# Return: zipfile path on local
def wait_for_download(path, timeout=100):
    seconds = 0
    while seconds < timeout:
        files = list(path.glob("*.zip"))
        if files and not any(f.name.endswith(".crdownload") for f in path.iterdir()):
            return files[0]
        time.sleep(1)
        seconds += 1
    raise TimeoutError("Download did not complete in time.")

# Convert .xls and .xlsx files to .csv files #
def convert_excel(extract_path, excel_filename_in_zip, output_csv_path):

        # Step 1: Locate and verify the Excel file
        excel_path = extract_path / excel_filename_in_zip
        if not excel_path.exists():
            raise FileNotFoundError(f"Excel file '{excel_filename_in_zip}' not found in ZIP archive.")
        print("Located file ", excel_filename_in_zip)
        
        # Step 2: Convert Excel to CSV
        try:
            # df = pd.read_excel(excel_path)
            if excel_path.suffix == '.xls':
                df = pd.read_excel(excel_path, engine='xlrd')
            elif excel_path.suffix == '.xlsx':
                df = pd.read_excel(excel_path, engine='openpyxl')
            else:
                raise ValueError(f"Unsupported Excel format: {excel_path.suffix}")
            df.to_csv(output_csv_path, index=False)
            print(f"Converted '{excel_filename_in_zip}' to CSV at: {output_csv_path}")
        except Exception as e:
            raise Exception(f"Failed to read/convert Excel file: {e}")

## Download zip automatically from CSS website and convert to .csv##

# Setup a cross-platform download path
download_path = Path.home() / "Downloads" / "CSS_autodownload"
download_path.mkdir(parents=True, exist_ok=True)

# Configure Chrome options
chrome_options = Options()
chrome_options.add_experimental_option("prefs", {
    "download.default_directory": str(download_path),
    "download.prompt_for_download": False,
    "download.directory_upgrade": True,
    "safebrowsing.enabled": True
})
chrome_options.add_argument("--headless=new")  # Optional: run in background

# Start WebDriver
driver = webdriver.Chrome(service=Service(), options=chrome_options)
driver.get("https://ope.ed.gov/campussafety/#/datafile/list") 

# Trigger the download
link_element = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.LINK_TEXT, "Data for calendar years 2020-22"))
)
link_element.click()
print("Downloading CSS...")
zip_file_path = wait_for_download(download_path)
print(f"Downloaded file located at: {zip_file_path}")

# Extract ZIP contents
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    extract_path = download_path / "unzipped"
    zip_ref.extractall(extract_path)
print(f"Extracted to: {extract_path}")

# Set csv path
csv_path_hate = Path(__file__).parent / "Oncampushate202122.csv"
csv_path_vawa = Path(__file__).parent / "Oncampusvawa202122.csv"

# Convert to csv
convert_excel(
    extract_path=extract_path,
    excel_filename_in_zip="Oncampushate202122.xlsx",
    output_csv_path=csv_path_hate
)
convert_excel(
    extract_path=extract_path,
    excel_filename_in_zip="Oncampusvawa202122.xls",
    output_csv_path=csv_path_vawa
)
