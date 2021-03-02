resource "helm_release" "rabbit" {
  name = "rabbitmq"
  chart = "https://charts.bitnami.com/bitnami/rabbitmq-8.11.1.tgz"
  namespace = kubernetes_namespace.queue.metadata[0].name
  timeout = 240
}

resource "kubernetes_namespace" "queue" {
  metadata {
    name = "queue"
  }
}

data "kubernetes_secret" "rabbit" {
  metadata {
    name = helm_release.rabbit.name
    namespace = helm_release.rabbit.namespace
  }

  depends_on = [
    helm_release.rabbit
  ]
}