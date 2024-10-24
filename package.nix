{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "xmcl";
  version = "0.47.10";
  src = fetchurl {
    url = "https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${version}/xmcl-${version}-x86_64.AppImage";
    hash = "sha256-6nEzjokcb4y7/etKiXPmgFO8VgRGk+lIQkaDszaAaRI=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };
  meta = with lib; {
    description = "An Open Source Minecraft Launcher with Modern UX.";
    homepage = "https://xmcl.app";
    license = licenses.mit;
    mainProgram = "xmcl";

    platforms = [ "x86_64-linux" ];
  };
in
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
