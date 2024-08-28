#!/bin/bash

zscroll --before-text "♪ x" --delay 0.3 -l 30 \
	--match-command "echo 'Playing'" \
	--match-text "No" "--before-text '♪ Offline' " \
	--match-text "Playing" "--before-text ' ' " \
	--match-text "Paused" "--before-text ' ' --scroll 0" \
	--match-text "Stopped" "--before-text 'Offline'" \
	--update-check true '/home/david/scripts/playerscript_actions.sh' &
wait
