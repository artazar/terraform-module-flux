variable flux_bot_username {
  description = "Username for Flux CD Git user"
  type        = string
  default     = "flux-bot"
}

variable flux_bot_password {
  description = "Password for Flux CD Git user"
  type        = string
}

variable flux_chart_version {
  description = "Flux CD chart version"
  type        = string
  default     = "1.6.0"
}

variable flux_namespace {
  description = "Flux CD kubernetes namespace"
  type        = string
  default     = "flux"
}

variable helm_operator_chart_version {
  description = "Helm Operator chart version"
  type        = string
  default     = "1.2.0"
}

variable k8s_cluster_name {
  description = "Cluster repository name"
  type        = string
}
