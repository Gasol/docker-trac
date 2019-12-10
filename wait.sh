#!/bin/sh

port="$1"
host="${2:-localhost}"
attempts="${3:-5}"

fails=0
count=1

while ! nc -w 1 -z "$host" "$port"; do
	count=$((count+1))
	printf .
	if [ "$count" -gt "$attempts" ]; then
		fails=1
		break
	fi
	sleep 1
done

if [ $fails -eq 1 ]; then
	message="Failed to connect $host:$port"
else
	message="$host:$port is up and running"
fi

echo "$message"
