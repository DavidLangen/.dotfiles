dbus-update-activation-environment --systemd --all

# Touchpad Setup
xinput | rg Touchpad | sed -r 's#^.+id=([0-9]+).+$#\1#g' | xargs -t -n 1 -I {} sh -x -c "xinput set-prop {} \$(xinput list-props {} | grep 'Tapping Enabled' | grep -i -v default | sed -r 's#^.+\(([0-9]+)\).+\$#\1#g') 1"
xinput | rg Touchpad | sed -r 's#^.+id=([0-9]+).+$#\1#g' | xargs -t -n 1 -I {} sh -x -c "xinput set-prop {} \$(xinput list-props {} | grep 'Disable While Typing Enabled' | grep -i -v default | sed -r 's#^.+\(([0-9]+)\).+\$#\1#g') 0"
xinput --map-to-output $(xinput | rg Touchscreen | sed -r 's#^.+id=([0-9]+).+$#\1#g') $(xrandr | rg eDP | sed -r 's#^([^ ]+).+$#\1#g')

# Fallback
xrandr --output eDP1 --dpi 92 --primary --scale 1x1 --mode 1920x1080

# Export XDG Enviroment Variables
export XDG_DATA_DIRS=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share/applications:$HOME/.local/share/steamApps:/usr/local/share:/usr/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

xset -r rate 250

# start i3
$HOME/.local/bin/xmonad 
#i3
