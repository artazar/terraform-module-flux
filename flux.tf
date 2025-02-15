/*

This is a Terraform module that installs [Flux CD](https://fluxcd.io/) into target Kubernetes cluster to manage all resources inside of it.

The module takes Git user credentials and cluster name as parameters:

Example of usage:

    module "flux" {

      source = "git@github.com:artazar/terrform-module-flux.git?ref=0.1.2"

      flux_bot_username = var.flux_bot_username
      flux_bot_password = var.flux_bot_password
      k8s_cluster_name  = var.cluster_name

    }


*/

# Create flux namespace

resource "kubernetes_namespace" "flux-ns" {
  metadata {
    name = var.flux_namespace
    labels = {
      k8s-namespace = var.flux_namespace
    }
  }
}

# Create a secret with Git Flux Bot user credentials

resource "kubernetes_secret" "flux-git-auth" {
  metadata {
    namespace = var.flux_namespace
    name      = "flux-git-auth"
  }

  # The secret is created with 2 different keys, as those are used by Flux and Helm Operator respectively
  data = {
    GIT_AUTHUSER = var.flux_bot_username
    username     = var.flux_bot_username
    GIT_AUTHKEY  = var.flux_bot_password
    password     = var.flux_bot_password
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.flux-ns]
}

# Install Flux

resource "helm_release" "flux" {
  name         = "flux"
  repository   = "https://charts.fluxcd.io"
  chart        = "flux"
  version      = var.flux_chart_version
  namespace    = var.flux_namespace
  reuse_values = "true"

  set {
    name  = "env.secretName"
    value = "flux-git-auth"
  }

  # Set the repository URL where cluster resources are to be stored
  set {
    name  = "git.url"
    value = "https://$(GIT_AUTHUSER):$(GIT_AUTHKEY)@github.com/artazar/${lower(var.k8s_cluster_name)}.git"
  }

  set {
    name  = "git.readonly"
    value = "true"
  }

  # We want Flux to clean up resources that were removed from the repository
  set {
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }

  # We want Flux to use .flux.yaml files on the repository to make use of git submodules
  set {
    name  = "manifestGeneration"
    value = "true"
  }

  # We do not need registry scanning functionality of Flux
  set {
    name  = "registry.disableScanning"
    value = "true"
  }

  # PSP-aware deployment
  set {
    name  = "rbac.pspEnabled"
    value = "true"
  }

  # Send logs in JSON for Graylog
  set {
    name  = "logFormat"
    value = "json"
  }

  depends_on = [kubernetes_secret.flux-git-auth]

}

# Install Helm Operator

resource "helm_release" "helm-operator" {
  name         = "helm-operator"
  repository   = "https://charts.fluxcd.io"
  chart        = "helm-operator"
  version      = var.helm_operator_chart_version
  namespace    = var.flux_namespace
  reuse_values = "true"

  # Work with Helm v3 only
  set {
    name  = "helm.versions"
    value = "v3"
  }

  # PSP-aware deployment
  set {
    name  = "rbac.pspEnabled"
    value = "true"
  }

  # Send logs in JSON for Graylog
  set {
    name  = "logFormat"
    value = "json"
  }

  depends_on = [kubernetes_secret.flux-git-auth]

}
