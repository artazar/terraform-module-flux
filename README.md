This is a Terraform module that installs [Flux CD](https://fluxcd.io/) (version 1) into target Kubernetes cluster to manage all resources inside of it.

The module takes Git user credentials and cluster name as parameters:

Example of usage:

    module "flux" {

      source = "git@github.com:artazar/terrform-module-flux.git?ref=0.1.2"

      flux_bot_username = var.flux_bot_username
      flux_bot_password = var.flux_bot_password
      k8s_cluster_name  = var.cluster_name

    }




## Core Version Constraints

| Version   |
|-----------|
| `>= 0.13` |

## Provider Requirements

| Name       | Version                               |
|------------|---------------------------------------|
| helm       | `{`                                   |
|            | `  "source": "hashicorp/helm",`       |
|            | `  "version_constraints": [`          |
|            | `    ">= 1.3.2"`                      |
|            | `  ]`                                 |
|            | `}`                                   |
| kubernetes | `{`                                   |
|            | `  "source": "hashicorp/kubernetes",` |
|            | `  "version_constraints": [`          |
|            | `    ">= 1.13.2"`                     |
|            | `  ]`                                 |
|            | `}`                                   |

## Input Variables

| name                           | description                   | type     | default    | required |
|--------------------------------|-------------------------------|----------|------------|----------|
| flux\_bot\_password            | Password for Flux CD Git user | `string` |            | True     |
| k8s\_cluster\_name             | Cluster repository name       | `string` |            | True     |
| flux\_bot\_username            | Username for Flux CD Git user | `string` | `flux-bot` | False    |
| flux\_chart\_version           | Flux CD chart version         | `string` | `1.6.0`    | False    |
| flux\_namespace                | Flux CD namespace             | `string` | `flux`     | False    |
| helm\_operator\_chart\_version | Helm Operator chart version   | `string` | `1.2.0`    | False    |

## Output Values


## Managed Resources

| type                  | name            | provider   |
|-----------------------|-----------------|------------|
| helm\_release         | flux            | helm       |
| kubernetes\_secret    | flux\-git\-auth | kubernetes |
| kubernetes\_namespace | flux\-ns        | kubernetes |
| helm\_release         | helm\-operator  | helm       |

## Data Resources


## Child Modules
