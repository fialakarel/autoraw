#!/bin/bash

# author: Karel Fiala
# email: fiala.karel@gmail.com

rp_canon_1100d_18_55="$( dirname "${BASH_SOURCE[0]}" )/raw-profiles/rp_canon_1100d_18_55.xmp"

printf "\n\n"

all="`ls -1 *.CR2 | wc -l`"
num="1"

for photo in `ls -1 *.CR2`
do

    # check format -- camera model, lens model
    # to use right raw profile
    rp="$rp_canon_1100d_18_55"
    
    printf "Processing photo $num/$all\r"
    darktable-cli "$photo" "$rp" "$photo.jpg" --hq 1 &>/dev/null
    
    ((num++))

done

printf "Processing done.\n\n"

exit 0
