resource "kubernetes_namespace" "iam" {
  count = var.keycloak_enabled ? 1 : 0

  metadata { name = "iam" }
}

resource "helm_release" "keycloak" {
  count = var.keycloak_enabled ? 1 : 0

  name = "keycloak"
  namespace = kubernetes_namespace.iam[0].metadata[0].name

  repository = "https://charts.bitnami.com/bitnami"
  chart = "keycloak"
  version = "5.0.1"

  set {
    name = "nameOverride"
    value = "keycloak"
  }

  values = [
    yamlencode({
      auth = {
        adminUser = "admin"
        adminPassword = "admin"
      }
      ingress = { enabled = true, hostname = "keycloak.lvh.me" }
      service = { type = "ClusterIP" }
      extraEnvVars = [
        { name = "KEYCLOAK_LOGLEVEL", value = "DEBUG" },
        { name = "ROOT_LOGLEVEL", value = "DEBUG" }
      ]
      postgresql = { enabled = false }
      externalDatabase = { existingSecret = kubernetes_secret.database_env_vars[0].metadata[0].name }
    })
  ]

  depends_on = [helm_release.postgresql]
}

resource "kubernetes_secret" "database_env_vars" {
  count = var.keycloak_enabled ? 1 : 0

  metadata {
    name = "database-env-vars"
    namespace = kubernetes_namespace.iam[0].metadata[0].name
  }
  data = {
    KEYCLOAK_DATABASE_HOST = "postgresql.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local"
    KEYCLOAK_DATABASE_PORT = 5432
    KEYCLOAK_DATABASE_NAME = local.database.keycloak.database
    KEYCLOAK_DATABASE_USER = local.database.keycloak.username
    KEYCLOAK_DATABASE_PASSWORD = local.database.keycloak.password
  }
}
