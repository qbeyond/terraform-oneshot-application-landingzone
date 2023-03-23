# Introduction
This module is intended for one-shot deployments only!

This module provides a bootstrap deployment for a new application landing zone. 
It creates the service connection, optionally moves the subscription, creates a build validation policy and creates a new repository with the first pipeline settings and terraform files. 

## Prerequisites
You need:
 - Personal Access Token for the DevOps Organization to create service connections and repositories
 - Rights to create the service principal
 - Project Admin on Customer DevOps Project

## Authentication

To authenticate yourself you need a service principal or an invited user. CSP AOBO Permissions will not work.
The Service Principal needs Owner permission on the management group and application admin in the AAD.
Follow the instructions on how to set the environment varibles for the service principal [here](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret).

## Approvals
On the first run of the pipeline, permissions are needed for the service connections and environment.
This can only be done with the user which pat was used in this deployment.