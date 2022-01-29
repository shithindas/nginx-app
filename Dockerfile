FROM nginx:latest
COPY index.html /usr/share/nginx/html
COPY health_check.html /usr/share/nginx/html