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
