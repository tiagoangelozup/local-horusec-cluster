resource "helm_release" "mailhog" {
  name = "mailhog"
  namespace = kubernetes_namespace.mail.metadata[0].name

  repository = "https://codecentric.github.io/helm-charts"
  chart = "mailhog"
  version = "4.1.0"

  values = [
    yamlencode({
      ingress = {
        enabled = true
        hosts = [ { host = "mail.local", paths = [ "/" ] } ]
      }
    })
  ]
}

resource "kubernetes_namespace" "mail" {
  metadata {
    name = "mail"
  }
}
