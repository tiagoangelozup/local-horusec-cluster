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
    "secret-key" = "74266279-766d-3075-7a2f-36587132a5eb"
  }
}

resource "kubernetes_secret" "horusec_smtp" {
  metadata {
    name = "horusec-smtp"
    namespace = kubernetes_namespace.horusec.metadata[0].name
  }

  data = {
    "username" = "5m7p-u53rn4m3"
    "password" = "5m7p-p455w0rd"
  }
}
