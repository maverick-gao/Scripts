# Author:   Maverick Gao
# Version:  V1.0 2023.02.17
#           V1.1 2023.02.17

import sys
import pymysql
from tqdm import tqdm


# 获取文件行数
def get_file_lines(file_path):
    with open(file_path, 'r') as f:
        return sum(1 for line in f)


def main():
    # 数据库连接信息
    db_host = 'localhost'
    db_port = 3306
    db_user = 'root'
    db_password = '123456'
    db_name = 'test'

    # SQL文件路径
    sql_file_path = 'test.sql'

    # 获取文件总行数
    total_lines = get_file_lines(sql_file_path)

    # 连接数据库
    conn = pymysql.connect(
        host=db_host,
        port=db_port,
        user=db_user,
        password=db_password,
        db=db_name,
        charset='utf8mb4'
    )

    # 获取游标对象
    cursor = conn.cursor()

    # 打开SQL文件并逐行执行SQL语句
    with open(sql_file_path, 'r') as f:
        # 使用tqdm显示进度条
        for line in tqdm(f, total=total_lines):
            sql = line.strip()
            if sql and not sql.startswith('--'):
                try:
                    cursor.execute(sql)
                except pymysql.Error as e:
                    with open('error.log', 'a') as log:
                        log.write(f"{sql}\n{str(e)}\n")

        # 提交事务
        conn.commit()

    # 关闭游标和连接
    cursor.close()
    conn.close()

    print('SQL导入完成！')


if __name__ == '__main__':
    main()