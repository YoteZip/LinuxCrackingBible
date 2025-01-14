#!/usr/bin/env bash

# SteamDB-compatible RHash SHA1 manifest generator
# For usage notes, run this script without arguments

if ! [[ -x "$(command -v "rhash")" ]]; then
    echo "\"rhash\" program is required for execution"
    exit 1
fi

if [[ $# -ge 1 ]] && [[ -d "$1" ]]; then
    if [[ $# -eq 1 ]]; then
        hashfilename="$(basename "$(realpath "$1")")"
    else
        hashfilename="$2"
    fi

    CurRhashDir="$(pwd)"
    cd "$1" || return

    rhash . --sha1 --recursive --output="$CurRhashDir/$hashfilename.sha1" --printf="%h *%p\n"
else
    echo 'SteamDB-compatible RHash SHA1 manifest generator:'
    echo '-------------------------------------------------------------------------------'
    echo 'Argument 1: Input directory'
    echo 'Argument 2 (optional): Custom name for output hash file. (Default is directory name)'
    echo '-------------------------------------------------------------------------------'
fi