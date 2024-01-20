# nvim-docker

### Introduction

This repository holds the files I need to be able to easily move [my Neovim setup](https://github.com/513G3/kickstart-modular.nvim) from one host to another, including to offline hosts.

### Quirks

There are two quirks and both pertain to ownership of files and directories on your host (not in the docker container).

#### UID:GID

Since root is the default user within a docker container and since I need to be able to bind mount a local directory/workspace with my development files into the docker container, an issue arises.  Files and directories made with nvim in the container's bind mount will have UID:GID of 0:0 on the host.  I tried several approaches to overcome this.  First, I leveraged [fixuid](https://github.com/boxboat/fixuid) but realized that it caused a ~1 minute startup delay every time the container launches... unacceptable for me since I launch the container many times over the course of a development day.  I then leveraged Python's [inotify](https://pypi.org/project/inotify/) but the recurisve watch failed for cases like `mkdir -p l/m/n/o/ && touch l/m/n/o/p.txt` (this was indeed called out on the PyPi site).  Finally, I went with the solution here... have a `sudo` process on the host periodically chown the contents of the bind mount... this is why `sudo` is needed in the "Alias" section below.

#### Sane Roots

As a protection mechanism against accidentally running `nvim-docker /` and changing the ownership of your entire filesystem... only paths/files with sane roots are accepted:

* `/usr/local/workspace`
* `/local/mnt/workspace`
* `/home/$USER`


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
echo "alias nvim-docker='sudo -E <SOMEWHERE>/nvim-docker/nvim_docker.py'" >> ~/.bash_aliases
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
