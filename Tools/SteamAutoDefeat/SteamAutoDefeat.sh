#!/usr/bin/env bash
# SteamAutoDefeat v1.1.2
# Automatically configures the 2nd-gen Goldberg Steam Emulator and runs Steamless on executables in a given directory
# For usage notes, run this script without arguments
# Made by Yote.zip

# Don't touch
#---------------------------------------
for reqProg in "crudini" "dirname" "mktemp" "od" "parallel"; do # Sorry for crudini, but with INI files and the rapid development of the fork I'm not playing games with sed
    if ! [[ -x "$(command -v "$reqProg")" ]]; then
        echo "\"$reqProg\" program is required for execution"
        exit 1
    fi
done
SAD_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#---------------------------------------

# SAD Configuration:
#---------------------------------------
# Set a directory to hold all the relevant crack parts as they're generated, then you'll be asked to apply the crack at the end
# You can set this to a static directory if you plan on saving the clean crack without applying it, otherwise mktemp will put it in your /tmp
SAD_OUTPUT_PATH="$(mktemp -d)"
# SAD_OUTPUT_PATH="$HOME/SADOutput"
# Downloaded Goldberg Emulator file paths. They will be checked before use
SAD_WIN_RELEASE_RELPATH="$SAD_SCRIPT_DIR/goldberg_emu/emu-win-release"
SAD_LINUX_RELEASE_RELPATH="$SAD_SCRIPT_DIR/goldberg_emu/emu-linux-release"
SAD_GEN_INTERFACES_CMD="$SAD_LINUX_RELEASE_RELPATH/tools/generate_interfaces/generate_interfaces_x64"
SAD_GENERATE_EMU_CMD="$SAD_SCRIPT_DIR/goldberg_emu/gen_emu_config_old-linux/generate_emu_config/generate_emu_config"
# If enabled, automatically strip any SteamDRM/SteamStub protection from binaries using Steamless. This doesn't affect regular binaries, so it's safe to leave on
SAD_AUTO_STEAMLESS=1
SAD_STEAMLESS_CLI_EXE="$SAD_SCRIPT_DIR/steamless/Steamless.CLI.exe"
# Leave empty to use system Wine prefix. This Wine prefix must have `winetricks -q -f dotnet48` run in it first to produce valid binaries
SAD_STEAMLESS_WINE_PREFIX=""
#---------------------------------------
# Custom Emulator configuration:
#---------------------------------------
# Displayed name ingame
SAD_PLAYER_NAME="Player"
# Path to an image for displaying as a player avatar ingame (jpg/png only)
# Leave blank or pointing to a nonexistent path to disable
SAD_PLAYER_AVATAR="$SAD_SCRIPT_DIR/account_avatar.png"
# If enabled, emulator will respond to all DLC inquiries with "yes". Rarely, games will use other methods to check DLC, or may try to query false DLCs to catch emulators
# In most cases, leave this on unless it doesn't work
SAD_AUTO_UNLOCK_DLC=1
# Enable the experimental version of the emulator, which is required for the options below
SAD_EXPERIMENTAL_ENABLED=1
# If enabled, emulator will block the game from sending any network connections unless they are to a local/LAN IP address
# Alternatively, you can use `bwrap --unshare-net --dev-bind / /` as a command prefix to sandbox all networking from a game
SAD_BLOCK_NON_LAN_CONNECTIONS=1
# If enabled, a Shift+Tab overlay will be injected into the game for achievement popups and LAN friend network
# As of writing, some DirectX 9 games crash on startup with this overlay enabled, and some Vulkan games will only display a black screen
SAD_ENABLE_OVERLAY=1
# By default, the overlay will display a notification every time you make any progress on an achievement
# You most likely want this disabled, as it is very spammy
SAD_DISABLE_OVERLAY_ACHIEVEMENT_PROGRESS=1
#---------------------------------------

trap "echo User terminated script; exit" SIGINT
shopt -s globstar nullglob dotglob # Makes all the **/* work

