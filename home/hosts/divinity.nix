{ config, lib, pkgs, ... }:
{
  home.file.".config/alacritty/alacritty.yml".text = ''
    font:
      normal:
        family: xterm
      size: 12
    import:
      - ~/.config/alacritty/alacritty-theme/themes/tender.yaml
  '';

}
