# **Uplay r2**

This is the new DRM that Ubisoft uses for their games. It's trivial to crack, but almost every game that Ubisoft releases with this DRM also comes with Denuvo. If you can get a game build without Denuvo, it's easy to crack the r2 protection off. Sometimes Ubisoft slips up and releases a Denuvoless build, or some people can just crack Denuvo directly (hello to about 3 people).

To handle r2, we're going to use Goldberg's Uplay r2 Emulator, which can be found under `Main Forum -> Releases` (thread ID `111722`). Download the latest copy for your toolkit.

# Cracking Guide

For our walkthrough we'll be cracking the Uplay r2 DRM off the Denuvoless copy of Immortals Fenyx Rising (hereafter referred to as `IFR` for my sanity). This game is easy to source via cs.rin's SCS (thread ID `128248`), and only uses Uplay r2 for protection. Make sure you get the `10074088` Steam build of the game, which is the one where the developers messed up and released an executable without Denuvo applied.

1. Source IFR and extract it to your workspace

2. Copy `uplay_r2_loader64.dll` and `uplay_r2.ini` from Goldberg's Uplay r2 Emulator to the game directory

3. Open `uplay_r2.ini` in a text editor and configure the following options:
    - `Username` - Change to whatever you want your name to show up as ingame
    - `Language` - Change if you need a language other than English. The list of available languages is right above the key
    - `[DLC]` section - Fill out with DLC IDs for your game in order to unlock them. Acidicoala maintains a [public list](https://github.com/acidicoala/public-entitlements/blob/main/ubisoft/v1/products.jsonc) of them ([local version here](Ubisoft_DLC_IDs.jsonc)). The default configuration for Goldberg's Uplay r2 Emulator is actually already set up for IFR, so no need to change anything.
    - `[Items]` section - Same as above. Acidicoala's list also includes these.

4. Uplay r2 is now defeated! This game specifically launches through `scimitar_engine_win64_vs2017_dx11_fx.exe`, which is the Denuvoless version of the executable.

![wise yote channels his inner bob ross](images/ubisoftsmistakes.png "wise yote channels his inner bob ross")
