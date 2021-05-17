resource "helm_release" "argocd" {
  name = "argocd"
  namespace = kubernetes_namespace.ops.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "3.2.4"

  values = [
    yamlencode({
      fullnameOverride = "argocd",
      global = { image = { repository: "argoproj/argocd", tag: "v2.0.1" } }
      server = {
        extraArgs = [ "--insecure" ]
        ingress = { enabled = true, hosts = [ "argocd.local" ] }
        additionalApplications = [
          {
            destination = { namespace = "horusec-operator-system", server = "https://kubernetes.default.svc" }
            name = "horusec-operator"
            project = "default"
            source = {
              path = "config/default",
              repoURL = "https://github.com/ZupIT/horusec-operator",
              targetRevision = "v1.1.0"
            }
            syncPolicy = { automated = {}, syncOptions = [ "CreateNamespace=true" ] }
          }
        ]
      }
      configs = {
        secret = {
          argocdServerAdminPassword = bcrypt("admin"),
          argocdServerAdminPasswordMtime = "2021-05-01T00:00:00Z"
        } 
      }
    })
  ]
}

resource "kubernetes_namespace" "ops" {
  metadata {
    name = var.argo_namespace
  }
}
