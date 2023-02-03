#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

ls
echo "$SCRIPT_ROOT/installs"
cd $SCRIPT_ROOT/installs
./env_setting.sh < $SCRIPT_ROOT/test/env_setting.data
cat ~/.bashrc
./git.sh < $SCRIPT_ROOT/test/git_test.data
source ~/.bashrc && git config --global --list
# ./go.sh
./python.sh < $SCRIPT_ROOT/test/python_test.data