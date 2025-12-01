
# from db_lastConn import *
import db_lastTest

while True:
    print("[ 학생성적처리프로그램 ]")
    # print("1. 성적입력")
    # print("2. 성적출력")
    # print("3. 성적수정")
    # print("4. 성적삭제")
    # print("5. 학생검색")
    # print("6. 학생정렬")
    # print("7. 등수처리")
    # print("0. 프로그램 종료")
    print("1.성적입력, 2.출력, 3.수정, 4.삭제, 5.검색, 6.정렬, 7.등수처리, 8.등급처리, 0.종료")
    print("-"*85)
    choice = input("원하는 번호를 입력하세요.>> ")
    
    if   choice == "1": # 성적입력
        db_lastTest.stuInput()
    elif choice == "2": # 성적출력
        db_lastTest.stuOutput()
    elif choice == "3": # 성적수정
        db_lastTest.stuUpdate()
    elif choice == "4": # 성적삭제
        db_lastTest.stuDelete()
    elif choice == "5": # 학생검색
        db_lastTest.stuSearch()
    elif choice == "6": # 학생정렬
        db_lastTest.stuOrder()
    elif choice == "7": # 등수처리
        db_lastTest.stuRank()
    elif choice == "8": # 등급처리
        db_lastTest.stuGrade()
    else:
        print("[ 프로그램 종료 ]")
        break
    
    print()
