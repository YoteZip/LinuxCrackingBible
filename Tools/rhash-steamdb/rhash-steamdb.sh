#! /bin/bash

# SteamDB-compatible RHash SHA1 manifest generator
# For usage notes, run this script without arguments

(
    for reqProg in "rhash" "sed"; do
        if ! [[ -x "$(command -v "$reqProg")" ]]; then
            echo "\"$reqProg\" program is required for execution"
            exit 1
        fi
    done

    if [[ $# -ge 1 ]] && [[ -d "$1" ]]; then
        if [[ $# -eq 1 ]]; then
            hashfilename="$(basename "$(realpath "$1")")"
        else
            hashfilename="$2"
        fi

        CurRhashDir="$(pwd)"
        cd "$1" || return

        rhash -H . -r -o "$CurRhashDir/$hashfilename.sha1"
        sed -i -r -E 's/([0-9a-f]{40})  /\1 \*/g' "$CurRhashDir/$hashfilename.sha1" # add a "*" before the filename, which is how SteamDB userscript wants the formatting
    else
        echo 'SteamDB-compatible RHash SHA1 manifest generator:'
        echo '-------------------------------------------------------------------------------'
        echo 'Argument 1: Input directory'
        echo 'Argument 2 (optional): Custom name for output hash file. (Default is directory name)'
        echo '-------------------------------------------------------------------------------'
    fi
)