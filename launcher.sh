#!/bin/bash

# Fix the uid/gid
echo "Now setting the uid/gid for the docker user in the container"
echo "so that filesystem changes that you make in the container's"
echo "bind mount will map to you on the host"
fixuid -q

# Set $HOME
export HOME=/home/docker

# Run Neovim
~/nvim-linux64/bin/nvim $1
