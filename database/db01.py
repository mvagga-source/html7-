
import oracledb

# db연결함수
def getConnection():
    return oracledb.connect\
        (user="ora_user",password="1111",dsn="localhost:1521/xe")
        
# db연결
conn = getConnection() ## sql 실행
cursor = conn.cursor() ## 창


# query구문
query = "select * from board"
cursor.execute(query)

# 데이터를 가져옴
rows = cursor.fetchall() # 튜플형식으로 넘어온다

# 데이터 출력
print(f"아이디\t비밀번호\t이름\t전화번호\t이메일\t성별\t취미")
print("-"*65)
for row in rows:
    # print(row[0],row[1],row[2],row[3],row[4],row[5],row[6])
    print("{}\t{}\t{}\t{}\t{}\t{}\t{}".format(row[0],row[1],row[2],row[3],row[4],row[5],row[6]))
    
print("-------------------")



# print("연결 : ", conn)
