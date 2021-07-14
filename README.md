# Overview

The purpose of this repo is to demo using Consul as a LB for Vault Clusters.

## Steps

Run 
```sh
terraform init
terraform apply
```

Use the following command to access the K8s cluster
```sh
gcloud container clusters get-credentials gke-consul-vault --region us-central1 --project sam-gabrail-gcp-demos
```