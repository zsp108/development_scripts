#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

set -o errexit
set +o nounset
set -o pipefail

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${SCRIPT_ROOT}/lib/logging.sh"

