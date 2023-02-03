#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

log_porint(){
    local type="$1"
    local dt; dt="$(date --rfc-3339=seconds)"
    local text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
    printf '%s [%s]: %s\n' "$dt" "$type" "$text"
}
log_info(){
    log_porint Info "$@"
}
log_warn(){
    log_porint Warning "$@" >&2
}
log_error(){
    log_porint Error "$@" >&2
    exit 1
}