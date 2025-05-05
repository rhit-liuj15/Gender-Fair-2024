import requests
import zipfile
import io
import pandas as pd

class CSSDownloader:
    ## Download CSS database automatically online and extract needed files ##
    def __init__(self, temp_dir, download_path, extract_path):
        self.temp_dir = temp_dir
        self.download_path = download_path
        self.extract_path = extract_path

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
    
    ## Download CSS data files and convert table to .csv format ##
    ## Params: download_url: download link for CSS zip file
    ## Return: path to output .csv file
    def download_and_convert(self, download_url):
        print(f"Downloading CSS data from {download_url} ...")
        # Download the zip file using download_url
        res = requests.get(download_url, timeout=10)
        print(f"Downloaded ZIP file to {self.download_path}")

        with zipfile.ZipFile(io.BytesIO(res.content)) as zip_ref:
            zip_ref.extractall(self.extract_path)
        print(f"Extracted to: {self.extract_path}")

        hate_path = self.extract_path / "Oncampushate202122.csv"
        vawa_path = self.extract_path / "Oncampusvawa202122.csv"

        self.convert_excel("Oncampushate202122.xlsx", hate_path)
        self.convert_excel("Oncampusvawa202122.xls", vawa_path)

        return hate_path, vawa_path

