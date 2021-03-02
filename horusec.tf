resource "kubernetes_namespace" "horusec" {
  metadata {
    name = "horusec-system"
  }
}

resource "kubernetes_secret" "horusec_broker" {
  metadata {
    name = "horusec-broker"
    namespace = kubernetes_namespace.horusec.metadata[0].name
  }

  data = {
    "username" = "user"
    "password" = data.kubernetes_secret.rabbit.data.rabbitmq-password
  }
}

resource "kubernetes_secret" "horusec_database" {
  metadata {
    name = "horusec-database"
    namespace = kubernetes_namespace.horusec.metadata[0].name
  }

  data = {
    "username" = "postgres"
    "password" = data.kubernetes_secret.postgres.data.postgresql-password
  }
}

resource "kubernetes_secret" "horusec_jwt" {
  metadata {
    name = "horusec-jwt"
    namespace = kubernetes_namespace.horusec.metadata[0].name
  }

  data = {
    "secret-key" = uuid()
  }
}