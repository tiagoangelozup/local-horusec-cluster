resource "kubernetes_namespace" "tracing" {
  count = var.jaeger_enabled ? 1 : 0

  metadata {
    name = "tracing"
  }
}

resource "helm_release" "jaeger_operator" {
  count = var.jaeger_enabled ? 1 : 0

  name = "jaeger-operator"
  chart = "https://github.com/jaegertracing/helm-charts/releases/download/jaeger-operator-2.19.1/jaeger-operator-2.19.1.tgz"
  namespace = kubernetes_namespace.tracing[0].metadata[0].name
}

resource "kustomization_resource" "jaeger_custom_resource" {
  count = var.jaeger_enabled ? 1 : 0

  manifest = jsonencode({
    apiVersion = "jaegertracing.io/v1"
    kind = "Jaeger"
    metadata = {
      name = "jaeger"
      namespace = kubernetes_namespace.tracing[0].metadata[0].name
    }
    spec = {
      ingress = { enabled = true, hosts = [ "tracing.zup" ] }
    }
  })

  depends_on = [
    helm_release.jaeger_operator
  ]
}
