FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y supervisor openssh-server nginx
COPY deploy.pub /root/.ssh/authorized_keys
COPY conf/supervisor/*.conf /etc/supervisor/conf.d/
RUN mkdir -p /run/sshd
RUN echo "\nPubkeyAuthentication yes\nPubkeyAcceptedKeyTypes +ssh-rsa" >> /etc/ssh/sshd_config
EXPOSE 80 443
WORKDIR /var/www/html
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-n"]
