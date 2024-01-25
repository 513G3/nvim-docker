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
RUN apt install -y sudo

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
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs
RUN npm install -g neovim

# Clean up apt
RUN rm -rf /var/lib/apt/lists/*

# Install go
RUN curl -LO https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
RUN rm -fr /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
RUN rm go1.21.6.linux-amd64.tar.gz
RUN ln -sf /usr/local/go/bin/go /usr/local/bin/

# Install stuff via pip3
RUN pip3 install neovim

# Prepare for fonts
RUN mkdir $HOME/.fonts

# Install Ubuntu Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Ubuntu.zip
RUN mkdir temp && mv Ubuntu.zip temp && cd temp && unzip *.zip && mv *.ttf $HOME/.fonts/ && cd .. && rm -fr temp

# Install Ubuntu Mono Nerd Font
RUN curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip
RUN mkdir temp && mv UbuntuMono.zip temp && cd temp && unzip *.zip && mv *.ttf $HOME/.fonts/ && cd .. && rm -fr temp

# Update the font cache
RUN fc-cache -fv

# Install nvim
WORKDIR /root
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
RUN tar xzf nvim-linux64.tar.gz
RUN rm nvim-linux64.tar.gz

# Set entrypoint to configure runtime stuff and invoke nvim
COPY ./launcher.sh /
RUN chmod 755 /launcher.sh
ENTRYPOINT [ "/launcher.sh" ]

# Get custom nvim configuration
RUN mkdir -p $HOME/.local/share/nvim/mason
RUN mkdir -p $HOME/.config
WORKDIR /root/.config
RUN git clone https://github.com/513G3/kickstart-modular.nvim nvim && cd nvim && git checkout v1.01
WORKDIR /root

# Run nvim while online and let it install stuff
# TODO Figure out a good way to couple this line with the `lsp-setup.lua` file in the config repo above
RUN $HOME/nvim-linux64/bin/nvim --headless +"MasonInstall ruff-lsp lua-language-server buf-language-server clangd pyright" +q
