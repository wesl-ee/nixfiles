nixfiles
========

These files dictate the configuration of each NixOS computer I have.

### ekowraith

Microsoft Surface Pro (5th Gen) 128GiB i5 4GiB

<figure align="center">
  <img src="/doc/img/ekowraith.jpeg">
</figure>

### air2earth

Microsoft Surface Laptop Go 128GiB i5 8GiB

### wind-tempos

Acer Swift 3

### wonder-pop

Thinkpad x61 tablet

---

Typical Setup for a New Machine
-------------------------------

```
# D/L repos that define configuration
git clone git@github.com:wesl-ee/nixfiles.git
git clone git@github.com:wesl-ee/awesome-wm-config.git

# For managing passwords with pass + my YubiKey
git clone w@gyw.wesl.ee:.password-store
```

Then:

```
mkdir -p ~/.config
mkdir -p ~/img/screenshot

ln -s ~/nixfiles/bin ~/bin

mkdir -p "awesome-wm-config/themes/$(hostname)"
touch "awesome-wm-config/themes/$(hostname)/theme.lua"
ln -s ~/awesome-wm-config .config/awesome
```

Add a host module for the new machine at `hosts/<hostname>.nix` by
copying the generated `/etc/nixos/hardware-configuration.nix`
and a home-manager module at `home/hosts/<hostname>.nix` (import
`modules/home/base.nix` plus `desktop`/`workstation`/`mail` of your choosing
then wire the hostname into `flake.nix`'s `nixosConfigurations` or
`darwinConfigurations` on macOS.

Then build / switch:

```
# nixos
sudo nixos-rebuild switch --flake .#<hostname>

# macOS
darwin-rebuild switch --flake .#<hostname>
```

License
-------

MIT License (available under /LICENSE)
