import pandas as pd

class CSSTableBuilder:
    ## Build a table in the database with PK and specified dtypes ##
    ## Params: csv_path: directory of the csv file
    ##         table_name: name of the table to create
    ##         database_name: name of the database to create table in
    ##         primary_key: columns that serve as PK
    ##         str_cols: columns that has a dtype of VARCHAR
    def __init__(self, csv_path, table_name, database_name, primary_key, str_cols):
        self.csv_path = csv_path
        self.table_name = table_name
        self.database_name = database_name
        self.primary_key = primary_key
        self.str_cols = str_cols
        self.df = pd.read_csv(csv_path)

    def generate_create_table_query(self):
        columns = []
        for col in self.df.columns:
            if col == self.primary_key:
                columns.append(f"`{col}` INT PRIMARY KEY")
            elif col in self.str_cols:
                columns.append(f"`{col}` VARCHAR(128)")
            else:
                columns.append(f"`{col}` INT")

        query = f"CREATE TABLE IF NOT EXISTS `{self.database_name}`.`{self.table_name}` (\n    "
        query += ",\n    ".join(columns) + "\n);"
        return query

    def insert_into_database(self, cursor):
        create_table_query = self.generate_create_table_query()

        # Drop table if exists
        cursor.execute(f"DROP TABLE IF EXISTS `{self.table_name}`")
        cursor.execute(create_table_query)

        # Insert data
        placeholders = ', '.join(['%s'] * len(self.df.columns))
        column_names = ', '.join(f"`{col}`" for col in self.df.columns)
        insert_query = f"INSERT INTO `{self.table_name}` ({column_names}) VALUES ({placeholders})"

        for row in self.df.itertuples(index=False):
            cursor.execute(insert_query, tuple(row))

        print(f"Table `{self.table_name}` created and data inserted successfully.")
