resource "helm_release" "keycloak" {
  name = "keycloak"
  chart = "https://charts.bitnami.com/bitnami/keycloak-2.3.0.tgz"
  namespace = kubernetes_namespace.iam.metadata[0].name

  values = [
    yamlencode({
      auth = {
        adminUser = "admin"
        adminPassword = "admin"
      }
      ingress = { enabled = true }
      service = { type = "ClusterIP" }
    })
  ]
}

resource "kubernetes_namespace" "iam" {
  metadata {
    name = "iam"
  }
}
