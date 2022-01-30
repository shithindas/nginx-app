# NodeJs-Nginx-MySQL Application

## Application Overview
Dokerized NodeJS app with MySQL Database. The Nodejs code is cloned from [Docker-NodeJS-MySQL](https://github.com/frasnym/Docker-NodeJS-MySQL)

The NodeJs application listens on port `3000` and requires connection to MySQL service. NodeJs application accepts MySQL credentials via Env variables. Nginx is configured as a side car container which will reverse proxy the requests to NodeJs container. The Nginx container listens on port `80`. The Nginx configuration is loaded from the configmap `nginx-config-<BUILD_ID>` Nginx port is exposed via NodePort service with port number `30160`.

### Building the NodeJs application

1. To build the image 

```
docker build -t shithindas/nginx-app:tagname .
```

2. Login into Dockerhub repository using `docker login` command and push the image to remote repository

```
docker push shithindas/nginx-app:tagname
```

## Code Deployment

The Code deployment to Kubernetes cluster is handled via Jenkins Job(Todo: Add link here). This pipeline is automatically triggered when there is any code change in the repository. The pipeline performs the following: 
- Configures MySQL persistent volume and deploys MySQL service
- Builds the NodeJs docker image with latest code and push to DockerHub repository.
- Tags the image using the Combination of environment and Build number
- Replaces the Image build tag and triggers app deployment

