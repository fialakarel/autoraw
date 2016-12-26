#!/bin/bash

set -veufo pipefail

# for each photo
for f in $(ls -1 | grep ".*\.jpg$")
do
	# get maker
	maker=$(exiftool $f | grep "Make" | cut -d":" -f 2 | grep -o "[a-zA-Z]*")

	
	if [ "$maker" == "Canon" ]
	then
		# shift time for my photos
		echo "$f - Canon - shifting +01:03:27"
		exiftool "-AllDates+=01:03:27" $f &>/dev/null

	elif [ "$maker" == "SONY" ]
	then
		# shift time for dad's photos
		echo "$f - SONY - shifting -01:00:08"
		exiftool "-AllDates-=01:00:08" $f &>/dev/null

	else
		# Errors
		echo "Failed to recognize ..."
	fi

done

# delete backups from exiftool
rm *.jpg_original

echo "Hard work done ..."

