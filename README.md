## Run once
```bash
docker network create application
docker volume create jenkins_data
```
## Run webserver
```bash
docker build -t local/web-server:latest .
docker run -itd --name web-server --network application -p 9080:80 local/web-server:latest
```
## Run jenkins
```bash
docker run -itd --name jenkins --network application -p 8080:8080 -p 50000:50000 -v jenkins_data:/var/jenkins_home jenkins/jenkins
```

## Description
`FROM ubuntu:22.04` - base image
`ENV DEBIAN_FRONTEND=noninteractive` - set terminal to noninteractive mod and disable "y/n" prompts and other like that
`RUN apt-get update && apt-get upgrade -y` - install updates
`RUN apt-get install -y supervisor openssh-server nginx` - install supervisor, ssh server and nginx webserver. Because apache sucks.
`COPY deploy.pub /root/.ssh/authorized_keys` - copying public key to ssh authorized to allow ssh passwordless auth
`COPY conf/supervisor/*.conf /etc/supervisor/conf.d/` - copy supervisor configs
`RUN mkdir -p /run/sshd` - create ssh server run dir to avoid startup error
`RUN echo "\nPubkeyAuthentication yes\nPubkeyAcceptedKeyTypes +ssh-rsa" >> /etc/ssh/sshd_config` - patch ssh config because of fuckin' jenkins
`EXPOSE 80 443` - open web server ports
`WORKDIR /var/www/html` - set working dir
`ENTRYPOINT ["/usr/bin/supervisord"]` - set entrypoint (main running process)
`CMD ["-n"]` - set entrypoint params

### Supervisor info
[https://docs.docker.com/config/containers/multi-service_container/](https://docs.docker.com/config/containers/multi-service_container/)

