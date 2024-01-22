#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.


SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${SCRIPT_ROOT}/common/init.sh"
source $HOME/.bashrc

download_dir=/tmp


function install_go(){

    read -p "请输入需要安装的go版本(默认为1.18.3)：" go_version
    if [ ! $go_version ];then
        go_version=1.18.3
    fi

    if [ `command -v go` ];then
        cur_goversion=`go version 2>&1 | sed '1!d' | sed -e 's/go//g' |awk '{print $2}'`
        log_info "当前go版本为$cur_goversion"

        if [ $go_version == $cur_goversion ];then
            log_info "已安装的版本和将要安装的版本相同,不进行安装"
            return
        else
            log_error "该环境已安装的Golang版本和将要安装的版本不同，请清理旧版本Golang后重试本脚本，旧版本位置：`command -v go`"
        fi
    fi

    rm -rf $download_dir/go$go_version.linux-amd64.tar.gz $HOME/go/go$go_version # clean up

    # 下载 go$go_version 版本的 Go 安装包
    cpu_type="amd64"
    if [[ "$CPUTYPE"=="aarch64" ]];then
        cpu_type="arm64"
    fi
    wget -P $download_dir https://golang.google.cn/dl/go$go_version.linux-$cpu_type.tar.gz
    

    # 安装 Go
    mkdir -p $HOME/go
    tar -xvzf $download_dir/go$go_version.linux-$cpu_type.tar.gz -C $HOME/go
    mv $HOME/go/go $HOME/go/go$go_version

    # 配置 Go 环境变量

    if [ `grep -c "# Go envs" $HOME/.bashrc` -ne 0 ];then
        log_warn """$HOME/.bashrc has git config, please check it 

# Go envs
export GOVERSION=go$go_version # Go 版本设置
export GO_INSTALL_DIR=\$HOME/go # Go 安装目录
export GOROOT=\$GO_INSTALL_DIR/\$GOVERSION # GOROOT 设置
export GOPATH=\$WORKSPACE/golang # GOPATH 设置
export PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH # 将 Go 语言自带的和通过 go install 安装的二进制文件加入到 PATH 路径中
export GO111MODULE="on" # 开启 Go moudles 特性
#export GOPROXY=https://goproxy.cn,direct # 安装 Go 模块时，代理服务器设置
export GOPRIVATE=
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值

"""
    else
        cat << EOF >> $HOME/.bashrc

# Go envs
export GOVERSION=go$go_version # Go 版本设置
export GO_INSTALL_DIR=\$HOME/go # Go 安装目录
export GOROOT=\$GO_INSTALL_DIR/\$GOVERSION # GOROOT 设置
export GOPATH=\$WORKSPACE/golang # GOPATH 设置
export PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH # 将 Go 语言自带的和通过 go install 安装的二进制文件加入到 PATH 路径中
export GO111MODULE="on" # 开启 Go moudles 特性
#export GOPROXY=https://goproxy.cn,direct # 安装 Go 模块时，代理服务器设置
export GOPRIVATE=
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值
EOF
    fi
  
    #source $HOME/.bashrc && 
    source $HOME/.bashrc && go version > /dev/null | mkdir -p $GOPATH && cd $GOPATH && go work init && log_info "Install Golang successfully" || log_error "Golang version is not '$go_version',maynot install Golang properly"

  
  
  
}


install_go
