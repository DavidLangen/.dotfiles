#!/bin/bash

currentKernel="$(uname -r)"
searchWord="linux"

if [[ "$currentKernel" == *"zen"* ]]; then
	searchWord="linux-zen"
fi

current_version="$(echo $currentKernel | grep -Eo '([0-9].[0-9].[0-9])+')"
latest_version="$(paru -Q $searchWord | awk '{print $2}' | grep -Eo '([0-9].[0-9].[0-9])+')"

if [ "$current_version" == "$latest_version" ]; then
	echo " $currentKernel"
else
	echo " $currentKernel (%{F#00ff00}$latest_version%{F-})"
fi
