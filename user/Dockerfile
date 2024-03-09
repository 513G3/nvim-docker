FROM nvim-docker-root

ENV DEBIAN_FRONTEND=noninteractive

# Grab the arguments
ARG _USER
ARG _UID
ARG _GID

# Create a non-root user and group
RUN addgroup --gid $_GID $_USER
RUN adduser --uid $_UID --ingroup $_USER --home /home/$_USER --shell /bin/bash --disabled-password --gecos "" $_USER

# Copy stuff from the root user in the base docker image
RUN cp -r /root/.fonts /home/$_USER/
RUN mkdir -p /home/$_USER/.config
RUN cp -r /root/.config/nvim /home/$_USER/.config/nvim
RUN mkdir -p /home/$_USER/.local/share
RUN cp -r /root/.local/share/nvim /home/$_USER/.local/share/nvim
RUN cp -r /root/nvim-linux64 /home/$_USER/

# Copy in ssh stuff (best effort via glob)
RUN mkdir -p /home/$_USER/.ssh
RUN chmod 700 /home/$_USER/.ssh
COPY .ssh/id_rs[a] /home/$_USER/.ssh/
COPY .ssh/id_rsa.pu[b] /home/$_USER/.ssh/
COPY .ssh/known_host[s] /home/$_USER/.ssh/
COPY ssh_config /home/$_USER/.ssh/config

# Copy in git config (best effort via glob)
COPY .gitconfi[g] /home/$_USER/

# Fix ownership
RUN chown -R $_UID:$_GID /home/$_USER

# Copy in script to fix stuff
COPY fixer.sh /
RUN chmod 755 /fixer.sh

# Switch to the non-root user
USER $_USER:$_USER
WORKDIR /home/$_USER

# Update the font cache
RUN fc-cache -fv

# Fix symlinks and file content that point to /root/
RUN /fixer.sh $_USER
