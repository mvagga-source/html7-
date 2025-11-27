import oracledb

def get_connection():
    return oracledb.connect\
        (user="ora_user",password="1111",dsn="localhost:1521/xe")
        
while (True):
    
    score = int(input("점수를 입력하세요 >> "));
    # print("입력 : ",score)
    
    conn = get_connection()
    cursor = conn.cursor()    
    
    query= f"select count(total) from stuscore where total >= {score}"
    cursor.execute(query)
    # rows = cursor.fetchall() # 리스트
    rows = cursor.fetchone() # 튜플
    # print(rows[0])
    print("입력한 점수보다 높은 학생수 : ", rows[0])

    cursor.close()
    conn.close()

