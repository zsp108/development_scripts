#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.


SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")
source "${SCRIPT_ROOT}/common/init.sh"

#获取系统类型
get_ostype

files=$(ls $SCRIPT_ROOT/installs/) 

echo """
####################################################################
#                  欢迎使用开发环境一键安装脚本                    #
#请按以下提示选择您需要安装的脚本 :                                #
`
for filename in $files
do
   echo "# $filename"
done
`
####################################################################

"""
read -p "请输入您要执行的脚本名称：" script_name
$SCRIPT_ROOT/installs/$script_name
