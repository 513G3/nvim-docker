#!/bin/bash

# Fix the uid/gid
echo "Setting uid/gid for the docker user in the container so that"
echo "filesystem changes in the container's bind mount map to you"
echo "on the host"
fixuid -q

# Put Google's Golang into the runtime path
export PATH=$PATH:/usr/local/go/bin

# Set $HOME
export HOME=/home/docker

# Run Neovim
~/nvim-linux64/bin/nvim $1
