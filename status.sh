#!/bin/bash

function write_connection() {
	local conn="$(curl --max-time 5 --silent --head --fail --output /dev/null --socks5-hostname socks5://127.0.0.1:25344 https://www.github.com || echo ' off')"
	local file="/tmp/wireproxy-connection"
	echo "$conn" > "$file"
}

function read_connection() {
	local file="/tmp/wireproxy-connection"
	if [[ -f "$file" ]]; then
		cat "$file"
	else
		echo " .."
	fi
}

name=$(docker ps --no-trunc --format "json" | jq -r 'select(.Names == "wireproxy").Command' | sed 's/^"\(.*\)"$/\1/')

config=${name##*/}

if [[ -z "$config" ]]; then
	echo "off"
else
	# Test the connection:
	conn=$(read_connection)
	write_connection &

	loc=${config##*-}
	
	if [[ "$loc" == "config" ]]; then
		echo "default$conn"
	else
		echo "$loc$conn"
	fi
fi

