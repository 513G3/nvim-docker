#!/usr/bin/env python3

import logging
import os
import shutil
import subprocess
import sys
from pathlib import Path
from pwd import getpwnam
from random import randint
from threading import Thread
from time import sleep

# Setup logging
LOG_DIR = "/tmp/nvim_docker"
Path(LOG_DIR).mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR + "/log.txt"
log_handlers = [logging.FileHandler(LOG_FILE, "a")]
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)-8s %(message)s",
    datefmt="%H:%M:%S",
    handlers=log_handlers,
)
WATCH_DIR = LOG_DIR + "/chown_watch"


def usage():
    print("Usage:")
    print(f"$ sudo -E {__file__} <DIRECTORY_OR_FILE>")


def reset_watch():
    if Path(WATCH_DIR).is_dir():
        shutil.rmtree(WATCH_DIR)
    Path(WATCH_DIR).mkdir(parents=True, exist_ok=True)


def chown(root_dir, uid_gid):
    # Get stuff ready for watching and chown'ing
    reset_watch()

    # Trigger the chown subprocesses
    while True:
        # Make a new watch file
        watch_num = randint(0, sys.maxsize)
        watch_file = WATCH_DIR + os.sep + str(watch_num)
        Path(watch_file).touch()
        logging.info(f"Made watch file {watch_file}")

        # Spawn a subprocess (non-blocking) to chown the root
        subprocess.Popen(
            [
                f"{script_dir}/chown.py",
                str(root_dir),
                uid_gid,
                LOG_FILE,
                watch_file,
                str(False),  # Recursive
            ],
            stdin=None,
            stdout=None,
            stderr=None,
        )

        # Spawn a subprocess (non-blocking) for each directory in the root
        for d in filter(os.path.isdir, os.listdir(root_dir)):
            subprocess.Popen(
                [
                    f"{script_dir}/chown.py",
                    str(d),
                    uid_gid,
                    LOG_FILE,
                    watch_file,
                    str(True),  # Recursive
                ],
                stdin=None,
                stdout=None,
                stderr=None,
            )

        # Sleep for a few minutes and prepare to loop again
        sleep(60 * 2)
        Path(watch_file).unlink()


# Figure out ID stuff
invoker = os.getlogin()
invoker_uid = getpwnam(os.getlogin()).pw_uid
invoker_gid = getpwnam(os.getlogin()).pw_gid
euid = os.getuid()  # Should match os.geteuid() since sudo
script_dir = os.path.dirname(os.path.abspath(__file__))
script_uid = os.stat(__file__).st_uid
script_gid = os.stat(__file__).st_gid

# Make sure that we have root privileges since we are
# planning on changing ownership of files and directories
# made by root
if euid != 0:
    usage()
    sys.exit(1)

# Make sure that exactly one argument was passed to the script
if len(sys.argv[1:]) != 1:
    usage()
    sys.exit(1)

# Make sure that the argument is a file or a directory
path = Path(sys.argv[1])
if not path.is_dir() and not path.is_file():
    usage()
    sys.exit(1)
path = path.absolute()
base = path if path.is_dir() else path.parent.absolute()

# Only operate on paths with sane roots
SANE_ROOTS = [
    "/usr/local/workspace",
    "/local/mnt/workspace",
    f"/home/{os.getlogin()}/workspace",
]
bad_juju = True
for sr in SANE_ROOTS:
    if str(path).startswith(sr):
        bad_juju = False
        break
if bad_juju:
    print("Please choose a different directory or file; it must start with one of:")
    for sr in SANE_ROOTS:
        print(f"* {sr}")
    sys.exit(1)

# Start fixing UID:GID's for files and directories made within the
# container's bind mount
t = Thread(
    target=chown,
    args=(str(base), str(invoker_uid) + ":" + str(invoker_gid)),
    daemon=True,
)
t.start()

# Start nvim in the container with a bind mount
args = [
    "docker",
    "run",
    "--rm",
    "-it",
    "--mount",
    f"type=bind,source={base},target=/bind/mount/{base}",
    "nvim-docker",
    f"/bind/mount/{path}",
]
subprocess.call((args))

# Reset the watch directory
reset_watch()
