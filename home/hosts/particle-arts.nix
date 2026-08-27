{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/home/base.nix
  ];

  home.username = "wesl-ee";
  home.homeDirectory = "/Users/wesl-ee";

  home.sessionPath = [
    "$HOME/.foundry/bin"
  ];

  programs.zsh.initExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  home.packages = [
    pkgs.fastfetch
    pkgs.lynx
    pkgs.ipfs
    pkgs.kubectl

    # Language servers
    pkgs.nodePackages.typescript-language-server
    pkgs.rust-analyzer-unwrapped
    pkgs.nil

    # tabby
    pkgs.tabby-agent
  ];

  programs.ssh.matchBlocks."divinity" = {
    hostname = "10.0.0.248";
    user = "wesl-ee";
    proxyJump = "xen";
  };

  programs.git.userEmail = "wesley.coakley@magic.link";
  programs.git.signing.key = "361FD33468D04DCE";

  home.stateVersion = "24.05";
}
