# 说明文档
Cent OS初始化脚本

## 使用方法
直接执行sh init_centos.sh或加上执行权限

## 功能说明
show_info：Function to display current time and kernel information

setup_system：Function to set up the system with user inputs

configure_aliyun_source：配置阿里源

install_basic_apps_and_sync_time：安装基础应用和时间同步工具并进行同步

install_java：#Function to install Java and configure environment variables

kernel_tuning：调整内核参数，例如调整time_wait套接字最大数量等

history_settings：设置历史命令显示用户及ip地址

ssh_timeout：设置10分钟无操作断开终端

disable_selinux：关闭SELinux

set_system_limit：设置系统limit

tcp_ip_optimization：TCP/IP优化

