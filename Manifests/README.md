# Kubernetes Manifests

This directory contains the kubernetes manifests required for running and configuring the applications. 

- mysql-pv.yaml: Configures persistent volume required for MySQL. The data directory is mounted to `/mnt/data` location on the host machine.
- mysql-deployment.yaml: Performs MySQL deployment and configures `clusterIP` service
- app-deployment.yaml: Performs Nodejs-Nginx deployment and configures `NodePort` service on port `30160`
- default.conf: This contains the reverse proxy nginx configuration. It is passed to Nginx container via ConfigMap `nginx-config-<BUILD_ID>`


**MySQL Root password**

MySQL root password is loaded from the secret `db-secret`. 

```
kubectl create secret generic db-secret --from-literal=password="<Your password>"
```

You can connect to MySQL server via 

```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -u root -h mysql.default.svc.cluster.local -p<Your password>
```