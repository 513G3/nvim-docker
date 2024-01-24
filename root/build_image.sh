#!/bin/bash

TAG=nvim-docker-root

echo "Building $TAG with UID:GID 0:0"
cp ../launcher.sh .
docker buildx build --tag $TAG --no-cache .
rm launcher.sh
