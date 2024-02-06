#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path


def usage():
    print("Usage:")
    print(f"$ .{__file__} [DIRECTORY_OR_FILE]")


# Make sure that no more than one argument was passed to the script
if len(sys.argv[1:]) > 1:
    usage()
    sys.exit(1)

# If there was an argument, make sure that it is a file or a directory
if len(sys.argv[1:]) == 1:
    path = Path(sys.argv[1])
    if not path.is_dir() and not path.is_file():
        usage()
        sys.exit(1)
    path = path.absolute()
    base = path if path.is_dir() else path.parent.absolute()
else:
    script_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.getcwd()
    base = path

# Start nvim in the container with a bind mount
args = [
    "docker",
    "run",
    "--rm",
    "-it",
    "-e",
    "DISPLAY",
    "-v",
    "/tmp/.X11-unix:/tmp/.X11-unix",
    "--mount",
    f"type=bind,source={base},target=/bind/mount{base}",
    f"nvim-docker-{os.getlogin()}",
    f"/bind/mount{path}",
]
subprocess.call((args))
