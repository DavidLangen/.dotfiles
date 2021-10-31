#!/bin/bash
export LOCATION=$(cat ~/location/raw.json | grep city |awk '{print $3}' | tr -dc '[:alnum:]\n\r')

if [ "$LOCATION" == "Troisdorf" ] || [ "$LOCATION" == "Mulheim" ]
then
  export LOCATION="Bielefeld"
fi

if [ "$1" != "" ]
then
  curl -s "wttr.in/{$1}?format=4"
elif [ "$LOCATION" != "" ]
then
  curl -s "wttr.in/{$LOCATION}?format=4"
else
  curl -s "wttr.in?format=4" 
fi

