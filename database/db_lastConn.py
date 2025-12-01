import oracledb

def getConnection():
    return oracledb.connect(user="ora_user",password="1111",dsn="localhost:1521/xe")

def query_Select(query):
    
    if query == "":
        print("요청 쿼리가 없습니다.")
        return 0
    
    conn = getConnection()
    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return rows    