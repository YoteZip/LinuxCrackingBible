#!/usr/bin/env bash
# Steamless-Helper v1.1.0

# Configuration:
STEAMLESS_CLI_EXE="/path/to/Steamless.CLI.exe"
#---------------------------------------

shopt -s globstar nullglob dotglob # Makes all the **/* work

if [[ ! -f "$STEAMLESS_CLI_EXE" ]]; then
    echo "Steamless.CLI.exe location not found"
    exit 1
elif ! [ -x "$(command -v parallel)" ]; then
    echo "'parallel' program is required to run."
    exit 1
fi

if [[ $# -eq 1 ]] && [[ -d "$1" ]]; then
        cd "$1" || return
        echo "Unpacking .exes..."
        # Send all exes into Steamless, in parallel
        printf %s\\n **/*.exe | parallel -q wine "$STEAMLESS_CLI_EXE" --keepbind --quiet {} &> /dev/null
        echo "Exes unpacked with Steamless:"
        echo "#-----------------------------------------------------------------------------#"
        for filePath in **/*.unpacked.exe; do
            originalExeName="${filePath//.unpacked.exe/}"
            mv "$originalExeName" "$originalExeName".bak;
            mv "$filePath" "$originalExeName";
            echo "./$originalExeName"
        done
        echo "#-----------------------------------------------------------------------------#"
elif [[ $# -eq 1 ]] && [[ -f "$1" ]] && [[ "$1" =~ \.exe$ ]]; then
    WINEDEBUG=-all wine "$STEAMLESS_CLI_EXE" --keepbind --quiet "$1"

    unpackedExeName="$1.unpacked.exe"
    if [[ -f "$unpackedExeName" ]]; then
        mv "$1" "$1".bak;
        mv "$unpackedExeName" "$1";
    fi
else
    echo 'Steamless Helper:'
    echo '-------------------------------------------------------------------------------'
    echo 'Argument 1: Input directory or file. All .exes in an input directory will have their SteamDRM removed'
    echo '(EXEs that are not packed with SteamDRM are unaffected)'
    echo '-------------------------------------------------------------------------------'
    exit 0
fi