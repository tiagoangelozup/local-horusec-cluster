data "kustomization_overlay" "horusec_admin" {
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
  for_each = data.kustomization_overlay.horusec_admin.ids
  manifest = data.kustomization_overlay.horusec_admin.manifests[each.value]

  depends_on = [
    kubernetes_namespace.horusec_system
  ]
}