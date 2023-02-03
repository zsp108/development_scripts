#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

set -o errexit
set +o nounset
set -o pipefail
# set -e

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${SCRIPT_ROOT}/common/logging.sh"


#判断操作系统类型
function get_ostype() {
    declare -g OSNAME
    if [[ -f /etc/redhat-release ]];then
        OSTYPE='redhat'
    elif [[ -f /etc/lsb-release ]];then
        OSTYPE='debian'
    fi
    # echo "$OSNAME"
}


#获取sudo 权限，export LINUX_PASSWORD=""
function common_sudo() {
  echo ${LINUX_PASSWORD} | sudo -S $1
}

