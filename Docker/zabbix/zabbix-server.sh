#!/bin/bash

# Author:   Maverick Gao
# Version:  V0.1 2023.02.23

# 用于启动zabbix server集群
# 包括如下版本：
# zabbix-server-mysql:centos4.4.4
# zabbix-web-nginx-mysql:centos:4.4.4
# mysql:5.7
# 需要配置好防火墙的地址

docker run --name mysql-server -t \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="zabbix" \
-p 13306:3306 \
-d mysql:5.7 \
--character-set-server=utf8 --collation-server=utf8_bin

docker run --name zabbix-server-mysql -t \
--link mysql-server:mysql \
-e DB_SERVER_HOST="mysql-server" \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="zabbix" \
-p 10051:10051 \
-d \
zabbix/zabbix-server-mysql:centos-4.4.4

docker run --privileged --name zabbix-web-nginx-mysql -t \
--link mysql-server:mysql \
--link zabbix-server-mysql:zabbix-server \
-e DB_SERVER_HOST="mysql-server" \
-e MYSQL_DATABASE="zabbix" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="zabbix" \
-e PHP_TZ="Asia/Singapore" \
-p 18080:80 \
-d \
zabbix/zabbix-web-nginx-mysql:centos-4.4.4
