#!/bin/bash

# Fix the uid/gid
echo "This can take some time..."
echo ""
echo "... setting the uid/gid for the docker user in the container"
echo "so that filesystem changes made in the container's bind mount"
echo "will map back to ${USER}"
fixuid -q 

# Set $HOME
export HOME=/home/docker

# Run Neovim
~/nvim-linux64/bin/nvim $1
