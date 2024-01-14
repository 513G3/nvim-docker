#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Please pass the directory you want to bind mount into the container"
  exit 1
fi

SOURCE=$1
TARGET=$(basename "${SOURCE%/}")
ID=$(id -u $USER)
GID=$(id -g $USER)
docker run -it --mount type=bind,source=${SOURCE},target=/bind/mount/${TARGET} -u ${ID}:${GID} --rm nvim-docker /bind/mount/${TARGET}
