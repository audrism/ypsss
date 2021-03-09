FROM ubuntu:latest

MAINTAINER Audris Mockus <audris@mockus.org>

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && DEBIAN_FRONTEND='noninteractive' apt install -y  curl gnupg apt-transport-https


RUN apt update && \
    DEBIAN_FRONTEND='noninteractive' apt install -y  \
    libssl-dev \
    libcurl4-openssl-dev \
    openssh-server \
    lsof sudo \
    sssd \
    sssd-tools \
    nis \
    vim \
    git \
    curl lsb-release \
    vim-runtime tmux  zsh zip build-essential \
    python3-dev \
	 python3-pip

#RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && 
#RUN  pip3 install --upgrade pip && \\
#     pip3 install requests pymongo  

ENV LC_ALL=C

COPY euterpe-ilom_eecs_utk_edu_interm.cer /etc/ssl/ 
COPY sssd.conf /etc/sssd/ 
COPY common* /etc/pam.d/
COPY nsswitch.conf /etc/
COPY *.sh /bin/ 

RUN chmod 0600 -R /etc/sssd/sssd.conf /etc/pam.d/common* /etc/sssd/* && \
 if [ ! -d /var/run/sshd ]; then mkdir /var/run/sshd; chmod 0755 /var/run/sshd; fi && \
 echo domain da server 160.36.59.121 >> /etc/yp.conf && echo da > /etc/defaultdomain \
 && echo "rpcbind: 127.0.0.1" >> /etc/hosts.allow \
 && echo "+::::::" >> /etc/passwd \
 && echo "+:::" >> /etc/group \
 && echo "+::::::::" >> /etc/shadow \

# for deployment to the cloud
ENV NB_USER jovyan
ENV NB_UID 9000
ENV HOME /home/$NB_USER
RUN useradd -m -s /bin/bash -N -u 9000 jovyan && mkdir /home/jovyan/.ssh && chown -R jovyan:users /home/jovyan 
COPY id_rsa_gcloud.pub /home/jovyan/.ssh/authorized_keys
RUN chown -R jovyan:users /home/jovyan && chmod -R og-rwx /home/jovyan/.ssh

