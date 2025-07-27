# **Xbox Live**

This is Microsoft's Xbox Live DRM, only found on a half dozen games so far. It's trivial to crack, only requiring an auto-defeat DLL to be injected with no configuration. To crack this DRM, we're going to use Goldberg Xbox Live Emulator, which can be found under `Main Forum -> Releases` (thread ID `114182`). Download the latest copy for your toolkit.

The most popular way to defeat this DRM is by injecting the DLL through Goldberg's Experimental Steam Emulator, which includes an easy folder for loading DLLs. It's still possible to use other methods to inject this DLL (e.g. [Koaloader](../../Tools/Koaloader/koaloader.md)), but it's often not necessary if the game is already protected with Steamworks.

# Cracking Guide

For our walkthrough we'll be cracking the Xbox Live DRM off of Halo - The Master Chief Collection (hereafter referred to as `MCC` for my sanity). This game is easy to source via cs.rin's Main Forum (thread ID `90277`), or you can follow along with your own Xbox Live-protected game. MCC uses Xbox Live and Steamworks API for protection.

1. Source MCC and extract it to your workspace

2. Defeat [Steamworks API](../Steamworks-API/defeating_steamworks.md) protection with Goldberg's Steam Emulator (make sure you crack with the `experimental` version)

3. In your `steam_settings` folder from Goldberg's Steam Emulator, create a folder named `load_dlls`

4. Copy `xlive64.dll` from Goldberg's Xbox Live Emulator into this new folder

5. Xbox Live DRM is now defeated!

- [`MCC ONLY`] MCC needs special handling in order to actually launch campaign missions etc. Since all Halo games are optional to install, it uses "depot" markers to check whether they've been installed. To tell MCC that we have everything it's expecting, navigate to your `steam_settings` folder and create a file named `depots.txt`. Fill that file with the following content:

    ```
    228987
    228990
    229005
    976731
    976732
    976733
    976734
    976735
    976736
    976737
    976738
    976739
    1064222
    1064223
    1064224
    1064225
    1064226
    1064227
    1064228
    1064229
    1064274
    1064275
    1064276
    ```

- [`MCC ONLY`] Next, make sure that the file in `steam_settings` named `configs.app.ini` contains the DLC IDs, like so:

    ```
    [app::dlcs]
    # should the emu report all DLCs as unlocked, default=1
    unlock_all=1
    1064220=Halo: Reach
    1064221=Halo: Combat Evolved Anniversary
    1064270=Halo 2: Anniversary
    1064271=Halo 3
    1064272=Halo 3: ODST
    1064273=Halo 4
    1080080=MCC - H1: Multiplayer
    1097220=MCC - H4: Multiplayer
    1097222=MCC - H3: Multiplayer
    1097223=MCC - H2: Multiplayer
    1097224=MCC - Reach (Content Pack 2)
    1108760=MCC - H1: Extended Language Pack
    1108761=MCC - H2: Extended Language Pack
    1108762=MCC - H3: Extended Language Pack
    1108763=MCC - ODST: Extended Language Pack
    1109620=MCC - H4: Extended Language Pack
    1109621=MCC - Reach: Extended Language Pack
    ```

- [`MCC ONLY`] Now MCC will allow you to start campaigns.

![wise yote wants to participate in the flame wars](images/console.png "wise yote wants to participate in the flame wars")
