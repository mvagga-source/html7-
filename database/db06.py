import oracledb

def get_connection():
    return oracledb.connect\
        (user="ora_user",password="1111",dsn="localhost:1521/xe")
        
conn = get_connection()
cursor = conn.cursor()

# query="select substr(phone,1,instr(phone,'-')-1),substr(phone,instr(phone,'-')+1,3),substr(phone,instr(phone,'-',-1)+1,4) from member"

# cursor.execute(query)
# rows = cursor.fetchall()

# print(f"국번\t전화번호1\t전화번호2")
# for row in rows:
#     print("{}\t{}\t{}".format(*row));
    

query="select phone from member"
cursor.execute(query)
rows = cursor.fetchall()

for row in rows:
    print(row)
    phone = row[0].split('-')
    print("{}\t{}\t{}".format(*phone));

cursor.close()
conn.close()