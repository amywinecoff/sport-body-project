import sqlite3
import pandas as pd

class ExtractData(object):
    
    
    def __init__(self, db_file):
        
        self.conn = None
        try:
            self.conn = sqlite3.connect(db_file)
        except Error as e:
            print(e)
 
        #return conn


    def select_from_table(self, table_name):
        """
        Query all rows in the tasks table
        :param conn: the Connection object
        :return:
        """
        sql_str = "SELECT * FROM {tb}".format(tb=table_name)
        cur = self.conn.cursor()
        cur.execute(sql_str)
        names = [description[0] for description in cur.description]

        rows = cur.fetchall()

        df = pd.DataFrame(rows, columns =names) 

        return df
   
    def close_connection(self):
        self.conn.close()