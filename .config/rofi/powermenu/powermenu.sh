theme="custom.rasi"
dir="$HOME/.config/rofi/powermenu/"

rofi_command="rofi -theme $dir$theme"

# Options
shutdown=""
reboot="凌"
logout=""

options="$shutdown\n$reboot\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
    	systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $logout)
		killall xmonad
        ;;
esac
