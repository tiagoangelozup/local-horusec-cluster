data "kustomization_overlay" "horusec_admin" {
  resources = [
    "github.com/ZupIT/horusec-admin/deployments/k8s/overlays/staging?ref=develop",
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
    kustomization_resource.horusec_operator,
  ]
}
