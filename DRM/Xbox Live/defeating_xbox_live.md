# **Xbox Live**

This is Microsoft's Xbox Live DRM, only found on a half dozen games so far. It's trivial to crack, only requiring an auto-defeat DLL to be injected with no configuration. To crack this DRM, we're going to use Goldberg Xbox Live Emulator, which can be found under `Main Forum -> Releases` (thread ID `114182`). Download the latest copy for your toolkit.

The most popular way to defeat this DRM is by injecting the DLL through Goldberg's Experimental Steam Emulator, which includes an easy folder for loading DLLs. It's possible to use other Steam emulators/cracks and inject this DLL in another way, but so far there hasn't been a need to do this.

# Cracking Guide

For our walkthrough we'll be cracking the Xbox Live DRM off of Halo - The Master Chief Collection (hereafter referred to as `MCC` for my sanity). This game is easy to source via cs.rin's SCS (thread ID `88449`), and uses Xbox Live and Steamworks API for protection. It requires quite a few unique steps that other Xbox Live games will not require, but this was the easiest game to source for demonstration

1. Source MCC and extract it to your workspace

2. [`MCC ONLY`] Set your Lutris Wine version to be a Kron4ek build. This may not be necessary in the future - I was having issues with Wine-GE 8-8 crashing after splash screen. Kron4ek 8.10 worked correctly

3. Defeat [Steamworks API](../Steamworks-API/defeating_steamworks.md) protection with Goldberg's Steam Emulator (make sure you crack with the `experimental` version)

4. [`MCC ONLY`] MCC has custom DRM that also needs to be defeated. Go to MCC's official cs.rin thread (thread ID `90277`). On page 142, download the file under `GOLDBERG CRACK MIRROR` posted by oneshotman.

5. [`MCC ONLY`] From that archive, extract `mcclauncher.exe`, `mcclauncher.exe.legit`, and the `data` folder to your MCC game directory. Rename the `data` directory to `Data` and merge it into the original `Data` folder, because capitalization matters on Linux.

6. In your `steam_settings` folder from Goldberg's Steam Emulator, create a folder named `load_dlls`

7. Copy `xlive64.dll` from Goldberg's Xbox Live Emulator into this new folder

8. Xbox Live DRM is now defeated!

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

- [`MCC ONLY`] Next, create a file in `steam_settings` named `DLC.txt`. Fill that file with this content:

    ```
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
