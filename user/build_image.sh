#!/bin/bash

TAG=nvim-docker-$USER
GID=$(id -g "$USER")

echo "Building $TAG with UID:GID $UID:$GID"

# Provide ssh and git stuff (best effort)
if [ -d "$HOME/.ssh" ]; then
    cp -r "$HOME/.ssh" .
fi
if [ -f "$HOME/.gitconfig" ]; then
    cp "$HOME/.gitconfig" .
fi

# Build
docker buildx build --no-cache --tag nvim-docker-"$USER" --build-arg _USER="$USER" --build-arg _UID="$UID" --build-arg _GID="$GID" .

# Cleanup
rm -fr .ssh .gitconfig >> /dev/null 2>&1
