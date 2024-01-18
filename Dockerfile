FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Grab the man pages
RUN yes | unminimize

# Install general stuff via apt
RUN apt update -y
RUN apt install -y apt-utils
RUN apt install -y man
RUN apt install -y man-db
RUN apt install -y bash-builtins
RUN apt install -y curl
RUN apt install -y file
RUN apt install -y fontconfig
RUN apt install -y git
RUN apt install -y locales
RUN apt install -y lsb-release
RUN apt install -y ripgrep

# Install nvim stuff via apt
RUN apt install -y cargo
RUN apt install -y composer
RUN apt install -y fd-find
RUN apt install -y lua5.1
RUN apt install -y luarocks
RUN apt install -y openjdk-11-jre
RUN apt install -y python3-pip
RUN apt install -y python3-venv
RUN apt install -y ruby
RUN apt install -y xclip

# Install node-specific stuff
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs
RUN npm install -g neovim

# Clean up apt
RUN rm -rf /var/lib/apt/lists/*

# Install go
RUN curl -LO https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
RUN rm -fr /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
RUN rm go1.21.6.linux-amd64.tar.gz

# Set entrypoint to configure runtime stuff and invoke nvim
COPY ./launcher.sh /
RUN chmod 755 /launcher.sh
ENTRYPOINT [ "/launcher.sh" ]

# Create a docker user and group (for fixuid shenanigans)
RUN addgroup --gid 1111 docker && adduser --uid 1111 --ingroup docker --home /home/docker --shell /bin/bash --disabled-password --gecos "" docker

# Install fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.6.0/fixuid-0.6.0-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n  - /home/docker" > /etc/fixuid/config.yml

# Switch to the docker user
USER docker:docker

# Install stuff via pip3
RUN pip3 install neovim

# Change to the docker user's home directory
WORKDIR /home/docker

# Prepare for fonts
RUN mkdir .fonts

# Install Ubuntu Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Ubuntu.zip
RUN mkdir temp && mv Ubuntu.zip temp && cd temp && unzip *.zip && mv *.ttf ~/.fonts/ && cd .. && rm -fr temp

# Install Ubuntu Mono Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip
RUN mkdir temp && mv UbuntuMono.zip temp && cd temp && unzip *.zip && mv *.ttf ~/.fonts/ && cd .. && rm -fr temp

# Update the font cache
RUN fc-cache -fv

# Install nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
RUN tar xzf nvim-linux64.tar.gz
RUN rm nvim-linux64.tar.gz

# Get custom nvim configuration
RUN mkdir -p .local/share/nvim/mason
RUN mkdir .config
WORKDIR .config
RUN git clone https://github.com/513G3/kickstart-modular.nvim nvim && cd nvim && git checkout v1.00
WORKDIR /home/docker

# Run nvim while online and let lazy and mason install stuff
RUN /home/docker/nvim-linux64/bin/nvim & sleep 20 && killall nvim
