variable "namespace" {
  type = string
  description = "The namespace where the solution will be installed"
  default = "horusec-system"
}

variable "jaeger_enabled" {
  type = bool
  description = "If set to true, it will deploy Jaeger"
  default = false
}

variable "keycloak_enabled" {
  type = bool
  description = "If set to true, it will deploy Keycloak"
  default = false
}

variable "horusec_operator_version" {
  type = string
  description = "The version of Horusec Kubernetes Operator"
  default = "0.1.14"
}

variable "horusec_admin_version" {
  type = string
  description = "The version of Horusec Administrator"
  default = "0.0.1"
}