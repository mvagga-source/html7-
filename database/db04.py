import oracledb

def get_connection():
    return oracledb.connect(user="ora_user",password="1111",dsn="localhost:1521/xe")

def stu_input():
    name = input("학생이름을 입력>> ")
    kor = int(input("국어점수를 입력>> "))
    eng = int(input("영어점수를 입력>> "))
    math = int(input("수학점수를 입력>> "))
    
    total = kor+eng+math
    avg = total/3
    
    # DB연결
    conn = get_connection()
    cursor = conn.cursor()
    
    query = f"insert into stuscore values(stuscore_seq.nextval,'{name}',{kor},{eng},{math},{total},{avg},sysdate)"
    print(query)
    cursor.execute(query)        
    conn.commit()
    
    cursor.close()
    conn.close()
    

def stu_print(title):
    
    # DB연결
    conn = get_connection()
    cursor = conn.cursor() # 
    
    query = "select * from stuscore"
    cursor.execute(query)
    rows = cursor.fetchall()
    
    print("-"*70)
    print("{}\t{:10s}\t{}\t{}\t{}\t{}\t{}\t{}".format(*title))
    print("-"*70)
    for row in rows:
        print("{}\t{:15s}\t{}\t{}\t{}\t{}\t{:.2f}\t{}".format(*row))
    print("-"*70)
    
    cursor.close()
    conn.close()



while True:
    
    title = ['번호','이름','국어','영어','수학','합계','평균','등록일']
    
    print("[학생성적 프로그램]")
    print("1.학생성적 입력")
    print("2.학생성적 출력")
    print("3.학생성적 수정")
    print("4.학생성적 삭제")
    print("5.학생성적 종료")
    choice = input("원하는 번호를 입력하세요 >>")
    if choice == "1":
        print("학생성적 입력")
        
        stu_input()
        
    elif choice == "2":
        print("[학생성적 출력]")
        
        stu_print(title)
        
    elif choice == "3":
        print("[학생성적 수정]")
        
        stu_print(title)
        
        # DB연결
        conn = get_connection()
        cursor = conn.cursor() #         
        
        sno = int(input("학생 번호를 선택하세요 >>"))
        
        query = f"select name from stuscore where sno = {sno}"
        # print(query)
        cursor.execute(query)
        name = cursor.fetchall() # fetchall() - list타입 여러명, fetchone() - 튜플타입 1명
        
        if len(name) == 0:
            print("잘못된 학생 번호를 선택 하셨습니다.")
            cursor.close()
            conn.close()            
            break
        
        print("-"*30)
        num = int(input("{name}학생의 수정 과목을 선택(1.국어, 2.영어, 3.수학) >> "))
        
        num_name = ""
        if num == 1:
            query = f"select kor from stuscore where sno = {sno}"
            num_name = "국어"
        elif num == 2:
            query = f"select eng from stuscore where sno = {sno}"
            num_name = "영어"
        elif num == 3:
            query = f"select math from stuscore where sno = {sno}"
            num_name = "수학"
        else:
            print("잘못된 과목을 선택 하셨습니다.")
            cursor.close()
            conn.close()            
            break
        
        cursor.execute(query)
        result = cursor.fetchone()
        
        result_m = int(input("현재점수 : {result}, 변경할 {num_name} 점수를 입력하세요 >> "))
        
        
        
        
        
        
        cursor.close()
        conn.close()

        
        
        
        
        
        

        
        

        

        
        
        
    elif choice == "4":
        print("학생성적 삭제")
    else:
        print("프로그램 종료")
        break
