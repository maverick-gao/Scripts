# Author:   Maverick Gao
# Version:  V0.1 2023.02.17


#!/bin/bash

# Function to display current time and kernel information
function show_info {
    echo "System info:"
    echo "Current time: $(date)"
    echo "Kernel information: $(uname -ar)"
}

# Function to set up the system with user inputs
function setup_system {
    # Prompt for hostname
    read -p "Enter hostname: " hostname
    hostnamectl set-hostname $hostname
    
    # Prompt for user creation
    read -p "Enter username: " username
    read -p "Enter password: " password
    useradd -m -s /bin/bash $username
    echo $password | passwd --stdin $username
    
    # Backup and compress /etc directory
    backup_name="etc-$(date +%Y-%m-%d)"
    mkdir /root/$backup_name
    cp -r /etc/* /root/$backup_name/
    tar -zcvf /root/$backup_name.tar.gz /root/$backup_name/
    rm -rf /root/$backup_name
    echo "Backup of /etc directory completed and saved to /root/$backup_name.tar.gz"
}

# 配置阿里源
function configure_aliyun_source() {
  echo "Configuring Aliyun source..."
  # 备份原来的yum源配置文件
  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
  # 下载阿里云的CentOS-Base.repo文件
  curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
  # 更新yum缓存
  yum makecache fast
}

# 安装基础应用和时间同步工具并进行同步
function install_basic_apps_and_sync_time() {
  echo "Installing basic apps and synchronizing time..."
  # 安装常用的应用
  yum install -y vim wget net-tools nmap telnet
  # 安装ntpdate时间同步工具并使用aliyun时间服务器进行同步
  yum install -y ntpdate
  ntpdate ntp.aliyun.com
  # 将ntpdate命令加入计划任务，每天同步一次时间
  echo "0 0 * * * /usr/sbin/ntpdate ntp.aliyun.com" >> /etc/crontab
}

# Function to install Java and configure environment variables
 function install_java() {
  # Download Java archive
  cd /opt
  curl -LO https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-linux-x64.tar.gz -H 'Cookie: oraclelicense=accept-securebackup-cookie'

  # Extract Java archive
  tar -xzf jdk-8u202-linux-x64.tar.gz

  # Set environment variables for all users
  echo "export JAVA_HOME=/opt/jdk1.8.0_202" >> /etc/profile.d/java.sh
  echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile.d/java.sh
  source /etc/profile.d/java.sh

  # Set environment variables for the current user
  echo "export JAVA_HOME=/opt/jdk1.8.0_202" >> ~/.bashrc
  echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc
  source ~/.bashrc
}


# 调整内核参数，例如调整time_wait套接字最大数量等
function kernel_tuning {
  # 设置 time_wait 最大数量为 200000
  echo "net.ipv4.tcp_max_tw_buckets = 200000" >> /etc/sysctl.conf

  # 使设置生效
  sysctl -p
}

# 设置历史命令显示用户及ip地址
function history_settings {
  # 在 /etc/profile 中添加以下两行配置
  echo 'export HISTTIMEFORMAT="%F %T `whoami` `who -m | awk "{print \\$1}"` "' >> /etc/profile
  echo 'export PROMPT_COMMAND="history 1 | sed -e '\''s/^[[:space:]]*[0-9]*[[:space:]]*//'\'' -e '\''s/$/ `whoami` `who -m | awk "{print \\$1}"`"/' >> /etc/profile

  # 使设置生效
  source /etc/profile
}

#!/bin/bash

# 设置10分钟无操作断开终端
function ssh_timeout {
  # 在 /etc/ssh/sshd_config 中添加以下行
  echo "ClientAliveInterval 600" >> /etc/ssh/sshd_config
  echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config

  # 重启 ssh 服务
  systemctl restart sshd
}

# 关闭SELinux
function disable_selinux() {
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
    echo "SELinux has been disabled."
}

# 设置系统limit
function set_system_limit() {
    echo "* soft nofile 65535" >> /etc/security/limits.conf
    echo "* hard nofile 65535" >> /etc/security/limits.conf
    echo "* soft nproc 65535" >> /etc/security/limits.conf
    echo "* hard nproc 65535" >> /etc/security/limits.conf
    echo "System limit has been set."
}

# TCP/IP优化
function tcp_ip_optimization() {
    echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_recycle=1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout=30" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_time=1200" >> /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
    echo "TCP/IP has been optimized."
    sysctl -p
}

# Display menu options and execute selected function
function display_menu {
    echo "----------------------------------------"
    echo "         CentOS Initialization          "
    echo "----------------------------------------"
    show_info
    echo " "
    echo "Please select an option:"
    echo "1. Set up the system"
    echo "2. Configure aliyun source"
    echo "3. Install basic apps and sync time"
    echo "4. Install java"
    echo "5. Kernel tuning"
    echo "6. History setting"
    echo "7. SSH timesout"
    echo "8. Disable selinux"
    echo "9. Set system limit"
    echo "10. TCP/IP optimization"
    echo "11. Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1) setup_system
           ;;
        2) configure_aliyun_source
           ;;
        3) install_basic_apps_and_sync_time
           ;;
        4) install_java
           ;;
        5) kernel_tuning
           ;;
        6) history_settings
           ;;
        7) ssh_timeout
           ;;
        8) disable_selinux
           ;;
        9) set_system_limit
           ;;
        10) tcp_ip_optimization
           ;;
        11) exit 0
           ;;
        *) echo "Invalid choice. Please try again."
           ;;
    esac
    echo " "
    read -p "Press enter to return to main menu"
    display_menu
}

# Run the main menu
display_menu
