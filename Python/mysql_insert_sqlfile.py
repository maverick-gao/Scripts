# Author:   Maverick Gao
# Version:  V1.0 2023.02.17
#           V1.1 2023.02.17
#           V1.3 2023.02.18
#           V1.4 2023.02.21 Add conn.commit() function

import pymysql
import sys

# 定义连接信息
host = 'localhost'
user = 'root'
password = 'password'
db = 'test'
port = 3306

# 定义文件路径
filename = 'sql_file.sql'
success_file = 'success.txt'
failure_file = 'failure.txt'

# 获取 sql 文件的总行数
with open(filename, 'r', encoding='utf-8') as f:
    total_lines = sum(1 for _ in f)

# 打开 sql 文件
with open(filename, 'r', encoding='utf-8') as f:
    # 初始化进度条和成功/失败的计数器
    progress_count = 0
    success_count = 0
    failure_count = 0
    
    # 连接数据库
    conn = pymysql.connect(host=host, user=user, password=password, db=db, port=port, charset='utf8mb4')
    cursor = conn.cursor()

    # 逐行读取 sql 文件
    for line in f:
        try:
            # 执行 sql 语句
            cursor.execute(line)

            # 记录插入成功的语句到文件
            with open(success_file, 'a', encoding='utf-8') as sf:
                sf.write(line)

            # 计数器加 1
            success_count += 1

        except Exception as e:
            # 记录插入失败的语句和错误信息到文件
            with open(failure_file, 'a', encoding='utf-8') as ff:
                ff.write(line)
                ff.write(str(e) + '\n')

            # 计数器加 1
            failure_count += 1

        # 更新进度条
        progress_count += 1
        progress = int(progress_count / total_lines * 100)
        sys.stdout.write(f"\rProgress: [{progress * '#'}{(100 - progress) * ' '}] {progress}%")
        sys.stdout.flush()

    # 此处需要提交才能实现插入功能
    conn.commit()
    # 关闭数据库连接
    cursor.close()
    conn.close()

# 输出成功与失败的数量
print(f"\nInserted successfully: {success_count}\nInsertion failed: {failure_count}")
