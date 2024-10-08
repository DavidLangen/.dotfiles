#!/usr/bin/env bash

location=${1}

set -exu

for MONITOR in $(polybar -m | cut -d: -f1); do
  # Launch bar1 and bar2
  if polybar -m | grep "$MONITOR" | grep -q primary; then
    export TRAY=right
  else
    export TRAY=none
  fi
  export MONITOR
  unitName="polybar-$location@$MONITOR"
  if systemctl --user is-failed -q "$unitName"; then
    systemctl --user reset-failed -q "$unitName"
  elif systemctl --user is-active --quiet "$unitName"; then
    systemctl --user stop "$unitName"
  fi
  systemd-run --user --unit "$unitName" --collect --setenv TRAY --setenv MONITOR --slice "polybar-$location.slice" -- polybar "$location" -c "$HOME/.config/polybar/config.ini"
done
