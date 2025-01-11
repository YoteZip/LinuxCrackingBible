#!/usr/bin/env bash

# Portable Steam-Runtime installer
# Note that the runtime version that games expect may change in the future (it's currently "Sniper")
# Run this file on the same directory as the game executable. (Linux Native only)
# How to run:
# ./runtime-installer.sh start-file.sh
# start-file.sh is the name of the original file that launches the game

# Might work as a simple codename swap in the future, depending on how Valve does things
CURRENT_RUNTIME_CODENAME="sniper"

set -e
startFile="$1"

# Download steam-runtime
startFileDir=$(dirname "$startFile")
cd "$startFileDir"
steamRuntimeURL="https://repo.steampowered.com/steamrt-images-$CURRENT_RUNTIME_CODENAME/snapshots/latest-steam-client-general-availability/SteamLinuxRuntime_$CURRENT_RUNTIME_CODENAME.tar.xz"
wget -c "$steamRuntimeURL" || curl "$steamRuntimeURL"

# Extract it
tar xf "SteamLinuxRuntime_$CURRENT_RUNTIME_CODENAME.tar.xz"
rm "SteamLinuxRuntime_$CURRENT_RUNTIME_CODENAME.tar.xz"

# Create start-runtime executable
cat > start-runtime.sh << EOF
#!/bin/sh
# Arguments go after the "--", e.g. "./start.sh" "--" "-vulkan"
"./SteamLinuxRuntime_$CURRENT_RUNTIME_CODENAME/run" "./$startFile" "--"
EOF

chmod +x start-runtime.sh
chmod +x "$startFile"
