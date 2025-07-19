{
  stdenv,
  autoPatchelfHook,
  libsForQt5,
  pkgs,
  lib,
}:
stdenv.mkDerivation {
  name = "gowin-eda-ide";
  src = pkgs.fetchzip {
    url = "https://cdn.gowinsemi.com.cn/Gowin_V1.9.11.03_linux.tar.gz";
    hash = "sha256-ytkfL1Yww4h5DjWUpdVoloHSNLvDA9TzPq/nhiMX6GU=";
    stripRoot = false;
  };

  buildInputs =
    [
      autoPatchelfHook
      libsForQt5.qt5.wrapQtAppsHook
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qtvirtualkeyboard
      libsForQt5.qt5.qtwayland
      libsForQt5.qt5.qtwebengine
    ]
    ++ gowinPackages;

  installPhase = ''
    cp -r $src/IDE $out
  '';
}
