#!/bin/bash

# Author:   Maverick Gao
# Version:  V1.0 2023.02.25

# 此脚本配合docker-compose-encrypt.yml来使用
# 执行完毕即可删除

# 使用docker secret命令需要将此节点加入docker swarm网络:
docker swarm init

echo -n 'zabbix' | docker secret create mysql_database -
echo -n 'zabbix' | docker secret create mysql_user -
echo -n 'zabbix' | docker secret create mysql_password -
echo -n 'zabbix' | docker secret create mysql_root_password -

