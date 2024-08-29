#!/bin/sh

# 심볼릭 링크 생성
ln -sf /usr/share/zoneinfo/Japan /etc/localtime
echo "Etc/UTC" > /etc/timezone

# MySQL 서버 실행
#exec mysqld "$@"