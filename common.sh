#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

set -e

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

source "${SCRIPT_ROOT}/lib/init.sh"
source "${SCRIPT_ROOT}/environment.sh"


#获取sudo 权限，export LINUX_PASSWORD=""
function common::sudo() {
  echo ${LINUX_PASSWORD} | sudo -S $1
}


