#! /bin/bash

# GoldbergAutoTool
# Automatically configures Goldberg Steam Emulator
# For usage notes, run this script without arguments
# Made by Yote.zip

#---------------------------------------
GOLDSTEAM_API_KEY="YOUR_API_KEY_HERE"
GOLDPLAYER_NAME="Player"
EXPERIMENTAL_ENABLED="Y"
#---------------------------------------

if [[ $# -eq 1 ]] && [[ -d "$1" ]]; then
    echo "Potential steam_api libraries found in $(realpath "$1")":
    cd "$(realpath "$1")" || exit
    echo '-------------------------------------------------------------------------------'
    find . -type f -name 'steam_api64.dll'
    find . -type f -name 'steam_api.dll'
    find . -type f -name 'libsteam_api.so'
    find . -type f -name 'steamclient.so'
    echo '-------------------------------------------------------------------------------'
    cd - &> /dev/null || exit
    exit 0

elif [[ $# -eq 2 ]] && [[ "$1" =~ ^[0-9]+$ ]] && [[ -d "$2" ]]; then
    APP_ID="$1"
    EXECUTABLE_DIR="$(realpath "$2")"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


    if [[ ! -f "$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh" ]]; then
        echo "(.sh file location)/goldberg_emu/linux/tools/find_interfaces.sh not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/generate_game_infos" ]]; then
        echo "(.sh file location)/generate_game_infos not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/experimental/steam_api64.dll" ]]; then
        echo "(.sh file location)/goldberg_emu/experimental/steam_api64.dll not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/experimental/steam_api.dll" ]]; then
        echo "(.sh file location)/goldberg_emu/experimental/steam_api.dll not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/linux/x86/libsteam_api.so" ]]; then
        echo "(.sh file location)/goldberg_emu/linux/x86/libsteam_api.so not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/linux/x86/steamclient.so" ]]; then
        echo "(.sh file location)/goldberg_emu/linux/x86/steamclient.so not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/linux/x86_64/libsteam_api.so" ]]; then
        echo "(.sh file location)/goldberg_emu/linux/x86_64/libsteam_api.so not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/linux/x86_64/steamclient.so" ]]; then
        echo "(.sh file location)/goldberg_emu/linux/x86_64/steamclient.so not found"
        exit 1
    elif [[ ! -d "$SCRIPT_DIR/controller/glyphs" ]]; then
        echo "(.sh file location)/controller/glyphs not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/InGameControls.txt" ]]; then
        echo "(.sh file location)/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/InGameControls.txt not found"
        exit 1
    elif [[ ! -f "$SCRIPT_DIR/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/MenuControls.txt" ]]; then
        echo "(.sh file location)/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/MenuControls.txt not found"
        exit 1
    elif ! [ -x "$(command -v wc)" ]; then
        echo "'wc' program is required for GoldbergAutoTool"
        exit 1
    elif ! [ -x "$(command -v od)" ]; then
        echo "'od' program is required for GoldbergAutoTool"
        exit 1
    fi

    cracked=0

    chmod +x "$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh"

    curFile="steam_api64.dll"
    if [[ -f "$EXECUTABLE_DIR/$curFile" ]]; then
        echo "$curFile exists, replacing..."

        mv "$EXECUTABLE_DIR/$curFile" "$EXECUTABLE_DIR/$curFile.bak" || exit

        if [[ $EXPERIMENTAL_ENABLED = 'Y' ]]; then
            cp "$SCRIPT_DIR/goldberg_emu/experimental/$curFile" "$EXECUTABLE_DIR" || exit
        else
            cp "$SCRIPT_DIR/goldberg_emu/$curFile" "$EXECUTABLE_DIR" || exit
        fi

        ARGSTR=("$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh" "$EXECUTABLE_DIR/$curFile.bak")
        "${ARGSTR[@]}" > "$EXECUTABLE_DIR/steam_interfaces.txt"

        cracked=1
    fi

    curFile="steam_api.dll"
    if [[ -f "$EXECUTABLE_DIR/$curFile" ]]; then
        echo "$curFile exists, replacing..."

        mv "$EXECUTABLE_DIR/$curFile" "$EXECUTABLE_DIR/$curFile.bak" || exit

        if [[ $EXPERIMENTAL_ENABLED = 'Y' ]]; then
            cp "$SCRIPT_DIR/goldberg_emu/experimental/$curFile" "$EXECUTABLE_DIR" || exit
        else
            cp "$SCRIPT_DIR/goldberg_emu/$curFile" "$EXECUTABLE_DIR" || exit
        fi

        ARGSTR=("$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh" "$EXECUTABLE_DIR/$curFile.bak")
        "${ARGSTR[@]}" > "$EXECUTABLE_DIR/steam_interfaces.txt"

        cracked=1
    fi

    curFile="libsteam_api.so"
    if [[ -f "$EXECUTABLE_DIR/$curFile" ]]; then
        echo "$curFile exists, replacing..."

        bits=$(od -An -t x1 -j 4 -N 1 "$EXECUTABLE_DIR/$curFile")
        mv "$EXECUTABLE_DIR/$curFile" "$EXECUTABLE_DIR/$curFile.bak" || exit

        if [[ $bits -eq 01 ]]; then
            echo "32bit $curFile detected"
            cp "$SCRIPT_DIR/goldberg_emu/linux/x86/$curFile" "$EXECUTABLE_DIR" || exit
        elif [[ $bits -eq 02 ]]; then
            echo "64bit $curFile detected"
            cp "$SCRIPT_DIR/goldberg_emu/linux/x86_64/$curFile" "$EXECUTABLE_DIR" || exit
        fi

        ARGSTR=("$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh" "$EXECUTABLE_DIR/$curFile.bak")
        "${ARGSTR[@]}" > "$EXECUTABLE_DIR/steam_interfaces.txt"

        cracked=1
    fi

    curFile="steamclient.so"
    if [[ -f "$EXECUTABLE_DIR/$curFile" ]]; then
        echo "$curFile exists, replacing..."

        bits=$(od -An -t x1 -j 4 -N 1 "$EXECUTABLE_DIR/$curFile")
        mv "$EXECUTABLE_DIR/$curFile" "$EXECUTABLE_DIR/$curFile.bak" || exit

        if [[ $bits -eq 01 ]]; then
            echo "32bit $curFile detected"
            cp "$SCRIPT_DIR/goldberg_emu/linux/x86/$curFile" "$EXECUTABLE_DIR" || exit
        elif [[ $bits -eq 02 ]]; then
            echo "64bit $curFile detected"
            cp "$SCRIPT_DIR/goldberg_emu/linux/x86_64/$curFile" "$EXECUTABLE_DIR" || exit
        fi

        ARGSTR=("$SCRIPT_DIR/goldberg_emu/linux/tools/find_interfaces.sh" "$EXECUTABLE_DIR/$curFile.bak")
        "${ARGSTR[@]}" > "$EXECUTABLE_DIR/steam_interfaces.txt"

        cracked=1
    fi

    if [[ $cracked -eq 1 ]]; then
        echo '-------------------------------------------------------------------------------'
        mkdir -p "$EXECUTABLE_DIR/steam_settings" || exit
        echo -e "$APP_ID" > "$EXECUTABLE_DIR/steam_settings/steam_appid.txt"
        echo -e "$GOLDPLAYER_NAME" > "$EXECUTABLE_DIR/steam_settings/force_account_name.txt"
        cp -r "$SCRIPT_DIR/controller" "$EXECUTABLE_DIR/steam_settings"
        cp "$SCRIPT_DIR/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/InGameControls.txt" "$EXECUTABLE_DIR/steam_settings/controller"
        cp "$SCRIPT_DIR/goldberg_emu/steam_settings.EXAMPLE/controller.EXAMPLE/MenuControls.txt" "$EXECUTABLE_DIR/steam_settings/controller"

        if [[ $EXPERIMENTAL_ENABLED = 'Y' ]]; then
            mkdir -p "$EXECUTABLE_DIR/steam_settings/load_dlls" || exit
        fi

        echo '-------------------------------------------------------------------------------'

        chmod +x "$SCRIPT_DIR/generate_game_infos"
        ARGSTR=("$SCRIPT_DIR/generate_game_infos" "$APP_ID" "-s" "$GOLDSTEAM_API_KEY" "-o" "$EXECUTABLE_DIR/steam_settings/")
        "${ARGSTR[@]}"

        curFile="DLC.txt"
        if [[ -f "$EXECUTABLE_DIR/steam_settings/$curFile" ]]; then
            if [[ ! $(wc -c <"$EXECUTABLE_DIR/steam_settings/$curFile") -gt 2 ]]; then # If we didn't get any results
                rm "$EXECUTABLE_DIR/steam_settings/$curFile"
            else
                mv "$EXECUTABLE_DIR/steam_settings/$curFile" "$EXECUTABLE_DIR/steam_settings/$curFile.onlyifneeded"
            fi
        fi
        curFile="achievements.json"
        if [[ -f "$EXECUTABLE_DIR/steam_settings/$curFile" ]]; then
            if [[ ! $(wc -c <"$EXECUTABLE_DIR/steam_settings/$curFile") -gt 2 ]]; then # If we didn't get any results
                rm "$EXECUTABLE_DIR/steam_settings/$curFile"
            fi
        fi
        if [[ -z "$(ls -A "$EXECUTABLE_DIR/steam_settings/images")" ]]; then
            rmdir "$EXECUTABLE_DIR/steam_settings/images"
        fi

        echo '-------------------------------------------------------------------------------'
        echo "Remember to unpack any exes with 'steamless /path/to/game-directory'"
        echo '-------------------------------------------------------------------------------'
    else
        echo "No steam_api library files found. Try another directory."
    fi
else
    echo 'GoldbergAutoTool'
    echo '-------------------------------------------------------------------------------'
    echo ''
    echo 'Cracking Mode:'
    echo '-------------------------------------------------------------------------------'
    echo 'Argument 1: Steam AppID'
    echo 'Argument 2: Directory where game steam_api libraries are (steam_api64.dll etc)'
    echo '-------------------------------------------------------------------------------'
    echo ''
    echo 'Detect Mode:'
    echo '-------------------------------------------------------------------------------'
    echo 'Argument 1: Root directory of game'
    echo '-------------------------------------------------------------------------------'
fi

unset GOLDSTEAM_API_KEY GOLDPLAYER_NAME EXPERIMENTAL_ENABLED APP_ID EXECUTABLE_DIR SCRIPT_DIR cracked curFile ARGSTR bits