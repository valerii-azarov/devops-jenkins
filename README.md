## Run once
```bash
docker network create application
docker volume create jenkins_data
```
## Run webserver
```bash
docker build -t local/web-server:latest .
docker run -itd --network application -p 9080:80 local/web-server:latest
```
## Run jenkins
```bash
docker run -itd --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_data:/var/jenkins_home jenkins/jenkins
```

