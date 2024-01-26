#!/bin/bash

TAG=nvim-docker-$USER
GID=$(id -g "$USER")

echo "Building $TAG with UID:GID $UID:$GID" 
cp ../launcher.sh .
docker buildx build --tag nvim-docker-$USER --build-arg _USER=$USER --build-arg _UID=$UID --build-arg _GID=$GID --no-cache .
rm launcher.sh
