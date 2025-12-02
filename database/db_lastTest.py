from db_lastConn import *
import datetime

def titleOutput():
    
    title = ['번호','이름','국어','영어','수학','합계','평균','날짜','등수','등급']
    
    print("-"*85)
    print("{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}".format(*title))
    print("-"*85)


# 8. 성적등급 처리
def stuGrade():
    
    choice = input("성적 등급처리를 진행하시겠습니까?>>(1.예, 0.아니오)")
    if choice == "1":
        conn = getConnection()
        cursor = conn.cursor()
        
        # query = "update stuscore3 a set a.grade = (select b.grade from scoregrade b where a.avg between b.lowgrade and b.highgrade )"
        query = """update stuscore3 a set a.grade = 
        (
            select b.grade from scoregrade b where a.avg between b.lowgrade and b.highgrade 
        )
        """
        
        cursor.execute(query)
        conn.commit()
        
        cursor.close()
        conn.close()
        
        print("\n**등수처리가 완료되었습니다.")    


# 7. 성적등수 처리
def stuRank():
    
    choice = input("성적 등수처리를 진행하시겠습니까?>>(1.예, 0.아니오)")
    if choice == "1":
        conn = getConnection()
        cursor = conn.cursor()
        
        # query = "update stuscore3 a set a.rank = (select ranknum from (select rank() over(order by avg desc) ranknum,sno from stuscore3) b where a.sno = b.sno)"
        query = """update stuscore3 a set a.rank = 
            (select ranknum from (
                select rank() over(order by avg desc) ranknum,sno from stuscore3
            ) b where a.sno = b.sno)
        """
        
        cursor.execute(query)
        conn.commit()
        
        cursor.close()
        conn.close()
        
        print("\n**등수처리가 완료되었습니다.")
        
# 6. 학생검색
def stuSearch():
    
    name = input("검색할 학생이름을 입력하세요 >> ")
    query = f"select * from stuscore3 where name like '%{name}%'"
    rows = query_Select(query)
    print(query)
    
    titleOutput()
    if len(rows) > 0:
        for row in rows:
            print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
    else:
        print("\n**검색결과가 없습니다. 다시 검색바랍니다.")

# 5. 성적정렬
def stuOrder():

    print("1. 학생이름")
    print("2. 학생성적")
    
    choice = input("원하는 번호를 입력하세요>> ")
    if   choice == "1":
        query = f"select * from stuscore3 order by name"
        rows = query_Select(query)
    elif choice == "2":
        query = f"select * from stuscore3 order by total desc"
        rows = query_Select(query)
    else:
        print("\n**잘못된 번호를 선택하셨습니다.")
        return
    
    titleOutput()
    for row in rows:
        print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
        

# 4. 성적삭제
def stuDelete():
    
    # 1) 학생검색
    name = input("삭제하려는 학생이름을 입력하세요>> ")

    query = f"select * from stuscore3 where name = '{name}'"
    rows = query_Select(query)

    titleOutput()

    if len(rows) <= 0:
        print("\n**삭제하려는 학생이 없습니다.")
        return
    
    for row in rows:
        print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
    print()
    
    choice = input("정말 학생성적을 삭제하시겠습니까?(1.삭제, 0.취소)>> ")    
    
    if choice == "1":    
        
        conn = getConnection()    
        cursor = conn.cursor()        
        query = f"delete from stuscore3 where name = '{rows[0][1]}'"
        cursor.execute(query)

        conn.commit()

        cursor.close()
        conn.close()
        print(f"\n**{rows[0][1]}학생 성적을 삭제하였습니다.")
    else:
        print("\n**취소 되었습니다.")
        
        

# 3. 성적수정
def stuUpdate():
    
    # 1) 학생검색
    list = ['국어','영어','수학']
    
    name = input("수정하려는 학생이름을 입력하세요>> ")

    query = f"select * from stuscore3 where name like '%{name}%' order by sno asc"
    rows = query_Select(query)

    if len(rows) == 0:
        print("\n**수정하려는 학생이 없습니다.")
        return
    
    titleOutput()
    for row in rows:
        print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
    print()
    
    sno = input("수정하려는 학생번호를 입력하세요>> ")
    
    if sno == "":
        print("\n**잘못된 학생번호를 입력하셨습니다.")
        return
            
    query = f"select * from stuscore3 where sno = {sno}"
    rows = query_Select(query)
        
    if len(rows) == 0:
        print("\n**잘못된 학생번호를 입력하셨습니다.")
        return

    for i,v in enumerate(list):
        print(f"{i+1}.{v}")
    
    choice = int(input(f"[{rows[0][1]}] 학생의 수정하려는 과목을 선택하세요>> "))
    
    if choice in [1,2,3]:
    
        changeVal = input(f"{list[choice-1]}과목의 변경값을 입력하세요 >> ")
        
        conn = getConnection()
        cursor = conn.cursor()
        if   choice == 1:
            query = f"update stuscore3 set kor = {changeVal} where sno = {sno}"
        elif choice == 2:
            query = f"update stuscore3 set eng = {changeVal} where sno = {sno}"
        elif choice == 3:
            query = f"update stuscore3 set math = {changeVal} where sno = {sno}"
        cursor.execute(query)
        
        query = f"update stuscore3 set total=kor+eng+math,avg=(kor+eng+math)/3 where sno = {sno}"
        cursor.execute(query)
        conn.commit()
        
        query = "update stuscore3 a set a.rank = (select ranknum from (select rank() over(order by avg desc) ranknum,sno from stuscore3) b where a.sno = b.sno)"
        cursor.execute(query)
        conn.commit()                
        
        cursor.close()
        conn.close()
        
        print("\n**성적수정이 완료되었습니다.")
    else:
        print("\n**과목선택을 잘못하셨습니다. 다시 입력하세요.")
        

# 2. 성적출력
# def stuOutput():
#     print("{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}".format(*title))
#     print("-"*80)
#     cursor = conn.cursor()
#     query = "select * from stuscore3 order by sno"
#     cursor.execute(query)
#     rows = cursor.fetchall()
#     # print(rows)
#     for row in rows:
#         # print(row[7].strftime("%Y-%m-%d"))
#         # print("{}\t{}\t{}\t{}\t{}\t{}\t{:.2f}\t{}\t{}\t{}".format(*row))
#         print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
#     cursor.close()
#     conn.close()        
#     print()

def stuOutput():

    titleOutput()
    query = "select * from stuscore3 order by sno"
    rows = query_Select(query)

    for row in rows:
        # print("{}\t{}\t{}\t{}\t{}\t{}\t{:.2f}\t{}\t{}\t{}".format(*row))
        print(f"{row[0]}\t{row[1]}\t{row[2]}\t{row[3]}\t{row[4]}\t{row[5]}\t{row[6]:.2f}\t{row[7].strftime("%y-%m-%d")}\t{row[8]}\t{row[9]}")
        


# 1. 성적입력
def stuInput():

    name = input("이름을 입력 >> ")
    kor = int(input("국어점수를 입력 >> "))
    eng = int(input("영어점수를 입력 >> "))
    math = int(input("수학점수를 입력 >> "))
    
    if name == "":
        print("\n**이름이 누락되었습니다.")
        return

    total= kor+eng+math
    avg = total/3

    conn = getConnection()    
    cursor = conn.cursor()

    query = f"insert into stuscore3 values (stuscore3_seq.nextval,'{name}',{kor},{eng},{math},{total},{avg},sysdate,0,'')"
    cursor.execute(query)

    conn.commit()

    cursor.close()
    conn.close()

    print("\n**",name,"학생성적이 입력되었습니다.")
