#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.


SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${SCRIPT_ROOT}/common/init.sh"
source $HOME/.bashrc


download_dir=/tmp


#git 安装
install_git(){

    read -p "请输入需要安装的git版本(默认为2.36.1)：" git_version
    if [ ! $git_version ];then
        git_version=2.36.1
    fi

    #判断是否安装过git，如果有再确认是否卸载原安装的git
    if [ `command  -v git` ];then
        cur_gitversion=`git --version 2>&1 | sed '1!d' | sed -e 's/"//g' | awk '{print $3}'`
        log_info "当前git版本为$cur_gitversion"

        if [[ $cur_gitversion == $git_version  ]];then
            log_info "已安装的版本和将要安装的版本相同,不进行安装"
            return
        else
            log_info "已安装的版本和将要安装的版本不同"

            read -p "是否删除已安装的git$cur_gitversion？(y/n):" is_del_git
 
            if [[ $is_del_git == 'y' ]];then
                case $OSNAME in
                    'redhat')
                        yum remove git -y
                        ;;
                    'debian')
                        apt remove git -y
                        ;;
                esac
            fi
        fi
    
    fi

    #安装git 编译需要的依赖
    case $OSNAME in
        'redhat')
            yum update -y
            yum install -y wget make autoconf automake cmake perl-CPAN libcurl-devel libtool gcc gcc-c++ glibc-headers zlib-devel telnet ctags lrzsz jq expat-devel openssl-devel
            ;;
        'debian')
            apt-get update -y
            apt-get install -y  wget make autoconf automake cmake libtool gcc zlib1g-dev tcl-dev telnet ctags lrzsz jq openssl expat dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev libghc-zlib-dev libprotoc-dev
            ;;
    esac

    #清理git 编译目标目录
    if [ -f /usr/local/libexec/git-core ];then
        rm -rf /usr/local/libexec/git-core/*
    fi
    rm -rf /tmp/git-$git_version.tar.gz /tmp/git-$git_version # clean up

  
    wget --no-check-certificate https://mirrors.edge.kernel.org/pub/software/scm/git/git-$git_version.tar.gz -O $download_dir/git-$git_version.tar.gz
    cd $download_dir
    tar -xvzf git-$git_version.tar.gz
    cd git-$git_version/
    ./configure
    make -j`nproc`
    make install -j`nproc`
    cp $download_dir/git-$git_version/contrib/completion/git-completion.bash $HOME/.git-completion.bash

    # 添加git到环境变量
    if [ `grep -c "# Configure for git" $HOME/.bashrc` -ne 0 ];then
        log_warn """$HOME/.bashrc has git config, please check it 

# Configure for git
export PATH=/usr/local/libexec/git-core:\$PATH
"""
    else
        cat << 'EOF' >> $HOME/.bashrc

# Configure for git
export PATH=/usr/local/libexec/git-core:$PATH
EOF
        log_info "$HOME/.bashrc add git config successfully"
    fi

    source $HOME/.bashrc && git --version | grep -q "git version $git_version" | log_info "install git successfully" || {
    log_error "git version is not '$git_version',maynot install git properly"
    }

  
}

#设置git 配置
setting_git(){

    
    while [[ -z $git_name || -z $git_email ]]
    do
        
        read -p "请输入您的git账户名：" git_name
        
        read -p "请输入您的git绑定邮箱：" git_email

        read -p "确认输入账户和邮箱：$git_name  $git_email？(y/n):" is_name_email
        if [ $is_name_email == 'n' ];then
            git_name=''
            git_email=''
        fi

    done

    
    
    
    #安装lfs
    case $OSNAME in
        'redhat')
	    yum install epel-release.noarch -y
            yum update -y
            yum install -y git-lfs
            ;;
        'debian')
            apt-get update -y
            apt-get install -y git-lfs
            ;;
    esac

    git config --global user.name "$git_name"    # 用户名改成自己的
    git config --global user.email "$git_email"    # 邮箱改成自己的
    git config --global credential.helper store    # 设置 Git，保存用户名和密码
    git config --global core.longpaths true # 解决 Git 中 'Filename too long' 的错误
    git config --global core.quotepath off
    git lfs install --skip-repo
  }

#获取系统类型
get_ostype
# 执行git 安装
install_git

#配置git 设置
source $HOME/.bashrc

read -p "是否进行git配置？(y/n)" is_config_git
is_config_git=${is_config_git:-'n'}
if [ $is_config_git == 'y' ];then
    setting_git
fi
