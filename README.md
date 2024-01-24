# nvim-docker

## Introduction

This repository holds the files I need to be able to easily move [my Neovim setup](https://github.com/513G3/kickstart-modular.nvim) from one host to another, including to offline hosts.

The steps below describe how to build the `nvim-docker-root` image (which you will not run) on an Internet-connected host and then describe how to build the `nvim-docker-$USER` image (which you will run) on any host.

## Get Build System Dependencies

You must do this step on the Internet-connected host that you will build `nvim-docker-root` on.

If you will build and run `nvim-docker-$USER` on an offline host, repeat these steps there too.

```sh
sudo apt install docker.io
sudo apt install docker-buildx
```

## Get the Code 

You must do this step on the Internet-connected host that you will build `nvim-docker-root` on.

```sh
cd <SOMEWHERE>
git clone https://github.com/513G3/nvim-docker
```

## Build

Choose one option.

### Build Everything for Local User and Usage

This option is for instances where you want to run `nvd` locally with the current user.

```sh
cd nvim-docker
./build_all.sh
```

### Build In Discrete Steps for Offline Usage

This option is for instances where you want to run `nvd` on an offline host.

Build the `nvim-docker-root` image.

```sh
cd nvim-docker/root
./build_image.sh
```

Archive the `nvim-docker-root` image.

```sh
docker save -o nvim-docker-root.tar nvim-docker-root:latest
``` 

Transport the following files to the offline host.

* `nvim-docker-root.tar`
* The files in this repository

Load `nvim-docker-root` into the offline host.

```sh
docker load < nvim-docker-root.tar
``` 

Build the `nvim-docker-$USER` image.

```sh
cd nvim-docker/user
./build_image.sh
```

## Set an Alias

On the machine with the `nvim-docker-$USER` image, make an alias.

```sh
echo "alias nvd='<SOMEWHERE>/nvim-docker/nvd.py'" >> ~/.bash_aliases
source ~/.bash_aliases
```

### Run Neovim in a Docker Container

```sh
nvd ~/workspace
```
