#!/bin/bash
if [ "$#" -ne 1 ]; then
  echo "Please pass the directory you want to work from"
  exit 1
fi

SOURCE=$1
TARGET=$(basename "${SOURCE%/}")
docker run -it --mount type=bind,source=${SOURCE},target=/bind/mount/${TARGET} --rm nvim-docker /bind/mount/${TARGET}
