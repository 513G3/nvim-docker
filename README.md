# nvim-docker

### Introduction

This repository holds the files I need to be able to easily move [my Neovim setup](https://github.com/513G3/kickstart-modular.nvim) from one host to another, including to offline hosts.

### Quirks

There are two quirks and both pertain to ownership of files and directories on your host (not in the docker container).

#### UID:GID

Since root is the default user within a docker container, files and directories made with nvim in the container's bind mount will have UID:GID of 0:0 on the host.  I solved this problem by periodically launching a `sudo` process on the host `chown` the contents of the bind mount.  This is why `sudo` is needed in the "Alias" section below.

* I tried [fixuid](https://github.com/boxboat/fixuid) but realized that it caused a ~1 minute startup delay every time the container launches... unacceptable for iterative development.
* I tried [inotify](https://pypi.org/project/inotify/) but the recurisve watch failed for cases like `mkdir -p l/m/n/o/ && touch l/m/n/o/p.txt`.

#### Sane Roots

As a protection mechanism against accidentally running `nvim-docker /` and changing the ownership of the entire filesystem... only paths/files with sane roots are accepted:

* `/usr/local/workspace`
* `/local/mnt/workspace`
* `/home/$USER/workspace`


### Get Build System Dependencies

```sh
sudo apt install docker.io
sudo apt install docker-buildx
```

### Get the Code

```sh
cd <SOMEWHERE>
git clone https://github.com/513G3/nvim-docker
```

### Build the Docker Image

```sh
cd nvim-docker
docker buildx build --tag nvim-docker .
```

### Set an Alias

```sh
echo "alias nvd='sudo -E <SOMEWHERE>/nvim-docker/nvim_docker.py'" >> ~/.bash_aliases
source ~/.bash_aliases
```

### Run Neovim in a Docker Container

```sh
nvim-docker ~/workspace
```

### Archive the Docker Image for Transport to a Different Machine

```sh
docker save -o nvim-docker.tar nvim-docker:latest
``` 

Remember to grab `nvim_docker.py` and `chown.py` too so you can repeat the "Alias" step on the different machine.

### Load the Docker Image Into a Different Machine

```sh
docker load < nvim-docker.tar
``` 
