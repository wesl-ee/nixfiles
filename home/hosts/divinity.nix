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

  home.file."img/wp/bafkreif5hz3cqgzjm7onbuhzug5c2ltfitghdlvswfghwcppxi4ixdxuvu".source = builtins.fetchurl {
    url = "https://web.hooya.wesl.ee/cid-content/bafkreif5hz3cqgzjm7onbuhzug5c2ltfitghdlvswfghwcppxi4ixdxuvu";
    sha256 = "1bglis5kifpg15xlrcdjmrqwqi355qnvm8grs38dqrr93cl7cgmx";
  };

  home.stateVersion = "22.05";
}
