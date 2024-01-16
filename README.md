# nvim-docker

### Introduction

This repository holds the files I need to be able to easily move [my Neovim setup](https://github.com/513G3/kickstart-modular.nvim) from one host to another, including to offline hosts.

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
echo "alias nvim-docker='<SOMEWHERE>/nvim-docker/nvim_docker.sh'" >> ~/.bash_aliases
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

Remember to grab `nvim_docker.sh` too so you can repeat the `alias` step on the different machine.

### Load the Docker Image Into a Different Machine

```sh
docker load < nvim-docker.tar
``` 
