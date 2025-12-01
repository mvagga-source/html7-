
import oracledb

def get_connection():
    return oracledb.connect(user="ora_user",password="1111",dsn="localhost:1521/xe")