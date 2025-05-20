import pandas as pd
import numpy as np

class CSSTableBuilder:
    ## Build a table in the database with PK and specified dtypes ##
    ## Params: csv_path: directory of the csv file
    ##         table_name: name of the table to create
    ##         database_name: name of the database to create table in
    ##         primary_key: columns that serve as PK
    ##         colum_dtype: dict mapping column names to SQL data types
    def __init__(self, csv_path, table_name, database_name, primary_key, column_dtype):
        self.csv_path = csv_path
        self.table_name = table_name
        self.database_name = database_name
        self.primary_key = primary_key
        self.column_dtype = column_dtype
        self.df = pd.read_csv(csv_path)

    ## Create table query
    def generate_create_table_query(self):
        columns = []
        for col in self.df.columns:
            dtype = self.column_dtype.get(col, 'INT') 
            pk = ' PRIMARY KEY' if col == self.primary_key else ''
            columns.append(f"`{col}` {dtype}{pk}")

        query = f"CREATE TABLE IF NOT EXISTS `{self.database_name}`.`{self.table_name}` (\n    "
        query += ",\n    ".join(columns) + "\n);"
        return query

    ## Insert data into table created
    def insert_into_database(self, cursor):
        print("Creating table...")
        create_table_query = self.generate_create_table_query()

        # Drop table if exists
        cursor.execute(f"DROP TABLE IF EXISTS `{self.table_name}`")
        cursor.execute(create_table_query)

        self.df = self.df.replace({np.nan: None, 'nan': None})

        # Insert data
        placeholders = ', '.join(['%s'] * len(self.df.columns))
        column_names = ', '.join(f"`{col}`" for col in self.df.columns)
        insert_query = f"INSERT INTO `{self.table_name}` ({column_names}) VALUES ({placeholders})"

        for row in self.df.itertuples(index=False):
            cursor.execute(insert_query, tuple(row))

        print(f"Table `{self.table_name}` created and data inserted successfully.")
