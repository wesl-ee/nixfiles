{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/home/base.nix
    ../../modules/home/desktop.nix
    ../../modules/home/workstation.nix
    ../../modules/home/mail.nix
  ];

  home.username = "wesl-ee";
  home.homeDirectory = "/home/wesl-ee";

  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.foundry/bin"
    "$HOME/.local/bin"
  ];

  programs.git.userEmail = "w@wesl.ee";

  home.stateVersion = "22.05";
}
