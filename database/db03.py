
import oracledb

def get_connection():
    return oracledb.connect(user="ora_user",password="1111",dsn="localhost:1521/xe")

conn = get_connection()
# print("연결 : ",conn)

cursor = conn.cursor()

# query = ""
cursor.execute("select *  from stuscore order by kor desc, eng")
rows = cursor.fetchall()

for row in rows:
    # print(row)
    print("{}\t{:15s}\t{}\t{}\t{}\t{}\t{:.2f}".format(*row))





