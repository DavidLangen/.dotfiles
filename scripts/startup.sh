#!/bin/bash

~/.config/polybar/launch.sh &
pkill picom; picom --config="$HOME/.config/picom/config.conf" &
feh --bg-scale ~/.bg/background
