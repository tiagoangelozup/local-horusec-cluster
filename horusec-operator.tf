data "kustomization_overlay" "horusec_operator" {
  count = var.horusec_operator_enabled ? 1 : 0

  resources = [
    "https://github.com/ZupIT/horusec-operator/config/default?ref=${var.horusec_operator_version}"
  ]

  images {
    name = "horuszup/horusec-operator"
    new_tag = var.horusec_operator_version
  }
}

resource "kustomization_resource" "horusec_operator" {
  for_each = length(data.kustomization_overlay.horusec_operator) > 0 ? data.kustomization_overlay.horusec_operator[0].ids : toset([])
  manifest = data.kustomization_overlay.horusec_operator[0].manifests[each.value]
}