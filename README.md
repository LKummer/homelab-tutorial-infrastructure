# Homelab Tutorial Infrastructure

This repository contains example infrastructure code for my homelab infrastructure framework.
[It is accompanied by a step-by-step tutorial.](https://lkummer.github.io/homelab-wiki/tutorial/part-1-preparation/)

This repository creates a Proxmox VM and sets up:

* Single node Kubernetes cluster with K3s.
* Cert Manager and ClusterIssuer for issuing certificates using ACME DNS01 challenge.
* Observability stack with Grafana, OpenTelemetry Collector, Prometheus, Loki, Tempo and operators for managing them.
* ArgoCD as CD solution.

**Make this repository private when cloning.**
Terraform plans and state may leak secrets.

Related guides:

* [How to deploy this repository with GitLab CI](https://lkummer.github.io/homelab-wiki/how-to/gitlab-automation/)
* [How to configure Proxmox credentials](https://lkummer.github.io/homelab-wiki/how-to/proxmox-api-tokens/)
* [How to configure GitLab managed Terraform state](https://lkummer.github.io/homelab-wiki/how-to/gitlab-managed-state/)
* [How to build the Proxmox template](https://lkummer.github.io/homelab-wiki/how-to/packer-template/)

# Quickstart

This is a *very* short version of the tutorial, with many details missing.
[Make sure to follow the tutorial if you need more than just the commands to bring it up.](https://lkummer.github.io/homelab-wiki/tutorial/part-1-preparation/)

This guide assumes you have the Packer template already built.
If not, [see this guide for instructions](https://lkummer.github.io/homelab-wiki/how-to/packer-template/).

## Configuring credentials

Configure Proxmox credentials [(see guide for more information)](https://lkummer.github.io/homelab-wiki/how-to/proxmox-api-tokens/#managing-credentials-when-working).

There are 2 options for managing Terraform state:

1. Use local Terraform state
2. Use GitLab managed Terraform state

### Using local Terraform state

Run the following commands to modify the repository to use local Terraform state:

```
sed 's/terraform_http/terraform_local/' -i playbook/inventory/tutorial.yaml
echo tfstate_path: ../terraform/terraform.tfstate >> playbook/inventory/tutorial.yaml
sed '/backend "http"/d' -i terraform/main.tf
```

### Using GitLab managed Terraform state

[See how-to guide for preparing your environment.](https://lkummer.github.io/homelab-wiki/how-to/gitlab-managed-state/#preparing-local-environment)

## Cloning a VM with Terraform

Head into the `terraform` folder, and initialize Terraform:

```
terraform init
```

Once Terraform is initialized, apply the module to clone a VM:

```
terraform apply
```

Make sure the plan looks about right, and type `yes` to confirm it.

## Configuring the VM with Ansible

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

# Development Guide

## Terraform initialization

Go to `terraform` directory:

```
cd terraform
```

Initialize Terraform:

```
terraform init
```

## Terraform linting

Format and validate the Terraform module:
(still in `terraform` directory)

```
terraform fmt
terraform validate
```

## Provision with Terraform

Apply the Terraform module:
(still in `terraform` directory)

```
terraform apply
```

Review and confirm the plan.

## Installing Ansible dependencies

Go to the playbook directory:

```
cd playbook
```

Create a virtual environment:

```
python3 -m venv .venv
```

Activate the virtual environment:

```
source .venv/bin/activate
```

Install dependencies:

```
pip install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

## Playbook linting

Lint the Ansible playbook:
(still in `playbook` directory)

```
ansible-lint main.yaml
```

## Configure with Ansible

Run the playbook:
(still in `playbook` directory)

```
ansible-playbook --inventory=inventory main.yaml
```

# CI Variables

CI variables required for the pipeline:

* `PM_API_TOKEN_ID` ID of the form `user@pve!token`
* `PM_API_TOKEN_SECRET` secret of the ID stored in `PM_API_TOKEN_ID`
* `SSH_PRIVATE_KEY_FILE` (file) (protected) private key in OpenSSH format, **make sure it ends with an empty line**
* `SSH_PUBLIC_KEY` (protected) public key of the key stored in `SSH_PRIVATE_KEY_FILE`
