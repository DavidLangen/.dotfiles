rofi_command="rofi -theme $HOME/.config/rofi/applets/custom.rasi"

terminal=""
files=""
editor=""
browser=""
music=""
settings=""

options="$terminal\n$files\n$editor\n$browser\n$music\n$settings"

chosen="$(echo -e "$options" | $rofi_command -p "Most Used" -dmenu -selected-row 0)"
case $chosen in
    $terminal)
		alacritty &
        ;;
    $files)
		ranger &
        ;;
    $editor)
		code &
        ;;
    $browser)
		firefox &
        ;;
    $music)
    	spotify &
        ;;
    $settings)
		code ~/.config/i3/config &
        ;;
esac
