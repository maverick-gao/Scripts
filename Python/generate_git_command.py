# Author:   gaozhl
# Versin:   V1.0 2023.02.15
#           V1.1 2023.02.16

import os

def generate_git_command():
    print("This tool generates git commands based on user selection.")
    print("Enter your selection below:")

    # 提示用户输入操作类型
    print("Select an operation to perform:")
    print("1. Generate git log command")
    print("2. Generate git commit command")
    operation = input("Enter the operation number (1 or 2): ")

    # 提示用户输入路径
    path = input("Enter the path to the git repository (default is current directory): ")

    # 提示用户输入时间范围
    time_option = input("Enter a time range for the commits (e.g. '1 week ago', '2018-01-01..2018-12-31'): ")

    # 提示用户输入提交人
    author_option = input("Enter an author for the commits (default is all authors): ")

    # 提示用户输入展示条数
    count_option = input("Enter the number of commits to show (default is 10): ")

    # 根据用户选择的操作类型执行相应的代码
    if operation == '1':
        print("Generating git log command...")

        # 根据用户输入拼接命令
        git_log_command = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative "

        if time_option:
            git_log_command += "--since='" + time_option + "' "

        if author_option:
            git_log_command += "--author='" + author_option + "' "

        if count_option:
            git_log_command += "-n " + count_option + " "

        # 输出生成的命令
        print("Generated git log command:\n" + git_log_command)

    elif operation == '2':
        print("Generating git commit command...")

        # 根据用户输入拼接命令
        git_commit_command = "git commit -m '"

        commit_message = input("Enter the commit message: ")
        git_commit_command += commit_message + "'"

        # 输出生成的命令
        print("Generated git commit command:\n" + git_commit_command)

    else:
        print("Invalid operation selected. Please enter 1 or 2.")

if __name__ == '__main__':
    generate_git_command()
