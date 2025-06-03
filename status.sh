#!/bin/bash

name=$(docker ps --no-trunc --format "json" | jq -r 'select(.Names == "wireproxy").Command' | sed 's/^"\(.*\)"$/\1/')

config=${name##*/}
if [[ -z "$config" ]]; then
	echo "off"
else
	loc=${config##*-}
	if [[ "$loc" == "config" ]]; then
		echo "default"
	else
		echo "$loc"
	fi
fi

