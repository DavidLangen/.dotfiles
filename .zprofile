if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  #exec $HOME/.local/bin/wrappedhl.sh
	exec startx
fi
