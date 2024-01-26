#!/bin/bash

# Root image
(
  cd root
  ./build_image.sh
)

# User image
(
  cd user
  ./build_image.sh
)
