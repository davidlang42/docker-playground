FROM ubuntu:latest

# install tools
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		openssh-server \
		sudo bash nano git curl wget less htop zip unzip gzip jq \
		python3 pip \
		nodejs npm \
		build-essential rustc cargo

# copy files
COPY docker_entrypoint.sh /root

# create user
ARG USERNAME=player
ARG PASSWORD
RUN useradd -m $USERNAME && echo "$USERNAME:$PASSWORD" | chpasswd && adduser $USERNAME sudo && usermod -s /usr/bin/bash $USERNAME
WORKDIR /home/$USERNAME
COPY startup.sh .
VOLUME /home/$USERNAME

# configure SSH
RUN mkdir /var/run/sshd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
EXPOSE 22

# run
CMD ["/root/docker_entrypoint.sh"]