#!/usr/bin/env python3

import logging
import os
import subprocess
import sys
from pathlib import Path, PurePath
from time import sleep

# Make sure that exactly 5 arguments were passed to the script
arg_count = len(sys.argv[1:])
if arg_count != 5:
    sys.exit(1)

# Parse the script's arguments
root_dir = sys.argv[1]
uid_gid = sys.argv[2]
log_file = sys.argv[3]
watch_file = Path(sys.argv[4])
recursive = sys.argv[5].lower() == "true"

# Setup logging
log_handlers = [logging.FileHandler(log_file, "a")]
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)-8s %(message)s",
    datefmt="%H:%M:%S",
    handlers=log_handlers,
)

# Make sure that we have root privileges
if os.geteuid() != 0:
    logging.info("Please try again with sudo")
    sys.exit(1)

# Loop as long as the watch file exists
while watch_file.exists():
    # Log and chown
    dir_str = PurePath(root_dir).name
    if recursive:
        logging.info(
            f"{watch_file} exists... recursively chown'ing {dir_str} to {uid_gid}"
        )

        if subprocess.call(["chown", "-R", f"{uid_gid}", f"{root_dir}"]) == 0:
            logging.info(f"... succeeded for {dir_str}")
        else:
            logging.info(f"... failed for {dir_str}")
    else:
        logging.info(f"{watch_file} exists... chown'ing {dir_str} to {uid_gid}")

        if subprocess.call(["chown", f"{uid_gid}", f"{root_dir}"]) == 0:
            logging.info(f"... succeeded for {dir_str}")
        else:
            logging.info(f"... failed for {dir_str}")

    # Conditionally sleep
    if watch_file.exists():
        sleep(10)
logging.info(f"{watch_file} does not exist; exiting")
