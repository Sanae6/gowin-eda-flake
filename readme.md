# Gowin EDA Flake
Unfortunately, QT's Web Engine component segfaults when IDE tries to use it. I tried figuring it out but gave up.
What I needed from the IDE was just the IP Core Generator and project creation, so I ended up using a Windows 11 VM. 
What I'm doing now is running [gowiners](https://github.com/sigma-logic/gowiners) in a dev shell to invoke the toolchain manually,
and I'll flash my bitstreams with [openFPGALoader](https://github.com/trabucayre/openFPGALoader).

## Setup
Gowin's IDE/bin needs to be in a writable folder, so that the license file can be modified.
To set that up, you can run the the setup script in the folder where you want the IDE to live.
You need to pass a license server to the script, formatted like `106.55.34.119:10559`. If you're using Sipeed's FPGAs, their license server can be found [here](https://wiki.sipeed.com/hardware/en/tang/common-doc/get_started/install-the-ide.html#About-the-license).
```bash
nix run github:Sanae6/gowin-eda-flake#setup <license>
```
After that, you need to be in the dev shell to be able to run the tools.
Add `github:Sanae6/gowin-eda-flake` as an input to your flake and pass your nixpkgs to `gowinPackages`.
```nix
with pkgs; mkShell rec {
  name = "gowin";
  LD_LIBRARY_PATH = lib.makeLibraryPath (gowin-eda.gowinPackages pkgs);
};
```
