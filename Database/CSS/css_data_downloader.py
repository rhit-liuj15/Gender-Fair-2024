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

class CSSDownloader:
    ## Download CSS database automatically online and extract needed files ##
    def __init__(self):
        self.download_path = Path.home() / "Downloads" / "CSS_autodownload"
        self.download_path.mkdir(parents=True, exist_ok=True)
        self.extract_path = self.download_path / "unzipped"

    ## Wait for the zip file to be downloaded within 100 seconds ##
    def wait_for_download(self, timeout=300):  # adjust accordingly if needed
        seconds = 0
        while seconds < timeout:
            files = list(self.download_path.glob("*.zip"))
            if files and not any(f.name.endswith(".crdownload") for f in self.download_path.iterdir()):
                return files[0]
            time.sleep(1)
            seconds += 1
        raise TimeoutError("Download did not complete in time.")

    ## Convert target files to .csv format ##
    ## Params: execel_filename_in_zip: name of the target file to convert
    ##         output_csv_path: directory of the output .csv file
    def convert_excel(self, excel_filename_in_zip, output_csv_path):
        excel_path = self.extract_path / excel_filename_in_zip
        if not excel_path.exists():
            raise FileNotFoundError(f"Excel file '{excel_filename_in_zip}' not found in ZIP archive.")
        print("Located file ", excel_filename_in_zip)

        try:
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

    ## Perform the auto-download and convert ##
    def download_and_convert(self):
        chrome_options = Options()
        chrome_options.add_experimental_option("prefs", {
            "download.default_directory": str(self.download_path),
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True
        })
        chrome_options.add_argument("--headless=new")

        driver = webdriver.Chrome(service=Service(), options=chrome_options)
        driver.get("https://ope.ed.gov/campussafety/#/datafile/list")

        try:
            link_element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.LINK_TEXT, "Data for calendar years 2020-22"))
            )
            link_element.click()
            print("Downloading CSS...")
            zip_file_path = self.wait_for_download()
            print(f"Downloaded file located at: {zip_file_path}")
        finally:
            driver.quit()

        with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
            zip_ref.extractall(self.extract_path)
        print(f"Extracted to: {self.extract_path}")

        base_dir = Path(__file__).parent
        self.convert_excel("Oncampushate202122.xlsx", base_dir / "Oncampushate202122.csv")
        self.convert_excel("Oncampusvawa202122.xls", base_dir / "Oncampusvawa202122.csv")
