#!/bin/bash
currentPlayerName=$(exec playerctl metadata --format "{{playerName}}" 2>/dev/null)
playerIcon=""

if grep -q "youtube" <<<"$currentPlayerName"; then
	playerIcon=""
elif grep -q "kdeconnect" <<<"$currentPlayerName"; then
	playerIcon=""
elif grep -q "chrom" <<<"$currentPlayerName"; then
	playerIcon=""
else
	playerIcon=''
fi
echo $playerIcon
