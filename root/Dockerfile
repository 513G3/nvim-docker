FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Grab the man pages
RUN yes | unminimize

# Install apt packages
RUN apt update && \
    apt install -y \
    apt-utils \
    bash-builtins \
    cargo \
    composer \
    curl \
    fd-find \
    file \
    fontconfig \
    git \
    libssl-dev \
    libusb-dev \
    locales \
    lsb-release \
    lua5.1 \
    luarocks \
    man \
    man-db \
    mlocate \
    openjdk-11-jre \
    openssl \
    python3-pip \
    python3-venv \
    ripgrep \
    ruby \
    sudo \
    xclip && \
    rm -rf /var/lib/apt/lists/*

# Install node-specific stuff
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs && npm install -g neovim

# Install go
RUN curl -LO https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
RUN rm -fr /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
RUN rm go1.21.6.linux-amd64.tar.gz
RUN ln -sf /usr/local/go/bin/go /usr/local/bin/

# Install stuff via pip3
RUN pip3 install \
    neovim \
    psutil \
    pycryptodome

# Prepare for fonts
RUN mkdir $HOME/.fonts

# Install Ubuntu Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Ubuntu.zip && \
  mkdir temp && mv Ubuntu.zip temp && cd temp && unzip *.zip && \
  mv *.ttf $HOME/.fonts/ && cd .. && rm -fr temp

# Install Ubuntu Mono Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip && \
  mkdir temp && mv UbuntuMono.zip temp && cd temp && unzip *.zip && \
  mv *.ttf $HOME/.fonts/ && cd .. && rm -fr temp

# Update the font cache
RUN fc-cache -fv

# Install nvim
WORKDIR /root
RUN curl \
  -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz && \
  tar xzf nvim-linux64.tar.gz && \
  rm nvim-linux64.tar.gz

# Set entrypoint to configure runtime stuff and invoke nvim
COPY ./launcher.sh /
RUN chmod 755 /launcher.sh
ENTRYPOINT [ "/launcher.sh" ]

# Get custom nvim configuration
RUN mkdir -p $HOME/.local/share/nvim/mason
RUN mkdir -p $HOME/.config
WORKDIR /root/.config
RUN git clone https://github.com/513G3/kickstart-modular.nvim nvim && cd nvim && git checkout v1.31
RUN rm -r ./nvim/.git
WORKDIR /root

# Run nvim while online and let it install stuff
# TODO Figure out a good way to couple this line with the `lsp-setup.lua` and
# `mason-tool-installer.lua` files in the config repo above
RUN $HOME/nvim-linux64/bin/nvim --headless +"MasonInstall bash-language-server  shellcheck checkmake ruff-lsp json-lsp lua-language-server shfmt stylua buf buf-language-server protolint clangd cpplint pyright isort" +qa
RUN $HOME/nvim-linux64/bin/nvim --headless +"Lazy! sync" +qa
