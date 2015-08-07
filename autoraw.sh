#!/bin/bash

# author: Karel Fiala
# email: fiala.karel@gmail.com

profile="default"

raw_files="*.CR2 *.ARW"

all="`ls -1 $raw_files 2>/dev/null | wc -l`"


if [[ ! $# -eq 0 ]]
then
    profile="$1"
fi


printf "\n\n"

num="1"
for photo in `ls -1 $raw_files 2>/dev/null`
do

    printf "Analyzing photo $num/$all\r"
    #info="`exiftool $photo | grep -E "(Camera Model Name|Lens Model)" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    #camera="`echo "$info" | head -n 1`"
    #lens="`echo "$info" | tail -n 1`"
    camera="`exiftool $photo | grep -E "Camera Model Name" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    lens="`exiftool $photo | grep -E "Lens Model" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    
    rp_dir="$( dirname "${BASH_SOURCE[0]}" )/raw-profiles/$camera/$lens"
    
    [[ -d "$rp_dir" ]] || { echo "Can't find right profile for $photo -- $camera, $lens" ; exit 1; }
    [[ -f "$rp_dir/$profile.xmp" ]] || { echo "Can't read profile $rp_dir/$profile.xmp" ; exit 1; }
    
    
    ((num++))

done

printf "Analyzing done              \n"

num="1"

for photo in `ls -1 $raw_files 2>/dev/null`
do

    # check format -- camera model, lens model
    # to use right raw profile
    printf "Processing photo $num/$all\r"
    #info="`exiftool $photo | grep -E "(Camera Model Name|Lens Model)" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    #camera="`echo "$info" | head -n 1`"
    #lens="`echo "$info" | tail -n 1`"
    camera="`exiftool $photo | grep -E "Camera Model Name" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    lens="`exiftool $photo | grep -E "Lens Model" | cut -d":" -f 2 | sed "s/ //g;s/f\/.*//g"`"
    
    rp="$( dirname "${BASH_SOURCE[0]}" )/raw-profiles/$camera/$lens/$profile.xmp"
    
    darktable-cli "$photo" "$rp" "$photo.jpg" --hq 1 &>/dev/null
    
    ((num++))

done

printf "Processing done            \n\n"

exit 0
