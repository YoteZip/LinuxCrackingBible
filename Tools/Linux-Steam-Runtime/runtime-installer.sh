#!/bin/sh

# Steam-Runtime installer in one step.
# Note that the runtime version that games expect may change in the future (it's currently "Sniper")
# Run this file on the same directory as the game executable. (Linux Native only)
# How to run:
# ./runtime-installer.sh start-file.sh
# start-file.sh is the name of the original start file

# Define start file
START_FILE_NAME="$1"

# Download steam-runtime
set -e
APP_PATH=$(dirname "$0")
cd "$APP_PATH"
# Use latest
STEAM_RUNTIME_URL='https://repo.steampowered.com/steamrt-images-sniper/snapshots/latest-steam-client-general-availability/SteamLinuxRuntime_sniper.tar.xz'
wget -c "$STEAM_RUNTIME_URL" || curl "$STEAM_RUNTIME_URL"

# Extract it
tar xf SteamLinuxRuntime_sniper.tar.xz
rm SteamLinuxRuntime_sniper.tar.xz

echo "Success"

# Create start-runtime file
cat > start-runtime.sh << EOF
#!/bin/sh
"./SteamLinuxRuntime_sniper/run" "./$START_FILE_NAME"
EOF

# Make our runtime script executable
chmod +x start-runtime.sh

# Make original start script executable
chmod +x "$START_FILE_NAME"
