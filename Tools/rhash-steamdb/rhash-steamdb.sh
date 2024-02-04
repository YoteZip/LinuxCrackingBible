#! /bin/bash

# SteamDB-compatible RHash SHA1 manifest generator
# For usage notes, run this script without arguments

if ! [ -x "$(command -v rhash)" ]; then
    echo "'rhash' program is required for SHA1 manifest generation"
    exit 1
elif ! [ -x "$(command -v sed)" ]; then
    echo "'sed' program is required for SHA1 manifest generation"
    exit 1
fi

if [[ $# -eq 1 ]] && ([[ -d "$1" ]] || [[ -f "$1" ]]); then
    CurRhashDir="$(pwd)"
    hashfilename="$(basename "$(realpath "$1")")"
    cd "$1" || return
    rhash -H . -r -o "$CurRhashDir/$hashfilename.sha1"
    sed -i -r -E 's/([0-9a-f]{40})  /\1 \*/g' "$CurRhashDir/$hashfilename.sha1"
    cd - &> /dev/null || return
elif [[ $# -eq 2 ]] && [[ -d "$1" ]]; then
    CurRhashDir="$(pwd)"
    cd "$1" || return
    rhash -H . -r -o "$CurRhashDir/$2.sha1"
    sed -i -r -E 's/([0-9a-f]{40})  /\1 \*/g' "$CurRhashDir/$2.sha1"
    cd - &> /dev/null || return
else
    echo 'RHash hash generator:'
    echo '-------------------------------------------------------------------------------'
    echo 'Argument 1: Input folder'
    echo 'Argument 2 (optional): Custom name for output hash file. (Default is file/folder name)'
    echo '-------------------------------------------------------------------------------'
fi

unset CurRhashDir hashfilename