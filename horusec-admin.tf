// kustomize build github.com/ZupIT/horusec-admin/deployments/k8s/overlays/production?ref=v1.0.0 | kubectl apply -f -
// kubectl apply -k github.com/ZupIT/horusec-admin/deployments/k8s/base?ref=v1.0.0
data "kustomization_overlay" "horusec_admin" {
  resources = [
    "github.com/ZupIT/horusec-admin/deployments/k8s/overlays/production?ref=v${var.horusec_admin_version}",
  ]

  namespace = var.namespace

  images {
    name = "horuszup/horusec-admin"
    new_tag = "v${var.horusec_admin_version}"
  }
}

resource "kustomization_resource" "horusec_admin" {
  for_each = data.kustomization_overlay.horusec_admin.ids
  manifest = data.kustomization_overlay.horusec_admin.manifests[each.value]

  depends_on = [
    kubernetes_namespace.horusec,
  ]
}
