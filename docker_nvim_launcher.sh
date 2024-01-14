#!/bin/bash
if [ "$#" -ne 1 ]; then
  echo "Please pass one direcotry path arg"
  exit 1
fi

SOURCE=$1
TARGET=$(basename "${SOURCE%/}")
docker run -it --mount type=bind,source=${SOURCE},target=/bind/mount/${TARGET} --rm neovim_docker /bind/mount/${TARGET}
