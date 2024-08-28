#!/bin/bash

playerctl status 2>/dev/null | grep -qE "Playing|Paused" && playerctl metadata --format "$(if [ -n "$(playerctl metadata artist)" ]; then playerctl metadata --format "{{ artist }} - {{ title }}"; else playerctl metadata --format "{{ title }}"; fi)"
