{pkgs, ...}:
 
{
  services.nix-daemon.enable = true;
 
  users.users.wesl-ee = {
    home = "/Users/wesl-ee";
  };
 
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';


  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
 fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      hack-font
    ];
  };
 
  homebrew = {
    enable = true;
    taps = [
      "hashicorp/tap"
    ];
    casks = [
      "docker"
      "mixxx"
    ];
    brews = [
      "hashicorp/tap/vault"
      "helm"
      "mpd"
      "mpc"
      "ncmpcpp"
      "pinentry-mac"
      "neovide"
    ];
  };
}
