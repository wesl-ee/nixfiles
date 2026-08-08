# Heavy GUI/creative/RE tooling - divinity only.
{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.inkscape
    pkgs.deluge
    pkgs.virt-manager
    pkgs.maxima
    pkgs.gyroflow

    # Multimedia
    pkgs.gimp

    # DJ shit
    pkgs.mixxx
    pkgs.nicotine-plus

    pkgs.kubectl

    # Cryptoshit
    pkgs.monero-gui

    pkgs.dolphin-emu
    pkgs.wineWowPackages.stable
    pkgs.winetricks
    pkgs.ghidra
    pkgs.hexedit

    (pkgs.writeShellScriptBin "codex" ''
      exec ${pkgs.nodejs}/bin/npx -y @openai/codex@latest "$@"
    '')
  ];
}
