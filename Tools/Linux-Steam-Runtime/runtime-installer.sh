#!/bin/sh

# I don't remember where I got this script
# Steam-Runtime installer in one step.
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
STEAM_RUNTIME_URL='http://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/steam-runtime.tar.xz'
wget -c "$STEAM_RUNTIME_URL" || curl "$STEAM_RUNTIME_URL" --output steam-runtime.tar.xz

# Extract it
tar xf steam-runtime.tar.xz
rm steam-runtime.tar.xz

echo "Success"

# Create start-runtime file
cat > start-runtime.sh << EOF
#!/bin/sh
"./steam-runtime/run.sh" "./$START_FILE_NAME"
EOF

# Make our runtime script executable
chmod +x start-runtime.sh

# Make original start script executable
chmod +x "$START_FILE_NAME"
