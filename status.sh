#!/bin/bash

name=$(docker ps --no-trunc --format "json" | jq -r 'select(.Names == "wireproxy").Command' | sed 's/^"\(.*\)"$/\1/')

config=${name##*/}
if [[ -z "$config" ]]; then
	echo "off"
else
	# Test the connection:
	conn="$(curl --silent --head --fail --output /dev/null --socks5-hostname socks5://127.0.0.1:25344 https://www.github.com || echo ' off')"
	loc=${config##*-}
	
	if [[ "$loc" == "config" ]]; then
		echo "default$conn"
	else
		echo "$loc$conn"
	fi
fi

