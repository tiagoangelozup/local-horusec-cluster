resource "kubernetes_namespace" "iam" {
  count = var.keycloak_enabled ? 1 : 0

  metadata {
    name = "iam"
  }
}

resource "helm_release" "keycloak" {
  count = var.keycloak_enabled ? 1 : 0

  name = "keycloak"
  chart = "https://charts.bitnami.com/bitnami/keycloak-2.3.0.tgz"
  namespace = kubernetes_namespace.iam[0].metadata[0].name

  values = [
    yamlencode({
      auth = {
        adminUser = "admin"
        adminPassword = "admin"
      }
      ingress = { enabled = true, hostname = "keycloak.iam" }
      service = { type = "ClusterIP" }
      extraEnvVars = [
        { name = "KEYCLOAK_LOGLEVEL", value = "DEBUG" },
        { name = "ROOT_LOGLEVEL", value = "DEBUG" }
      ]
    })
  ]
}
