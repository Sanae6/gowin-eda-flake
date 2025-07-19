{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    requiredPackages = pkgs:
      with pkgs; [
        libGL
        fontconfig
        libxcrypt-legacy
        zlib
        libuuid
        libpulseaudio
        glib
        dbus
        libusb1
        openssl
        wayland-scanner
        wayland-protocols
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrender
        xorg.libXrandr
        xorg.libXtst
        xorg.libxcb
        xorg.libXau
        xorg.libX11
        libxkbcommon
        alsa-lib
        zlib
        gtk3
        glib
        gdk-pixbuf
        gobject-introspection
        pango
        cairo
        atkmm
        libGL
        expat
        fontconfig
        freetype
        krb5Full.dev
        bzip2
        unixODBC
        libpq
        nss
        nspr
        pkgs.stdenv.cc.cc.lib
        glibc
      ];
  in
    {
      gowinPackages = requiredPackages;
    }
    // flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        gowinPackages = requiredPackages pkgs;
        gowinPackage = pkgs.callPackage ./gowin-eda.nix {
          inherit gowinPackages;
        };
      in
        with pkgs; rec {
          formatter = alejandra;
          packages.setup = writeShellScriptBin "setup.sh" ''
            ${nushell}/bin/nu ${writeText "setup.nu" ''
              def main [license: string] {
                print "Copying IDE to current directory"
                rm -rf ./IDE
                ^cp --no-preserve=ownership -r ${gowinPackage} ./IDE
                chmod ug+w -R ./IDE
                $"[license]\nlic=\"($license)\"" | save -f IDE/bin/gwlicense.ini
                ls -l ./IDE/bin/* | where {|f| ($"./IDE/bin/.($f.name | path basename)-wrapped" | path exists) and ($f.type == "file")} |
                  each {|f| rm $f.name; ln -s ($"./IDE/bin/.($f.name | path basename)-wrapped" | path expand) ($f.name | path expand)}
                print "Done!"
              }
            ''} "$@"
          '';
          packages.gowin = gowinPackage;
          devShells.default = mkShell rec {
            name = "gowin";
            LD_LIBRARY_PATH = lib.makeLibraryPath gowinPackages;
          };
        }
    );
}
