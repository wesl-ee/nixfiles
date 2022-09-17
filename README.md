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

Follow the [NixOS manual](https://nixos.org/manual/nixos/stable/index.html#ch-installation)
to install NixOS. Next sign-in with the user created during installation and clone these
repositories:

```
# D/L repos that define configuration
git clone git@github.com:wesl-ee/nixfiles.git
git clone git@github.com:wesl-ee/awesome-wm-config.git

# For managing passwords with pass + my YubiKey
git clone w@gyw.wesl.ee:.password-store

```

Now copy the configuration files derived during install and add them to this repo:

```
# Mirror system configuration to this repo
mkdir -p "nixfiles/hosts/$(hostname)"
cp /etc/nixos/{configuration.nix,hardware-configuration.nix} "nixfiles/hosts/$(hostname)"
sudo ln -sf "`pwd`/nixfiles/hosts/`hostname`/{configuration.nix,hardware-configuration.nix}" /etc/nixos/
```

Now set up the user's awesomewm configuration and manage everything with home-manager:

```
# Configure awesomewm
# Misc directories
mkdir -p ~/.config
mkdir -p ~/img/screenshot

mkdir -p "awesome-wm-config/themes/$(hostname)"
touch "awesome-wm-config/themes/$(hostname)/theme.lua"
ln -s ~/awesome-wm-config .config/awesome

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Initial home-manager profile
ln -s ~/nixfiles/home ~/.config/nixpkgs
home-manager switch
```

A restart now should yield my normal desktop experience.

License
-------

MIT License (available under /LICENSE)
