#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.


SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

source "${SCRIPT_ROOT}/common.sh"

#修改$HOME/.bashrc文件
init::bashrc() {
	if [ -f $HOME/.bashrc_bak ];then
		mv $HOME/.bashrc $HOME/.bashrc_`date +%Y%m%d%H%M%S`
        log::warn "rm $HOME/.bashrc"
	else
		cp $HOME/.bashrc $HOME/.bashrc_bak
        log::warn "cp $HOME/.bashrc $HOME/.bashrc_bak"
	fi

cat << 'EOF' > $HOME/.bashrc

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f ~/.git-completion.bash ]; then
        . ~/.git-completion.bash
fi

# User specific environment
# Basic envs
export LANG="en_US.UTF-8" # 设置系统语言为 en_US.UTF-8，避免终端出现中文乱码
export PS1='[\u@dev \W]\$ ' # 默认的 PS1 设置会展示全部的路径，为了防止过长，这里只展示："用户名@dev 最后的目录名"
export WORKSPACE="$HOME/workspace" # 设置工作目录
export PATH=$HOME/bin:$PATH # 将 $HOME/bin 目录加入到 PATH 变量中

#创建工作路径
if [ ! -d $HOME/workspace ];then
    mkdir -p $HOME/workspace 
    # ln -s /data/zsp/workspace $HOME/workspace
fi

# Default entry folder
cd $WORKSPACE # 登录系统，默认进入 workspace 目录

alias ws="cd $WORKSPACE"

function setgithub(){
  git config --global user.name "zsp108"    # 用户名改成自己的
  git config --global user.email "echo996@foxmail.com"    # 邮箱改成自己的

}
function setgitlab(){
  git config --global user.name "zhangshaopeng"    # 用户名改成自己的
  git config --global user.email "zhangshaopeng@stoneatom.com"    # 邮箱改成自己的

}

EOF


    source $HOME/.bashrc
    log::info "prepare linux successfully"
}

# Go环境搭建依赖安装
install::lib() {
    if [[ "$OSTYPE" == 'debian' ]];then
        apt-get update -y
        apt-get install -y  wget make autoconf automake cmake libtool gcc zlib1g-dev tcl-dev git-lfs telnet ctags lrzsz jq openssl expat dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev libghc-zlib-dev libprotoc-dev
    elif [[ "$OSTYPE" == 'redhat' ]];then
        yum update -y
        yum install -y wget make autoconf automake cmake perl-CPAN libcurl-devel libtool gcc gcc-c++ glibc-headers zlib-devel git-lfs telnet ctags lrzsz jq expat-devel openssl-devel
    fi
}

#git 安装
install::git(){
    read -p "请输入需要安装的git版本(默认为2.36.1)：" git_version
    if [ ! $git_version ];then
        git_version=2.36.1
    fi

    rm -rf /tmp/git-$git_version.tar.gz /tmp/git-$git_version # clean up
  cd /tmp
  wget --no-check-certificate https://mirrors.edge.kernel.org/pub/software/scm/git/git-$git_version.tar.gz
  tar -xvzf git-$git_version.tar.gz
  cd git-$git_version/
  ./configure
  make -j`nproc`
  make install -j`nproc`
  cp /tmp/git-$git_version/contrib/completion/git-completion.bash $HOME/.git-completion.bash

  cat << 'EOF' >> $HOME/.bashrc
# Configure for git
export PATH=/usr/local/libexec/git-core:$PATH
EOF

  git --version | grep -q "git version $git_version" || {
    log::error "git version is not '$git_version', maynot install git properly"
    return 1
  }

  # 5. 配置 Git
  git config --global user.name "zsp108"    # 用户名改成自己的
  git config --global user.email "echo996@foxmail.com"    # 邮箱改成自己的
  git config --global credential.helper store    # 设置 Git，保存用户名和密码
  git config --global core.longpaths true # 解决 Git 中 'Filename too long' 的错误
  git config --global core.quotepath off
  git lfs install --skip-repo

  source $HOME/.bashrc
  log::info "Install git successfully"
}

function install::go(){

    read -p "请输入需要安装的go版本(默认为1.18.3)：" go_version
    if [ ! $go_version ];then
        go_version=1.18.3
    fi

    rm -rf /tmp/go$go_version.linux-amd64.tar.gz $HOME/go/go$go_version # clean up

  # 下载 go$go_version 版本的 Go 安装包
  wget -P /tmp/ https://golang.google.cn/dl/go$go_version.linux-amd64.tar.gz

  # 安装 Go
  mkdir -p $HOME/go
  tar -xvzf /tmp/go$go_version.linux-amd64.tar.gz -C $HOME/go
  mv $HOME/go/go $HOME/go/go$go_version

  # 配置 Go 环境变量
  cat << "EOF" >> $HOME/.bashrc
# Go envs
export GOVERSION=go$go_version # Go 版本设置
export GO_INSTALL_DIR=$HOME/go # Go 安装目录
export GOROOT=$GO_INSTALL_DIR/$GOVERSION # GOROOT 设置
export GOPATH=$WORKSPACE/golang # GOPATH 设置
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH # 将 Go 语言自带的和通过 go install 安装的二进制文件加入到 PATH 路径中
export GO111MODULE="on" # 开启 Go moudles 特性
export GOPROXY=https://goproxy.cn,direct # 安装 Go 模块时，代理服务器设置
export GOPRIVATE=
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值
EOF
  source $HOME/.bashrc

  # 初始化 Go 工作区
  mkdir -p $GOPATH && cd $GOPATH
  go work init
  log::info "Install Golang successfully"
}




get::ostype
echo "当前脚本运行环境为: $OSTYPE"

# read -p "自动安装(Y/N):" auto_install
# case $auto_install in
#     "y")
#     	init::bashrc
#         install::lib
# 	install::git
# 	install::go
# 	exit 0
#         ;;
# esac


read -n1 -p "是否为新服务器需要进行~/.bashrc 初始化和基础依赖安装? (y/n): " IS_BASH
case $IS_BASH in
    "y")
        echo "y"
        #$HOME/.bashrc 配置文件修改
        # init::bashrc
        #安装所需要的依赖
        # install::lib
        ;;
    "n")
        log::info "非新服务器，不进行 ~/.bashrc 初始化和基础依赖安装"
        ;;
    *)
        echo "没有该选项，退出脚本安装"
        exit 0
        ;;
esac

cat << "EOF"  
###################################################################
#                  欢迎使用开发环境一键安装脚本                      #
#请按以下提示选择您需要安装的软件或环境 :                          #
# 1:安装配置GIT环境;
# 2:安装配置GO开发环境;
# e:退出脚本
####################################################################
EOF

if [ -z $LINUX_PASSWORD ];then
    read -s -p "未设置 LINUX_PASSWORD,请输入当前账号密码：" LINUX_PASSWORD
fi
read -p "请选择安装序号：" INSTALL_NUM
case $INSTALL_NUM in
    1)
        install::git
        ;;
    2)
        install::go
        ;;
    'e')
        log:info "退出脚本"
        exit 0
        ;;
esac

