CSS import script README

In the CSS folder you will find the following files:
- css_data_downloader.py
- css_db_connector.py
- css_table_builder.py
- main.py
- requirement.txt
- readme.txt

*The python version used during development is 3.10.11

**The requirement.txt include all libraries and their current version installed for the scripts.
**To install all dependencies, use <pip install -r requirement.txt>
**Ideally, install pip packages in a virtual environment and not on one's root Python installation to avoid version conflicts

***The main.py requires a path to the config.ini file, which is used for database credential storage.
***Fields required in such db_config.ini:
	host: hostname of the mysql database
	port: port
	user: username of a user of the database
	password: password of the database
	database: name of the database schemas
***For custom db_config.ini, change all mock information to actual credentials

***IMPORTANT: DO NO PUSH ANY ACTUAL CREDENTIALS TO GITHUB***

To run the script, run 
	python main.py --file-path <actual/path/to/config.ini>
in the git-terminal to automatically download CSS database online and import to a Database.

The script will automatically generate a temporary directory and store all downloaded files there until the end of the script, where they are cleaned up and removed.