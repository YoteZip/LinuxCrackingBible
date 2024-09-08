# **Steamworks API**

This is the big one. Most games you'll interact with are "protected" by Steamworks API. It's trivially bypassed by any number of tools, and often it's the only protection a game will have. At some point, publishers gave up on protecting their games and let GabeN's words ring true: "piracy is a service problem"

We defeat this DRM with `Goldberg Steam Emulator`, which is an excellent tool full of customization. Among its features are auto-unlocking of DLC, auto-LAN setup, achievement support, friends network, mod support, and support for native Linux games

Goldberg Steam Emulator:

  - [Gitlab](https://gitlab.com/Mr_Goldberg/goldberg_emulator)

  - [Latest Release](https://mr_goldberg.gitlab.io/goldberg_emulator/)

  - [Full Readme](https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/blob/master/Readme_release.txt)

Grab the latest release for your toolkit. Goldberg Steam Emulator comes with two versions: `stable` and `experimental`. There are a [number of differences](https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/blob/master/Readme_experimental.txt) between stable and experimental, but generally the biggest ones for us are that experimental includes a Shift+Tab overlay which can display achievements, and it has a subsystem for injecting arbitrary DLLs that you put into one of its folders. The Linux version of Goldberg Steam Emulator unfortunately does not have an experimental build. I recommend using the experimental version by default on Windows games, except in one case: DirectX 9 games [do not play nice with the overlay](https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/issues/219). If you have a DirectX 9 game, either use the stable build or include the file `steam_settings/disable_overlay.txt` in order to disable the overlay

I will go over the basics in this guide, but you should read the [full readme](https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/blob/master/Readme_release.txt) to get comfortable with all the customizations this tool is capable of

**TEMP NOTE**: Mr. Goldberg has ceased development on the emulator and several forks have been swirling around. I expect that one of these forks will eventually overtake the original in the (hopefully near) future. For the moment, most of the activity seems to be happening in [this repo](https://github.com/Detanup01/gbe_fork). Recently, Linux compatibility was expanded there as well, and it all mostly works as expected at this point. The one problem I still have with the newer version is that the experimental overlay doesn't work on 99% of DXVK games, whereas the original Goldberg emulator did. I've rewritten my auto-cracking tool to accomodate the newer version, but I'm still testing my tool and the emulator to shake out any quirks. In the meantime, there is nothing "wrong" with the old Goldberg Emulator, but if a game you want to play uses a newer Steam SDK version, the old version will not work for it. So far I haven't run into many games that require the newer SDK functions, but we will need to upgrade sooner or later. You can track development of the forks with the latest comments in the original Goldberg Steam Emulator thread, under cs.rin's `Main Forum -> Releases` section (thread ID `91627`).

# Cracking Guide

For our walkthrough we'll be cracking the Steamworks API DRM on a Windows copy of Banners of Ruin. This game is easy to source via cs.rin's SCS (thread ID `119427`), and only uses Steamworks API for protection

1. Source Banners of Ruin and extract it to your workspace

2. Open a terminal in the base game directory and run the following command to locate the Steamworks API libraries: `find . -type f | grep -E steam_api.dll\|steam_api64.dll\|libsteam_api.so`

    ![BOR Search](images/BOR-Search.png "Steam library search results")

3. Navigate to those libraries (`steam_api.dll`, `steam_api64.dll`, `libsteam_api.so`) and replace each one with its Goldberg Steam Emulator equivalent. If you're replacing DLLs, choose between the "experimental" build, located in the emulator's `experimental` folder, and the "stable" build, located in the base folder. If you're replacing `.so` files, they are located in the `linux` folder of the emulator (split between 32-bit/64-bit)

    ![BOR Old DLLs](images/BOR-OldDLLs.png "Steam old DLLS")

    ![BOR New DLLs](images/BOR-NewDLLs.png "Steam new DLLS")

4. Create a new folder named `steam_settings` next to the libraries you just replaced. If you replaced multiple libraries in different folders, you'll need to create a `steam_settings` folder next to each one (or just ignore the builds that you aren't going to use, e.g. 32-bit)

5. Create a file in those folders named `steam_appid.txt`, and insert the game's Steam ID here. You can find the Steam ID by visiting its store page and checking the number in the URL. In our case it is `1075740`

6. If you're cracking inside a Wine prefix, create a file in those folders named `force_account_name.txt` and insert whatever name you want the game to display ingame

    - Goldberg normally has a global name that it will use for all games if you change it in the following places:
      - Windows: `C:/Users/<user>/AppData/Roaming/Goldberg SteamEmu Saves/settings/account_name.txt`
      - Linux: `~/.local/share/Goldberg SteamEmu Saves/settings/account_name.txt`
    - Since we're spinning up a Wine prefix per game, there's really no such thing as "global" to us. Each Wine prefix is effectively its own Windows install. It's easier to just configure it here as a `force` setting

7. If your game has a steam_api library older than May 2016, you may need to generate a `steam_interfaces.txt` file

    1. Navigate to the `linux/tools` folder in your copy of Goldberg Steam Emulator
    2. Open a terminal and run the following command on each offending steam library, e.g.: `./find_interfaces.sh "/path/to/steam_api.dll" > steam_interfaces.txt`
    3. Copy the `steam_interfaces.txt` file next to each original steam library file

8. Steamworks API is now defeated!

- Notes on features:
    - DLC is auto-unlocked on most games, as the emulator just says "yes" whenever a game asks if a user has a DLC. Rarely, games will check DLC with a different method, which requires manually inserting DLC info into a `steam_settings/DLC.txt` file. An easy way to get this DLC info is to use [this userscript](https://github.com/Sak32009/GetDLCInfoFromSteamDB/) on SteamDB and use `APPID=APPIDNAME` mode
    - You may rarely need to fill out `depots.txt` for a game to unlock DLC or etc. An easy way to find depot IDs is to visit its SteamDB page.
    - If you're using the Windows experimental version, you can press Shift+Tab ingame to get an overlay that displays achievements. You'll need to load achievement data into the emulator manually. An easy way to get achievement data is to use [this userscript](https://github.com/Sak32009/GetDLCInfoFromSteamDB/) on SteamDB and use `GOLDBERG` mode
    - LAN play is auto-configured with Goldberg Steam Emulator - read the readme for details
    - I highly recommend reading the entire [Goldberg Steam Emulator readme](https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/blob/master/Readme_release.txt) for more information on all the other configurations you can perform with this tool

- If you're trying to crack one of the few native Linux games that requires a Steam runtime in order to work, follow the steps in the [Linux Steam Runtime guide](../../Tools/Linux-Steam-Runtime/configuring_linux_steam_runtime.md)

- Very rarely, Windows games will need to use the `experimental_steamclient` feature. Copy these files in and configure `ColdClientLoader.ini`, then start the game using `steamclient_loader.exe`. The only game that I've seen require this is Dying Light 2. The game may warn you about "Steam not running" as a hint

- To crack Steamworks API automatically in the future, use my [GoldbergAutoTool](../../Tools/GoldbergAutoTool/goldbergautotool.md)

![wise yote has stars in his eyes](images/coolNFO.png "wise yote has stars in his eyes")
