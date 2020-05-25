FROM jenkins/jnlp-slave
USER root
RUN apt update && apt install sudo
RUN echo 'jenkins  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jenkins
