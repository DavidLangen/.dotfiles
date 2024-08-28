#!/bin/sh

# Touchpad Setup
#xinput | rg Touchpad | sed -r 's#^.+id=([0-9]+).+$#\1#g' | xargs -t -n 1 -I {} sh -x -c "xinput set-prop {} \$(xinput list-props {} | grep 'Tapping Enabled' | grep -i -v default | sed -r 's#^.+\(([0-9]+)\).+\$#\1#g') 1"
#xinput | rg Touchpad | sed -r 's#^.+id=([0-9]+).+$#\1#g' | xargs -t -n 1 -I {} sh -x -c "xinput set-prop {} \$(xinput list-props {} | grep 'Disable While Typing Enabled' | grep -i -v default | sed -r 's#^.+\(([0-9]+)\).+\$#\1#g') 0"
#xinput --map-to-output $(xinput | rg Touchscreen | sed -r 's#^.+id=([0-9]+).+$#\1#g') $(xrandr | rg eDP | sed -r 's#^([^ ]+).+$#\1#g')

# Fallback
#xrandr --output eDP-1 --dpi 100 --primary --scale 1x1 --mode 1920x1080
#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto
autorandr -c
# Export XDG Enviroment Variables
export XDG_DATA_DIRS=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share/applications:$HOME/.local/share/steamApps:/usr/local/share:/usr/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

xsetroot -cursor_name Left_ptr
#Xft.dpi: 100
#stack exec myxmonad
#export DISPLAY=:0
systemctl --user import-environment DISPLAY XAUTHORITY

if which dbus-update-activation-environment >/dev/null 2>&1; then
	dbus-update-activation-environment DISPLAY XAUTHORITY
fi
#systemctl --user start xmonad.service
#i3
systemd-cat --stderr-priority=warning --identifier=xmonad stack exec myxmonad
