FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Install stuff via apt
RUN apt update -y
RUN apt install -y npm
RUN apt install -y ripgrep
RUN apt install -y fd-find
RUN apt install -y python3-pip
RUN apt install -y python3-venv
RUN apt install -y cargo
RUN apt install -y composer
RUN apt install -y nodejs
RUN apt install -y lua5.1
RUN apt install -y luarocks
RUN apt install -y curl
RUN apt install -y git
RUN rm -rf /var/lib/apt/lists/*

# Install stuff via npm
RUN npm install -g neovim

# Install stuff via pip3
RUN pip3 install neovim

# Change to home directory
WORKDIR /root

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

# Install go
RUN curl -LO https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
RUN rm -fr /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
# NOTE that the $PATH gets updated in nvim_launcher.sh instead

# Install nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
RUN tar xzf nvim-linux64.tar.gz
RUN ln -sf ~/nvim-linux64/bin/nvim /usr/bin/

# Get custom nvim configuration
RUN mkdir -p .local/share
RUN mkdir .config
WORKDIR .config
RUN git clone https://github.com/513G3/kickstart-modular.nvim nvim

# Change to home directory
WORKDIR /root

# Run nvim while online and let lazy and mason install stuff
RUN nvim & sleep 20 && killall nvim

# Get bash to invoke nvim via nvim_launcher.sh
COPY ./nvim_launcher.sh /
RUN chmod 755 /nvim_launcher.sh
ENTRYPOINT [ "/nvim_launcher.sh" ]
