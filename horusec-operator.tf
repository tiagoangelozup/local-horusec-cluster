// kustomize build github.com/ZupIT/horusec-operator/config/default?ref=v1.0.0 | kubectl apply -f -
data "kustomization_overlay" "horusec_operator" {
  resources = [
    "github.com/ZupIT/horusec-operator/config/default?ref=v${var.horusec_operator_version}",
  ]

  images {
    name = "controller"
    new_name = "horuszup/horusec-operator"
    new_tag = "v${var.horusec_operator_version}"
  }
}

resource "kustomization_resource" "horusec_operator" {
  for_each = data.kustomization_overlay.horusec_operator.ids
  manifest = data.kustomization_overlay.horusec_operator.manifests[each.value]

  depends_on = [
    kind_cluster.horusec
  ]
}
