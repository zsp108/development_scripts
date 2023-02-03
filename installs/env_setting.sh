#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.


SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${SCRIPT_ROOT}/common/init.sh"

#修改$HOME/.bashrc文件
init_bashrc() {

    read -p "该环境名称：" env_name


	if [ -f $HOME/.bashrc ];then
		mv $HOME/.bashrc $HOME/.bashrc_bak_`date +%Y%m%d%H%M%S`
        log_warn "backup $HOME/.bashrc"
	fi

    cp ${SCRIPT_ROOT}/templates/temp_bashrc $HOME/.bashrc
    sed -i "s/#env_name/$env_name/g" $HOME/.bashrc


    source $HOME/.bashrc
    log_info "prepare linux successfully"
}

init_bashrc