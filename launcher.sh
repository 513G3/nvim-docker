#!/bin/bash

# Change to the new work directory
if [ -d "$1" ]; then
  DIR="$1"
else
  DIR=$(dirname "$1")
fi
cd "$DIR" || return 1

# Run nvim
~/nvim-linux64/bin/nvim "$1"
