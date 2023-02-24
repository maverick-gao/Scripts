# Author:   Maverick Gao
# Version:  V0.1 2023.02.24

#!/bin/bash

# 需要提前修改下面两个变量并将zabbix-agent的tar包放到此目录下
server_ip="What_your_Zabbix_Server_IP"
active_addr="What_is_your_zabbix_server_IP"

# 创建/opt/zabbix目录
if [ ! -d "/opt/zabbix" ]; then
    mkdir /opt/zabbix
fi

# 解压软件包到/opt/zabbix目录下
tar -zxvf zabbix-agent-*.tar.gz -C /opt/zabbix

# 修改zabbix_agentd.conf文件
sed -i "s/Server=127.0.0.1/Server=${server_ip}/g" /opt/zabbix/conf/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=${active_addr}/g" /opt/zabbix/conf/zabbix_agentd.conf
sed -i "s/#\s*LogFile=\s*/LogFile=\/opt\/zabbix\/zabbix_agent.log/g" /opt/zabbix/conf/zabbix_agentd.conf

# 配置LogFile的大小为10M
sed -i "s/#\s*LogFileSize=1/LogFileSize=10/g" /opt/zabbix/conf/zabbix_agentd.conf

# 启动zabbix_agentd服务
/opt/zabbix/sbin/zabbix_agentd -c /opt/zabbix/conf/zabbix_agentd.conf

# 检查zabbix_agentd服务是否启动成功
if [ $? -eq 0 ]; then
    echo "zabbix_agentd服务已成功启动。"
else
    echo "启动zabbix_agentd服务失败，请检查。"
fi
