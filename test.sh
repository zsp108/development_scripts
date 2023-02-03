#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/" && pwd -P)"

ls
echo "$SCRIPT_ROOT/installs"
cd $SCRIPT_ROOT/installs
./env_setting.sh
./git.sh
./go.sh
./python.sh
