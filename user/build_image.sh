#!/bin/bash

TAG=nvim-docker-$USER
GID=$(id -g "$USER")

echo "Building $TAG with UID:GID $UID:$GID"

# Provide git-needed stuff for fugitive
cp -r ~/.ssh .
cp ~/.gitconfig .

# Build
docker buildx build --no-cache --tag nvim-docker-"$USER" --build-arg _USER="$USER" --build-arg _UID="$UID" --build-arg _GID="$GID" .

# Cleanup
rm -fr .ssh .gitconfig
