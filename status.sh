#!/bin/bash

function read_connection() {
	local name=$(docker ps --no-trunc --format "json" | jq -r 'select(.Names == "wireproxy").Command' | sed 's/^"\(.*\)"$/\1/')

	local config=${name##*/}

	if [[ -z "$config" ]]; then
		echo "off"
	else
		# Test the connection:
		local conn="$(curl --max-time 5 --silent --head --fail --output /dev/null --socks5-hostname socks5://127.0.0.1:25344 https://www.github.com || echo ' off')"

		loc=${config##*-}
		
		if [[ "$loc" == "config" ]]; then
			echo "default$conn"
		else
			echo "$loc$conn"
		fi
	fi
}

echo ".."

while [[ true ]]; do
	SECONDS=0
	read_connection
	time_elapsed=$SECONDS

	# if time elapsed is less than 5 seconds, sleep for the remaining time
	if [[ $time_elapsed -lt 5 ]]; then
		sleep $((5 - time_elapsed))
	fi
done


