#!/bin/bash

# Set $HOME
export HOME=/home/docker

# Fix the UID:GID
echo "This can take some time... recursively changing the"
echo "UID:GID (and file ownerships) of the docker user in"
echo "the container so that:"
echo "*  You can execute things owned by the docker user"
echo "*  Filesystem changes that you make in the"
echo "   container's bind mount will map back to you"
fixuid -q 

# Run nvim
~/nvim-linux64/bin/nvim $1
