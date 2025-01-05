# **SteamDRM (Linux)**

This is a very basic DRM from Valve that wraps around a Linux executable. Also commonly referred to as SteamStub. It's primarily found on older games, but there are a couple modern games that still have it. This is a very rare protection type, but luckily it's very easy to unwrap with a simple python script named [pyUnstub](https://gitlab.com/sektour/steamstub_scripts). Clone the repo to your toolkit.

# Cracking Guide

For our walkthrough we'll be cracking SteamDRM on the native Linux version of Binding of Isaac - Rebirth. A native Linux copy of this game was posted by zTG on page 84 of cs.rin's official Binding of Isaac thread (thread ID `65646`), or you can follow along with your own Linux SteamDRM-protected game. Binding of Isaac - Rebirth uses SteamDRM and Steamworks API for protection.

1. Source Binding of Isaac - Rebirth and extract it to your workspace

2. Defeat [Steamworks API](../Steamworks-API/defeating_steamworks.md) protection (SteamDRM games won't always have this protection)

3. Open a terminal in the toolkit folder where your pyUnstub tool lives, and run `python pyUnstub.py "/path/to/isaac.x64"` to generate an unpacked executable.

4. Run `chmod +x /path/to/isaac.x64.crk` in order to set the executable flag on the new file

5. Delete the original `isaac.x64`, and rename the `.crk` file to the original's name

6. SteamDRM is now defeated!

![wise yote channels his inner screen rant](images/steamdrm.png "wise yote channels his inner screen rant")