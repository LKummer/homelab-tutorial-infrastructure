# Homelab Tutorial Infrastructure

This repository contains example infrastructure code for my homelab infrastructure framework.
[It is accompanied by a step-by-step tutorial.](https://lkummer.github.io/homelab-wiki/tutorial/part-1-preparation/)

This repository creates a Proxmox VM and sets up:

* Single node Kubernetes cluster with K3s.
* Cert Manager and ClusterIssuer for issuing certificates using ACME DNS01 challenge.
* Observability stack with Grafana, OpenTelemetry Collector, Prometheus, Loki, Tempo and operators for managing them.
* ArgoCD as CD solution.

# Quick Start Guide

This is a *very* short version of the tutorial, with many details missing.
[Make sure to follow the tutorial if you need more than just the commands to bring it up.](https://lkummer.github.io/homelab-wiki/tutorial/part-1-preparation/)

This guide assumes you have the Packer template already built.
If not, [see this guide for instructions](https://lkummer.github.io/homelab-wiki/how-to/packer-template/).

## Preparing Credentials

[See this guide for instructions on preparing a Proxmox API token with correct privileges.](https://lkummer.github.io/homelab-wiki/how-to/proxmox-api-tokens/)

Set your Proxmox token ID and secret in `PM_API_TOKEN_ID` and `PM_API_TOKEN_SECRET` environment variables respectively.
See the following example `.env` file:

```
# Inside .env
export PM_API_TOKEN_ID='user@pve!token'
export PM_API_TOKEN_SECRET='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

**Never commit credentials into Git.**

## Clone a VM with Terraform

Head into the `terraform` folder, and initialize Terraform:

```
terraform init
```

Once Terraform is initialized, apply the module to clone a VM:

```
terraform apply
```

Make sure the plan looks about right, and type `yes` to confirm it.

## Configure the VM with Ansible

Head into the `playbook` folder, and install the Galaxy dependencies:

```
ansible-galaxy collection install --requirements requirements.yaml
```

**Make sure to install Galaxy dependencies whenever switching between projects.**
Galaxy dependencies are managed globally and mixing collection versions between projects may be destructive.

Configure the VM by running the playbook:

```
ansible-playbook --inventory=inventory main.yaml
```

You should now have a Kubernetes cluster up and running, with an observability stack and CD solution.
