CSS import script README

In the github repo you will find the following files:
- css_data_downloader.py
- css_db_connector.py
- css_table_builder.py
- example_config.ini
- main.py
- requirement.txt
- readme.txt
- css_data_download_test.py
- css_db_connection_test.py

*The two test files can be omitted as they are for development testing.

**The requirement.txt include all libraries and their current version installed for the scripts.

***The example_config.ini contains a example format of a .ini file for database credential storage. Note that all information in example_config.ini is for mock only.
***Fields in example_config.ini:
	host: hostname of the mysql database
	port: port
	user: username of a user of the database
	password: password of the database
	database: name of the database schemas
***For custom db_config.ini, change all mock information to actual credentials

***IMPORTANT: DO NO PUSH ANY ACTUAL CREDENTIALS TO GITHUB***

To run the script, run <python main.py> in the git-terminal to automatically download CSS database online and import to a Database.