# Detect Mode
# If one argument was given: a valid directory
if [[ $# -eq 1 ]] && [[ -d "$1" ]]; then
    echo "Potential Steam libraries found in $(cd "$1" && pwd)":
    (
        cd "$1" || exit
        echo "#-----------------------------------------------------------------------------#"
        # Search and report any Steam Libraries
        for filePath in **/steam_api.dll **/steam_api64.dll **/steamclient.dll **/steamclient64.dll **/libsteam_api.so **/steamclient.so; do
            echo "./$filePath"
        done
        echo "#-----------------------------------------------------------------------------#"
    )
    exit 0
# Cracking Mode
# If two arguments were given: a numeric Steam ID and a valid directory
elif [[ $# -eq 2 ]] && [[ "$1" =~ ^[0-9]+$ ]] && [[ -d "$2" ]]; then
    APP_ID="$1"
    BASE_GAME_DIR="$(cd "$2" && pwd)"

    # Append the Steam App ID to the output path and create the directory
    SAD_OUTPUT_PATH="$SAD_OUTPUT_PATH/$APP_ID"
    mkdir -p "$SAD_OUTPUT_PATH"

    if [[ "$SAD_EXPERIMENTAL_ENABLED" -eq 1 ]]; then
        SAD_WIN_RELEASE_RELPATH="$SAD_WIN_RELEASE_RELPATH/experimental"
        SAD_LINUX_RELEASE_RELPATH="$SAD_LINUX_RELEASE_RELPATH/experimental"
    else
        SAD_WIN_RELEASE_RELPATH="$SAD_WIN_RELEASE_RELPATH/regular"
        SAD_LINUX_RELEASE_RELPATH="$SAD_LINUX_RELEASE_RELPATH/regular"
    fi

    # Verify important files are in place and ready to use
    requiredFiles=(
        "$SAD_GEN_INTERFACES_CMD"
        "$SAD_GENERATE_EMU_CMD"
        "$SAD_WIN_RELEASE_RELPATH/x32/steam_api.dll"
        "$SAD_WIN_RELEASE_RELPATH/x64/steam_api64.dll"
        "$SAD_LINUX_RELEASE_RELPATH/x32/libsteam_api.so"
        "$SAD_LINUX_RELEASE_RELPATH/x32/steamclient.so"
        "$SAD_LINUX_RELEASE_RELPATH/x64/libsteam_api.so"
        "$SAD_LINUX_RELEASE_RELPATH/x64/steamclient.so"
    )
    if [[ "$SAD_EXPERIMENTAL_ENABLED" -eq 1 ]]; then
        requiredFiles+=("$SAD_WIN_RELEASE_RELPATH/x32/steamclient.dll" "$SAD_WIN_RELEASE_RELPATH/x64/steamclient64.dll")
    fi
    if [[ "$SAD_AUTO_STEAMLESS" -eq 1 ]]; then
        requiredFiles+=("$SAD_STEAMLESS_CLI_EXE")
    fi
    for reqFile in "${requiredFiles[@]}"; do
        if [[ ! -f "$reqFile" ]]; then
            echo "\"$reqFile\" file is required for execution"
            exit 1
        fi
    done

    # Generates a Goldberg configuration into the output directory
    # Does not copy to the original game directory yet
    (
        cd "$SAD_OUTPUT_PATH" || exit
        echo "-------------------------------------------------------------------------------"
        echo "Login may time out or need to be reattempted - if it takes too long, cancel and try again"
        echo "-------------------------------------------------------------------------------"
        (
            # Run the emu config generator
            "$SAD_GENERATE_EMU_CMD" "-cve" "-token" "$APP_ID"
        )

        cd "output/$APP_ID/steam_settings/" || exit

        # Set DLC auto-unlock preference
        crudini --set "configs.app.ini" "app::dlcs" "unlock_all" "$SAD_AUTO_UNLOCK_DLC"
        # Set LAN blocking preference
        crudini --set "configs.main.ini" "main::connectivity" "disable_lan_only" "$((SAD_BLOCK_NON_LAN_CONNECTIONS ^ 1))" # Inverts 0 <--> 1, intended
        # Set overlay preference
        crudini --set "configs.overlay.ini" "overlay::general" "enable_experimental_overlay" "$SAD_ENABLE_OVERLAY"
        # Set overlay partial achievement notification preference
        crudini --set "configs.overlay.ini" "overlay::general" "disable_achievement_progress" "$SAD_DISABLE_OVERLAY_ACHIEVEMENT_PROGRESS"
        # Set player name
        crudini --set "configs.user.ini" "user::general" "account_name" "$SAD_PLAYER_NAME"
        # If configured player avatar exists
        if [[ -f "$SAD_PLAYER_AVATAR" ]]; then
            # Copy the avatar to steam_settings, renaming to account_avatar and carrying over the original extension
            cp -f "$SAD_PLAYER_AVATAR" "account_avatar.${SAD_PLAYER_AVATAR##*.}"
        fi

        # You can put any manual configurations in a $SAD_SCRIPT_DIR/custom_handling/$APP_ID directory and this will copy it into steam_settings when it encounters that game
        if [[ -d "$SAD_SCRIPT_DIR/custom_handling/$APP_ID" ]]; then
            echo "Custom handling detected for App ID: $APP_ID"
            echo "#-----------------------------------------------------------------------------#"
            (
                cd "$SAD_SCRIPT_DIR/custom_handling/$APP_ID" || exit
                for filePath in **/*; do
                    echo "./$filePath"
                done
            )
            echo "#-----------------------------------------------------------------------------#"
            read -rp "Copy these files into the steam_settings directory? --- " SAD_PROMPT
            if [[ "$SAD_PROMPT" = [Yy] ]]; then
                cp -r "$SAD_SCRIPT_DIR/custom_handling/$APP_ID/." .
            fi
        fi

        # Next, we generate a skeleton of the Steam libraries need to be replaced into the output directory
        # Copies a backup of each library, and the Goldberg variant alongside it
        # Also runs Steamless and unpacks executables and their backups into the output directory if enabled
        # At the end of this section, it will ask to copy the finished crack into the game directory
        cd "$BASE_GAME_DIR" || exit

        # Flag which denotes whether anything was found and cracked during runtime
        cracked=0

        filesToReplace=(
            "steam_api.dll"
            "steam_api64.dll"
            "libsteam_api.so"
            "steamclient.so"
        )
        if [[ "$SAD_EXPERIMENTAL_ENABLED" -eq 1 ]]; then
            filesToReplace+=("steamclient.dll" "steamclient64.dll")
        fi

        echo "Steam library files replaced:"
        echo "#-----------------------------------------------------------------------------#"
        # For each Steam library variant
        for curFile in "${filesToReplace[@]}"; do
            # For each instance of that variant found
            for filePath in **/"$curFile"; do
                fileDir="$(dirname "$filePath")"

                # Make .bak copy
                mkdir -p "$SAD_OUTPUT_PATH/$fileDir"
                cp "$filePath" "$SAD_OUTPUT_PATH/$filePath.bak"

                # Copy emulator variant to output path
                case "$curFile" in
                    # Windows 32 bit
                    "steam_api.dll" | "steamclient.dll" )
                        echo "./$filePath"
                        cp "$SAD_WIN_RELEASE_RELPATH/x32/$curFile" "$SAD_OUTPUT_PATH/$filePath"
                        cracked=1 # Flag that we cracked something during execution
                        ;;
                    # Windows 64 bit
                    "steam_api64.dll" | "steamclient64.dll" )
                        echo "./$filePath"
                        cp "$SAD_WIN_RELEASE_RELPATH/x64/$curFile" "$SAD_OUTPUT_PATH/$filePath"
                        cracked=1 # Flag that we cracked something during execution
                        ;;
                    # Linux 32/64 bit
                    "libsteam_api.so" | "steamclient.so" )
                        echo "./$filePath"
                        bits="$(od -An -t x1 -j 4 -N 1 "$filePath")" # get 32/64 bit status

                        if [[ "$bits" -eq 01 ]]; then # 32 bit
                            cp "$SAD_LINUX_RELEASE_RELPATH/x32/$curFile" "$SAD_OUTPUT_PATH/$filePath"
                        elif [[ "$bits" -eq 02 ]]; then # 64 bit
                            cp "$SAD_LINUX_RELEASE_RELPATH/x64/$curFile" "$SAD_OUTPUT_PATH/$filePath"
                        fi
                        cracked=1 # Flag that we cracked something during execution
                        ;;
                esac

                # Generate interfaces off the original .bak copy
                case "$curFile" in
                    "steam_api.dll" | "steam_api64.dll" | "libsteam_api.so" )
                        (
                            cd "$SAD_OUTPUT_PATH/$fileDir" || exit # need to move into the directory since the tool doesn't allow output parameter
                            "$SAD_GEN_INTERFACES_CMD" "$SAD_OUTPUT_PATH/$filePath.bak" &> /dev/null
                        )
                        ;;
                esac

                # Copy the generated emulator config settings next to the library, if this is the first time in this directory
                if [[ ! -d "$SAD_OUTPUT_PATH/$fileDir/steam_settings" ]]; then
                    cp -r "$SAD_OUTPUT_PATH/output/$APP_ID/steam_settings" "$SAD_OUTPUT_PATH/$fileDir"
                fi
            done
        done
        echo "#-----------------------------------------------------------------------------#"
        echo ""

        # Remove remaining original config generation output
        rm -rf "$SAD_OUTPUT_PATH/output/"

        # Parallel unpacking of SteamDRM/SteamStub protection, if enabled
        if [[ "$SAD_AUTO_STEAMLESS" -eq 1 ]]; then
            # Set Wine prefix if configured
            if [[ -n "$SAD_STEAMLESS_WINE_PREFIX" ]]; then
                export WINEPREFIX="$SAD_STEAMLESS_WINE_PREFIX"
            fi

            # Send all exes into Steamless, in parallel
            printf %s\\n **/*.exe | parallel -q wine "$SAD_STEAMLESS_CLI_EXE" --keepbind --quiet {} &> /dev/null
            echo "Exes unpacked with Steamless:"
            echo "#-----------------------------------------------------------------------------#"
            # For each unpacked exe
            for filePath in **/*.unpacked.exe; do
                # Stores the original exe name, e.g. "game.exe" instead of "game.exe.unpacked.exe"
                originalExeName="${filePath//.unpacked.exe/}"
                # Copy backup of original executable into output directory
                fileDir="$(dirname "$filePath")"
                mkdir -p "$SAD_OUTPUT_PATH/$fileDir"
                cp "$originalExeName" "$SAD_OUTPUT_PATH/$originalExeName.bak"
                # Move unpacked executable out of the game directory and into the output directory, into its original name
                mv "$filePath" "$SAD_OUTPUT_PATH/$originalExeName"

                cracked=1 # Flag that we cracked something during execution
                echo "./$originalExeName"
            done
            echo "#-----------------------------------------------------------------------------#"
            echo ""
        fi

        # If something was cracked during runtime
        if [[ "$cracked" -eq 1 ]]; then
            read -rp "Copy the generated crack into the game directory? (y/n) --- " SAD_PROMPT
            if [[ "$SAD_PROMPT" = [Yy] ]]; then
                cp -rf "$SAD_OUTPUT_PATH/." "$BASE_GAME_DIR"
            fi

            read -rp "Clean up the output directory? (y/n) --- " SAD_PROMPT
            if [[ "$SAD_PROMPT" = [Yy] ]]; then
                # Remeber that this deletes SAD_OUTPUT_PATH/APP_ID, not the original SAD_OUTPUT_PATH from the configuration
                rm -rf "$SAD_OUTPUT_PATH"
            fi
        else
            echo "No Steam protected files found. Try another directory."
        fi

        # If output directory is completely empty for our APP_ID, remove it
        if [[ -d "$SAD_OUTPUT_PATH" ]]; then
            rmdir --ignore-fail-on-non-empty "$SAD_OUTPUT_PATH"
        fi
    )
else
    echo "SteamAutoDefeat"
    echo "-------------------------------------------------------------------------------"
    echo ""
    echo "Cracking Mode:"
    echo "-------------------------------------------------------------------------------"
    echo "Argument 1: Steam AppID"
    echo "Argument 2: Root directory of a game that contains Steam libraries (steam_api64.dll, steam_api.so, etc)"
    echo "-------------------------------------------------------------------------------"
    echo ""
    echo "Detect Mode:"
    echo "-------------------------------------------------------------------------------"
    echo "Argument 1: Root directory of game"
    echo "-------------------------------------------------------------------------------"
fi

# Changelog
# 1.1.2 - Add note on overlay's interaction with Vulkan
# 1.1.1 - change default directory for the config generation tool to "gen_emu_config_old-linux", to correspond with the new gbe_fork_tools repo naming convention
# 1.1.0 - change authentication to use new refresh token feature instead of hardcoded creds. (this requires gbe_fork 2024-11-05 or later)
#       - switches away from -reldir, which wasn't doing much for us.
#         (this  will make a "backup" directory start appearing next to your generate_emu_config executable, but there's not a clean way of keeping the refresh tokens with -reldir enabled.)
#       - sends generate interfaces output into /dev/null, since it's started being noisy and there's no internal quiet flag
# 1.0.1 - added avatar support