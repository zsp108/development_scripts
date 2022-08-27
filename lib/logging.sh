#!/bin/bash

# Copyright 2020 SP Zhang <echo996@foxmail.com>. All rights reserved.

log::porint(){
    local type="$1"
    local dt; dt="$(date --rfc-3339=seconds)"
    local text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
    printf '%s [%s]: %s\n' "$dt" "$type" "$text"
}
log::info(){
    log::porint Info "$@"
}
log::warn(){
    log::porint Warning "$@" >&2
}
log::error(){
    log::porint Error "$@" >&2
    exit 1
}