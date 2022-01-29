FROM nginx:latest
LABEL maintainer="shithindasmk@gmail.com"

#Copying Sample app code to document root
COPY index.html /usr/share/nginx/html

#Copying Sample health check page to document root
COPY health_check.html /usr/share/nginx/html