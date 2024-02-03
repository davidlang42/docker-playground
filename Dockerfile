FROM ubuntu:latest

# install tools
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openssh-server \
		sudo bash nano git curl wget less htop zip unzip gzip jq iputils-ping \
		python3 pip \
		nodejs npm \
		build-essential rustc cargo

# create user
ARG USERNAME=player
RUN useradd -m $USERNAME && adduser $USERNAME sudo && usermod -s /usr/bin/bash $USERNAME

# copy files
COPY --chmod=500 docker_entrypoint.sh /
WORKDIR /home/$USERNAME
COPY --chown=$USERNAME:$USERNAME --chmod=770 run_on_startup.sh .
COPY --chown=$USERNAME:$USERNAME --chmod=660 install_packages .
VOLUME /home/$USERNAME

# configure SSH
RUN mkdir /var/run/sshd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
EXPOSE 22

# run
ENV PLAYER_USERNAME=${USERNAME}
ENTRYPOINT ["/docker_entrypoint.sh"] # requires environment var PLAYER_PASSWORD to be set