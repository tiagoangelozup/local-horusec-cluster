data "kustomization_overlay" "horusec_operator" {
  resources = [
    "https://github.com/ZupIT/horusec-operator/config/default?ref=${var.horusec_operator_version}"
  ]

  images {
    name = "horuszup/horusec-operator"
    new_tag = var.horusec_operator_version
  }
}

resource "kustomization_resource" "horusec_operator" {
  for_each = data.kustomization_overlay.horusec_operator.ids
  manifest = data.kustomization_overlay.horusec_operator.manifests[each.value]
}