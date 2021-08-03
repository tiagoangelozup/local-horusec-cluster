data "kustomization_overlay" "horusec_admin" {
  count = var.horusec_admin_enabled ? 1 : 0

  namespace = var.horusec_namespace

  resources = [
    "https://github.com/ZupIT/horusec-admin/deployments/k8s/overlays/production?ref=${var.horusec_admin_version}"
  ]

  images {
    name = "horuszup/horusec-admin"
    new_tag = var.horusec_admin_version
  }
}

resource "kustomization_resource" "horusec_admin" {
  for_each = length(data.kustomization_overlay.horusec_admin) > 0 ? data.kustomization_overlay.horusec_admin[0].ids : toset([])
  manifest = data.kustomization_overlay.horusec_admin[0].manifests[each.value]

  depends_on = [
    kubernetes_namespace.horusec_system
  ]
}