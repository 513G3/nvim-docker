# nvim-docker

### Introduction

This repository holds the files I need to be able to easily move [my Neovim setup](https://github.com/513G3/kickstart-modular.nvim) from one host to another, including to offline hosts.

### Get Build System Dependencies

```sh
$ sudo apt install docker.io
$ sudo apt install docker-buildx
```

### Get the Code  

```sh
$ cd <SOMEWHERE>
$ git clone https://github.com/513G3/nvim-docker
```

### Build the Docker Container

```sh
$ cd nvim-docker
$ docker buildx build --tag nvim-docker .
```

### Set an Alias

```sh
$ tail -1 ~/.bash_aliases 
alias nvim-docker='<SOMEWHERE>/nvim-docker/nvim_docker.sh'
```

### Run Neovim in the Docker Container

```sh
$ nvim-docker ~/workspace
```
