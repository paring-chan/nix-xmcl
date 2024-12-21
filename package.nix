{
  stdenv,
  fetchurl,
  lib,
  electron_33,
  bash,
  makeDesktopItem
}:
let
  pname = "xmcl";
  version = "0.48.1";
  src = fetchurl {
    url = "https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${version}/xmcl-${version}-x64.tar.xz";
    hash = "sha256-y/Nx02ZO9V9wBJaZf5GDvPDInm2Ifxh9boZ7U9K4adY=";
  };
  # appimageContents = appimageTools.extractType2 { inherit pname src version; };
  meta = with lib; {
    description = "An Open Source Minecraft Launcher with Modern UX.";
    homepage = "https://xmcl.app";
    license = licenses.mit;
    mainProgram = "xmcl";

    platforms = [ "x86_64-linux" ];
  };
  desktopEntry = makeDesktopItem {
    name = "xmcl";
    desktopName = "X Minecraft Launcher";
    exec = "xmcl %f";
    terminal = false;
  };
in
stdenv.mkDerivation {
  inherit src pname version;
  buildInputs = [
    electron_33
  ];

  installPhase = ''
    mkdir -p $out/etc/xmcl
    mkdir -p $out/share/applications
    cp resources/app.asar $out/etc/xmcl/app.asar
    mkdir -p $out/bin
    echo '#!${bash}/bin/bash' > $out/bin/xmcl
    echo "${electron_33}/bin/electron $out/etc/xmcl/app.asar \$@" >> $out/bin/xmcl
    cp ${desktopEntry}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
    chmod +x $out/bin/xmcl
  '';
}
/*
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=xmcl'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }
*/
