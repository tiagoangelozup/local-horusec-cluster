resource "helm_release" "postgres" {
  name = "postgresql"
  chart = "https://charts.bitnami.com/bitnami/postgresql-10.3.7.tgz"
  namespace = kubernetes_namespace.database.metadata[0].name
  timeout = 240

  set {
    name = "postgresqlDatabase"
    value = "horusec_db"
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
  }
}

data "kubernetes_secret" "postgres" {
  metadata {
    name = helm_release.postgres.name
    namespace = helm_release.postgres.namespace
  }

  depends_on = [
    helm_release.postgres
  ]
}