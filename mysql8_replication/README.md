### image build
```
docker build -t mysql8_replication-rails_app .
```

### docker-compose commands
```
docker-compose up -d 
docker-compose down

docker-compose down --volumes 
  # 볼륨까지 삭제한다.
docker-compose down --rmi all
  # 이미지도 삭제한다.

docker-compose exec mysql8_1 bash -c 'mysql -uroot -padmin -P3301'
docker-compose exec mysql8_2 bash -c 'mysql -uroot -padmin -P3302'

https://zenn.dev/ryo7/articles/create-mysql-on-docker

docker-compose exec mysql8_2
docker-compse restart mysql8_2
docker-compose logs mysql8_1
docker-compose logs mysql8_2
```

### rails 컨테이너에 들어감
```
docker-compose exec rails_app bash 
```

### replication 
##### master
```
CREATE USER 'repl'@'192.168.%.%' IDENTIFIED WITH mysql_native_password BY 'repl';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.%.%';
 
CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'repl';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
 
show grants for 'repl'@'192.168.%.%' ;
 
show master status;
```

##### replica
```
CHANGE MASTER TO MASTER_HOST = 'juni_mysql8.0.28_1', MASTER_PORT = 3301, MASTER_USER = 'repl', MASTER_PASSWORD = 'repl', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=157;
START SLAVE USER = 'repl' PASSWORD = 'repl';
show replica status\G
```

### mysqlslap
```
docker compose run slap `
mysqlslap  --no-defaults --auto-generate-sql `
--engine=innodb --auto-generate-sql-add-autoincrement  `
--host=192.168.16.1 --port=3306 -u root -proot `
--number-int-cols=10  --number-char-cols=10  --iterations=10  --concurrency=50  `
--auto-generate-sql-write-number=10  --number-of-queries=10  --auto-generate-sql-load-type=read
```