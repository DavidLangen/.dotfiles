# XMonad Config as Stack Project

## Prerequisite

### 1. Stack is installed

There are couple ways to get stack.

- via AUR (Arch): [stack-static](https://aur.archlinux.org/packages/stack-static/)
- via Curl:
```
curl -sSL https://get.haskellstack.org/ | sh
```
- via wget:
```
wget -qO- https://get.haskellstack.org/ | sh
```
- or take a look at [how to on haskellstack.org](https://docs.haskellstack.org/en/stable/README/#how-to-install)

### 2. GHC is installed via stack

To build and install Haskell packages, we need GHC. Simply run
```
stack setup
```
GHC will installed into ``~/.stack``

## How to Setup

### 1. Clone Projects
```
# From inside ~/.xmonad.
git clone "https://github.com/xmonad/xmonad" xmonad-git
git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
git clone "https://github.com/jaor/xmobar" xmobar-git
```

### 2. Build and install everything

Just run:
```
# From inside ~/.xmonad.
stack install
```

You’ll now have two new binaries, ``xmonad`` and ``xmobar``, installed into ``~/.local/bin``

### 3. Adding to PATH

If it doesn’t, make sure that you’ve added ``~/.local/bin`` to your **PATH** by adding it to one of your shell profile files,
such as ``~/.profile`` or (if you only use one shell, e.g. Bash/ZSH) ~/.bash_profile, 
and not to your shell’s configuration file (e.g. ~/.bashrc or ~/.zshrc)

## Updating

Whenever you update your xmonad, xmonad-contrib, or xmobar repositories, just cd ``~/.xmonad`` and run
```
stack install
```
to rebuild and reinstall everything.

NB: If you add a new flag or extra dependencies (in stack.yaml), you may need to run stack clean first.


## Login Managers

If you use a login manager, such as LightDM, then you may need to take some additional steps.
Adding the following File as ``xmonad.desktop`` to ``/usr/share/xsessions``:
```
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Xmonad
Comment=Lightweight X11 tiled window manager written in Haskell
Exec=xmonad
Icon=xmonad
Terminal=false
StartupNotify=false
Categories=Application;
```
