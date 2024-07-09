import mysql.connector
import random
import string

# MySQL 연결 설정
config = {
  'user': 'root',
  'password': 'admin',
  'host': '127.0.0.1',
  'database': 'junitest',
  'port': 3301,
  'raise_on_warnings': True
}

# MySQL 연결
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()

# 100개의 행을 삽입하는 SQL 쿼리
insert_query = "INSERT INTO drop_table_test (name, age, email) VALUES (%s, %s, %s)"

# 100개의 행을 생성하는 데이터
data = []
for _ in range(1000):
    name = ''.join(random.choices(string.ascii_letters, k=random.randint(20, 20)))
    age = random.randint(20, 60)
    email = ''.join(random.choices(string.ascii_lowercase, k=random.randint(50, 50))) + '@example.com'
    data.append((name, age, email))

print(data)
# 테이블 크기가 1GB가 될 때까지 데이터를 반복해서 삽입
total_rows = 0
while total_rows < 2000000:  # 1GB = 1,000,000 rows * 약 1KB (예상)
    cursor.executemany(insert_query, data)
    cnx.commit()
    total_rows += 100  # 100개의 행을 삽입했으므로 누적된 행 수를 업데이트

# 연결 종료
cursor.close()
cnx.close()
