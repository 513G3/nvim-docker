#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Please pass the directory you want to bind mount into the container"
  exit 1
fi

SOURCE=$1
TARGET=$(basename "${SOURCE%/}")
ID=$(id -u $USER)
GID=$(id -g $USER)
docker run --rm -it --mount type=bind,source=${SOURCE},target=/bind/mount/${TARGET} -u ${ID}:${GID} nvim-docker /bind/mount/${TARGET}
