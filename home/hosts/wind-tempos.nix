{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/desktop.nix
    ../../modules/home/mail.nix
  ];

  home.username = "wesl-ee";
  home.homeDirectory = "/home/wesl-ee";

  programs.git.userEmail = "w@wesl.ee";

  xresources.properties = {
    "Xft.dpi" = "162";
  };

  home.stateVersion = "22.05";
}
