#!/bin/bash

USER=$1
DIR=/home/$USER/.local/share/nvim

# Find all of the symlinks
declare -A links
while IFS= read -r line; do
    links["$line"]=`readlink $line`
done < <(find $DIR -type l)

# Fix the symlinks that start with /root/
for key in "${!links[@]}"; do
    if [[ ${links[$key]} = "/root/"* ]]; then
        prefer="/home/$USER/`echo ${links[$key]} | cut -d/ -f 3-`"
        rm $key
        ln -s $prefer $key
    fi
done

# Find all of the files with /root/ in them
for file in `find $DIR -type f`; do
    if grep "/root/" $file 2>/dev/null; then
        sed -i "s/\/root\//\/home\/$USER\//g" $file
    fi
done
