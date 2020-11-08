# scaleway-k8s

Scaleway k8s deployment

Install scw cli and init with email and password to create and set default credentials.

These credentials are located in ~/.config/scw/config.yaml

If you don't want to insatll scw cli, the credentials file is like this:

```bash
access_key: <Accesskey>
secret_key: <SecretKey>
default_organization_id: <DeforgID>
default_project_id: <DefproyID>
default_region: fr-par
default_zone: fr-par-1
```

## Docker Usage
1. Prepare environment variables (see .env.template)
```
# AWS credentials (for tfstate in S3 bucket)
$ aws configure get aws_access_key_id     --profile piwpiiwn | xargs -I% echo AWS_ACCESS_KEY_ID=%      >   .env
$ aws configure get aws_secret_access_key --profile piwpiiwn | xargs -I% echo AWS_SECRET_ACCESS_KEY=%  >>  .env
$ aws configure get region                --profile piwpiiwn | xargs -I% echo AWS_DEFAULT_REGION=%     >>  .env
```
```
# Scaleway credentials (without profiles)
$ awk '/#/{next} NF{print "SCW_"toupper(substr($1, 1, length($1)-1))"="$2}' ~/.config/scw/config.yaml  >> .env
```

2. Build the image
```
$ docker build -t k8s-cluster-state-manager .
```

3. Run the container
```
$ docker run -it --env-file=.env --rm k8s-cluster-state-manager

========================================
  PiwPiiwn - k8s Cluster State Manager
========================================

Usage: /app/entrypoint.sh [up|stop|down|show-kubeconfig]
---
up              - Create the cluster
stop            - Stop destroy workers
down            - Destroy cluster
show-kubeconfig - Displays kubeconfig file
```

* Create the cluster
```
$ docker run --rm -it --env-file=.env k8s-cluster-state-manager up
```
* Stop the cluster
```
$ docker run --rm -it --env-file=.env k8s-cluster-state-manager stop
```
* Destroy the cluster
```
$ docker run --rm -it --env-file=.env k8s-cluster-state-manager down
```
* Use the cluster
```
$ docker run --rm -it --env-file=.env k8s-cluster-state-manager show-kubeconfig \
  | awk '/^=== KUBECONFIG ===/{i=1;next} /^==================/{i=0}i' > kubeconfig
$ export KUBECONFIG=$(realpath kubeconfig)
```

## Use bash_completion
```
$ cd scaleway-k8s/
$ echo . $(realpath ./bash_completion.sh) >> ~/.bashrc
```
```
$ k8s-cluster-state-manager

========================================
  PiwPiiwn - k8s Cluster State Manager
========================================

Usage: /app/entrypoint.sh [up|stop|down|show-kubeconfig]
---
up              - Create the cluster
stop            - Stop destroy workers
down            - Destroy cluster
show-kubeconfig - Displays kubeconfig file
```
