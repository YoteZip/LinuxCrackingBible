# **Koaloader**

[Koaloader](https://github.com/acidicoala/Koaloader) is nifty tool that lets you arbitrarily inject DLLs into a program at runtime, some of which can auto-defeat DRM. Using Koaloader is one of the harder parts of this guide because it requires some experimentation. You might have noticed that Windows executables usually come with a lot of DLLs scattered around next to them. When a game launches, it dynamically checks for and loads these various DLLs at runtime. Our special trick is that oftentimes games carelessly look for a number of common DLLs that it doesn't ship with, and will load them into itself if it finds them. We're going to exploit this naivety and drop a Koaloader DLL into the game directory disguised as a common DLL. The game will load Koaloader, and Koaloader will then inject any other DLLs that we specify.

Using Koaloader is optional for some DRM techniques. Koaloader can load multiple DLLs at one time, but if you only have one to inject you might be able to get away with renaming that DLL directly as a surrogate instead. This doesn't always work, and some DLLs insist that they have specific names (LumaCEG). Keep your options open and be ready to use Koaloader if the situation calls for it.

# Variants

The main problem to solve when using Koaloader is figuring out which common DLL variant a game will try to load in the first place. There are ways to deterministically figure this out, but process hacking methods are really rough to get working on Linux. In my experience, it's a lot quicker to just dump a bunch of DLLs in and figure out which one is working. Koaloader (currently) comes in the following variants:

  - `audioses.dll`
  - `d3d9.dll`
  - `d3d10.dll`
  - `d3d11.dll`
  - `dinput8.dll`
  - `dwmapi.dll`
  - `dxgi.dll`
  - `glu32.dll`
  - `hid.dll`
  - `iphlpapi.dll`
  - `msasn1.dll`
  - `msimg32.dll`
  - `mswsock.dll`
  - `opengl32.dll`
  - `profapi.dll`
  - `propsys.dll`
  - `textshaping.dll`
  - `version.dll`
  - `winhttp.dll`
  - `winmm.dll`
  - `wldp.dll`
  - `xinput9_1_0.dll`

I've had the most luck with `winmm.dll`, `iphlpapi.dll`, and `winhttp.dll` in that order. `dinput8.dll` is very commonly used in user-created mods, and it's a good target to check also.

# Compatibility Shortlist

Here's a shortlist of some games and the .dlls that they try to reach for (by no means comprehensive):

  - `winmm.dll`
    - Assassin's Creed - Brotherhood
    - Call of Duty - Black Ops
    - Call of Duty - Black Ops 2
    - Call of Duty - Black Ops 3
    - Call of Duty - Infinite Warfare
    - Call of Duty - Modern Warfare Remastered
    - GRID 2
    - Metal Gear Solid V
    - Red Faction - Armageddon
    - Saints Row - The Third
  - `iphlpapi.dll`
    - Mercenaries 2
    - Need for Speed - Prostreet
  - `winhttp.dll`
    - Need for Speed - Shift

# Configuration

**Protip:** After extracting Koaloader to your toolkit, I recommend replacing the contents of its default `Koaloader.config.json` file with the following:
```
{
  "logging": true,
  "enabled": true,
  "auto_load": false,
  "targets": [
    "program32.exe",
    "program64.exe"
  ],
  "modules": [
    {
      "path": "target.dll",
      "required": true
    },
    {
      "path": "C:/users/acidicoala/eucalyptus.dll",
      "required": false
    }
  ]
}
```

This is the default example configuration from Koaloader's github page, and it's a lot easier to see at a glance what is supposed to be put where when you're trying to configure a new injection.

The important options here are `targets` and `modules`:

- When you specify a `target`, you're whitelisting an exe that's allowed to inject Koaloader. For our usecase this security feature doesn't matter much, but it's primarily used to prevent random exes that are also in the folder from trying to load Koaloader as well.

- When you specify a `module`, you're declaring a DLL that you want Koaloader to inject. Relative or absolute paths work here. If you set `required` to `true`, then Koaloader will crash itself if it doesn't find the DLL. I usually leave `required` on because the DLL should always be found, and if it's not there I want to know immediately.

---

**Important:** when using Koaloader with Wine games, you will need to whitelist your chosen DLL as `n,b` in Wine's "DLL Overrides" configuration.

![wise yote respects koalas](images/koalas.png "wise yote respects but fears koalas")