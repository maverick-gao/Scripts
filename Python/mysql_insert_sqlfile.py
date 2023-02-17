# Author:   Maverick Gao
# Version:  V1.0 2023.02.17

import pymysql

# 连接数据库
conn = pymysql.connect(host='your_host', port=your_port, user='your_user', password='your_password', database='your_database')
cursor = conn.cursor()

# 打开sql文件
with open('your_sql_file.sql', 'r') as f:
    sql = f.read()

# 分割sql语句
sql_commands = sql.split(';')

# 执行sql语句
for command in sql_commands:
    try:
        if command.strip() != '':
            cursor.execute(command)
            conn.commit()
    except Exception as e:
        # 输出无法插入的数据及错误信息到文件中
        with open('error_log.txt', 'a') as log_file:
            log_file.write(f'Error: {str(e)}\nSQL command: {command}\n\n')
        conn.rollback()

# 关闭数据库连接
conn.close()
