# Author:   Maverick Gao
# Time:     2023.02.15
# Version:  1.0

import argparse

parser = argparse.ArgumentParser(description='Git Command Line Tool')

# 添加提交人参数
parser.add_argument('--author', help='commit author', default=None)

# 添加时间参数
parser.add_argument('--since', help='list commits since a specific date', default=None)
parser.add_argument('--until', help='list commits until a specific date', default=None)

# 添加修改的文件参数
parser.add_argument('--file', help='commit with only given files', default=None)

# 添加操作类型参数
parser.add_argument('--merge', help='merge the specified branch into the current branch', default=False, action='store_true')
parser.add_argument('--new-branch', help='create a new branch and switch to it', default=None)

args = parser.parse_args()

# 提示用户输入
print('Please enter the following information:')
author = input('Commit Author: ') if not args.author else args.author
since = input('List Commits Since (yyyy-mm-dd): ') if not args.since else args.since
until = input('List Commits Until (yyyy-mm-dd): ') if not args.until else args.until
file = input('Commit with Only Given Files: ') if not args.file else args.file
merge = input('Merge Branch Name: ') if args.merge else None
new_branch = input('New Branch Name: ') if not args.new_branch else args.new_branch

# 构造git命令
git_command = 'git log '

if author:
    git_command += f'--author="{author}" '

if since:
    git_command += f'--since="{since}" '

if until:
    git_command += f'--until="{until}" '

if file:
    git_command += f'-- {file}'

if merge:
    git_command = f'git merge {merge}'

if new_branch:
    git_command = f'git checkout -b {new_branch}'

# 执行git命令
print(f'Executing command: {git_command}')
