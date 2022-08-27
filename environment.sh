#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

#判断操作系统类型
function get::ostype() {
    declare -g OSNAME
    if [[ -f /etc/redhat-release ]];then
        OSTYPE='redhat'
    elif [[ -f /etc/lsb-release ]];then
        OSTYPE='debian'
    fi
    # echo "$OSNAME"
}