# Author:   Maverick Gao
# Version:  V0.1 2023.02.20

#!/bin/bash

# 设置变量
backup_dir="/tmp/ssh-backup-$(date +%Y%m%d%H%M%S)"
ssh_config_file="/etc/ssh/sshd_config"
telnet_config_file="/etc/xinetd.d/telnet"

# 创建备份目录
mkdir -p $backup_dir

# 备份ssh配置文件和telnet配置文件
cp $ssh_config_file $backup_dir/
cp $telnet_config_file $backup_dir/

# 显示菜单
echo "==========================================="
echo "  SSH升级脚本"
echo "==========================================="
echo "  1) 下载openssh升级包"
echo "  2) 在线升级openssh"
echo "  3) 离线升级openssh"
echo "  q) 退出"
echo "==========================================="
read -p "请选择操作 [1-3, q]: " choice

case $choice in
  1)
    # 下载openssh升级包
    echo "正在下载openssh升级包..."
    yum install -y --downloadonly --downloaddir=. openssh-server openssh-clients
    echo "openssh升级包下载完成"
    ;;
  2)
    # 在线升级openssh
    echo "正在在线升级openssh..."
    yum update -y openssh-server openssh-clients
    echo "openssh升级完成"
    ;;
  3)
    # 离线升级openssh
    echo "请将openssh升级包放到当前目录，并输入升级包文件名（例如：openssh-server-7.4p1-21.el7.x86_64.rpm）"
    read -p "请输入升级包文件名: " package_name
    echo "正在离线升级openssh..."
    yum install -y ./$package_name
    echo "openssh升级完成"
    ;;
  q)
    echo "退出"
    exit 0
    ;;
  *)
    echo "无效的选项"
    exit 1
    ;;
esac

# 恢复ssh配置文件和telnet配置文件
echo "正在恢复ssh配置文件和telnet配置文件..."
cp $backup_dir/sshd_config $ssh_config_file
cp $backup_dir/telnet $telnet_config_file

# 如果telnet已开启，则重启服务并关闭telnet登录
if grep -q "disable.*=.*no" $telnet_config_file; then
  echo "正在关闭telnet登录..."
  sed -i 's/disable.*=.*no/disable = yes/' $telnet_config_file
  systemctl restart xinetd
fi

# 清理备份文件
echo "正在清理备份文件..."
rm -rf $backup_dir

echo "操作完成"
