# **Securom**

Securom is quite an invasive DRM for legitimate players. There have been many controversies involving its malware-like tendencies - it's no surprise that Securom grew up to become Denuvo. It used to be commonly found on retail disc games, but most games have stripped it with the move to Steam et al. These days, you'll usually only find it on games that are sourced from retail disc releases or from games that forgot to take it out when moving to the digital marketplace.

Securom is mildly annoying to defeat, as it requires injecting a DLL into the game's runtime. Our cracking method utilizes an auto-defeat DLL made by virusek and NEOGAME, which can auto defeat Securom versions 7 and 8 (the most common kind). You can find this DLL posted by Christsnatcher on page 54 of the thread "RIN SteamInternals", stickied under cs.rin's `Main Forum` (thread ID `65887`). Download it and add it to your toolkit.

Another tool you may find useful for handling Securom is the "80_PA Universal Securom Keygen". The auto-defeat DLL should be able to handle everything that this can, but the keygen is an almost equally powerful tool. We mostly prefer the DLL because it's stable and can be archived, whereas the keygen needs to generate different keys based on the system you're running it on. There's a [GitHub repo](https://github.com/Blaukovitch/80_PA) available for this keygen with the latest releases attached, but the source code is not available. In order to use the keygen through Wine, you'll need to run `winetricks mfc42` in the prefix that you're launching the tool from. It's worth noting that all releases of this keygen come with what is effectively a complete technical manual to how Securom breaking works - just in case you're wild enough to write your own open-source version.

# Cracking Guide

For our walkthrough we'll be cracking the Securom DRM on Fable III. This game is easy to source via cs.rin's Main Forum (thread ID `59454`), or you can follow along with your own Securom-protected game. Fable III is infested with DRM - it contains Steamworks API, Securom, and GFWL.

1. Source Fable III and extract it to your workspace

2. [`Fable III ONLY`] Winetricks `xact` is required for Fable III to run, otherwise it will crash after intro videos

3. [`Fable III ONLY`] Defeat [Steamworks API](../Steamworks-API/defeating_steamworks.md) protection (remember that this is a DirectX9 game, so if you use Goldberg Experimental build you need to disable the overlay or it may crash on Linux)

4. [`Fable III ONLY`] Defeat [GFWL](../GFWL/defeating_gfwl.md) protection (we crack Fable III in the GFWL guide as well)

5. The auto-defeat DLL doesn't require any configuration, so the only real step is copying our Securom auto-defeat DLL into the game directory, making sure it's named `iphlpapi.dll`. This DLL name should work for almost all games, but if you find that a game isn't pulling that DLL name in, you'll have to manually inject it through [Koaloader](../../Tools/Koaloader/koaloader.md) (the [CEG guide](../CEG/defeating_ceg.md) uses Koaloader as an example).

6. We're almost ready, but since we're using Wine, we need to tell Wine to leave our DLL alone. By default, Wine hijacks some DLLs that load and replaces them with its own versions at runtime. We're going to explicitly tell Wine that if it sees our DLL, it should let it load without interfering. If it doesn't see the DLL we specify, then it will try to load its own DLL as normal.

7. We can inform Wine of this configuration by using Lutris. If you use another tool, there should be a section somewhere for this, or worst-case you can use the `WINEDLLOVERRIDES` environment variable. To do this in Lutris, open your game's configuration and navigate to `Runner Options` -> `DLL Overrides`. Input `iphlpapi` as a key and `n,b` as a value. `n,b` stands for "Native, then Built-in", aka Wine should preferentially let the game's local DLL load if available, or fallback to the Built-in Wine version if it's not.

    ![Fable III iphlpapi DLL Override](images/Fable3-iphlpapi-Override.png "iphlpapi DLL override")

8.  Securom is now defeated!

![wise yote used to be troubled pup too](images/securom.png "wise yote used to be a troubled pup too")
