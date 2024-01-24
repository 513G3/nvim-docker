#/bin/bash

# Root image
cd root
./build_image.sh
cd ..

# User image
cd user
./build_image.sh
cd ..
